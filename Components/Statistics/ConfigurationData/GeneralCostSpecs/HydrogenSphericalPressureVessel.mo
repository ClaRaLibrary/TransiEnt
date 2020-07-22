within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model HydrogenSphericalPressureVessel "Hydrogen spherical pressure vessels (2500...55000m3 geo, 6-20 bar)"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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
  final parameter Real dV_stp=dm/TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_pTxi(vle_h2,1.01325e5,273.15);
  final parameter Real dm=(TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_pTxi(vle_h2,size2,288.15)-TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_pTxi(vle_h2,1.01325e5,288.15))*size1;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Hydrogen spherical pressure vessels (2500...55000m3 geo, 6-20 bar)</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] V. Tietze, S. Luhr, D.Stolten, &quot;Bulk Storage Vessels for Compressed and Liquid Hydrogen&quot;,2016, pp. 659&ndash;689 (see code for further information)</p>
<p>[2] K. Stolzenburg, &quot;Integration von Wind-Wasserstoff-Systemen in das Energiesystem&quot;, 2014 </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end HydrogenSphericalPressureVessel;
