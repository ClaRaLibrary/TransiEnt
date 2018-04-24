within TransiEnt.Producer.Gas.MethanatorSystem.Controller;
model ControllerCO2ForMethanator

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.MolarMass M_H2=0.0020159 "Molar mass of hydrogen";
  constant SI.MolarMass M_CO2=0.0440095 "Molar mass of carbon dioxide";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real molarRatioH2toCO2=4 "Molar ratio hydrogen to carbon dioxide" annotation(Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput m_flow_H2(
    final quantity="MassFlowRate",
    final unit="kg/s") "Hydrogen mass flow for methanation" annotation (Placement(transformation(extent={{120,-20},{80,20}})));

  Modelica.Blocks.Interfaces.RealOutput m_flow_CO2(
    final quantity="MassFlowRate",
    final unit="kg/s") "Carbon dioxide mass flow from source" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  m_flow_CO2=-(m_flow_H2*M_CO2/(molarRatioH2toCO2*M_H2));

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ControllerCO2ForMethanator;
