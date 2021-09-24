within TransiEnt.Basics.Tables.Check;
model TestGenericCombiTable2D "Model for testing combi tables"

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



  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  Modelica.Blocks.Sources.ExpSine expSine(
    amplitude=1e6,
    offset=1e7,
    f=1/2e5,
    damping=0.011/3600) annotation (Placement(transformation(extent={{-48,-2},{-28,18}})));
  TransiEnt.Basics.Tables.GenericCombiTable2D genericCombiTable2D(relativepath="heat/PQ_HeatInput_Matrix_WW1.txt") annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  Modelica.Blocks.Sources.ExpSine expSine1(
    amplitude=1e6,
    offset=1e7,
    f=1/1e5,
    damping=0.11/3600) annotation (Placement(transformation(extent={{-50,-44},{-30,-24}})));
equation

  connect(expSine1.y, genericCombiTable2D.u2) annotation (Line(points={{-29,-34},{-10,-34},{-10,-36},{-10,-10},{-10,-7},{6,-7}}, color={0,0,127}));
  connect(expSine.y, genericCombiTable2D.u1) annotation (Line(points={{-27,8},{-10,8},{-10,7},{6,7}}, color={0,0,127}));
  annotation (experiment(
      StopTime=604800,
      Interval=900,
      Tolerance=1e-010,
      __Dymola_Algorithm="Dassl"),                           __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for 2D combi tables</p>
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
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestGenericCombiTable2D;
