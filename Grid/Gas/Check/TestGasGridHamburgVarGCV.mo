within TransiEnt.Grid.Gas.Check;
model TestGasGridHamburgVarGCV "High pressure gas grid of Hamburg with variable gross calorific value at consumption side"
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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;

  //FeedInControl
  parameter Real phi_H2max=0.1 annotation(Evaluate=false);
  parameter Real k_consumer=1e6 annotation(Evaluate=false);
  parameter Real Nper10km=5 "Number of discrete volumes in 10 km pipe length";
  parameter Boolean productMassBalance=false "Set to true for product component mass balance formulation in pipe";

  // Variable declarations
   SI.Energy H_demand "Gas demand";
  SI.Mass m_H2_max(start=0,fixed=true) "Maximal H2 mass that could be fed into the gas grid" annotation(stateSelect=StateSelect.never);
  SI.Mass m_gas_import=-(GTS_Tornesch.m+GTS_Leversen.m+GTS_Reitbrook.m) "Gas demand with H2 fed into the grid";

  inner TransiEnt.SimCenter simCenter(
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    p_amb=101343,
    T_amb=283.15)             annotation (Placement(transformation(extent={{-286,212},{-258,240}})));

  inner TransiEnt.Grid.Gas.StatCycleGasGridHamburg Init(
    m_flow_feedIn_Tornesch=0.01,
    m_flow_feedIn_Leversen=0.01,
    m_flow_feedIn_Reitbrook=0.01,
    h_source=-1849.95) annotation (Placement(transformation(extent={{-296,184},{-249,218}})));

  TransiEnt.Grid.Gas.GasGridHamburg gasGridHamburg(
    phi_H2max=phi_H2max,
    Nper10km=Nper10km,
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-230,-182},{266,198}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Harburg(
    length(displayUnit="km") = 3770,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_Harburg,
    xi_start=Init.Harburg.pipe.xi_in,
    p_nom=ones(Harburg.pipe.N_cv)*Init.Harburg.pipe.p_in,
    h_nom=ones(Harburg.pipe.N_cv)*Init.Harburg.pipe.h_in,
    p_start=linspace(
        Init.Harburg.pipe.p_in,
        Init.Harburg.pipe.p_out,
        Harburg.N_cv),
    h_start=ones(Harburg.pipe.N_cv)*Init.Harburg.pipe.h_in,
    m_flow_start=ones(Harburg.pipe.N_cv + 1)*Init.Harburg.pipe.m_flow,
    N_tubes=17,
    m_flow_nom=Init.m_flow_nom_Harburg,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*Harburg.length/10000) < 2 then 2 else integer(Nper10km*Harburg.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-42,-81},{-22,-61}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Altona(
    length(displayUnit="km") = 5150,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_Altona,
    xi_start=Init.Altona.pipe.xi_in,
    p_nom=ones(Altona.pipe.N_cv)*Init.Altona.pipe.p_in,
    h_nom=ones(Altona.pipe.N_cv)*Init.Altona.pipe.h_in,
    p_start=linspace(
        Init.Altona.pipe.p_in,
        Init.Altona.pipe.p_out,
        Altona.N_cv),
    h_start=ones(Altona.pipe.N_cv)*Init.Altona.pipe.h_in,
    m_flow_start=ones(Altona.pipe.N_cv + 1)*Init.Altona.pipe.m_flow,
    N_tubes=18,
    m_flow_nom=Init.m_flow_nom_Altona,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*Altona.length/10000) < 2 then 2 else integer(Nper10km*Altona.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-62,-3},{-42,17}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Eimsbuettel(
    length(displayUnit="km") = 2740,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_Eimsbuettel,
    xi_start=Init.Eimsbuettel.pipe.xi_in,
    p_nom=ones(Eimsbuettel.pipe.N_cv)*Init.Eimsbuettel.pipe.p_in,
    h_nom=ones(Eimsbuettel.pipe.N_cv)*Init.Eimsbuettel.pipe.h_in,
    p_start=linspace(
        Init.Eimsbuettel.pipe.p_in,
        Init.Eimsbuettel.pipe.p_out,
        Eimsbuettel.N_cv),
    h_start=ones(Eimsbuettel.pipe.N_cv)*Init.Eimsbuettel.pipe.h_in,
    m_flow_start=ones(Eimsbuettel.pipe.N_cv + 1)*Init.Eimsbuettel.pipe.m_flow,
    N_tubes=12,
    m_flow_nom=Init.m_flow_nom_Eimsbuettel,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*Eimsbuettel.length/10000) < 2 then 2 else integer(Nper10km*Eimsbuettel.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-42,34},{-22,54}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow HHNord(
    length(displayUnit="km") = 10560,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_HHNord,
    xi_start=Init.HHNord.pipe.xi_in,
    p_nom=ones(HHNord.pipe.N_cv)*Init.HHNord.pipe.p_in,
    h_nom=ones(HHNord.pipe.N_cv)*Init.HHNord.pipe.h_in,
    p_start=linspace(
        Init.HHNord.pipe.p_in,
        Init.HHNord.pipe.p_out,
        HHNord.N_cv),
    h_start=ones(HHNord.pipe.N_cv)*Init.HHNord.pipe.h_in,
    m_flow_start=ones(HHNord.pipe.N_cv + 1)*Init.HHNord.pipe.m_flow,
    N_tubes=14,
    m_flow_nom=Init.m_flow_nom_HHNord,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*HHNord.length/10000) < 2 then 2 else integer(Nper10km*HHNord.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={2,84})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Wandsbek(
    length(displayUnit="km") = 4700,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_Wandsbek,
    xi_start=Init.Wandsbek.pipe.xi_in,
    p_nom=ones(Wandsbek.pipe.N_cv)*Init.Wandsbek.pipe.p_in,
    h_nom=ones(Wandsbek.pipe.N_cv)*Init.Wandsbek.pipe.h_in,
    p_start=linspace(
        Init.Wandsbek.pipe.p_in,
        Init.Wandsbek.pipe.p_out,
        Wandsbek.N_cv),
    h_start=ones(Wandsbek.pipe.N_cv)*Init.Wandsbek.pipe.h_in,
    m_flow_start=ones(Wandsbek.pipe.N_cv + 1)*Init.Wandsbek.pipe.m_flow,
    N_tubes=4,
    m_flow_nom=Init.m_flow_nom_Wandsbek,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*Wandsbek.length/10000) < 2 then 2 else integer(Nper10km*Wandsbek.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={48,62})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow HHMitte(
    length(displayUnit="km") = 9480,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_HHMitte,
    xi_start=Init.HHMitte.pipe.xi_in,
    p_nom=ones(HHMitte.pipe.N_cv)*Init.HHMitte.pipe.p_in,
    h_nom=ones(HHMitte.pipe.N_cv)*Init.HHMitte.pipe.h_in,
    p_start=linspace(
        Init.HHMitte.pipe.p_in,
        Init.HHMitte.pipe.p_out,
        HHMitte.N_cv),
    h_start=ones(HHMitte.pipe.N_cv)*Init.HHMitte.pipe.h_in,
    m_flow_start=ones(HHMitte.pipe.N_cv + 1)*Init.HHMitte.pipe.m_flow,
    N_tubes=23,
    m_flow_nom=Init.m_flow_nom_HHMitte,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*HHMitte.length/10000) < 2 then 2 else integer(Nper10km*HHMitte.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={42,-18})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Bergedorf(
    length(displayUnit="km") = 6770,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_Bergedorf,
    xi_start=Init.Bergedorf.pipe.xi_in,
    p_nom=ones(Bergedorf.pipe.N_cv)*Init.Bergedorf.pipe.p_in,
    h_nom=ones(Bergedorf.pipe.N_cv)*Init.Bergedorf.pipe.h_in,
    p_start=linspace(
        Init.Bergedorf.pipe.p_in,
        Init.Bergedorf.pipe.p_out,
        Bergedorf.N_cv),
    h_start=ones(Bergedorf.pipe.N_cv)*Init.Bergedorf.pipe.h_in,
    m_flow_start=ones(Bergedorf.pipe.N_cv + 1)*Init.Bergedorf.pipe.m_flow,
    N_tubes=15,
    m_flow_nom=Init.m_flow_nom_Bergedorf,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*Bergedorf.length/10000) < 2 then 2 else integer(Nper10km*Bergedorf.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={66,-77})));

  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP H_flow_demand(constantfactor=simCenter.f_gasDemand*12.14348723*3.6e6/7) annotation (Placement(transformation(extent={{80,-170},{44,-134}})));

  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-258,212},{-230,240}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Tor(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10.5},{10,-10.5}},
        rotation=0,
        origin={-174,154.5})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Tornesch(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-224,138},{-192,170}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Tornesch(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-156,154},{-136,174}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Lev(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-146,-140})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Leversen(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-206,-157},{-174,-125}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Leversen(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-114,-140},{-94,-120}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Rei(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={178,-76})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Reitbrook(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(
        extent={{-18,17},{18,-17}},
        rotation=180,
        origin={226,-77})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Reitbrook(compositionDefinedBy=2) annotation (Placement(transformation(extent={{152,-76},{132,-56}})));
equation
   der(H_demand)=H_flow_demand.y1;
   der(m_H2_max)=maxH2MassFlow_Rei.m_flow_H2_max+maxH2MassFlow_Lev.m_flow_H2_max+maxH2MassFlow_Tor.m_flow_H2_max;

  connect(HHNord.H_flow, H_flow_demand.y1) annotation (Line(
      points={{-9,84},{-14,84},{-14,-152},{42.2,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Eimsbuettel.H_flow, H_flow_demand.y1) annotation (Line(
      points={{-21,44},{-14,44},{-14,-152},{42.2,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Wandsbek.H_flow, H_flow_demand.y1) annotation (Line(
      points={{37,62},{-14,62},{-14,-152},{42.2,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Altona.H_flow, H_flow_demand.y1) annotation (Line(
      points={{-41,7},{-14,7},{-14,-152},{42.2,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(HHMitte.H_flow, H_flow_demand.y1) annotation (Line(
      points={{31,-18},{-14,-18},{-14,-152},{42.2,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Bergedorf.H_flow, H_flow_demand.y1) annotation (Line(
      points={{55,-77},{-14,-77},{-14,-152},{42.2,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Harburg.H_flow, H_flow_demand.y1) annotation (Line(
      points={{-21,-71},{-14,-71},{-14,-152},{42.2,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Wandsbek.fluidPortIn, gasGridHamburg.offTakeWandsbek) annotation (Line(
      points={{58,62},{72,62},{72,62.7647},{75.4909,62.7647}},
      color={255,255,0},
      thickness=1.5));
  connect(Bergedorf.fluidPortIn, gasGridHamburg.offTakeBergedorf) annotation (Line(
      points={{76,-77},{92,-77},{92,-76.9412},{95.7818,-76.9412}},
      color={255,255,0},
      thickness=1.5));
  connect(HHMitte.fluidPortIn, gasGridHamburg.offTakeMitte) annotation (Line(
      points={{52,-18},{66.4727,-18},{66.4727,-18.8235}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeAltona, Altona.fluidPortIn) annotation (Line(
      points={{-75.5636,6.88235},{-62,6.88235},{-62,7}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeEimsbuettel, Eimsbuettel.fluidPortIn) annotation (Line(
      points={{-56.4,46},{-56.4,44},{-42,44}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeHarburg, Harburg.fluidPortIn) annotation (Line(
      points={{-51.8909,-70.2353},{-42,-70.2353},{-42,-71}},
      color={255,255,0},
      thickness=1.5));
  connect(HHNord.fluidPortIn, gasGridHamburg.offTakeNord) annotation (Line(
      points={{12,84},{18,84},{18,118.647}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Tornesch.gasPort,maxH2MassFlow_Tor. gasPortIn) annotation (Line(
      points={{-192,154},{-192,154.5},{-184,154.5}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut, gasGridHamburg.GTSTor) annotation (Line(
      points={{-136,154},{-127.418,154},{-127.418,155.529}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Tor.gasPortOut,vleCompositionSensor_Tornesch. gasPortIn) annotation (Line(
      points={{-164,154.5},{-160,154.5},{-160,154},{-156,154}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Leversen.gasPort,maxH2MassFlow_Lev. gasPortIn) annotation (Line(
      points={{-174,-141},{-156,-141},{-156,-140}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Lev.gasPortOut,vleCompositionSensor_Leversen. gasPortIn) annotation (Line(
      points={{-136,-140},{-132,-140},{-114,-140}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Reitbrook.gasPort,maxH2MassFlow_Rei. gasPortIn) annotation (Line(
      points={{208,-77},{208,-76},{188,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Reitbrook.gasPortIn,maxH2MassFlow_Rei. gasPortOut) annotation (Line(
      points={{152,-76},{168,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut, gasGridHamburg.GTSTor) annotation (Line(
      points={{-136,154},{-130,154},{-130,155.529},{-127.418,155.529}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Leversen.gasPortOut, gasGridHamburg.GTSLev) annotation (Line(
      points={{-94,-140},{-57.5273,-140},{-57.5273,-140.647}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeBergedorf, vleCompositionSensor_Reitbrook.gasPortOut) annotation (Line(
      points={{95.7818,-76.9412},{116.459,-76.9412},{116.459,-76},{132,-76}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(extent={{-300,-240},{280,240}}, preserveAspectRatio=false)),
                                                                         Icon(coordinateSystem(extent={{-300,-240},{280,240}})),
    experiment(
      StopTime=604800,
      Interval=900,
      Tolerance=1e-008),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for open-loop high pressure gas ring grid of Hamburg with mass flow control.</p>
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
<p>Created by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end TestGasGridHamburgVarGCV;
