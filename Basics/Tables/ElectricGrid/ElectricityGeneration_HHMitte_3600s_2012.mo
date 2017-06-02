within TransiEnt.Basics.Tables.ElectricGrid;
model ElectricityGeneration_HHMitte_3600s_2012 "Hourly electricity generation data in Hamburg-Mitte. Source: Energie Portal Hamburg "
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
  extends GenericPowerDataTable(      relativepath="electricity/ElectricityGeneration_Mitte_3600s_01012012_31122012.txt",
      datasource=DataPrivacy.isPublic)
    annotation (Placement(transformation(extent={{-18,-16},{16,16}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<h4><span style=\"color:#008000\">Description</span></h4>
<p>Total electricity generation in Hamburg-Mitte in the year 2012 with hourly time resolution.</p>
<h4><span style=\"color:#008000\">Source</span></h4>
<p>Stromnetz Hamburg GmbH: <i>Energieportal Hamburg</i>. URL http://www.energieportal-hamburg.de/distribution/energieportal/</p>
<p><br><br><img src=\"modelica://TransiEnt/Images/ElectricityGeneration_HHMitte_3600s_2012.png\"/></p>
</html>"));
end ElectricityGeneration_HHMitte_3600s_2012;
