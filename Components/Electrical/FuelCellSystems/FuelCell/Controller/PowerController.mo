within TransiEnt.Components.Electrical.FuelCellSystems.FuelCell.Controller;
model PowerController "Controller for power output in Fuel Cell applications"

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

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Current i_max=150 "Gain value multiplied with input signal";
  parameter Real k = 1 "Proportional controller gain";
  parameter Real i_min=20 "Lower Limit";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn deltaP "Input for power difference" annotation (Placement(
        transformation(
        rotation=180,
        extent={{10,-10},{-10,10}},
        origin={-100,74}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,60})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(
          rotation=180,
                      extent={{10,-10},{-10,10}},
        origin={118,-28}),
                         iconTransformation(extent={{100,-10},{120,10}})));
  TransiEnt.Basics.Interfaces.Electrical.VoltageIn V_cell "Input for voltage of a cell" annotation (Placement(
        transformation(
        rotation=0,
        extent={{-10,-10},{10,10}},
        origin={-100,-66}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-90,-54})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Math.Gain Gain(k=k) annotation (Placement(transformation(
        extent={{9,-9},{-9,9}},
        rotation=180,
        origin={-13,6})));

  Modelica.Blocks.Math.Division division annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={19,0})));

  Modelica.Blocks.Logical.GreaterThreshold switch1(threshold=0)
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-44})));

  Modelica.Blocks.Logical.Switch errorSwitch annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-44,6})));

  Modelica.Blocks.Logical.Switch outputSwitch annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={54,-28})));

  Modelica.Blocks.Sources.Constant zero(k=0)
    annotation (Placement(transformation(extent={{-96,-10},{-80,6}})));

  Modelica.Blocks.Nonlinear.Limiter constantSaturation(uMax=i_max, uMin=i_min)
    annotation (Placement(transformation(extent={{76,-40},{100,-16}})));

  Modelica.Blocks.Sources.Constant Rampupcurrent(k=i_max)
    annotation (Placement(transformation(extent={{8,-60},{24,-44}})));

  Modelica.Blocks.Nonlinear.Limiter preventDivisionByZero(uMax=10e3, uMin=0.1)
    annotation (Placement(transformation(extent={{-40,-78},{-16,-54}})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(constantSaturation.y, y) annotation (Line(
      points={{101.2,-28},{118,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(V_cell, switch1.u) annotation (Line(
      points={{-100,-66},{-70,-66},{-70,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, errorSwitch.u2) annotation (Line(
      points={{-70,-33},{-70,6},{-56,6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(errorSwitch.y, Gain.u) annotation (Line(
      points={{-33,6},{-23.8,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deltaP, errorSwitch.u1) annotation (Line(
      points={{-100,74},{-68,74},{-68,14},{-56,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Gain.y, division.u1) annotation (Line(
      points={{-3.1,6},{7,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zero.y, errorSwitch.u3) annotation (Line(
      points={{-79.2,-2},{-56,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(outputSwitch.y, constantSaturation.u) annotation (Line(
      points={{65,-28},{73.6,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(division.y, outputSwitch.u1) annotation (Line(
      points={{30,-1.33227e-015},{34,-1.33227e-015},{34,0},{36,0},{36,-14},{36,
          -14},{36,-20},{42,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, outputSwitch.u2) annotation (Line(
      points={{-70,-33},{-70,-28},{42,-28}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(Rampupcurrent.y, outputSwitch.u3) annotation (Line(
      points={{24.8,-52},{32,-52},{32,-36},{42,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(V_cell, preventDivisionByZero.u) annotation (Line(
      points={{-100,-66},{-42.4,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preventDivisionByZero.y, division.u2) annotation (Line(
      points={{-14.8,-66},{-4,-66},{-4,-6},{7,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-126,94},{-76,74}},
          lineColor={0,0,255},
          textString="deltaQ"), Text(
          extent={{-128,-20},{-78,-40}},
          lineColor={0,0,255},
          textString="Vcell")}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller&nbsp;for&nbsp;power&nbsp;output&nbsp;in&nbsp;Fuel&nbsp;Cell&nbsp;applications</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealInput: electric voltage in V</p>
<p>Modelica RealInput: electric power difference in W</p>
<p>Modelica RealOutput: y</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Simon Weilbach (simon.weilbach@tuhh.de) on 01.10.2014</p>
<p>Model revised by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2015</p>
<p>Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</p>
</html>"));
end PowerController;
