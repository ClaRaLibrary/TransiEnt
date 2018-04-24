within TransiEnt.Producer.Combined.SmallScaleCHP.Specifications;
record CHP_10MW "CHP 10 MW"
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
//CHP_630kW scaled to 10 MW

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Combined.SmallScaleCHP.Specifications.CHP_630kW(
    P_el_max=10e6,
    m_engine=5510*P_el_max/630e3,
    n_cylinder=integer(ceil(16*P_el_max/630e3)),
    length=3.5*P_el_max/630e3,
    height=2.1*P_el_max/630e3,
    width=2.0*P_el_max/630e3,
    T_return_max=358.15);

end CHP_10MW;
