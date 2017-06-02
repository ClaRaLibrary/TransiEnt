within TransiEnt.Basics.Media.Gases;
record Gas_MoistAir "var {O2,N2,H2O} VDIWA"

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
    final nc_propertyCalculation=3,
    final gasNames={"VDIWA2006.Water(ReferenceState=3)","VDIWA2006.Nitrogen","VDIWA2006.Oxygen"},
    final condensingIndex=1,
    final mixingRatio_propertyCalculation={0.001,0.77,0.23});
end Gas_MoistAir;
