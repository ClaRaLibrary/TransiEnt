within TransiEnt.Examples.Heat;
model Test_DHN_SubSystem
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
  extends TransiEnt.Basics.Icons.Example;
  DHN_SubSystem dHN_SubSystem annotation (Placement(transformation(extent={{-252,-252},{248,128}})));
  TransiEnt.Basics.Blocks.Sources.PowerExpression powerExpression1(y=-1e6) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={152,206})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1 consumer2(use_Q_flow_in=true) annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=0,
        origin={136,160})));
  Modelica.Blocks.Sources.Constant p_sollWedel4(k=90)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-312,-232})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_hot_temperature(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    sign=1,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    u_ref=100,
    y_start=1e4,
    y_min=1e3,
    Tau_i=60,
    y_ref=5e6,
    y_max=5e6) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-332,-212})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1 producer1(use_Q_flow_in=true) annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-302,-168})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-340,180},{-320,200}})));
  inner TransiEnt.SimCenter simCenter(                                                                                                                                     k_H2_fraction=0.6,
    showExpertSummary=false,
    useHomotopy=false)
    annotation (Placement(transformation(extent={{-340,200},{-320,220}})));
equation
  connect(powerExpression1.y,consumer2. Q_flow_prescribed) annotation (Line(
      points={{152,195},{152,195},{152,178.4},{150,178.4}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(dHN_SubSystem.consumerInlet, consumer2.fluidPortIn) annotation (Line(
      points={{168,128},{168,140.4},{150.8,140.4}},
      color={175,0,0},
      thickness=0.5));
  connect(consumer2.fluidPortOut, dHN_SubSystem.consumerOutlet) annotation (Line(
      points={{118.8,140.4},{108,140.4},{108,127}},
      color={175,0,0},
      thickness=0.5));
  connect(p_sollWedel4.y,PID_hot_temperature. u_s) annotation (Line(points={{-318.6,-232},{-318,-232},{-330,-232},{-332,-232},{-332,-224}},                         color={0,0,127}));
  connect(PID_hot_temperature.y,producer1. Q_flow_prescribed) annotation (Line(points={{-332,-201},{-332,-201},{-332,-154},{-320,-154},{-320.4,-154}},                    color={0,0,127}));
  connect(producer1.fluidPortIn, dHN_SubSystem.producerInlet) annotation (Line(
      points={{-282.4,-153.2},{-282.4,-132},{-252,-132}},
      color={175,0,0},
      thickness=0.5));
  connect(producer1.fluidPortOut, dHN_SubSystem.producerOutlet) annotation (Line(
      points={{-282.4,-185.2},{-282.4,-192},{-252,-192}},
      color={175,0,0},
      thickness=0.5));
  connect(dHN_SubSystem.T1, PID_hot_temperature.u_m) annotation (Line(points={{-256,-212},{-288,-212},{-288,-211.9},{-320,-211.9}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,220}})),
    experiment(StopTime=86400, Interval=900),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for small closed-loop district heating subsystem. </p>
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
<p>Revised by Lisa Andresen (andresen@tuhh.de), Apr 2017</p>
</html>"));
end Test_DHN_SubSystem;
