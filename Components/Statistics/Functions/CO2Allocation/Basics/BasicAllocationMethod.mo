within TransiEnt.Components.Statistics.Functions.CO2Allocation.Basics;
partial function BasicAllocationMethod "basic class for allocation functions for CHP plants"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  input Real eta_th "thermal efficiency of the combined process";
  input Real eta_el "electrical efficiency of the combined process";
  input Real m_flow_spec "specific massflowrate per kJ fuel input";
  //output Real m_flow_spec_th;
protected
  Real m_flow_spec_th;
  Real m_flow_spec_el;
public
  output Real[2] alloc_m_flow_spec "specific massflowrate allocated to electrical part [elctrical, thermal]";

end BasicAllocationMethod;
