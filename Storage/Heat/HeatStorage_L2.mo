within TransiEnt.Storage.Heat;
model HeatStorage_L2 "Very simple heat storage"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

parameter SI.Pressure p_drop_nom=simCenter.p_n[2]-simCenter.p_n[1] "Pressure drop on supply side";
parameter SI.MassFlowRate m_flow_nom=20 "Nominal mass flow Rate ";

parameter SI.Temperature T_max(displayUnit="degC")=383.15 "Maximum allowed temperature in Storage";

parameter SI.Height height=20 "Heigh of heat storage";
parameter SI.Diameter d=11.28 "Diameter of heat storage";
 parameter SI.Temperature T_start=273.15+90 "Initial Temperature";
parameter SI.Temperature T_amb=273.15+15 "Assumed constant ambient temperature";
parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "Coefficient of heat Transfer";
                                    //According to BINE-Waermespeicher

protected
parameter SI.Volume Volume=d^2/4*Modelica.Constants.pi*height;
parameter SI.Area A=d*Modelica.Constants.pi*height+2*d^2/4*Modelica.Constants.pi;

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________
public
SI.Energy E_stor(start=4200*T_start*Volume*1000) "Stored Energy";
SI.HeatFlowRate Q_flow_gen "heat flow from heat generator";
SI.HeatFlowRate Q_flow_con "Heat flow to consumer";
SI.HeatFlowRate Q_flow_loss "surface losses";
SI.HeatFlowRate Q_flow_balance "Heat flow to or from storage";
SI.MassFlowRate m_flow_grid "Mass flow to grid";
SI.MassFlowRate m_flow_gen "Mass flow from source";
SI.Temperature T_stor(start=T_start);
SI.Temperature T_return_gen;
SI.Temperature T_supply_grid;

