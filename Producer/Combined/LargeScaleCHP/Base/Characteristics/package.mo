within TransiEnt.Producer.Combined.LargeScaleCHP.Base;
package Characteristics "Characterstics of large scale CHP plants (PQ-Boundaries and Heat input table)"
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
  extends TransiEnt.Basics.Icons.DataPackage;































annotation (Documentation(info="<html>
<p><span style=\"font-size: 8pt;\">All records (PQ diagrams and Heat input matrixes) included in this package are included with the intention of illustrating the modelling concept.</span></p>
<p><span style=\"font-size: 8pt;\">However, users are encouraged to create their own records based on the plants and scenarios that they want to simulate.</span></p>
<p><span style=\"font-size: 8pt;\">Contents were either extracted from a literature source or estimated with stationary simulations in a power plant simulation program</span></p>
<p><span style=\"font-size: 8pt;\">Values outside of the PQ limits are included to allow the modeling of start-up and shut down processes.</span></p>
</html>"));
end Characteristics;
