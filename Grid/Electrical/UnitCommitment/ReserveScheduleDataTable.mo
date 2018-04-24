within TransiEnt.Grid.Electrical.UnitCommitment;
model ReserveScheduleDataTable "Unit commitment schedule"
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
  extends TransiEnt.Basics.Tables.GenericDataTable(
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPrivate,
    relativepath="strom\UnitCommitmentSchedule_3600s_01012033_31122033_.txt",
    multiple_outputs=true,
    columns=2:3,
    change_of_sign=true,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments);

end ReserveScheduleDataTable;
