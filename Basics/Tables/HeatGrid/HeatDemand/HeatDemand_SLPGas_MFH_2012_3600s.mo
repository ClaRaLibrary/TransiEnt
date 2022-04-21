within TransiEnt.Basics.Tables.HeatGrid.HeatDemand;
model HeatDemand_SLPGas_MFH_2012_3600s "SLP Gas for heating and hot-Water energy demand for multi-family houses scaled to 1 J"


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





  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

extends GenericDataTable(
relativepath="gas/HMF_Gas_1J_2012_3600s.txt",
datasource=DataPrivacy.isPublic,
constantfactor = Q_demand);

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

parameter SI.Energy Q_demand = 1 "Heating and hot Water demand of the multi-family houses";
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Extends Tools.GenericDataTable, defining MSL CombiTimeTable with data paths and interfaces. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>calculated by gas load BDEW/WKU/GEODE, normed with annual heat consumption Hamburg</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Calculated standard load profile for multy-family houses in Hamburg.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealOutput y[noutCombiTimeTable]</p>
<p>Modelica RealOutput: y1</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>This is a calculated standard load profile calculated by VDI 4655.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(calculated profile, if possible, compare to measured profile)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] <span style=\"font-family: sans-serif;\">BDEW Bundesverband der Energie-und Wasserwirtschaft e.V., Verband kommunaler Unternehmen e.V.(VKU), GEODE &ndash; Groupement Europ&eacute;en des entreprises et Organismes de Distribution d&rsquo;&Eacute;nergie (EWIV), </span>&quot;BDEW/VKU/GEODE Leitfaden&quot;, 2013</p>
<p>[2] VDI-Gesellschaft Energie und Umwelt, &quot;VDI 4655 Referenzlastprofile von Ein- und Mehrfamilienhäusern für den Einsatz von KWK-Anlagen&quot;, 2008</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end HeatDemand_SLPGas_MFH_2012_3600s;
