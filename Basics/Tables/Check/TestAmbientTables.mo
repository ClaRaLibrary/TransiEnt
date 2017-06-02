within TransiEnt.Basics.Tables.Check;
model TestAmbientTables
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  inner Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{10,80},{30,100}})));
  Ambient.GHI_Hamburg_3600s_2012_TMY gHI_Hamburg_3600s_2012_TMY
    annotation (Placement(transformation(extent={{-38,36},{-18,56}})));
  Ambient.DNI_Hamburg_3600s_2012_TMY dNI_Hamburg_3600s_2012_TMY
    annotation (Placement(transformation(extent={{-58,6},{-38,26}})));
  Ambient.DHI_Hamburg_3600s_2012_TMY dHI_Hamburg_3600s_2012_TMY
    annotation (Placement(transformation(extent={{-86,-30},{-66,-10}})));
  Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012
    wind_Hamburg_Fuhlsbuettel_3600s_2012_1
    annotation (Placement(transformation(extent={{14,38},{34,58}})));
  Ambient.Wind_Hamburg_3600s_TMY wind_Hamburg_3600s_TMY
    annotation (Placement(transformation(extent={{14,4},{34,24}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestAmbientTables;
