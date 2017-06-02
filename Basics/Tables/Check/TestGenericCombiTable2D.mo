within TransiEnt.Basics.Tables.Check;
model TestGenericCombiTable2D
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  Modelica.Blocks.Sources.ExpSine expSine(
    amplitude=1e6,
    offset=1e7,
    freqHz=1/2e5,
    damping=0.011/3600) annotation (Placement(transformation(extent={{-48,-2},{-28,18}})));
  TransiEnt.Basics.Tables.GenericCombiTable2D genericCombiTable2D(relativepath="heat/PQ_HeatInput_Matrix_WW1.txt") annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  Modelica.Blocks.Sources.ExpSine expSine1(
    amplitude=1e6,
    offset=1e7,
    freqHz=1/1e5,
    damping=0.11/3600) annotation (Placement(transformation(extent={{-50,-44},{-30,-24}})));
equation

  connect(expSine1.y, genericCombiTable2D.u2) annotation (Line(points={{-29,-34},{-10,-34},{-10,-36},{-10,-10},{-10,-7},{6,-7}}, color={0,0,127}));
  connect(expSine.y, genericCombiTable2D.u1) annotation (Line(points={{-27,8},{-10,8},{-10,7},{6,7}}, color={0,0,127}));
  annotation (experiment(
      StopTime=604800,
      Interval=900,
      Tolerance=1e-010,
      __Dymola_Algorithm="Dassl"),                           __Dymola_experimentSetupOutput);
end TestGenericCombiTable2D;
