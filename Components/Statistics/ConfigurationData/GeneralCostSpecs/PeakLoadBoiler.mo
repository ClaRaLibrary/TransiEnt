within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model PeakLoadBoiler "Peak load boiler (gas-fired)"
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
//Lund, H., Moeller, B., Mathiesen, B. V., & Dyrelund, A. (2010). The role of district heating in future renewable energy systems. Energy, 35(3), 1381–1390. https://doi.org/10.1016/j.energy.2009.11.023
//Peak load boiler, Table 3
extends PartialCostSpecs(
    Cspec_inv_der_E=150/1000 "EUR/W",
    factor_OM=0.03 "Percentage of the invest cost that represents the annual O&M cost",
    Cspec_OM_Q=0.15/3.6e9 "Specific O&M cost per heating energy in EUR/J",
    lifeTime=20);

end PeakLoadBoiler;
