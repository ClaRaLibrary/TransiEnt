within TransiEnt.Components.Statistics.Collectors.LocalCollectors.Check;
model CheckCollectElectricPower

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

  extends Basics.Icons.Checkmodel;

  PlantModel plant;
  inner ModelStatistics modelStatistics;

  model PlantModel

  outer ModelStatistics modelStatistics;

  CollectElectricPower collectElectricPower annotation (Placement(transformation(extent={{-10,-6},{10,14}})));
  SI.ActivePower P_el_is=100e3*time/3600;
  equation
  collectElectricPower.powerCollector.P=-P_el_is;
  connect(modelStatistics.powerCollector[EnergyResource.Conventional],collectElectricPower.powerCollector);

  end PlantModel;

  annotation (experiment(StopTime=3600));
end CheckCollectElectricPower;
