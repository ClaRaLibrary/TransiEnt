within TransiEnt.Consumer.Heat.SpaceHeating.Base;
record FloorHeatingSystem "record for floor heating system"


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




  extends TransiEnt.Basics.Icons.Record;

  parameter Modelica.Units.SI.TemperatureDifference T_spreading=5 "Temperature spreading from inlet to outlet of the heating floor system" annotation (Dialog(group="Basic"));
  parameter Modelica.Units.SI.PressureDifference dp=0.2e5 "Pressure drop in the floor heating system" annotation (Dialog(group="Basic"));

  parameter Modelica.Units.SI.Length distance_pipes=0.15 "Distance between installed pipes of the heating floor system" annotation (Dialog(group="Pipes"));
  parameter Modelica.Units.SI.Length d_pipe=0.01 "Diameter of pipes" annotation (Dialog(group="Pipes"));
  parameter Real a_used=0.75 "Area ratio of the pipe which is used to transfer heat to the desired direction into the room"
                                                                                                    annotation(Dialog(group="Pipes"));

  final parameter Modelica.Units.SI.Area A_crossSectionalPipe=Modelica.Constants.pi/4*d_pipe^2 "Cross sectional area of the pipes of the floor heating system";

  // Floor fill
  parameter Modelica.Units.SI.Length h_floorFill=0.0045 "heigh of floorfill with high temperature (e.g. Estric)" annotation (Dialog(group="Floorfill"));
  parameter Modelica.Units.SI.Density rho_floor=2000 "density of the floor fill (e.g. Estrich)" annotation (Dialog(group="Floorfill"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_floor=1.116e3 "specific heat capacity of the floor (e.g. Estrich)" annotation (Dialog(group="Floorfill"));

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>record for floor heating system</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end FloorHeatingSystem;
