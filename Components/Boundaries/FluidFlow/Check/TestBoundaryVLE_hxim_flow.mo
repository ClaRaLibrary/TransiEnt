within TransiEnt.Components.Boundaries.FluidFlow.Check;
model TestBoundaryVLE_hxim_flow "Model for testing BoundaryVLE_hxim_flow"



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

  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  inner TransiEnt.SimCenter simCenter(Q_flow_n=100e3, m_flow_nom=1) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  BoundaryVLE_hxim_flow boundaryVLE_hxim_flow(variable_m_flow=true, variable_xi=false,
    boundaryConditions(showData=true))                                                 annotation (Placement(transformation(extent={{-32,-18},{-12,2}})));
  Modelica.Blocks.Sources.Step m_flow_step(
    height=10,
    startTime=100,
    offset=20) annotation (Placement(transformation(extent={{-66,-12},{-46,8}})));
  Visualization.Quadruple                      quadruple2 annotation (Placement(transformation(extent={{0,-50},{40,-26}})));
  BoundaryVLE_phxi boundaryVLE_phxi(boundaryConditions(showData=true)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,2})));
  Visualization.Quadruple                      quadruple1 annotation (Placement(transformation(extent={{34,37},{74,63}})));
  BoundaryVLE_hxim_flow boundaryVLE_hxim_flow1(                     variable_xi=false,
    boundaryConditions(showData=true, m_flow_const=100),
    variable_m_flow=false)                                                             annotation (Placement(transformation(extent={{-32,30},{-12,50}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(m_flow_step.y, boundaryVLE_hxim_flow.m_flow) annotation (Line(points={{-45,-2},{-39.5,-2},{-34,-2}}, color={0,0,127}));
  connect(boundaryVLE_hxim_flow.eye, quadruple2.eye) annotation (Line(points={{-12,-16},{-6,-16},{-6,-38},{0,-38}}, color={190,190,190}));
  connect(boundaryVLE_hxim_flow.fluidPortOut, boundaryVLE_phxi.fluidPortIn) annotation (Line(
      points={{-12,-8},{8.9,-8},{8.9,2},{20,2}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryVLE_phxi.eye, quadruple1.eye) annotation (Line(points={{20,10},{16,10},{16,50},{34,50}},                 color={190,190,190}));
  connect(boundaryVLE_hxim_flow1.fluidPortOut, boundaryVLE_phxi.fluidPortIn) annotation (Line(
      points={{-12,40},{0,40},{0,2},{20,2}},
      color={175,0,0},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for BoundaryVLE_hxim_flow</p>
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
end TestBoundaryVLE_hxim_flow;
