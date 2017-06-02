within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model CHP_500kW "CHP plant (500 kW, gas-fired)"
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
  // Parameters for CHP with ca. 500 kW_el
  // investment: (Kimmling S.175)
  // fuel: natural gas
  // fix costs: maintanace and repair (Kimmling S.176/ VDI 2067-1)

extends PartialCostSpecs(
    Cspec_inv_der_E=500/1000 "EUR/W",
    factor_OM=(0.02 + 0.06) "Percentage of the invest cost that represents the annual O&M cost",
    Cspec_OM_W_el=1.2/100/3.6e6 "EUR/J",
    lifeTime=20 "Life time");

end CHP_500kW;
