within TransiEnt.Components.Gas.Compressor.Controller;
model ControllerValveAndCompressor_mflow "Controls the mass flow through a valve or a compressor depending on the pressure difference"

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

  Modelica.Blocks.Interfaces.RealInput m_flowDesired(final quantity="MassFlowRate", final unit = "kg/s", displayUnit="kg/s") "Desired mass flow rate" annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealInput p_before(final quantity="Pressure", final unit = "Pa", displayUnit="bar") "Pressure before the valve/compressor" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealInput p_after(final quantity="Pressure", final unit = "Pa", displayUnit="bar") "Pressure before the valve/compressor" annotation (Placement(transformation(extent={{110,-10},{90,10}})));
  Modelica.Blocks.Interfaces.RealOutput m_flowValve(final quantity="MassFlowRate", final unit = "kg/s", displayUnit="kg/s") "Mass flow rate through the valve" annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-110})));
  Modelica.Blocks.Interfaces.RealOutput m_flowCompressor(final quantity="MassFlowRate", final unit = "kg/s", displayUnit="kg/s") "Mass flow rate through the valve" annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-110})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if p_before>p_after then
    m_flowValve=m_flowDesired;
    m_flowCompressor=0;
  else
    m_flowCompressor=m_flowDesired;
    m_flowValve=0;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ControllerValveAndCompressor_mflow;
