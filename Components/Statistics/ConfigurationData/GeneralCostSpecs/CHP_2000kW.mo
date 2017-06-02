within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model CHP_2000kW "CHP plant (2 MW, gas-fired)"
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
  // ASUE BHKW Grundlagen
  // CHP with 2000 kW
  // CHP with gas engine
  // powered with waste gas (emissions and costs are different to natural gas)

  extends PartialCostSpecs(
    Cspec_inv_der_E=0.4 "EUR/W",
    factor_OM=0.045 "Percentage of the invest cost that represents the annual O&M cost",
    Cspec_OM_W_el=0.75/100/3.6e6 "EUR/J",
    lifeTime=20 "years");

end CHP_2000kW;
