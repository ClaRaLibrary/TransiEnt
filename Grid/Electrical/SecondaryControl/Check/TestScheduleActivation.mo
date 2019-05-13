within TransiEnt.Grid.Electrical.SecondaryControl.Check;
model TestScheduleActivation
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

extends TransiEnt.Basics.Icons.Checkmodel;

  Activation.ScheduleActivation scheduleActivation(
    nout=2,
    P_max={1,1},
    P_grad_max_star={60,60},
    P_respond=1e6,
    Td=900) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Basics.Blocks.Sources.RealVectorExpression P_sec_pos(nout=2, y_set={0.8,0.2}) annotation (Placement(transformation(extent={{-34,14},{-14,34}})));
  TransiEnt.Basics.Blocks.Sources.RealVectorExpression P_sec_pos1(nout=2, y_set={0,1}) annotation (Placement(transformation(extent={{-16,36},{4,56}})));
  Modelica.Blocks.Sources.Sine                 P_sec_pos2(amplitude=10e6, freqHz=1/86400)                               annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
equation
  connect(P_sec_pos.y, scheduleActivation.P_R_pos) annotation (Line(points={{-13,24},{-4,24},{-4,12}}, color={0,0,127}));
  connect(P_sec_pos1.y, scheduleActivation.P_R_neg) annotation (Line(points={{5,46},{16,46},{16,22},{4,22},{4,12}}, color={0,0,127}));
  connect(P_sec_pos2.y, scheduleActivation.u) annotation (Line(points={{-45,0},{-28.5,0},{-12,0}}, color={0,0,127}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Interval=900),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for ScheduleActivation</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
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
</html>"));
end TestScheduleActivation;
