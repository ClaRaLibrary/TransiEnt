within TransiEnt.Consumer.Heat.SpaceHeating.Characteristics;
record HouseType70 "House type 70 characteristics according to EnEV 2007"
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
  extends Base.ThermodynamicProperties(
    n_min=0.5,
    cp_ext=50*3600*0.70,
    cp_int=8*3600,
    U_ext=0.4*0.70,
    U_roof=0.2*0.70,
    alpha_roomWall=8,
    alpha_wallAmbiance=15,
    alpha_groundsurface=10);
end HouseType70;
