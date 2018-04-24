within TransiEnt.Basics.Media.Gases;
record Gas_VDIWA_SG7_var "var{CH4,O2,CO2,H2O,H2,CO,N2} VDIWA"

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

  //this model works with TILMedia 1.2.1
  extends TILMedia.GasTypes.BaseGas(
    final fixedMixingRatio=false,
    final nc_propertyCalculation=7,
    final gasNames={"VDIWA2006.Methane(ReferenceState=3)","VDIWA2006.Oxygen", "VDIWA2006.Carbon Dioxide", "VDIWA2006.Water", "VDIWA2006.Hydrogen", "VDIWA2006.Carbon Monoxide", "VDIWA2006.Nitrogen"},
    final mixingRatio_propertyCalculation={0.4,0,0,0.3,0.1,0,0.2},
    final condensingIndex=4);
end Gas_VDIWA_SG7_var;
