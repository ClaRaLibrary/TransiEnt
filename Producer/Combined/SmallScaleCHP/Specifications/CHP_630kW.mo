within TransiEnt.Producer.Combined.SmallScaleCHP.Specifications;
record CHP_630kW "ICE 630 kWel"
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
//Record containing the known parameters of the CHP the TUHH is using (2012)

  import TransiEnt;

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Combined.SmallScaleCHP.Base.BaseCHPSpecification(
    P_el_max=630e3,
    lambda=1.877,
    eta_el_max=0.361,
    eta_el_min=0.327,
    eta_h_max=0.83,
    eta_h_min=0.846,
    pistonStroke=0.16,
    pistonDiameter=0.132,
    n_cylinder=16,
    m_engine=5510,
    k=110,
    length=3.5,
    height=2.1,
    width=2.0,
    reactionTime=1/40,
    shareExhaustHeat=0.43,
    thermalConductivity=846e3/50);
    //engineDisplacement=35/1000,

end CHP_630kW;
