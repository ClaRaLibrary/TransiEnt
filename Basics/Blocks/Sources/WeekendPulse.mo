within TransiEnt.Basics.Blocks.Sources;
model WeekendPulse "model for producing a pulse every weekend"
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

extends TransiEnt.Basics.Icons.Block;

  parameter TransiEnt.Basics.Types.TypeOfWeekday BeginningWeekday;
  parameter Real k_weekend;

  Modelica.Blocks.Sources.Pulse pulse(
    period=7*24*3600,
    width=2/7*100,
    startTime=-BeginningWeekday*24*3600)
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
          points={{-76,88},{-84,66},{-68,66},{-76,88}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-76,66},{-76,-82}}, color={192,192,192}),
        Line(points={{-76,-72},{-56,-72},{4,38},{4,-72},{64,39},{64,-72}},
            color={0,0,0}),
        Polygon(
          points={{94,-72},{72,-64},{72,-80},{94,-72}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-86,-72},{86,-72}}, color={192,192,192})}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Produces a pulse every weekend, to add gains to e.g. load models</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(none.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</span></p>
</html>"));
end WeekendPulse;
