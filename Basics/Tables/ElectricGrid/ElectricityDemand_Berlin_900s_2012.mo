within TransiEnt.Basics.Tables.ElectricGrid;
model ElectricityDemand_Berlin_900s_2012 "Electricity demand data in Berlin. Time resolution: 15 Minutes. Source: Stromnetz Berlin GmbH"
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
  extends TransiEnt.Basics.Tables.ElectricGrid.GenericPowerDataTable(relativepath="electricity/Electricity_Demand_BER_900s_01012012_31122012_.txt", datasource=DataPrivacy.isPublic)
    annotation (Placement(transformation(extent={{-18,-16},{16,16}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<h4><span style=\"color:#008000\">Description</span></h4>
<p>Total electricity generation in Hamburg in the year 2012 with 15 minutes time resolution.</p>
<p>This profile was created by adding the generation on the high voltage, medium voltage and low voltage levels reported in [1].</p>
<p><br><h4><span style=\"color:#008000\">Source</span></h4></p>
<p>[1] Stromnetz Hamburg GmbH: <i>Jahresh&ouml;chstlast der Netzlast und Lastverlauf</i>. URL http://www.stromnetz-hamburg.de/de/jahreshoechstlast-der-netzlast.htm</p>
<p><br><img src=\"modelica://TransiEnt/Graphics/ElectricityGeneration_HH_900s_2012.png\"/></p>
</html>"));
end ElectricityDemand_Berlin_900s_2012;
