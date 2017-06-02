within TransiEnt.Grid.Electrical.Base;
partial record PartialGenerationPark "Empty partial generation park"
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
  extends Basics.Icons.Record;

  parameter String[nPlants] index=fill("",0) "Click on edit (little book) to see indexing";
  parameter Integer nPlants "No. of plants in scenario (including e.g. RE)";
  parameter Integer nDispPlants "No. of dispatchable plants (plants that get setpoints)";
  parameter Integer nMODPlants=nDispPlants "No. of plants participating in intraday optimization";

  parameter SI.Power P_max[nDispPlants] "Maximum power production of dispatchable plants"  annotation(Dialog(tab="Summary"));
  parameter SI.Power P_min[nDispPlants] "Minimum power production of dispatchable plants"  annotation(Dialog(tab="Summary"));
  parameter SI.Frequency P_grad_max_star[nDispPlants] "Maximum power gradient with respect to nominal capacity (1/3600 s means full load in 1 hout)"  annotation(Dialog(tab="Summary"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var[nDispPlants] "Variable cost vector of dispatchable plants in MTU per Energy" annotation (Dialog(tab="Summary"));

  final parameter SI.Power P_total=sum(P_max) "Sum of installed capacity in generation park"  annotation(Dialog(tab="Summary"));

  parameter Integer[nMODPlants] isMOD=1:nDispPlants "Index set of plants that get setpoints from merit order dispatcher (intraday optimization)";
  parameter Integer[:] isFRE={0} "Index set of fluctuating renewable energy plants";
  parameter Integer[:] isCHP={0} "Index set of combined heat and power plants (these have time varying power limits)";

  final parameter SI.Power[nMODPlants] P_min_MOD = P_min[isMOD];
  final parameter SI.Power[nMODPlants] P_max_MOD = P_max[isMOD];
  final parameter SI.Frequency[nMODPlants] P_grad_max_star_MOD = P_grad_max_star[isMOD];
  final parameter Real[nMODPlants] C_var_MOD = C_var[isMOD];

end PartialGenerationPark;
