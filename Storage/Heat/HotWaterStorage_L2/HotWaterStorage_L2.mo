within TransiEnt.Storage.Heat.HotWaterStorage_L2;
model HotWaterStorage_L2 "Stratified hot water storage without spatial discretisation (based on analytic solution for output temperature at steady state)"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//

// _____________________________________________
//
//          Imports and Class Hierarchy
// _____________________________________________

  extends TransiEnt.Basics.Icons.ThermalStorageBasic;
  outer TransiEnt.SimCenter simCenter;

// _____________________________________________
//
//                   Parameters
// _____________________________________________

parameter TILMedia.VLEFluidTypes.BaseVLEFluid   Medium= simCenter.fluid1;

parameter Modelica.SIunits.Pressure dp= 0.02e5 "Pressure drop on generator and consumer side";

parameter Modelica.SIunits.Temperature T_max=383.15 "Maximum allowed temperature in Storage";
parameter Modelica.SIunits.Temperature T_start=273.15+30 "Initial Temperature of heat storage";
parameter Modelica.SIunits.Temperature T_amb=273.15+18 "Assumed constant ambient temperature";

//tank geometry
parameter Modelica.SIunits.Height height=1.0 "Heigh of heat storage";
parameter Modelica.SIunits.Diameter d_tank=0.8 "Diameter of heat storage";

//pipe geometry
parameter Modelica.SIunits.Diameter d_pipe_gen=0.01 "Diameter of pipe from the generator side";
parameter Modelica.SIunits.Length l_pipe_gen = 9 "length of pipe from the generator side in the storage tank for heat transfer";
parameter Modelica.SIunits.Diameter d_pipe_con=0.01 "Diameter of pipe from the consumer side";
parameter Modelica.SIunits.Length l_pipe_con = 14.2 "length of pipe from the consumer side in the storage tank for heat transfer";

parameter Modelica.SIunits.SurfaceCoefficientOfHeatTransfer k=0.08 "Coefficient of heat Transfer from storage to room";
parameter Modelica.SIunits.ThermalConductivity lambda_pipe=236 "thermal conductivity of aluminium pipe";

protected
parameter Modelica.SIunits.Volume Volume=d_tank^2/4*Modelica.Constants.pi*height;
parameter Modelica.SIunits.Area A=d_tank*Modelica.Constants.pi*height + 2*d_tank^2/4*
      Modelica.Constants.pi;
parameter Modelica.SIunits.Area A_crossSectionalGenPipe = d_pipe_gen^2*Modelica.Constants.pi/4;
parameter Modelica.SIunits.Area A_heatTransferGen = d_pipe_gen*Modelica.Constants.pi*l_pipe_gen;
parameter Modelica.SIunits.Area A_crossSectionalConPipe = d_pipe_con^2*Modelica.Constants.pi/4;
parameter Modelica.SIunits.Area A_heatTransferCon = d_pipe_con*Modelica.Constants.pi*l_pipe_con;

constant Modelica.SIunits.KinematicViscosity nu= 5.53e-7 "kinematic viscosity of water for calculation of alpha from water to pipe";
constant Modelica.SIunits.ThermalConductivity lambda_water= 0.597 "thermal conductivity of water for calculation of alpha from water to pipe";

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________
public
Modelica.SIunits.Energy  E_stor "Stored Energy (with cp and density of the Storage medium";
    //Modelica.SIunits.HeatFlowRate Q_flow_gen( start=1000) "heat flow from heat generator";
    Modelica.SIunits.HeatFlowRate Q_flow_con( start=1000) "heat flow to heat consumer";
Modelica.SIunits.HeatFlowRate Q_flow_loss "surface losses to the environment";

Modelica.SIunits.Temperature T_stor( start=273.15+30) "Temperature of the storage";

Modelica.SIunits.Temperature T_genOut;
//Modelica.SIunits.Temperature T_supply_con;
Modelica.SIunits.Temperature T_conOut(start=273.15+25);
//Modelica.SIunits.Temperature T_supply_con;

