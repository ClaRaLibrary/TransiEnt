within TransiEnt.Grid.Electrical.SecondaryControl.Activation;
partial model PartialActivationType "Partial Model for different types of Secondary Control Activation"
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

  extends TransiEnt.Basics.Icons.SystemOperator;

  // _____________________________________________
  //
  //             Outer Parameters
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer nout=simCenter.generationPark.nDispPlants "Number of plants";
  parameter Modelica.SIunits.Power P_max[nout]=simCenter.generationPark.P_max;
  parameter Real P_grad_max_star[nout]=simCenter.generationPark.P_grad_max_star "Specific Power gradient in 1/s";
  parameter Modelica.SIunits.Power P_respond=simCenter.P_el_small "Minimum absolute set value for response of one power plant (Ansprechempfindlichkeit)";
  parameter Modelica.SIunits.Time Td(min=Modelica.Constants.small) = 1 "Derivative time constant of slew rate limiter";
  parameter Modelica.SIunits.Power P_SB_max=57e6 "Maximum power reserve";
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput P_R_pos[nout] "Reserved positive control power (values are supposed to be positive)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,120})));
  Modelica.Blocks.Interfaces.RealInput P_R_neg[nout] "Reserved negative control power (values are supposed to be positive)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,120})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nout] annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput c[nout] "participation factors" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics={
        Text(
          extent={{48,154},{106,94}},
          lineColor={0,0,127},
          textString="-"),
        Text(
          extent={{-106,148},{-48,88}},
          lineColor={0,0,127},
          textString="+")}));
end PartialActivationType;
