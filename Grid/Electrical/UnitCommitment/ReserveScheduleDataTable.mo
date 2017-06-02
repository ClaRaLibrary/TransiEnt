within TransiEnt.Grid.Electrical.UnitCommitment;
model ReserveScheduleDataTable "Unit commitment schedule"
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

end ReserveScheduleDataTable;
