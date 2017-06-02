within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model SMR "Cost model for a steam methane reformer"
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
    size1=1e6 "H_flow_n_H2: Nominal hydrogen enthalpy flow rate",
    C_inv_size=(3.127*exp(-9.883e-7*size1)+0.6645*exp(-1.387e-7*size1)+0.1089)*size1 "curve fitting of curve from figure 5.13 from Krieg 2012: Konzept und Kosten eines Pipelinesystems zur Versorgung des deutschen Straenverkehrs mit Wasserstoff (values for high enthalpy flow rates are a bit too high)",
    factor_OM=0.05 "5%, Krieg 2012: Konzept und Kosten eines Pipelinesystems zur Versorgung des deutschen Straenverkehrs mit Wasserstoff",
    lifeTime=15 "Wietschel 2010 Vergleich von Strom und Wasserstoff als CO2-freie Endenergietrger: Endbericht");
end SMR;
