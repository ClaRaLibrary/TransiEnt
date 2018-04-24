within TransiEnt.Producer.Combined.SmallScaleCHP.Specifications;
record CHP_2MW "ICE 2 MWel"
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

 // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Combined.SmallScaleCHP.Base.BaseCHPSpecification(
    P_el_max=2000e3,
    eta_el_max=0.437,
    eta_h_min=0.867,
    m_engine=8070,
    length=3.7,
    height=2.6,
    width=1.5,
    P_el_min=0.5*P_el_max,
    eta_el_min=0.41,
    eta_h_max=0.869,
    n_cylinder=20);//deadweight Motor
    // from data sheet
    // not from data sheet

    //lambda=1.8,
    // T_opt=348.15,
    // eta_m=0.85,
    //
    // k=5,
    // reactionTime=1/15,
    // pistonStroke=0.091,
    // pistonDiameter=0.09);
    // //engineDisplacement=580/100^3,
end CHP_2MW;
