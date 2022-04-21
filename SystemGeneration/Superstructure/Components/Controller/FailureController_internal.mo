within TransiEnt.SystemGeneration.Superstructure.Components.Controller;
model FailureController_internal


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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




  extends TransiEnt.Basics.Icons.Controller;
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________
  parameter Integer quantity=1;
  parameter SI.Time failure1_table[:,:]=[0,1];
  parameter SI.Time failure2_table[:,:]=[0,1];
  parameter SI.Time failure3_table[:,:]=[0,1];
  parameter SI.Time failure4_table[:,:]=[0,1];
  parameter SI.Time failure5_table[:,:]=[0,1];
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Modelica.Blocks.Interfaces.RealInput value_in[quantity] annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput value_out[quantity] annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Math.RealToBoolean[quantity] realToBoolean annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput[quantity] value_out_boolean annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Blocks.Sources.RealExpression one(y=1) annotation (Placement(transformation(extent={{-40,4},{-20,24}})));
  Modelica.Blocks.Math.Product product[quantity] annotation (Placement(transformation(extent={{-8,-84},{12,-64}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable_failure1(
    table=failure1_table,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable_failure2(
    table=failure2_table,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation (Placement(transformation(extent={{-100,62},{-80,82}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable_failure3(
    table=failure3_table,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable_failure4(
    table=failure4_table,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable_failure5(
    table=failure5_table,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(combiTimeTable_failure1.y[1], realToBoolean[1].u);
  connect(combiTimeTable_failure1.y[1], product[1].u1);
  if quantity >= 2 then
    connect(combiTimeTable_failure2.y[1], realToBoolean[2].u);
    connect(combiTimeTable_failure2.y[1], product[2].u1);
  end if;
  if quantity >= 3 then
    connect(combiTimeTable_failure3.y[1], realToBoolean[3].u);
    connect(combiTimeTable_failure3.y[1], product[3].u1);
  end if;
  if quantity >= 4 then
    connect(combiTimeTable_failure4.y[1], realToBoolean[4].u);
    connect(combiTimeTable_failure4.y[1], product[4].u1);
  end if;
  if quantity >= 5 then
    connect(combiTimeTable_failure5.y[1], realToBoolean[5].u);
    connect(combiTimeTable_failure5.y[1], product[5].u1);
  end if;
  connect(value_in, product.u2) annotation (Line(points={{-120,-80},{-10,-80}}, color={0,0,127}));
  connect(realToBoolean.y, value_out_boolean) annotation (Line(points={{21,0},{110,0}}, color={255,0,255}));
  connect(product.y, value_out) annotation (Line(points={{13,-74},{62,-74},{62,-80},{110,-80}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Failure controller for arbitrary plant. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The value of <span style=\"font-family: Courier New;\">value_in</span> is multiplied by the output of the timetable <span style=\"font-family: Courier New;\">combiTimeTable_failure1</span> to define the output and <span style=\"font-family: Courier New;\">value_out</span> and <span style=\"font-family: Courier New;\">value_out_boolean. </p><p></span>Values between 0 and 1 should be used for the timetable output.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
</html>"));
end FailureController_internal;
