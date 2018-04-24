within TransiEnt.Basics.Blocks.Check;
model TestRealVectorExpression
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
  extends Icons.Checkmodel;
  Sources.RealVectorExpression sameAsTestdata(nout=2, y_set=Testdata.y) annotation (Placement(transformation(extent={{-26,-22},{-6,-2}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    Testdata(table=[0,0,0.0; 3600,1,0.0; 5400,0,0.0; 7200,1,0.0; 9000,1,0.0; 12600,0,0.0; 12600,1,0.0; 16200,1,0.0; 16200,0,0.0; 18000,0,0.0; 18000,1.2,0.0; 22320,1.2,0.0; 22320,-0.1,0.0; 26000,-0.1,0.0])
                                                                                                    annotation (Placement(transformation(extent={{-28,30},{8,66}})));
  annotation (experiment(StopTime=10000), __Dymola_experimentSetupOutput);
end TestRealVectorExpression;
