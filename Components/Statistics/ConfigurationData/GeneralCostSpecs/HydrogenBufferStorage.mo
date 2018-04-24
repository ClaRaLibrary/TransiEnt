within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model HydrogenBufferStorage "Cost model for small cylindrical hydrogen buffer storage (82m3 geo, max. 80 bar)"
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
    size1=82 "Geometric volume in m3",
    C_inv_size=300000/82*size1 "300000 EUR for a 82m3 storage tank Stolzenburg 2014",
    factor_OM=0.02 "2%, Stolzenburg 2014",
    lifeTime=30 "Stolzenburg 2014");
end HydrogenBufferStorage;
