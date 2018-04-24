within TransiEnt.Basics.Interfaces.Thermal;
connector FluidPortMSL

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

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium model"
                   annotation (choicesAllMatching=true);

  flow Modelica.SIunits.MassFlowRate m_flow "Mass flow rate from the connection point into the component";
  Modelica.SIunits.AbsolutePressure p "Thermodynamic pressure in the connection point";
  stream Modelica.SIunits.SpecificEnthalpy h_outflow "Specific thermodynamic enthalpy close to the connection point if m_flow < 0";
  stream Modelica.SIunits.MassFraction Xi_outflow[Medium.nC] "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";

  annotation (Icon(graphics={Ellipse(
          extent={{80,80},{-80,-80}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end FluidPortMSL;
