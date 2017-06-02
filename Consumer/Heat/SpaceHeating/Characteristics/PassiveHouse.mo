within TransiEnt.Consumer.Heat.SpaceHeating.Characteristics;
record PassiveHouse "Passive House characteristics according to EnEV 2007"
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
  extends Base.ThermodynamicProperties(
    n_min=0.5,
    cp_ext=50*3600*0.2,
    cp_int=8*3600,
    U_ext=0.4*0.2,
    U_roof=0.2*0.2,
    alpha_roomWall=8,
    alpha_wallAmbiance=15,
    alpha_groundsurface=10);
end PassiveHouse;
