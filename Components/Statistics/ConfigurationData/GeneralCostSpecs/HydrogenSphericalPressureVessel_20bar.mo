within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model HydrogenSphericalPressureVessel_20bar "Hydrogen spherical pressure vessels (2500...55000m3 geo, 20bar)"
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
//Source: Tietze, Vanessa ; Luhr, Sebastian ; Stolten, Detlef: Bulk Storage Vessels for Compressed and Liquid Hydrogen (2016), S. 659–689
//Table 27.9, page 676: p_max = 2 MPa
  extends PartialCostSpecs(
    size1=300 "Geometric volume in m3",
    C_inv_size=583.1*size1+186892 "Curve fitting for table data with pmax=20bar and V_geo=300, 1000 and 3000 m3",
    factor_OM=0.02 "2%, Stolzenburg 2014, small hydrogen storage",
    lifeTime=30 "Stolzenburg 2014, small hydrogen storage");
end HydrogenSphericalPressureVessel_20bar;
