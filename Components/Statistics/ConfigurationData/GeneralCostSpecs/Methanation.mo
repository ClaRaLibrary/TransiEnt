within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model Methanation "Methanation 2020"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

//Joachim Nitsch, Thomas Pregger, Tobias Naegler, Dominik Heide, Diego Luca de Tena, Franz Trieb, Yvonne Scholz, et al. 2012. “Langfristszenarien Und Strategien Für Den Ausbau Der Erneuerbaren Energien in Deutschland Bei Berücksichtigung Der Entwicklung in Europa Und Global. Schlussbericht.” Stuttgart, Kassel, Teltow.
  extends PartialCostSpecs(
    size1=1e6 "H_flow_n_CH4: Nominal methane enthalpy flow rate",
    C_inv_size=(400e-3)*size1,
    factor_OM=0.02,
    lifeTime=20);
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(no remarks)</p>
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
<p>[1] J.&nbsp;Nitsch,&nbsp;T.&nbsp;Pregger,&nbsp;T.&nbsp;Naegler,&nbsp;D.&nbsp;Heide,&nbsp;D.&nbsp;L.&nbsp;de&nbsp;Tena,&nbsp;F.&nbsp;Trieb,&nbsp;Y.&nbsp;Scholz,&nbsp;&ldquo;Langfristszenarien&nbsp;Und&nbsp;Strategien&nbsp;F&uuml;r&nbsp;Den&nbsp;Ausbau&nbsp;Der&nbsp;Erneuerbaren&nbsp;Energien&nbsp;in&nbsp;Deutschland&nbsp;Bei&nbsp;Ber&uuml;cksichtigung&nbsp;Der&nbsp;Entwicklung&nbsp;in&nbsp;Europa&nbsp;Und&nbsp;Global.&nbsp;Schlussbericht.&rdquo;, et al. 2012,&nbsp;Stuttgart,&nbsp;Kassel,&nbsp;Teltow.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end Methanation;