Modelica.SIunits.SpecificHeatCapacity cpCon;
Modelica.SIunits.SpecificHeatCapacity cpGen;

 Real Re_Gen "Re-number for tube flow";
 Real Pr_Gen "Pr-number";
 Real Nu_Gen "Nu-number Nu=0.021*Re^0.8*Pr^1/3";
 Modelica.SIunits.Velocity v_Gen "flow velocity in the pipe";
 Modelica.SIunits.DynamicViscosity eta_Gen "dynamic viscosity of the water";
 Modelica.SIunits.CoefficientOfHeatTransfer alpha_Gen( start=100) "coefficient of heat transfer from water to the pipe with a turbulent tube flow";

 Real Re_Con( start=2400) "Re-number for tube flow";
 Real Pr_Con "Pr-number";
 Real Nu_Con "Nu-number Nu=0.021*Re^0.8*Pr^1/3";
 Modelica.SIunits.Velocity v_Con( start=0.5) "flow velocity in the pipe";
 Modelica.SIunits.DynamicViscosity eta_Con "dynamic viscosity of the water";
 Modelica.SIunits.CoefficientOfHeatTransfer alpha_Con( start=100) "coefficient of heat transfer from water to the pipe with a turbulent tube flow";
 Modelica.SIunits.ThermalConductivity k_pipe_gen( start=100, fixed=true);
 Modelica.SIunits.ThermalConductivity k_pipe_con( start=100);

 Modelica.SIunits.MassFlowRate m_flow_con(start=0.05);
 Modelica.SIunits.SpecificEnthalpy h_outflow_con(start=178000);
 Modelica.SIunits.SpecificEnthalpy h_outflow_gen(start=231000);
// _____________________________________________
//
//                  Interfaces
// _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn GenIn(Medium=Medium) "inlet from heat generator" annotation (Placement(transformation(extent={{-72,70},{-52,90}}), iconTransformation(extent={{-72,70},{-52,90}})));

  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut GenOut(Medium=Medium) "outlet to heat generator" annotation (Placement(transformation(extent={{-74,-92},{-54,-72}}), iconTransformation(extent={{-74,-92},{-54,-72}})));

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn ConIn(Medium=Medium) "inlet from heat consumer" annotation (Placement(transformation(extent={{46,-90},{66,-70}}), iconTransformation(extent={{46,-90},{66,-70}})));

  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut ConOut(Medium=Medium) "outlet to heat consumer" annotation (Placement(transformation(extent={{60,72},{80,92}}), iconTransformation(extent={{60,72},{80,92}})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_gen "Generated heat flow" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-88,4}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={34,96})));

  TransiEnt.Basics.Interfaces.General.TemperatureOut T_Stor "Temperature in heat reservoir in K"
                                         annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,96}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-28,96})));

// _____________________________________________
//
//                Complex Components
// _____________________________________________

  TILMedia.VLEFluid_ph GenIn_State(
  h=inStream(GenIn.h_outflow),
  p=GenIn.p,
  vleFluidType=Medium)
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  TILMedia.VLEFluid_ph GenOut_State(
  h=GenOut.h_outflow,
  p=GenOut.p,
  vleFluidType=Medium)
    annotation (Placement(transformation(extent={{-52,-92},{-32,-72}})));
  TILMedia.VLEFluid_pT Tank_Medium(
    vleFluidType=Medium,
    p=(GenIn.p+GenOut.p+ConIn.p+ConOut.p)/4,
    T=T_stor)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

  TILMedia.VLEFluid_ph ConIn_State(
    vleFluidType=Medium,
    h=inStream(ConIn.h_outflow),
    p=ConIn.p) annotation (Placement(transformation(extent={{74,68},{94,88}})));
   TILMedia.VLEFluid_ph ConOut_State(
    vleFluidType=Medium,
    h=ConOut.h_outflow,
    p=ConOut.p)
    annotation (Placement(transformation(extent={{76,-94},{96,-74}})));

