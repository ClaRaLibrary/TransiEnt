within TransiEnt.Grid.Electrical.UnitCommitment;
model ScheduleDataTable "Unit commitment schedule"
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
  extends TransiEnt.Basics.Tables.GenericDataTable(
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPrivate,
    relativepath="strom\UnitCommitmentSchedule_3600s_01012033_31122033_.txt",
    multiple_outputs=true,
    columns=2:3,
    change_of_sign=true,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments);

  parameter Integer NUC= -1 "Nuclear" annotation (Dialog(tab="Index"));
  parameter Integer BCG= -1 "Brown coal" annotation (Dialog(tab="Index"));
  parameter Integer  WT= -1 "CHP Plant East (Black coal)" annotation (Dialog(tab="Index"));
  parameter Integer  GUDTS= -1 "CHP Plant East (Combined cycle)" annotation (Dialog(tab="Index"));
  parameter Integer  WW1= -1 "CHP Plant West 1 (Wedel1)" annotation (Dialog(tab="Index"));
  parameter Integer  WW2= -1 "CHP Plant West (Wedel2)" annotation (Dialog(tab="Index"));
  parameter Integer  BC= -1 "Black coal" annotation (Dialog(tab="Index"));
  parameter Integer CCP= -1 "Combinded Cycle Plant" annotation (Dialog(tab="Index"));
  parameter Integer GT1= -1 "Gasturbine 1" annotation (Dialog(tab="Index"));
  parameter Integer GT2= -1 "Gastrubine 2" annotation (Dialog(tab="Index"));
  parameter Integer GT3= -1 "Gastrubine 3" annotation (Dialog(tab="Index"));
  parameter Integer OIL= -1 "Mineral oil" annotation (Dialog(tab="Index"));
  parameter Integer OILGT= -1 "Mineral oil fired Gasturbine" annotation (Dialog(tab="Index"));
  parameter Integer GAR=-1 "Garbage" annotation (Dialog(tab="Index"));
  parameter Integer BM= -1 "Biomass" annotation (Dialog(tab="Index"));
  parameter Integer PS= -1 "Pumpedstorage (Turbine)" annotation (Dialog(tab="Index"));
  parameter Integer PS_Pump= -1 "Pumpedstorage (Pump)" annotation (Dialog(tab="Index"));

  parameter Integer Curt=-1 "RE curtailment " annotation (Dialog(tab="Index"));
  parameter Integer Import = -1 "Import" annotation (Dialog(tab="Index"));

  parameter Integer ROH= -1 "Run-off Water" annotation (Dialog(tab="Index"));
  parameter Integer PV= -1 "Photovoltaic" annotation (Dialog(tab="Index"));
  parameter Integer WindOn= -1 "Wind Onshore" annotation (Dialog(tab="Index"));
  parameter Integer WindOff= -1 "Wind Offshore" annotation (Dialog(tab="Index"));

  parameter Integer DSM=-1 "Demand Side Management" annotation (Dialog(tab="Index"));

end ScheduleDataTable;
