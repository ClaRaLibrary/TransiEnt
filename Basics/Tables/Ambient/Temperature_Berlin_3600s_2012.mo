within TransiEnt.Basics.Tables.Ambient;
model Temperature_Berlin_3600s_2012 "Berlin 2012, 1 h  resolution. Source: WebWerdis"
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
extends TransiEnt.Basics.Tables.GenericDataTable(relativepath="/ambient/Temperature_Berlin_Tempelhof_3600s_01012012_31122012.txt", datasource=DataPrivacy.isPublic);
extends TransiEnt.Components.Boundaries.Ambient.Base.PartialTemperature;

equation
 connect(y1, value);
 connect(y[1], value);
  annotation (Documentation(info="<html>
<h4><span style=\"color:#008000\">Description</span></h4>
<p>Ambient temperature in Hamburg in the year 2012 with 15 minutes time resolution.</p>
<p>This profile was created by creating 15 minute averages from the 1 minute values provided by [1]. Missing values were substituted by interpolated values between the values at the extremes of the missing intervals.</p>
<h4><span style=\"color:#008000\">Source</span></h4>
<p>[1] Lange, Ingo. KlimaCampus - Wettermast Hamburg. Universit&auml;t Hamburg - Meteorologisches Institut http://wettermast-hamburg.zmaw.de</p>
<p><br><img src=\"modelica://TransiEnt/Graphics/TemperatureHH_900s_2012.png\"/></p>
</html>"));
end Temperature_Berlin_3600s_2012;
