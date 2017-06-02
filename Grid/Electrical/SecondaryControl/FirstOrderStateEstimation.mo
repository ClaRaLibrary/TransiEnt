within TransiEnt.Grid.Electrical.SecondaryControl;
model FirstOrderStateEstimation "State estimation model with first order dynamics to improve secondary control activation (decoupling of economic dispatch and frequency control)"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //             Outer Parameters
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer nout=simCenter.generationPark.nDispPlants "Number of plants";
  parameter SI.Time T[nout]=0.63 ./ simCenter.generationPark.P_grad_max_star;

  Modelica.Blocks.Interfaces.RealInput u[nout] annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Math.Sum sum(nin=nout) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Blocks.Continuous.FirstOrder G_i_star[nout](T=T, each initType=Modelica.Blocks.Types.Init.InitialOutput) annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Math.Sum sum1(nin=nout) annotation (Placement(transformation(extent={{34,-46},{46,-34}})));

equation
  connect(u, sum.u) annotation (Line(points={{-120,0},{-12,0}}, color={0,0,127}));
  connect(sum.y, feedback.u1) annotation (Line(points={{11,0},{11,0},{52,0}}, color={0,0,127}));
  connect(feedback.y, y) annotation (Line(points={{69,0},{110,0},{110,0}}, color={0,0,127}));
  connect(sum1.y, feedback.u2) annotation (Line(points={{46.6,-40},{60,-40},{60,-8}}, color={0,0,127}));
  for i in 1:nout loop
    connect(u[i], G_i_star[i].u) annotation (Line(points={{-120,0},{-60,0},{-60,-40},{-12,-40}}, color={0,0,127}));
    connect(G_i_star[i].y, sum1.u[i]) annotation (Line(points={{11,-40},{32.8,-40}}, color={0,0,127}));
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics={
        Text(
          extent={{-8,34},{132,-38}},
          lineColor={0,0,0},
          textString="H"),
        Text(
          extent={{-21,-3},{48,-38}},
          lineColor={0,0,0},
          textString="entl"),
        Text(
          extent={{-122,40},{18,-32}},
          lineColor={0,0,0},
          textString="(s)")}));
end FirstOrderStateEstimation;
