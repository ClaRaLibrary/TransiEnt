within TransiEnt.Basics.Media.Gases;
record Gas_ExhaustGas "var{H2O,CO2,CO,H2,O2,NO,NO2,SO2,N2} VDIWA, exhaust"

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

  //this model works with TILMedia 1.2.1
  extends TILMedia.GasTypes.BaseGas(
    final fixedMixingRatio=false,
    final nc_propertyCalculation=9,
    final condensingIndex = 1,
    final gasNames={"VDIWA2006.Water(ReferenceState=3)", "VDIWA2006.Carbon Dioxide", "VDIWA2006.Carbon Monoxide", "VDIWA2006.Hydrogen", "VDIWA2006.Oxygen", "VDIWA2006.Nitric Oxide", "VDIWA2006.Nitrogen Dioxide", "VDIWA2006.Sulfur Dioxide", "VDIWA2006.Nitrogen"},
    final mixingRatio_propertyCalculation={0.19, 0.095, 0.0000, 0.00, 0.0, 0, 0, 0, 0.715});
end Gas_ExhaustGas;
