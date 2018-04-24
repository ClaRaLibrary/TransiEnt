within TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics;
record Generic_Characteristics_PVModule
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
  parameter Real MPP_dependency_on_Temp_fixedIrradiation[:,2] "Maximum power point power of provided IV curves in the data sheet of a module dependent on temperature at a fixed irradiation";
  parameter Real MPP_dependency_on_irradiation_fixedTemperature[:,2] "Maximum power point power of provided IV curves in the data sheet of a module dependent on irradiation at a fixed temperature";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Generic_Characteristics_PVModule;
