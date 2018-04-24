within TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs;
model PV "Photovoltaic plant"
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
    Cspec_inv_der_E=simCenter.Cinv_PV,
    Cspec_inv_E=0,
    m_flow_CDEspec_fuel=0,
    Cspec_OM_W_el=simCenter.Cvar_PV,
    Cspec_OM_other=0,
    lifeTime=simCenter.lifeTime_PV,
    factor_OM=simCenter.CfixOM_PV/simCenter.Cinv_PV,
    Cspec_fuel=simCenter.Cfue_PV);
end PV;
