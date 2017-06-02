within TransiEnt.Producer.Combined.SmallScaleCHP.Specifications;
record CHP_532kW "ICE 532 kWel"
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
//from Energiebunker, Hamburg-Wilhelmsburg

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Combined.SmallScaleCHP.Base.BaseCHPSpecification(
    P_el_max=532e3,
    eta_el_max=0.397,
    eta_h_max=0.909,
    m_engine=7300,
    length=3.7,
    height=2.6,
    width=1.5,
    P_el_min=0.5*P_el_max,
    eta_el_min=0.36,
    eta_h_min=0.904,
    n_cylinder=12);
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

end CHP_532kW;
