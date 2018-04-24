within TransiEnt.Components.Statistics.ConfigurationData.DemAndRevCostSpecs.ElectricityCostSpecs;
record Electricity70_150GWh "Cost record for electricity for consumers with 70-150 GWh/a"
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
  extends PartialCostElectricity(
    Cspec_demAndRev_el=103.3/3.6e9 "second half of 2014 for electricity usage of 70-150 GWh/a from Eurostat http://ec.europa.eu/eurostat/web/energy/data/database");
end Electricity70_150GWh;
