within TransiEnt.Basics;
package Tables
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
extends .TransiEnt.Basics.Icons.TableDataPackage;















































annotation (                  Documentation(info="<html>
<h4><span style=\"color:#008000\">General Description</span></h4>
<p>Tables are a way of feeding in data (time series) into the models. </p>
<p><br>There are mainly two types of tables:</p>
<ul>
<li>Generic DataTable: reads time series from a TXT file </li>
<li>GenericCombiTimeTable1Ds: reads a time changing variable (for instance outdoor temperature), reads a characteristic line from a TXT file and then delivers a result.</li>
</ul>
<p><br>These tables can have one or multiple outputs, depending on your application.</p>
<p>The model &QUOT;DataPrivacy&QUOT; is used for protecting confidential data during the library development process. It may be removed when the library is published.</p>
<p><br><br><b><font style=\"color: #008000; \">Importing your own data</font></b></p>
<p>Data can be easily converted in the proper format needed by means of the tool &QUOT;ModelicaConverter&QUOT;. This is an excel table with a built in macro, which formats your data into a format which Dymola can read. Besides, the converter helps you converting your data into the proper units (see section &QUOT;Units convention&QUOT;)</p>
<p><br><br><b><font style=\"color: #008000; \">Units Convention</font></b></p>
<p>For the models to work properly, the following conventions regarding the units must be followed:</p>
<ul>
<li>Temperatures: &deg;C</li>
<li>Heat flow rates: W</li>
<li>Electric Power: W</li>
<li>Solar irradiance: W/m2</li>
<li>Volume flows: m3/s</li>
<li>Wind speed: m/s</li>
</ul>
</html>"));
end Tables;
