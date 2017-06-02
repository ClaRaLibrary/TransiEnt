within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model Electrolyzer_2035 "Cost model for electrolyzers in 2035"
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
  extends PartialCostSpecs(
    Cspec_inv_der_E=0.8+0.1 "from a curve with various values over time, +0.1 for buildings etc. Stolzenburg 2014",
    factor_OM=0.04 "4% (Stolzenburg 2014)",
    lifeTime=30 "Stolzenburg 2014 \"30 years in 10-20 years\"");
end Electrolyzer_2035;
