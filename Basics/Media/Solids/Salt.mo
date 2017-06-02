within TransiEnt.Basics.Media.Solids;
model Salt "Salt"
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
  //averaged values from Kushnir, R., Dayan, A., & Ullmann, A. (2012). Temperature and pressure variations within compressed air energy storage caverns. International Journal of Heat and Mass Transfer, 55(21), 5616-5630.
  extends TILMedia.SolidTypes.BaseSolid(
    final d = 3295,
    final cp_nominal = 840,
    final lambda_nominal = 4);
equation
  cp=cp_nominal;
  lambda=lambda_nominal;
end Salt;
