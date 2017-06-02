within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model HydrogenSphericalPressureVessel_low "Cost model for hydrogen spherical pressure vessels (300...3000m3 geo, 10 bar)"
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
//Source: Tietze, Vanessa ; Luhr, Sebastian ; Stolten, Detlef: Bulk Storage Vessels for Compressed and Liquid Hydrogen (2016), S. 659–689
//Table 27.9, page 676: p_max=0.8 and 1.2 MPa
  extends PartialCostSpecs(
    size1=300 "Geometric volume in m3",
    C_inv_size=278.76*size1+128443 "Curve fitting for table data with pmax=10bar",
    factor_OM=0.02 "2%, Stolzenburg 2014, small hydrogen storage",
    lifeTime=30 "Stolzenburg 2014, small hydrogen storage");
end HydrogenSphericalPressureVessel_low;
