within TransiEnt.Basics.Media.Gases;
record Gas_VDIWA_SG6_var "var{CH4,CO2,H2O,H2,CO,N2} VDIWA"

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

  extends TILMedia.GasTypes.BaseGas(
    final fixedMixingRatio=false,
    final nc_propertyCalculation=6,
    final gasNames={"VDIWA2006.Methane(ReferenceState=3)", "VDIWA2006.Carbon Dioxide", "VDIWA2006.Water", "VDIWA2006.Hydrogen", "VDIWA2006.Carbon Monoxide", "VDIWA2006.Nitrogen"},
    final condensingIndex=3,
    final mixingRatio_propertyCalculation={0.4,0,0.3,0.1,0,0.2});
end Gas_VDIWA_SG6_var;
