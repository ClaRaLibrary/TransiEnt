within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model CHP_10kW "CHP plant (10 kW, gas-fired)"
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
  // CHP with 10 kW
  //CHP with gas engine
  // powered with waste gas (emissions and costs are different to natural gas)

extends PartialCostSpecs(
    Cspec_inv_der_E=4 "EUR/W",
    factor_OM=0.045 "Percentage of the invest cost that represents the annual O&M cost",
    Cspec_OM_W_el=2.5/100/3.6e6 "EUR/J",
    lifeTime=20 "Life time");

end CHP_10kW;
