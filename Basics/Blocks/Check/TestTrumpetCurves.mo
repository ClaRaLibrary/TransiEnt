within TransiEnt.Basics.Blocks.Check;
model TestTrumpetCurves
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
  extends Icons.Checkmodel;
  Grid.Electrical.Base.TrumpetCurveAdvanced trumpetCurveAdvanced annotation (Placement(transformation(extent={{-54,48},{-34,68}})));
  Grid.Electrical.Base.TrumpetCurveAdvanced trumpetCurveAdvanced1(P_Z=567e6) annotation (Placement(transformation(extent={{-58,-16},{-38,4}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=1100),
    __Dymola_experimentSetupOutput);
end TestTrumpetCurves;
