within TransiEnt.Basics.Records;
model RealGasBulk_L4
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
  replaceable parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var mediumModel "Used medium model";
    parameter Integer N_cv "Number of control volumes";
    input SI.Mass mass[N_cv] "Mass" annotation(Dialog(show));
    input SI.Temperature T[N_cv] "Temperature" annotation(Dialog);
    input SI.Pressure p[N_cv] "Pressure" annotation(Dialog(show));
    input SI.SpecificEnthalpy h[N_cv] "Specific enthalpy" annotation(Dialog(show));
    input SI.MassFraction xi[N_cv,mediumModel.nc - 1] "Component mass fractions"  annotation(Dialog);
    input SI.MassFraction x[N_cv,mediumModel.nc - 1] "Component molar fractions"  annotation(Dialog);
    input SI.Density rho[N_cv] annotation(Dialog);

end RealGasBulk_L4;
