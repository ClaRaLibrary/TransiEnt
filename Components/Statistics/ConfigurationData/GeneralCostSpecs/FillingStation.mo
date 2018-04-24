within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model FillingStation "Cost model for hydrogen trailer filling station"
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
  extends PartialCostSpecs(
    size1=1 "Number of trailers/trucks",
    C_inv_size=250000*size1 "25e6 EUR for 100 trucks, Stolzenburg 2014 Integration von Wind-Wasserstoff-Systemen in das Energiesystem",
    factor_OM=0.03 "3%, Stolzenburg 2014 Integration von Wind-Wasserstoff-Systemen in das Energiesystem",
    lifeTime=30 "Stolzenburg 2014 Integration von Wind-Wasserstoff-Systemen in das Energiesystem");
end FillingStation;
