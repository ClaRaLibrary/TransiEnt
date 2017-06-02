within TransiEnt.Components.Gas.Compressor.Controller;
model ControllerValveAndCompressor_dp "Controls the mass flow through a valve or a compressor depending on the pressure difference"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput dp_desired(
    final quantity="PressureDifference",
    final unit="Pa",
    displayUnit="bar") "Desired pressure difference" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_valve(
    final quantity="MassFlowRate",
    final unit="kg/s",
    displayUnit="kg/s") "Desired mass flow through valve" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-110})));
  Modelica.Blocks.Interfaces.RealOutput dp_comp(
    final quantity="PressureDifference",
    final unit="Pa",
    displayUnit="bar") "Desired compressor pressure difference" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-110})));
  Modelica.Blocks.Interfaces.RealInput m_flow(
    final quantity="MassFlowRate",
    final unit="kg/s",
    displayUnit="kg/s") "Mass flow rate through unit" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-100,0})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if dp_desired<0 then
    m_flow_valve = m_flow;
    dp_comp = dp_desired;
  else
    dp_comp = dp_desired;
    m_flow_valve = 0;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ControllerValveAndCompressor_dp;
