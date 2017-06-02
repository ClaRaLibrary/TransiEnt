within TransiEnt.Components.Statistics.Collectors.LocalCollectors.Check;
model CheckCollectElectricPower

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