initial equation
  E_stor=Volume*Tank_Medium.d*Tank_Medium.cp*(T_start-273.15);
equation
  cpCon=ConIn_State.cp;
  cpGen=GenIn_State.cp;

  assert(T_stor<T_max,"Heat storage too hot. Adjust your control!");
// _____________________________________________
//
//                Characteristic Equations
// _____________________________________________

// mass balances
GenIn.m_flow + GenOut.m_flow =0;
ConIn.m_flow + ConOut.m_flow =0;

// impulse balances
GenIn.p - GenOut.p = dp;
ConIn.p - ConOut.p=dp;

//Heat loss to environement
Q_flow_loss=k*A*(T_stor-T_amb);

// calcualtion of temperature at the outlet of water flow from heat generator
GenOut_State.T=(GenIn_State.T-T_stor)*exp(-k_pipe_gen/(GenIn.m_flow*GenIn_State.cp)*l_pipe_gen)+T_stor;
// calcualtion of temperature at the outlet of water flow from the consumer
if ConIn.m_flow>0.001 then
ConOut_State.T=(ConIn_State.T-T_stor)*exp(-k_pipe_con/(abs(ConIn.m_flow)*ConIn_State.cp)*l_pipe_con)+T_stor;
else
  ConOut_State.T=T_stor-0.001;
end if;

T_genOut=GenOut_State.T;
T_conOut=ConOut_State.T;

//Differential equation
der(E_stor)=-Q_flow_gen-Q_flow_loss-Q_flow_con;

 v_Gen=GenIn.m_flow/(GenIn_State.d*A_crossSectionalGenPipe);
 eta_Gen=nu*GenIn_State.d;
  Pr_Gen = Pr_for_lam_eta_cp(
    lambda_water,
    eta_Gen,
    GenIn_State.cp);
  Re_Gen = Re_for_v_nu_d(
    v_Gen,
    nu,
    d_pipe_gen);
  Nu_Gen = Nu_for_Re_Pr(Re_Gen, Pr_Gen);
  alpha_Gen = alpha_for_Nu_lam_d(Nu_Gen,lambda_water,d_pipe_gen);
k_pipe_gen=(1/(Modelica.Constants.pi*d_pipe_gen*alpha_Gen)+1/lambda_pipe)^(-1);

GenOut.h_outflow = inStream(GenIn.h_outflow)+Q_flow_gen/GenIn.m_flow;
GenIn.h_outflow = inStream(GenOut.h_outflow)-Q_flow_gen/GenIn.m_flow;
GenOut.h_outflow=h_outflow_gen;

 v_Con=abs(ConIn.m_flow)/(ConIn_State.d*A_crossSectionalConPipe);
 eta_Con=nu*ConIn_State.d;
  Pr_Con = Pr_for_lam_eta_cp(
    lambda_water,
    eta_Con,
    ConIn_State.cp);
  Re_Con = Re_for_v_nu_d(
    v_Con,
    nu,
    d_pipe_con);
  Nu_Con = Nu_for_Re_Pr(Re_Con, Pr_Con);
  alpha_Con = alpha_for_Nu_lam_d(
    Nu_Con,
    lambda_water,
    d_pipe_con);
 if noEvent(ConIn.m_flow>0.00002) then
 k_pipe_con=(1/(Modelica.Constants.pi*d_pipe_con*abs(alpha_Con))+1/lambda_pipe)^(-1);
 else
  k_pipe_con=0.1;
 end if;

T_stor-273.15=E_stor/(Volume*Tank_Medium.d*Tank_Medium.cp);
T_stor=T_Stor;
//Q_gen=-Q_flow_gen;
 if noEvent(ConIn.m_flow>0.0001) then
   ConOut.h_outflow = inStream(ConIn.h_outflow)+Q_flow_con/ConIn.m_flow;
 else
   ConOut.h_outflow = abs(inStream(ConIn.h_outflow))+abs(Q_flow_con)/0.00015;
 end if;
