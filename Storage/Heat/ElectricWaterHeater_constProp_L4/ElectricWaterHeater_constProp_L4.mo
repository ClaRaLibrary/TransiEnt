within TransiEnt.Storage.Heat.ElectricWaterHeater_constProp_L4;
model ElectricWaterHeater_constProp_L4 "Temperature and Heat flow rate based model of a stratified thermal storage with finite volume discretisation (1=top, n=bottom) no thermodynamic property computation"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.Model;
  extends TransiEnt.Basics.Icons.ThermalStorageBasic;

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // geometry
  parameter SI.Area A_top=0.3 "top tank area" annotation(Dialog(group="Geometry"));
  parameter SI.Area A_bottom=A_top "bottom tank area" annotation(Dialog(group="Geometry"));
  parameter SI.Area A_wall=0.0097 "outside tank area" annotation(Dialog(group="Geometry"));
  parameter SI.Length d = 0.01 "diameter of tank" annotation(Dialog(group="Geometry"));
  parameter SI.Length h = 1 "height of tank" annotation(Dialog(group="Geometry"));

  // heating unit properties
  parameter Integer N_heaters(min=1, max=2) = 2 annotation(Dialog(group="Heating Units"));
  parameter SI.Power P_0 = 4.5e3 annotation(Dialog(group="Heating Units"));
  parameter SI.Efficiency eta = 1 annotation(Dialog(group="Heating Units"));
  parameter Integer i_heater[N_heaters] = {integer(floor(0.2
                                                   *n)), n-1} "Index of control volume containing heater (1=bottom, n=top)" annotation(Dialog(group="Heating Units"));
  parameter Integer N_mix = 3 "Number of control volumes around heater position directly affected by the heater"
                                                                                                    annotation(Dialog(group="Heating Units"));
  parameter Integer i_heatingZone_1[N_mix]= integer(linspace(i_heater[1]-N_mix/2+1, i_heater[1]+N_mix/2, N_mix)) annotation(Dialog(group="Heating Units"));
  parameter Integer i_heatingZone_2[N_mix] = integer(linspace(i_heater[2]-N_mix/2+1, i_heater[2]+N_mix/2, N_mix)) annotation(Dialog(group="Heating Units"));

  // thermodynamic properties
  parameter SI.Mass m = 300 "mass inside tank" annotation(Dialog(group="Thermodynamics"));
  parameter SI.Temperature T_start[n]=linspace(273.15+40, 273.15+60, n) "Temperatures at initalization" annotation(Dialog(group="Thermodynamics"));
  parameter SI.Temperature Tamb = 273.15+20 "Constant ambient temperature, if isTambConst=true" annotation(Dialog(group="Thermodynamics"));
  parameter SI.Temperature T_inflow = 273.15+35 "Temperature of water inflow" annotation(Dialog(group="Thermodynamics"));
  parameter SI.Temperature T_max = 273.15+95 "Maximum temperature used for computation of SOC" annotation(Dialog(group="Thermodynamics"));

  parameter SI.ThermalConductivity k = 0.6 "Thermal conductivity of fluid in storage" annotation(Dialog(group="Thermodynamics"));
  parameter SI.Density rho = 1e3 "Density of fluid in storage" annotation(Dialog(group="Thermodynamics"));
  parameter SI.SpecificHeatCapacity c = 4.185e3 "Heat capacity of fluid in storage" annotation(Dialog(group="Thermodynamics"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer U = 0.5 "Coefficient of heat transfer to ambient (side, top and bottom walls)" annotation(Dialog(group="Thermodynamics"));
  parameter SI.Velocity v_cf = 0.05 "Empiric parameter for modeling of turbulence induced by internal heaters" annotation(Dialog(group="Thermodynamics"));

  // numerical parameters
  parameter Integer n=100 "Number of control volumes" annotation(Dialog(group="Numerical parameters"));
  parameter Boolean isTambConst = false "False, Ambient temperature through input connector" annotation(Dialog(group="Numerical parameters"));

  // final parameters:
  final parameter SI.Length dx=h/n;
  final parameter Real a = k/(rho*c);
  final parameter SI.Mass m_i = m / n;
  final parameter SI.MassFlowRate m_flow_cf = m_i/d*v_cf;
  final parameter Integer i_minturb_1 = min(i_heatingZone_1);
  final parameter Integer i_minturb_2 = min(i_heatingZone_2);

// _____________________________________________
//
//                  Interfaces
// _____________________________________________
  // inputs:
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow "Drawn water is assumed to be replaced by cold water"
                                                              annotation (Placement(transformation(extent={{-112,
            -10},{-92,10}})));

  TransiEnt.Basics.Interfaces.General.TemperatureIn Tamb_input if not isTambConst "Input for ambient temperature in [K]"
                                                              annotation (Placement(transformation(extent={{-110,58},{-90,78}}), iconTransformation(extent={{-110,58},{-90,78}})));

protected
  TransiEnt.Basics.Interfaces.General.TemperatureIn Tamb_internal "Internal input"
                                                              annotation (Placement(transformation(extent={{-110,28},{-90,48}})));

public
  Modelica.Blocks.Interfaces.BooleanInput u[N_heaters] "control input for heating element n" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,102}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-34,90})));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  // states:
  SI.Temperature T[n](start=T_start);

  // helper variables:
  SI.TemperatureSlope dTdt_diff[n];
  SI.TemperatureSlope dTdt_plug[n];
  SI.TemperatureSlope dTdt_loss[n];
  SI.TemperatureSlope dTdt_heater[n];
  SI.TemperatureSlope dTdt_turb[n];

  SI.Energy E_stor = m * c * (sum(T)/n - T_inflow);
  Real SOC = E_stor / (m * c * (T_max - T_inflow));
  SI.Temperature T_mean = sum(T)/n;
  SI.Temperature T_outflow=T[n];
  SI.HeatFlowRate Q_flow_out = m_flow * c * (T_inflow - T_outflow);
  SI.HeatFlowRate Q_heater_1 = if u[1] then P_0 * eta else 0;
  SI.HeatFlowRate Q_heater_2 = if u[2] then P_0 * eta else 0;
  SI.Power  P_el_heater_1 = if u[1] then P_0 else 0;
  SI.Power  P_el_heater_2 = if u[2] then P_0 else 0;
  SI.HeatFlowRate Q_heater = Q_heater_1 + Q_heater_2;

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{-10,86},{10,106}}), iconTransformation(extent={{-10,86},{10,106}})));
equation

  //
  // *** diffusion ***
  //
  dTdt_diff[1] = a/dx^2*(-T[1] + T[2]);
  for i in 2:n-1 loop
    dTdt_diff[i] = a/dx^2*(T[i-1] - 2*T[i] + T[i+1]);
  end for;
  dTdt_diff[n] = a/dx^2*(T[n-1] - T[n]);

  //
  // *** convection ***
  // ouput water is drawn from top (i=n), every element gets temperature from element below (i = 1: bottom)
  //
  dTdt_plug[1]=m_flow/m_i * (T_inflow - T[1]);
  for i in 2:n loop
    dTdt_plug[i] = m_flow/m_i * (T[i-1] - T[i]);
  end for;

  //
  // *** heat losses to ambient ***
  //
  dTdt_loss[1] = (A_wall + A_bottom) * U/(m_i*c) * (Tamb_internal - T[1]);
  for i in 2:n-1 loop
    dTdt_loss[i] = A_wall * U/(m_i*c) * (Tamb_internal - T[i]);
  end for;
  dTdt_loss[n] = (A_wall + A_top) * U/(m_i*c) * (Tamb_internal - T[n]);

  //
  // *** heat gain from heating units ***
  //
  for i in 1:n loop
    if Modelica.Math.Vectors.find(i, i_heatingZone_1)>0 and u[1] then
     dTdt_heater[i]=eta*P_0/(m_i*c*N_mix);
    elseif Modelica.Math.Vectors.find(i, i_heatingZone_2)>0 and u[2] then
     dTdt_heater[i]=eta*P_0/(m_i*c*N_mix);
    else
      dTdt_heater[i]=0;
    end if;
  end for;

  //
  // *** turbulence around heaters, modeled as circular massflow term
  //
  for i in 1:n-1 loop
    if i==i_minturb_2 and u[2] and u[1] then
      dTdt_turb[i] = 2 * m_flow_cf/m_i * (- T[i] + T[i+1]);
    elseif i>=i_minturb_2 and u[2] and u[1] then  // upper heating element, both on
      dTdt_turb[i] = 2 * m_flow_cf/m_i * (T[i-1] - 2*T[i] + T[i+1]);
    elseif i==i_minturb_2 and u[2] then  // upper heating element on
      dTdt_turb[i] = m_flow_cf/m_i * (- T[i] + T[i+1]);
    elseif i>=i_minturb_2 and u[2] then  // upper heating element on
      dTdt_turb[i] = m_flow_cf/m_i * (T[i-1] - 2*T[i] + T[i+1]);
    elseif i==i_minturb_1 and u[1] then // lower heating element on
      dTdt_turb[i] = m_flow_cf/m_i * ( - T[i] + T[i+1]);
    elseif i>=i_minturb_1 and u[1] then // lower heating element on
      dTdt_turb[i] = m_flow_cf/m_i * (T[i-1] - 2*T[i] + T[i+1]);
    else  // below lower heating element, or elements off
      dTdt_turb[i]=0;
    end if;
  end for;
  if u[1] or u[2] then
    dTdt_turb[n] = m_flow_cf/m_i * (T[n-1] - T[n]);  // top disk always turbulent, if one of the heaters is on
  elseif u[1] and u[2] then
    dTdt_turb[n] = 2 * m_flow_cf/m_i * (T[n-1] - T[n]);
  else
   dTdt_turb[n] = 0;
  end if;

  //
  // *** sum up of physical effects considered ***
  //
  der(T) = dTdt_diff +  dTdt_plug + dTdt_loss + dTdt_heater + dTdt_turb;

  //
  // parameter dependent source of ambient temperature:
  //
  if isTambConst then
    Tamb_internal = Tamb;
  end if;
  connect(Tamb_internal, Tamb_input);

  //
  // electric interface
  //
  epp.P = P_el_heater_1 + P_el_heater_2;

  annotation (experiment(StopTime=86400), __Dymola_experimentSetupOutput,
    Icon(graphics={
        Line(
          points={{0,90},{0,-6}},
          color={0,134,134},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,-6},{20,-14},{-18,-28},{18,-42},{0,-46},{0,-56}},
          thickness=0.5,
          smooth=Smooth.None,
          color={0,134,134})}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Hot water storage with spatial discretisation. Thermodynamic properties are not calculated in dependance of the temperature.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>m_flow: output for mass flow rate in [kg/s]( drawn water is assumed to be replaced by cold water)</p>
<p>Tamb_input: input for ambient in temperature in [K]</p>
<p>u[N_heaters]: BooleanInput (control input for heating element 1)</p>
<p>epp: active power port</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end ElectricWaterHeater_constProp_L4;
