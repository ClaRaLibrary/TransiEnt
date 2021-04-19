within TransiEnt.Components.Boundaries.FluidFlow.Check;
model TestBoundaryVLE_pTxi "Model for testing BoundaryVLE_pTxi"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
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
  BoundaryVLE_Txim_flow boundaryVLE_hxim_flow(variable_m_flow=true, variable_xi=false) annotation (Placement(transformation(extent={{-30,14},{-10,34}})));
  Modelica.Blocks.Sources.Step T_step(
    startTime=100,
    height=20,
    offset=273.15) annotation (Placement(transformation(extent={{-64,20},{-44,40}})));
  BoundaryVLE_pTxi boundaryVLE_pTxi annotation (Placement(transformation(extent={{24,14},{4,34}})));
  Visualization.Quadruple                      quadruple2 annotation (Placement(transformation(extent={{0,-70},{82,-8}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(T_step.y, boundaryVLE_hxim_flow.m_flow) annotation (Line(points={{-43,30},{-32,30}},          color={0,0,127}));
  connect(boundaryVLE_hxim_flow.fluidPortOut, boundaryVLE_pTxi.fluidPortIn) annotation (Line(
      points={{-10,24},{-3.1,24},{4,24}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryVLE_hxim_flow.eye, quadruple2.eye) annotation (Line(points={{-10,16},{-6,16},{-6,-39},{0,-39}}, color={190,190,190}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for BoundaryVLE_pTxi</p>
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
end TestBoundaryVLE_pTxi;
