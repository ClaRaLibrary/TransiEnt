within TransiEnt.Basics.Blocks.Sources;
model WeekendPulse_Trapezoid "model for producing a trapezoid weekend pulse"


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





extends TransiEnt.Basics.Icons.Block;

  parameter TransiEnt.Basics.Types.TypeOfWeekday BeginningWeekday;
  parameter Real k_weekend;
  parameter Real TransitionDuration=5;

  Modelica.Blocks.Sources.Trapezoid
                                pulse(
    period=7*24*3600,
    rising=3600*TransitionDuration,
    width=(2*24 - TransitionDuration)*3600,
    falling=3600*TransitionDuration,
    startTime=-BeginningWeekday*24*3600 - TransitionDuration*3600/2)
                   annotation (Placement(transformation(extent={{-54,-28},{-34,-8}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(extent={{96,-8},{116,12}})));
  Modelica.Blocks.Math.Gain gain( k=1-k_weekend) annotation (Placement(transformation(extent={{-20,-28},{0,-8}})));
  Modelica.Blocks.Sources.RealExpression Constant(y=1)       annotation (Placement(transformation(extent={{-54,-4},{-34,16}})));
  Modelica.Blocks.Math.Add add(k1=+1, k2=-1) annotation (Placement(transformation(extent={{24,-2},{34,8}})));
equation
  connect(pulse.y, gain.u) annotation (Line(
      points={{-33,-18},{-22,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.u1, Constant.y) annotation (Line(points={{23,6},{23,6},{-33,6}},    color={0,0,127}));
  connect(add.u2, gain.y) annotation (Line(points={{23,0},{12,0},{12,-18},{1,-18}},    color={0,0,127}));
  connect(add.y, y) annotation (Line(points={{34.5,3},{65.25,3},{65.25,2},{106,2}}, color={0,0,127}));

  annotation (Icon(graphics={
        Polygon(
          points={{-80,86},{-88,64},{-72,64},{-80,86}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,64},{-80,-84}}, color={192,192,192}),
        Polygon(
          points={{90,-74},{68,-66},{68,-82},{90,-74}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-74},{82,-74}}, color={192,192,192}),
        Line(points={{-79,-74},{-58,-74},{-28,36},{11,36},{41,-74},{63,-74},{92,36}})}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Produces a trapezoid pulse every weekend, to add gais to e.g. load models</p>
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
</html>"));
end WeekendPulse_Trapezoid;
