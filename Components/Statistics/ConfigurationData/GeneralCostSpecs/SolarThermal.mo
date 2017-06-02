within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model SolarThermal "Solar thermal flat plate collectors"
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
//Source: http://elib.dlr.de/89658/2/Sperber_Viebahn_FVEE-Themen_2013.pdf
//A_tot = 4000 m2, system cost
extends PartialCostSpecs(
    size1=1 "Area in m2",
    C_inv_size=size1*220 "220 EUR/m2",
    factor_OM=4/300 "Percentage of the invest cost that represents the annual O&M cost",
    Cspec_OM_Q=1/1000/3.6e6 "Specific O&M cost per heating energy",
    lifeTime=20 "Life time");

end SolarThermal;
