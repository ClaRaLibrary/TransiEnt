within TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs;
model PumpStorage "Pumped storage cost specification record"


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




  //C_inv in EUR/W: Mittelwert der Investitionskosten der PSW "Linth-Limmern (CH) 2015" (875€/kW), Nant-de-Drance (CH) 2017" (1666,67€/kW), "Südschwarzwald (D) 2019" (857,14€/kW) und "Goldisthal (D) 2004" (587,74€/kW) https://www.eeh.ee.ethz.ch/uploads/tx_ethpublications/GA_AebliTruessel_FS2012.pdf
  //77,18Mio€/2000MW nach "Rentabilität von Pumpspeicherkraftwerken" an der ETH ,S.15 https://www.eeh.ee.ethz.ch/uploads/tx_ethpublications/GA_AebliTruessel_FS2012.pdf
  extends PartialStorageCostSpecs(
 Cspec_inv_der_E=0.730/1e3,
 Cspec_inv_E=0,
 Cspec_fixOM=0.048/1e3,
 Cspec_OM_W_el=0,
 lifeTime=simCenter.Duration);
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Pumped storage cost specification record</p>
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
<p>[1] M. Aebli, J. Trüssel, &quot;Rentabilität von Pumpspeicherkraftwerken&quot;, 2012, Zuerich</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end PumpStorage;
