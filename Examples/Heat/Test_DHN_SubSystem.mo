within TransiEnt.Examples.Heat;
model Test_DHN_SubSystem
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

  extends TransiEnt.Basics.Icons.Example;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-340,180},{-320,200}})));
  inner TransiEnt.SimCenter simCenter(
    k_H2_fraction=0.6,
    showExpertSummary=false,
    useHomotopy=false) annotation (Placement(transformation(extent={{-340,200},{-320,220}})));

  DHN_SubSystem dHN_SubSystem annotation (Placement(transformation(extent={{-252,-252},{248,128}})));
  TransiEnt.Basics.Blocks.Sources.PowerExpression powerExpression1(y=-1e6) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={152,206})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1 consumer2(use_Q_flow_in=true) annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=0,
        origin={136,160})));
  Modelica.Blocks.Sources.Constant p_setWedel4(k=90) annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=180)));
  ClaRa.Components.Utilities.Blocks.LimPID PID_hot_temperature(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    sign=1,
    u_ref=100,
    y_start=1e4,
    y_min=1e3,
    Tau_i=60,
    y_ref=5e6,
    y_max=5e6,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-332,-212})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1 producer1(use_Q_flow_in=true) annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-302,-168})));

equation
  // _____________________________________________
  //
  //           Connect Statements
  // _____________________________________________

  connect(powerExpression1.y, consumer2.Q_flow_prescribed) annotation (Line(
      points={{152,195},{152,195},{152,176},{148,176}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(dHN_SubSystem.consumerInlet, consumer2.fluidPortIn) annotation (Line(
      points={{168,128},{168,140},{148,140}},
      color={175,0,0},
      thickness=0.5));
  connect(consumer2.fluidPortOut, dHN_SubSystem.consumerOutlet) annotation (Line(
      points={{124,140},{108,140},{108,127}},
      color={175,0,0},
      thickness=0.5));
  connect(p_setWedel4.y, PID_hot_temperature.u_s) annotation (Line(points={{-6.6,0},{-318,0},{-318,-232},{-332,-232},{-332,-224}}, color={0,0,127}));
  connect(PID_hot_temperature.y, producer1.Q_flow_prescribed) annotation (Line(points={{-332,-201},{-332,-201},{-332,-154},{-318,-154},{-318,-156}}, color={0,0,127}));
  connect(producer1.fluidPortIn, dHN_SubSystem.producerInlet) annotation (Line(
      points={{-282,-156},{-282,-132},{-252,-132}},
      color={175,0,0},
      thickness=0.5));
  connect(producer1.fluidPortOut, dHN_SubSystem.producerOutlet) annotation (Line(
      points={{-282,-180},{-282,-192},{-252,-192}},
      color={175,0,0},
      thickness=0.5));
  connect(dHN_SubSystem.T1, PID_hot_temperature.u_m) annotation (Line(points={{-256,-212},{-288,-212},{-288,-211.9},{-320,-211.9}}, color={0,0,127}));
  annotation (
    Icon(graphics, coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(graphics, coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,220}})),
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
