within TransiEnt.Consumer.Heat.SpaceHeating.Base;
record RoomGeometry "record for room geometry"


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

  // Room geometry

  parameter Modelica.Units.SI.Length a=10 "Length of the room";
  parameter Modelica.Units.SI.Length b=10 "Width of the room";
  parameter Modelica.Units.SI.Length h=2.9 "Hight of the room";
  parameter Modelica.Units.SI.Length d_wall=0.6 "Thickness of the external walls";
  parameter Modelica.Units.SI.Length d_wallInt=0.25 "Thickness of the internal walls";
  parameter Modelica.Units.SI.Length d_ceiling=0.4 "Thickness of the ceiling";

  final parameter Modelica.Units.SI.Volume V_room=a*b*h*0.76 "Volume of the house according to EnEV";
  final parameter Modelica.Units.SI.Area A_eff=V_room/0.76*0.32 "effective area of the house";
  final parameter Modelica.Units.SI.Area A_ext=(2*a + 2*b)*(h - d_ceiling) "walls to the environement";
  final parameter Modelica.Units.SI.Area A_int=(2*a + b)*(h - d_ceiling) "walls in the house";
  final parameter Modelica.Units.SI.Area A_floor=a*b "Floor with installed heating floor system";
  final parameter Modelica.Units.SI.Area A_roof=a*b*0.5 "Roof area of a house with two floors";

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>record for room geometry</p>
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
end RoomGeometry;
