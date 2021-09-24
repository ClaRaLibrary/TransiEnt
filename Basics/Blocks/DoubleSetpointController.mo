within TransiEnt.Basics.Blocks;
model DoubleSetpointController "Similar to On/Off Controller this block switches between three states with a hysteresis defined by a bandwidth"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import TransiEnt.Basics.Types;
  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

  parameter Real uLow1 "u<=uLow1, Switch to off";
  parameter Real uHigh1 "u>uHigh1, Switch to on1";
  parameter Real uLow2 "u>u";
  parameter Real uHigh2 "u>uHigh2, Switch to on2";

  parameter Real y0=0 "Output signal for state off";
  parameter Real y1=1 "Output signal for state on1";
  parameter Real y2=2 "Output signal for state on2";

  parameter Types.DoubleSetpointControllerStatus startState=Types.off "State at init";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(extent={{96,-10},{116,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Math.BooleanToReal b2r1(             realTrue=y1, realFalse=y0)
                                                                    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Blocks.Logical.Hysteresis      On2(                                       pre_y_start=startState == Types.on2,
    uLow=uLow2,
    uHigh=uHigh2)                                                                    annotation (Placement(transformation(extent={{-14,36},{6,56}})));
  Modelica.Blocks.Math.BooleanToReal b2r2(realFalse=0, realTrue=y2 - y1) annotation (Placement(transformation(extent={{20,36},{40,56}})));
  Modelica.Blocks.Math.Sum y_total(nin=2) annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Modelica.Blocks.Logical.Hysteresis      On1(
    uLow=uLow1,
    uHigh=uHigh1,
    pre_y_start=startState <> Types.off)                                             annotation (Placement(transformation(extent={{-24,-10},{-4,10}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(On2.y, b2r2.u) annotation (Line(points={{7,46},{12.5,46},{18,46}}, color={255,0,255}));
  connect(b2r1.y, y_total.u[1]) annotation (Line(points={{31,0},{58,0},{58,-1}}, color={0,0,127}));
  connect(b2r2.y, y_total.u[2]) annotation (Line(points={{41,46},{50,46},{50,1},{58,1}}, color={0,0,127}));
  connect(y_total.y, y) annotation (Line(points={{81,0},{106,0},{106,0}}, color={0,0,127}));
  connect(u, On2.u) annotation (Line(points={{-106,0},{-76,0},{-76,46},{-16,46}}, color={0,0,127}));
  connect(On1.y, b2r1.u) annotation (Line(points={{-3,0},{2.5,0},{8,0}}, color={255,0,255}));
  connect(u, On1.u) annotation (Line(points={{-106,0},{-66,0},{-26,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(points={{-49,43},{81,43}}),
        Line(points={{-49,43},{-49,-37}}),
        Line(points={{-59,21},{-49,3},{-39,21}}),
        Line(points={{-4,51},{-19,43},{-4,35}}),
        Line(points={{41,43},{41,-37}}),
        Line(points={{33,-5},{41,14},{50,-5}}),
        Line(points={{-15,-29},{1,-37},{-15,-44}}),
        Line(points={{-79,-37},{41,-37}})}),                     Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Uses two instances of MSL <a href=\"Modelica.Blocks.Logical.Hysteresis\">hysteresis</a>. Thereby a three point control (e.g. off, on1, on2) with hysteresis can be realized. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Modelica RealInput: u</p>
<p>Modelica RealOutput: y</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;DoubleSetPointController&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de), Aug 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de), Apr 2017 : code conventions</span></p>
</html>"));
end DoubleSetpointController;
