within TransiEnt.Producer.Combined.SmallScaleCHP.Specifications;
record Dachs_HKA_G_5_5kW "ICE 5.5 kWel"
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
//Record containing the data of the Dachs HKA G5.5 (Bernd Thomas, mini- blockeizkraftwerke,2011)

  import TransiEnt;

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Combined.SmallScaleCHP.Base.BaseCHPSpecification(
    P_el_max=5.5e3,
    P_el_min=5.49e3,
    lambda=1.8,
    eta_el_max=0.27,
    eta_el_min=0.27,
    eta_h_max=0.88,
    eta_h_min=0.88,
    m_engine=530,
    T_opt=348.15,
    eta_m=0.85,
    n_cylinder=1,
    k=5,
    length=1.07,
    width=0.72,
    reactionTime=1/15,
    height=1,
    pistonStroke=0.091,
    pistonDiameter=0.09);
    //engineDisplacement=580/100^3,

end Dachs_HKA_G_5_5kW;