// _____________________________________________
//
//                  Interfaces
// _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fpGenIn(Medium=Medium) "inlet from heat generator" annotation (Placement(transformation(extent={{-72,70},{-52,90}}), iconTransformation(extent={{-72,70},{-52,90}})));

  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fpGenOut(Medium=Medium) "outlet to heat generator" annotation (Placement(transformation(extent={{-74,-92},{-54,-72}}), iconTransformation(extent={{-74,-92},{-54,-72}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fpGridIn(Medium=Medium) "inlet (return) from consumer/grid" annotation (Placement(transformation(extent={{42,-90},{62,-70}}), iconTransformation(extent={{42,-90},{62,-70}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fpGridOut(Medium=Medium) "outlet to consumer/grid" annotation (Placement(transformation(extent={{52,72},{72,92}}), iconTransformation(extent={{52,72},{72,92}})));
Modelica.Blocks.Interfaces.RealOutput T_stor_out "Temperature in heat reservoir in K"
    annotation (final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC",Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,78}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,92})));

// _____________________________________________
//
//                Complex Components
// _____________________________________________
 parameter TILMedia.VLEFluidTypes.BaseVLEFluid Medium = simCenter.fluid1 "Medium in the component";
  ClaRa.Components.HeatExchangers.TubeBundle_L2 heatExchangerGen(
    medium=Medium,
    h_start=50*4200,
    p_nom=simCenter.p_n[1],
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=p_drop_nom),
    m_flow_nom=m_flow_nom,
    p_start=simCenter.p_n[2],
    initOption=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,0})));

Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatToStorage(T_ref=343.15)
  annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=180,
      origin={-32,0})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureGenIn(medium=Medium) annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 heatExchangerConsumer(
    medium=Medium,
    h_start=70*4200,
    p_start=simCenter.p_n[2],
    m_flow_nom=m_flow_nom,
    p_nom=simCenter.p_n[2],
    initOption=0) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={60,0})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureGridOut(medium=Medium) annotation (Placement(transformation(extent={{90,50},{70,70}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureGridIn(medium=Medium) annotation (Placement(transformation(extent={{90,-70},{70,-50}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureGenOut(medium=Medium) annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatFromStorage
  annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={32,0})));
equation
  assert(T_stor<T_max,"Heat storage too hot. Adjust your control!");
// _____________________________________________
//
//                Characteristic Equations
// _____________________________________________

if
  noEvent(m_flow_grid>m_flow_gen) then
  //If m_flow in grid is greater, we will have the same returntemperature to the heat generator
  T_return_gen=temperatureGridIn.T;
else
  //If not, temperature will be calculated from mixture of storage and grid return (weighted average)
  T_return_gen=(m_flow_grid*temperatureGridIn.T+T_stor*(m_flow_gen-m_flow_grid))/m_flow_gen;
end if;
//The necessary heat flow rate is thus calculated by
Q_flow_gen=fpGenIn.m_flow*4200*(temperatureGenIn.T-T_return_gen);
heatToStorage.Q_flow=-Q_flow_gen;
if
  noEvent(m_flow_grid<m_flow_gen) then
  //If m_flow on generator side is greater, we will be able to reach heating curve temperatures
T_supply_grid=min(temperatureGenIn.T,simCenter.heatingCurve.T_supply);
else
  //If not, we will get something in between T_stor and the generators supply temperature.
  //If that temperature is bigger than heating curve temperatures, we can get heating curve temperature!
  T_supply_grid=min((m_flow_gen*temperatureGenIn.T+(m_flow_grid-m_flow_gen)*T_stor)/m_flow_grid,simCenter.heatingCurve.T_supply);
end if;

Q_flow_con=m_flow_grid*4200*(T_supply_grid-temperatureGridIn.T);
heatFromStorage.Q_flow=Q_flow_con;

//Heat transfer of a body
Q_flow_loss=k*A*(T_stor-T_amb);

//Differential equation
der(E_stor)=Q_flow_gen-Q_flow_con-Q_flow_loss;
//Just for comparison and statistics
Q_flow_balance=Q_flow_con+Q_flow_gen;

m_flow_grid=fpGridIn.m_flow;
m_flow_gen=fpGenIn.m_flow;

T_stor=E_stor/(Volume*1000*4200)+273.15;
T_stor_out=T_stor;

// _____________________________________________
//
//               Connect Statements
// _____________________________________________

  connect(temperatureGenIn.port, fpGenIn)  annotation (Line(points={{-80,50},{-100,50},{-100,80},{-62,80}},
                                                smooth=Smooth.None));
  connect(heatExchangerConsumer.inlet, fpGridOut)  annotation (Line(
      points={{60,10},{60,82},{62,82}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatExchangerConsumer.outlet, fpGridIn)  annotation (Line(
      points={{60,-10},{60,-80},{52,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(temperatureGridOut.port, fpGridOut)   annotation (Line(
      points={{80,50},{62,50},{62,82}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(temperatureGridIn.port, fpGridIn)    annotation (Line(
      points={{80,-70},{52,-70},{52,-80}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(temperatureGenOut.port, fpGenOut) annotation (Line(points={{-80,-70},{-100,-70},{-100,-82},{-64,-82}},
                                                smooth=Smooth.None));
  connect(heatExchangerConsumer.heat, heatFromStorage.port)  annotation (Line(
      points={{50,1.77636e-015},{46,1.77636e-015},{46,-1.33227e-015},{
          42,-1.33227e-015}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatExchangerGen.heat, heatToStorage.port) annotation (Line(
      points={{-50,0},{-42,0}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatExchangerGen.inlet, fpGenIn) annotation (Line(
      points={{-60,10},{-60,80},{-62,80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatExchangerGen.outlet, fpGenOut) annotation (Line(
      points={{-60,-10},{-60,-82},{-64,-82}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
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
                                  Diagram(coordinateSystem(
        preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Line(
          points={{-54,60},{-54,34},{-54,26}},
          color={0,0,255},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled}), Line(
          points={{54,26},{54,52},{54,60}},
          color={0,0,255},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled})}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple energy balance model of a hot water storage. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
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
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Apr 2013</p>
<p>Edited and revised by Lisa Andresen (andresen@tuhh.de), Jun 2013</p>
</html>"));
end HeatStorage_L2;
