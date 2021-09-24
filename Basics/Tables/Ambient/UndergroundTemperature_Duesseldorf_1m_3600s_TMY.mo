within TransiEnt.Basics.Tables.Ambient;
model UndergroundTemperature_Duesseldorf_1m_3600s_TMY "Duesseldorf 1m depth 2017, 1 h resolution, Source: DWD-CDC"


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends GenericDataTable(
  relativepath="/ambient/UndergroundTemperature_Duesseldorf_1m_2017.txt",
  datasource=DataPrivacy.isPublic,
  tableName="default",
  columns={2});
  extends TransiEnt.Components.Boundaries.Ambient.Base.PartialTemperature;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation

 connect(y1, value);
 connect(y[1], value);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Underground temperature in Duesseldorf at 1m depth with 60 minutes time resolution.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Source: CDC DWD #DWD Climate Data Center (CDC): Hourly station observations of soil temperature at the depth of 100cm in &deg;C for Germany, version v18.1 &amp; recent</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Philipp Huismann (huismann@gwi-essen.de), Dec 2019</p>
</html>"),
    experiment(StopTime=31536000, __Dymola_Algorithm="Dassl"));
end UndergroundTemperature_Duesseldorf_1m_3600s_TMY;
