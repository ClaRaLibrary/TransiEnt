within TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs;
model PumpedStorage "Pumped storage plant"
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

  extends PartialPowerPlantCostSpecs(
    Cspec_inv_der_E=0.73 "EUR/W",
    Cspec_inv_E=0,
    Cspec_OM_W_el=0,
    Cspec_OM_other=0,
    m_flow_CDEspec_fuel=0,
    lifeTime=80,
    factor_OM=0.048,
    Cspec_fuel=0);
end PumpedStorage;
