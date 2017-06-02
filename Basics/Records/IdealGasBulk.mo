within TransiEnt.Basics.Records;
model IdealGasBulk
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
    extends TransiEnt.Basics.Icons.Record;
  replaceable parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG6_var mediumModel "Used medium model";
    input SI.Mass mass "Mass" annotation(Dialog(show));
    input SI.Temperature T "Temperature" annotation(Dialog);
    input SI.Pressure p "Pressure" annotation(Dialog(show));
    input SI.SpecificEnthalpy h "Specific enthalpy" annotation(Dialog(show));
    input SI.MassFraction xi[mediumModel.nc - 1] "Component mass fractions"  annotation(Dialog);
    input SI.MassFraction x[mediumModel.nc - 1] "Component molar fractions"  annotation(Dialog);
    input SI.Density rho annotation(Dialog);

end IdealGasBulk;
