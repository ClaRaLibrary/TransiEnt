within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model HydrogenSphericalPressureVessel_20bar "Hydrogen spherical pressure vessels (2500...55000m3 geo, 20bar)"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
//Table 27.9, page 676: p_max = 2 MPa
  extends PartialCostSpecs(
    size1=300 "Geometric volume in m3",
    C_inv_size=583.1*size1+186892 "Curve fitting for table data with pmax=20bar and V_geo=300, 1000 and 3000 m3",
    factor_OM=0.02 "2%, Stolzenburg 2014, small hydrogen storage",
    lifeTime=30 "Stolzenburg 2014, small hydrogen storage");
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Hydrogen spherical pressure vessels (2500...55000m3 geo, 20bar)</p>
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
end HydrogenSphericalPressureVessel_20bar;
