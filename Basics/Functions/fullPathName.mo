within TransiEnt.Basics.Functions;
function fullPathName "Get full path name of file or directory name (with logging to console)"
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

  extends Icons.Function;
  input String name "Absolute or relative file or directory name";
  output String fullName "Full path of 'name'";

algorithm
  Modelica.Utilities.Streams.print(">> Looking for file: " + name);
  fullName:=Modelica.Utilities.Files.fullPathName(name);
  Modelica.Utilities.Streams.print(">> Calling File: " + fullName);

  annotation (Library="ModelicaExternalC",Documentation(info="<html>
<h4>Syntax</h4>
<p style=\"margin-left: 40px;\"><code><span style=\"font-family: Courier New,courier;\">fullName = Files.<b>fullPathName</b>(name);</span></code></p>
<h4>Description</h4>
<p>Returns the full path name of a file or directory &QUOT;name&QUOT;. </p>
</html>"));
end fullPathName;
