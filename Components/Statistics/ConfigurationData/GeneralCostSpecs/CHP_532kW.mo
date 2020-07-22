within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model CHP_532kW "CHP plant (532 kW, gas-fired)"
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
  // ASUE BHKW Grundlagen
  // CHP with 532 kW based on Infromation for 20 and 2000 kW
  // CHP with gas engine
  // powered with waste gas (emissions and costs are different to natural gas)

extends PartialCostSpecs(
    Cspec_inv_der_E=1 "EUR/W",
    factor_OM=0.045 "Percentage of the invest cost that represents the annual O&M cost",
    Cspec_OM_W_el=1.2/100/3.6e6 "EUR/J",
    lifeTime=20 "Life time");

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>CHP plant (532 kW, gas-fired)</p>
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
<p>[1]  ASUE Arbeitsgemeinschaft für sparsamen und umweltfreundlichen Energieverbrauch e.V., &quot;BHKW Grundlagen&quot;, 2010</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end CHP_532kW;
