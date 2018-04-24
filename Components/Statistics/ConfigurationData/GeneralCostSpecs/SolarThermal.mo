within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model SolarThermal "Solar thermal flat plate collectors"
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
//Source: http://elib.dlr.de/89658/2/Sperber_Viebahn_FVEE-Themen_2013.pdf
//A_tot = 4000 m2, system cost
extends PartialCostSpecs(
    size1=1 "Area in m2",
    C_inv_size=size1*220 "220 EUR/m2",
    factor_OM=4/300 "Percentage of the invest cost that represents the annual O&M cost",
    Cspec_OM_Q=1/1000/3.6e6 "Specific O&M cost per heating energy",
    lifeTime=20 "Life time");

end SolarThermal;
