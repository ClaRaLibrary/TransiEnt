within TransiEnt.Basics.Media.Solids;
model MineralWool "Mineral Wool properties in TransiEnt"
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
  extends TILMedia.SolidTypes.BaseSolid(
    final d = 125.0,
    final cp_nominal = 840.0,
    final lambda_nominal = 0.060); //Values for d, cp and lambda are from Glck, 1985. p. 355. The rest are random placeholders.

equation
  //d=d_nominal;
  cp=cp_nominal;
  lambda=lambda_nominal;

end MineralWool;
