within TransiEnt.Basics.Tables.Ambient;
model Wind_Hamburg_Fuhlsbuettel_3600s_2012 "Hamburg-Fuhlsbuettel 2012, 1 h resolution, Source: WebWerdis"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

extends GenericDataTable(
relativepath="/ambient/Wind_Hamburg-Fuhlsbuettel_3600s_01012012_31122012_10m.txt",
datasource=DataPrivacy.isPublic);
extends TransiEnt.Components.Boundaries.Ambient.Base.PartialWindspeed;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  //  y=value;

 connect(y1, value);
 connect(y[1], value);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Wind Speed in Hamburg in 2012 with 60 minutes time resolution.</p>
<p>Data from Hamburg Fuhlsbuettel (Lattitude: 53.633 ; Longitude: 9.988 ; station height above sea level: 11m ; height of wind measurement over ground: 10m)</p>
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
<p>[1] DeutscherWetterDienst DWD2015, https://werdis.dwd.de</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Max Mustermann (mustermann@mustermail.de), Apr 2014</p>
</html>"));
end Wind_Hamburg_Fuhlsbuettel_3600s_2012;
