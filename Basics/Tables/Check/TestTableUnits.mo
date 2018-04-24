within TransiEnt.Basics.Tables.Check;
model TestTableUnits
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  Ambient.GHI_Hamburg_3600s_2012_TMY irradiationHamburg_3600s_010120120_010120130_1 annotation (Placement(transformation(extent={{-18,-2},{2,18}})));
  ElectricGrid.ElectricityGeneration_HHAltona_3600s_2012
    electricityGeneration_HHAltona_3600s_2012_1
    annotation (Placement(transformation(extent={{-22,40},{-2,60}})));
  Ambient.Temperature_Hamburg_Fuhlsbuettel_3600s_2012 temperatureHH_900s_01012012_0000_31122012_2345_1 annotation (Placement(transformation(extent={{-16,-40},{4,-20}})));
  Ambient.Temperature_Hamburg_Fuhlsbuettel_86400s_2012 temperatureHH_86400s_01012012_0000_31122012_2345_2 annotation (Placement(transformation(extent={{-16,-66},{4,-46}})));
  GasGrid.NaturalGasVolumeFlowSTP naturalGasVolumeFlowSTP annotation (Placement(transformation(extent={{-16,-94},{4,-74}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{30,20},{90,-30}},
          lineColor={0,0,255},
          textString="Plot outputs (y1) and check units

")}));
end TestTableUnits;
