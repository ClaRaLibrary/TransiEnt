within TransiEnt.Basics.Tables.Check;
model TestGenericCombiTable1DS
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  TransiEnt.Basics.Tables.GenericCombiTable1Ds genericCombiTable1Ds(relativepath="heat/LoadFactor_4sites_DHN_Vattenfall_2012.txt") annotation (Placement(transformation(extent={{-10,-6},{10,14}})));
  Modelica.Blocks.Sources.ExpSine expSine(
    amplitude=1e6,
    offset=1e7,
    freqHz=1/2e5,
    damping=0.011/3600) annotation (Placement(transformation(extent={{-56,-6},{-36,14}})));
equation

  connect(expSine.y, genericCombiTable1Ds.u) annotation (Line(points={{-35,4},{-12,4}}, color={0,0,127}));
  annotation (experiment(
      StopTime=604800,
      Interval=900,
      Tolerance=1e-010,
      __Dymola_Algorithm="Dassl"),                           __Dymola_experimentSetupOutput);
end TestGenericCombiTable1DS;
