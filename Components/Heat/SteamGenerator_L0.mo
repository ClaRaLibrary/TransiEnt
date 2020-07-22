within TransiEnt.Components.Heat;
model SteamGenerator_L0 "A steam generation unit following VDI3508"
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

extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Time T_u=60;
  parameter SI.Time T_g=1800 "Time constant of heat release";
  parameter Real y_start=0 "Initial or guess value of output (= state)";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set "Fuel energy flow setpoint" annotation (Placement(transformation(extent={{-124,-20},{-84,20}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput
             y "Connector of Real output signal" annotation (Placement(
        transformation(extent={{98,-10},{118,10}},  rotation=0)));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Nonlinear.FixedDelay delay(delayTime=T_u) annotation (Placement(transformation(extent={{-52,-16},{-20,16}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(k=1, T=T_g,
    y_start=y_start)                               annotation (Placement(transformation(extent={{20,-16},{52,16}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Q_flow_set, delay.u) annotation (Line(points={{-104,0},{-55.2,0}}, color={0,0,127}));
  connect(delay.y, firstOrder.u) annotation (Line(points={{-18.4,0},{-2,0},{16.8,0}}, color={0,0,127}));
  connect(firstOrder.y, y) annotation (Line(points={{53.6,0},{108,0}}, color={0,0,127}));
  annotation (defaultComponentName="SteamGenerator", Diagram(graphics,
                                                             coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Basic model for a steam generator unit.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>RealInput: Q_flow_set (Fuel Energy setpoint) </p>
<p>RealOutput: y (Real Output signal)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>T_u is the time</p>
<p>T_g is the time constant of heat release</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>VDI 3508</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,92},{92,-92}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-54,54},{54,-54}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-46,46},{48,-46}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-36,30},{-30,36},{38,-32},{32,-38},{-36,30}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-36,-30},{-30,-36},{38,32},{32,38},{-36,-30}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,108},{4,100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,104},{64,100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end SteamGenerator_L0;
