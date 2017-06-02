within TransiEnt.Basics.Tables.GasGrid;
model NaturalGasVolumeFlowSTP
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
  extends TransiEnt.Basics.Tables.GasGrid.GenericGasVolumeFlowDataTable(relativepath="/gas/NaturalGasVolumeFlow_RingSupplyLineHHReitbrook_2009_2011_Average_Monotonic.txt", datasource=DataPrivacy.isPublic);
  annotation (Documentation(info="<html>
<h4><span style=\"color:#008000\">Description</span></h4>
<p><br>Average volume flow in Nm3/h from 2009 until 2011 for the Reitbrook Ring-supply line. It has been converted to m3/s.</p>
<p><br><br><img src=\"modelica://TransiEnt/Images/Gas Ganglinie.JPG\"/></p>
<h4><span style=\"color:#008000\">Source:</span></h4>
<p>Brauer, Thomas ; Schoof, Ren&eacute;: Kompaktes 1 MW - PEM - Wasserelektrolysesystem. Regenerativer Wasserstoff f&uuml;r Mobilit&auml;t und Energiespeicherung. In: <i>NIP Vollversamlung</i>, 2013</p>
</html>"));
end NaturalGasVolumeFlowSTP;
