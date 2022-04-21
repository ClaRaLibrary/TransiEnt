within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model PeakLoadBoiler "Peak load boiler (gas-fired)"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//




//Lund, H., Moeller, B., Mathiesen, B. V., & Dyrelund, A. (2010). The role of district heating in future renewable energy systems. Energy, 35(3), 1381–1390. https://doi.org/10.1016/j.energy.2009.11.023
//Peak load boiler, Table 3
extends PartialCostSpecs(
    Cspec_inv_der_E=150/1000 "EUR/W",
    factor_OM=0.03 "Percentage of the invest cost that represents the annual O&M cost",
    Cspec_OM_Q=0.15/3.6e9 "Specific O&M cost per heating energy in EUR/J",
    lifeTime=20);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Peak load boiler (gas-fired)</p>
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
<p>[1] H. Lund, B. Moeller, B. V. Mathiesen, A. Dyrelund, &quot;The role of district heating in future renewable energy systems&quot;. Energy, 2010, 35(3), pp. 1381&ndash;1390</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end PeakLoadBoiler;
