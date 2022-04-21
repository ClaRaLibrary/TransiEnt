within TransiEnt.Examples.Gas;
model Test_GasGrid_SubSystem


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

  extends TransiEnt.Basics.Icons.Example;
  inner TransiEnt.SimCenter simCenter(
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2 gasModel3,
    useHomotopy=false,
    T_ground=282.15) annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  GasGrid_SubSystem gasGrid_Example_Simple_PtG(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=1,
    k=1e8,
    P_el_n=3e6,
    m_flow_start=0.001,
    p_out=simCenter.p_amb_const + 35e5,
    phi_H2max=0.1) annotation (Placement(transformation(extent={{-40,-82},{68,22}})));
public
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(
        extent={{-10,10.5},{10,-10.5}},
        rotation=180,
        origin={-80,-19.5})));
  TransiEnt.Basics.Tables.ElectricGrid.ResidualLoadExample residualLoad(smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2, negResidualLoad=true) annotation (Placement(transformation(extent={{-90,-4},{-70,16}})));
  Modelica.Blocks.Math.Gain gain(k=1) annotation (Placement(transformation(extent={{-64,2},{-56,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink2(p_nom=0, m_flow_const=0) annotation (Placement(transformation(extent={{94,-52},{74,-32}})));


equation
  // _____________________________________________
  //
  //           Connect Statements
  // _____________________________________________


  connect(gain.y, gasGrid_Example_Simple_PtG.P_el_set) annotation (Line(points={{-55.6,6},{-50,6},{-50,6.4},{-38.92,6.4}}, color={0,0,127}));
  connect(residualLoad.P_el, gain.u) annotation (Line(points={{-69,6},{-69,6},{-64.8,6}}, color={0,0,127}));
  connect(sink2.gasPort, gasGrid_Example_Simple_PtG.gasIn) annotation (Line(
      points={{74,-42},{68,-42},{68,-43}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid.epp, gasGrid_Example_Simple_PtG.epp) annotation (Line(
      points={{-70,-19.5},{-56.95,-19.5},{-56.95,-19.6},{-40,-19.6}},
      color={0,135,135},
      thickness=0.5));
  annotation (
    Icon(graphics, coordinateSystem(preserveAspectRatio=false)),
    Diagram(graphics, coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=259200,
      Interval=900,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for closed-loop gas grid subsystem. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
<p>Created by Johannes Brunnemann (brunnemann@xrg-simulation.de), Jan 2017</p>
<p>Edited and revised by Lisa Andresen (andresen@tuhh.de), Apr 2017</p>
</html>"));
end Test_GasGrid_SubSystem;
