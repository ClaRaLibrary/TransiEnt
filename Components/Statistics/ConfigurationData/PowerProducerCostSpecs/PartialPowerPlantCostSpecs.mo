within TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs;
partial model PartialPowerPlantCostSpecs "Partial power plant cost specification record"
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
  extends GeneralCostSpecs.PartialCostSpecs;

  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_fuel=0 "Specific fuel cost per input energy, e.g. €/kWh_fuel";
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy m_flow_CDEspec_fuel=0 "Specific co2 emissions in kg per J of fuel energy";

end PartialPowerPlantCostSpecs;
