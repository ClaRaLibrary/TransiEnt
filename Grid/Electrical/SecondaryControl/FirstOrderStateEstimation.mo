within TransiEnt.Grid.Electrical.SecondaryControl;
model FirstOrderStateEstimation "State estimation model"



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
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics={
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
          textString="(s)")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>State estimation model with first order dynamics to improve secondary control activation (decoupling of economic dispatch and frequency control)</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p><p>L2E: Models are based on (dynamic) transfer functions or differential equations.</p>
<p>nonlinear behavior</p></p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>u[nout]: Input signals from power plants base loads</p>
<p>y: Output signal for secondary balancing control</p>
<p>nout: Number of considered power plants</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) in 10/2014</span></p>
</html>"));
end FirstOrderStateEstimation;
