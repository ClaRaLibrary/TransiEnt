within TransiEnt.Basics.Blocks.Check;
model TestOnOffRelay "Model for testing the OnOffRelay model"

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



  extends TransiEnt.Basics.Icons.Checkmodel;
  Modelica.Blocks.Sources.BooleanPulse TestCase(startTime=2000, period=900)
                                                             annotation (Placement(transformation(extent={{-88,4},{-60,32}})));
  OnOffRelais    Plant1(t_min_on=3000, t_min_off=3000,
    init_state=Types.off_ready)               annotation (Placement(transformation(extent={{-20,58},{8,86}})));

  OnOffRelais    Plant2(t_min_on=3000, t_min_off=0,
    init_state=Types.off_blocked)                   annotation (Placement(transformation(extent={{-12,0},{16,28}})));
  OnOffRelais    Plant3(t_min_on=0, t_min_off=3000,
    init_state=Types.on_blocked)                    annotation (Placement(transformation(extent={{-10,-56},{18,-28}})));
equation
  connect(TestCase.y, Plant2.u) annotation (Line(points={{-58.6,18},{-48,18},{-48,14},{-12.56,14}},color={255,0,255}));
  connect(TestCase.y, Plant3.u) annotation (Line(points={{-58.6,18},{-46,18},{-46,-42},{-10.56,-42}},
                                                                                                   color={255,0,255}));
  connect(TestCase.y, Plant1.u) annotation (Line(points={{-58.6,18},{-54,18},{-54,22},{-46,22},{-46,72},{-20.56,72}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{28,94},{106,-58}},
          lineColor={28,108,200},
          textString="Look at:

TestCase.y
Plant1.y
Plant2.y
Plant3.y

Plant1.trigger.y

EventCounter")}),                         experiment(StopTime=20000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for OnOffRelay</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity</span><span style=\"color: #005500;\"> </span></b></p>
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
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestOnOffRelay;
