within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model HydrogenSphericalPressureVessel "Hydrogen spherical pressure vessels (2500...55000m3 geo, 6-20 bar)"
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
//Figure 27.5, page 676: Spherical pressure vessels (6-20 bar)
  extends PartialCostSpecs(
    size1=1 "Geometric volume in m3",
    size2=20e5 "Maximum storage pressure in Pa",
    C_inv_size=162.37*dV_stp^(0.8658) "Curve fitting from figure for C over V_stp",
    factor_OM=0.02 "2%, Stolzenburg 2014, small storages",
    lifeTime=30 "Stolzenburg 2014, small storages");

  final parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK vle_h2;
  final parameter Real dV_stp=dm/TILMedia.VLEFluidFunctions.density_pTxi(vle_h2,1.01325e5,273.15);
  final parameter Real dm=(TILMedia.VLEFluidFunctions.density_pTxi(vle_h2,size2,288.15)-TILMedia.VLEFluidFunctions.density_pTxi(vle_h2,1.01325e5,288.15))*size1;
end HydrogenSphericalPressureVessel;
