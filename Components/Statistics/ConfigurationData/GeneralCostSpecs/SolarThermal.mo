within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model SolarThermal "Solar thermal flat plate collectors"
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
//Source: http://elib.dlr.de/89658/2/Sperber_Viebahn_FVEE-Themen_2013.pdf
//A_tot = 4000 m2, system cost
extends PartialCostSpecs(
    size1=1 "Area in m2",
    C_inv_size=size1*220 "220 EUR/m2",
    factor_OM=4/300 "Percentage of the invest cost that represents the annual O&M cost",
    Cspec_OM_Q=1/1000/3.6e6 "Specific O&M cost per heating energy",
    lifeTime=20 "Life time");

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Solar thermal flat plate collectors</p>
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
<p>[1] E.Sperber, P. Viebahn, &quot;Techno-ökonomische Perspektive &ndash;Systeminnovationen am Beispiel des Strom-Wärme-Systems&quot;, FVEE Themen, 2013</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end SolarThermal;
