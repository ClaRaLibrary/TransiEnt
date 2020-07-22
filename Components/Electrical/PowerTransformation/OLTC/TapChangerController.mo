within TransiEnt.Components.Electrical.PowerTransformation.OLTC;
model TapChangerController "Simple model for TapChanger, model with reaction starting timer"
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

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real numberTaps=5 "number of taps for each direction";
  parameter SI.Voltage v_prim_n=simCenter.v_n "nominal voltage on primary side";
  parameter SI.Voltage v_sec_n=30e3 "nominal voltage on secondary side";
  parameter SI.Voltage v_deadband=0.025*v_sec_n "deadband voltage for secondary side";
  parameter SI.Voltage v_max=1.05*v_sec_n "maximum voltage on secondary side";
  parameter SI.Time T_delay=10 "time delay of tap changer";
  parameter Real idleRatio=v_prim_n/v_sec_n "Ratio without tap change";
  parameter Real tapRatio=(v_max-v_sec_n)/numberTaps "Voltage change with one tap change";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp "connect this epp with secondary" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealOutput RatioOut annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

   TransiEnt.Components.Sensors.ElectricVoltageComplex electricVoltageComplex "measurement of voltage on secondary side" annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
   Modelica.Blocks.Logical.Timer timerUp                annotation (Placement(transformation(extent={{-10,30},{10,50}})));
   Modelica.Blocks.Logical.Timer timerDown                annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
   Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThresholdUp(threshold=T_delay) annotation (Placement(transformation(extent={{26,30},{46,50}})));
   Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThresholdDown(threshold=T_delay) annotation (Placement(transformation(extent={{24,-50},{44,-30}})));
   Modelica.Blocks.Logical.Pre preUp annotation (Placement(transformation(extent={{60,36},{68,44}})));
   Modelica.Blocks.Logical.Pre         pre2                    annotation (Placement(transformation(extent={{58,-44},{66,-36}})));
   Modelica.Blocks.Logical.And andUp annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
   Modelica.Blocks.Logical.And andDown annotation (Placement(transformation(extent={{-42,-50},{-22,-30}})));
   Modelica.Blocks.Logical.Not notUp annotation (Placement(transformation(extent={{-78,30},{-58,50}})));
   Modelica.Blocks.Logical.Not notDown annotation (Placement(transformation(extent={{-76,-50},{-56,-30}})));
   Modelica.Blocks.Sources.BooleanExpression activateUpBlock(y=activateUp) annotation (Placement(transformation(extent={{-78,8},{-58,28}})));
   Modelica.Blocks.Sources.BooleanExpression activateDownBlock(y=activateDown) annotation (Placement(transformation(extent={{-76,-74},{-56,-54}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

 Real currentTap( start=0, fixed=true, min=-numberTaps, max=numberTaps) annotation(Dialog(group="Initialization", showStartAttribute=true));
 Boolean activateUp(start=false);
 Boolean activateDown(start=false);

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

 //if-clause for activation of timer

  if electricVoltageComplex.v > v_sec_n+v_deadband then
      activateDown = true;
      activateUp = false;
    elseif electricVoltageComplex.v < v_sec_n-v_deadband then
      activateUp = true;
      activateDown = false;
    else
      activateUp = false;
      activateDown = false;
  end if;

  //when-clause for the changing of taps

  when timerDown.y >= T_delay then
     currentTap = (if pre(currentTap)-1 <= -numberTaps-1 then pre(currentTap) else pre(currentTap)-1);
  elsewhen timerUp.y >= T_delay then
     currentTap = (if pre(currentTap)+1 >= numberTaps+1 then pre(currentTap) else pre(currentTap) +1);
  end when;

  //Calculation of ratio
  RatioOut=v_prim_n/(v_sec_n+pre(currentTap)*tapRatio);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(electricVoltageComplex.epp, epp) annotation (Line(
      points={{-68,0.2},{-86,0.2},{-86,0},{-100,0}},
      color={28,108,200},
      thickness=0.5));
  connect(timerUp.y, greaterEqualThresholdUp.u) annotation (Line(points={{11,40},{24,40}}, color={0,0,127}));
  connect(preUp.u, greaterEqualThresholdUp.y) annotation (Line(points={{59.2,40},{47,40}}, color={255,0,255}));
  connect(timerDown.y, greaterEqualThresholdDown.u) annotation (Line(points={{11,-40},{22,-40}}, color={0,0,127}));
  connect(greaterEqualThresholdDown.y, pre2.u) annotation (Line(points={{45,-40},{57.2,-40}}, color={255,0,255}));
  connect(timerUp.u, andUp.y) annotation (Line(points={{-12,40},{-19,40}}, color={255,0,255}));
  connect(timerDown.u, andDown.y) annotation (Line(points={{-12,-40},{-21,-40}}, color={255,0,255}));
  connect(andUp.u1, notUp.y) annotation (Line(points={{-42,40},{-57,40}}, color={255,0,255}));
  connect(preUp.y, notUp.u) annotation (Line(points={{68.4,40},{80,40},{80,60},{-88,60},{-88,40},{-80,40}}, color={255,0,255}));
  connect(andDown.u1, notDown.y) annotation (Line(points={{-44,-40},{-55,-40}}, color={255,0,255}));
  connect(pre2.y, notDown.u) annotation (Line(points={{66.4,-40},{80,-40},{80,-20},{-92,-20},{-92,-40},{-78,-40}}, color={255,0,255}));
  connect(activateUpBlock.y, andUp.u2) annotation (Line(points={{-57,18},{-52,18},{-52,32},{-42,32}}, color={255,0,255}));
  connect(activateDownBlock.y, andDown.u2) annotation (Line(points={{-55,-64},{-50,-64},{-50,-48},{-44,-48}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Advanced model of a controller for On Load Tap Cahanger (OLTC)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L1E (defined in the CodingConventions) Only the change of ratio is calculated.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Timer that starts counting when voltage is out of deadband</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Complex Power Port for voltage measurement and ouput for ratio</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no further remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Testmodel in TransiEnt.Components.Electrical.PowerTransformation.Check.GridN5AreaFirstVoltageCollapse</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2019 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised and added to TransiEnt Library by Jan-Peter Heckel (jan.heckel@tuhh.de) in December 2019 </span></p>
</html>"));
end TapChangerController;
