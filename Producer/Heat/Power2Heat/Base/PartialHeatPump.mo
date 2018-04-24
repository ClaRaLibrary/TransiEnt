within TransiEnt.Producer.Heat.Power2Heat.Base;
partial model PartialHeatPump "Partial model of a controlled heat pump model useable for large pool simulations in demand side management scenarios"

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

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Boolean use_T_source_input_K = false "False, use outer ambient conditions";
  parameter SI.TemperatureDifference Delta_T_internal = 5 "Temperature difference between refrigerant and source/sink temperature";
  parameter SI.TemperatureDifference Delta_T_db = 2 "Deadband of hysteresis control";
  parameter SI.HeatFlowRate Q_flow_n = 3.5e3 "Nominal heat flow of heat pump at nominal conditions according to EN14511";
  parameter Real COP_n = 3.7 "Coefficient of performance at nominal conditions according to EN14511";

  final parameter Real eta_HP = COP_n/((273.15+40)/(40-2));
  final parameter SI.Power P_el_n = Q_flow_n / COP_n;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput u_set "Setpoint value, e.g. Storage setpoint temperature" annotation (Placement(transformation(extent={{-124,-20},{-84,20}})));
  Modelica.Blocks.Interfaces.RealInput u_meas "Measurement value, e.g. Actual storage temperature" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-112})));
  Modelica.Blocks.Interfaces.RealInput T_source_input_K if
                                                        use_T_source_input_K "Input ambient temperature in Kelvin" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,106})));

protected
  Modelica.Blocks.Interfaces.RealInput T_source_internal;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
public
  Modelica.Blocks.Sources.RealExpression COP(y=COP_Carnot*eta_HP) annotation (Placement(transformation(extent={{10,18},{30,38}})));
  Modelica.Blocks.Math.Product Q_flow annotation (Placement(transformation(extent={{38,-10},{58,10}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real COP_Carnot=(u_set + Delta_T_internal)/max(2*Delta_T_internal, u_set + 2*Delta_T_internal - T_source_internal);

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // temperature from ambient condition bloc or real input
  if not use_T_source_input_K then
    T_source_internal = SI.Conversions.from_degC(simCenter.T_amb_var);
  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(T_source_internal, T_source_input_K);

  connect(COP.y,Q_flow. u1) annotation (Line(points={{31,28},{32,28},{32,6},{36,6}}, color={0,0,127}));
  connect(u_set, feedback.u1) annotation (Line(points={{-104,0},{-80,0}}, color={0,0,127}));
  connect(u_meas, feedback.u2) annotation (Line(points={{0,-112},{0,-76},{-72,-76},{-72,-8}}, color={0,0,127}));
  annotation(defaultComponentName="Heatpump", Icon(graphics={
        Rectangle(
          extent={{-38,40},{42,-48}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,8},{-44,8},{-30,8},{-38,-4},{-30,-14},{-48,-14},{-38,-4},{-48,8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,48},{20,32}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,-40},{22,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,10},{56,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{34,-10},{42,10},{52,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,22},{-20,-24},{28,-24}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,-22},{-16,-14},{-4,4},{-2,6},{6,12},{16,16},{24,16}},
          color={0,0,255},
          smooth=Smooth.None)}));
end PartialHeatPump;