ConIn.h_outflow = inStream(ConOut.h_outflow)-Q_flow_con/ConIn.m_flow;
ConIn.m_flow=m_flow_con;
ConOut.h_outflow=h_outflow_con;

  // _____________________________________________
  //
  //             Private functions
  // _____________________________________________

  //
  // **** Function that calculates alpha from Nusselt, Lambda and Diameter
  //
protected
  function alpha_for_Nu_lam_d
    input Real Nu;
   input Modelica.SIunits.ThermalConductivity lambda;
   input Modelica.SIunits.Length diameter;

    output Modelica.SIunits.CoefficientOfHeatTransfer alpha;

  algorithm
    alpha:=Nu*lambda/diameter;

  end alpha_for_Nu_lam_d;

  //
  // **** Function that calculates Nusselt from Reynolds and Prandtl Number
  //
  function Nu_for_Re_Pr
    input Real Re;
    input Real Pr;

    output Real Nu;

  algorithm
    Nu:=0.021*Re^0.8*Pr^(1/3) "for T_Wall=constheizl";

  end Nu_for_Re_Pr;

  //
  // **** Function that calculates Reynold from viscosity, Nusselt no. and diameter
  //
  function Re_for_v_nu_d

   input Modelica.SIunits.Velocity v;
   input Modelica.SIunits.KinematicViscosity nu;
   input Modelica.SIunits.Length diameter;

    output Real Re;

  algorithm
    Re:=v*diameter/nu;

  end Re_for_v_nu_d;

  //
  // **** Function that calculates Prandtl No. from Lambda, Eta and Cp
  //
  function Pr_for_lam_eta_cp

   input Modelica.SIunits.ThermalConductivity lambda;
   input Modelica.SIunits.DynamicViscosity eta;
   input Modelica.SIunits.SpecificHeatCapacity cp;

    output Real Pr;

  algorithm
   Pr:=eta*cp/lambda;

  end Pr_for_lam_eta_cp;
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                       graphics={
        Line(
          points={{-62,80},{-18,80},{-18,46}},
          color={127,0,0},
          thickness=1,
          smooth=Smooth.None),
        Line(
          points={{-20,-60},{-20,-82},{-68,-82}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None),
        Line(
          points={{21,-60},{21,-82},{52,-82}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None),
        Line(
          points={{64,80},{20,80},{20,46}},
          color={127,0,0},
          thickness=1,
          smooth=Smooth.None),
        Line(
          points={{52,-82},{52,80}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None),
        Polygon(
          points={{46,8},{58,8},{46,-10},{58,-10},{46,8}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-50,80},{34,80},{34,80}},
          color={127,0,0},
          thickness=1,
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-42,-82},{42,-82},{42,-82}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None,
          pattern=LinePattern.Dot)}),
                                  Diagram(graphics,
                                          coordinateSystem(
        preserveAspectRatio=false, extent={{-100,-100},{100,100}})),          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Hot water storage without spatial discretisation (based on analytic solution for output temperature at steady state). Thermodynamic properties are calculated in dependance of the temperature.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>GenIn: inlet from heat generator</p>
<p>GenOut: outlet to heat generator</p>
<p>ConIn: inlet from heat consumer</p>
<p>ConOut: outlet to heat consumer</p>
<p>Q_flow_gen: generated heat flow [W]</p>
<p>T_Stor: output for temperature in heat reservoir in K [K]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>mass balances</p>
<p>heat loss to environment</p>
<p>first law of thermodynamics</p>
<p>impulse balances</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Inken Knop (inken.knop@tuhh.de), Jun 2015</p>
<p>Edited by Pascal Dubucq (dubucq@tuhh.de), Aug 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Dec 2016</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Dec 2017</p>
</html>"));
end HotWaterStorage_L2;
