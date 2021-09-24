within TransiEnt.Producer.Electrical.Base.CCS;
record CCP_PCC "CCGT-power plant with PCC"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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



  extends TransiEnt.Producer.Electrical.Base.CCS.NoCCS(
  CCS_Absolute_Efficiency_Loss=[
0.4, 0.1221182300884956;
0.5, 0.09963893805309736;
0.6, 0.08082973451327437;
0.8, 0.07761840707964605;
1,0.08],
  Deviation_CO2_Absolute_Efficiency_Loss=[
0.5,0.625298329;
0.508635436,0.635031325;
0.527200006,0.650320704;
0.545764576,0.665828503;
0.564329146,0.681227093;
0.581788682,0.695615491;
0.601458285,0.712461111;
0.620022855,0.728296539;
0.638587425,0.744241178;
0.657151995,0.759858187;
0.675716565,0.776130455;
0.694281135,0.791856674;
0.712845705,0.808456572;
0.731410275,0.825056469;
0.749974845,0.841547157;
0.768539415,0.858911524;
0.787103985,0.876385101;
0.805668555,0.893967887;
0.824233124,0.912533562;
0.842797694,0.931099237;
0.861362264,0.950538591;
0.879926834,0.972052932;
0.898491404,0.996406729;
0.9,1;
0.917055974,1.027203908;
0.935620544,1.071433899;
0.953301087,1.138454261;
0.968168816,1.235556452;
0.976080957,1.286396181]);
 // CO2_Deposition_Rate=0.9,
//1, 0.07991221238938055],
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Record for CCS via Post-Compostion-Capture (PCC) for a CCP-plant.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p><span style=\"font-family: Courier New;\">CCS_Absolute_Efficiency_Loss [1] </span>contains the absolute efficiency load of the power plant over the original relative load of power plant without CCS for one specific value of the deposited CO2 fraction.</p>
<p><span style=\"font-family: Courier New;\">Deviation_CO2_Absolute_Efficiency_Loss [2] </span>contains the deviation of the efficiency losses if the CO2 deposition fraction deviates from the original fraction.</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] A. Kather, S. Ehlers, J. Hitzwebel, &quot;CO2-Abtrennung in GuD-Kraftwerkspro-zessen mit Post-Combustion und Oxyfuel&quot; , Abschlussbericht, 2017, p. 28</p>
<p>[2] S. Ehlers, &quot;Auslegung und Optimierung einer nachgeschalteten CO2-Rauchgaswäsche in einem erdgasbefeuerten Gas- und Dampfturbinenkraftwerk&quot; , Dissertation, 2017, p. 59</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Schülting (oliver.schuelting@tuhh.de), Dec 2018</p>
</html>"));
end CCP_PCC;
