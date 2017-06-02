within TransiEnt.Grid.Gas.Check;
model TestGasGridHamburg "High pressure gas grid of Hamburg with constant gross calorific value at consumption side"
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

  //FeedIn Control
  parameter Real phi_H2max=0.1 annotation(Evaluate=false);

  //Pipe Network
  parameter Real Nper10km=5 "Number of discrete volumes in 10 km pipe length";
  parameter Boolean productMassBalance=false "Set to false for different (faster) component mass balance formulation in pipe";

  // Variable declarations
  SI.Mass m_demand(start=0,fixed=true) "Gas demand" annotation(stateSelect=StateSelect.never);
  SI.Mass m_H2_max(start=0,fixed=true) "Maximal H2 mass that could be fed into the gas grid" annotation(stateSelect=StateSelect.never);
  SI.Mass m_gas_import=-(GTS_Tornesch.m+GTS_Leversen.m+GTS_Reitbrook.m) "Gas demand with H2 fed into the grid";

  inner TransiEnt.SimCenter simCenter(
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    p_amb=101343,
    T_amb=283.15)             annotation (Placement(transformation(extent={{-286,210},{-257,240}})));
  inner TransiEnt.Grid.Gas.StatCycleGasGridHamburg Init(
    m_flow_feedIn_Tornesch=0,
    m_flow_feedIn_Leversen=0,
    m_flow_feedIn_Reitbrook=0,
    h_source=-1849.95) annotation (Placement(transformation(extent={{-296,182},{-248,216}})));

  TransiEnt.Grid.Gas.GasGridHamburg gasGridHamburg(
    phi_H2max=phi_H2max,
    Nper10km=Nper10km,
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-218,-194},{278,186}})));

  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Harburg(
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
    N_cv=if integer(Nper10km*Harburg.length/10000) < 2 then 2 else integer(Nper10km*Harburg.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-26,-92},{-6,-72}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Altona(
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
    N_cv=if integer(Nper10km*Altona.length/10000) < 2 then 2 else integer(Nper10km*Altona.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-38,-15},{-18,5}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Eimsbuettel(
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
    N_cv=if integer(Nper10km*Eimsbuettel.length/10000) < 2 then 2 else integer(Nper10km*Eimsbuettel.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-28,23},{-8,43}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow HHNord(
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
    N_cv=if integer(Nper10km*HHNord.length/10000) < 2 then 2 else integer(Nper10km*HHNord.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={20,76})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Wandsbek(
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
    N_cv=if integer(Nper10km*Wandsbek.length/10000) < 2 then 2 else integer(Nper10km*Wandsbek.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,50})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow HHMitte(
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
    N_cv=if integer(Nper10km*HHMitte.length/10000) < 2 then 2 else integer(Nper10km*HHMitte.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={52,-30})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Bergedorf(
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
    N_cv=if integer(Nper10km*Bergedorf.length/10000) < 2 then 2 else integer(Nper10km*Bergedorf.length/10000),
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={62,-89})));
  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP m_flow_demand(constantfactor=simCenter.f_gasDemand*0.844499954/7) annotation (Placement(transformation(extent={{80,-182},{44,-146}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-258,210},{-227,240}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Lev(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-130,-154})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Leversen(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-190,-171},{-158,-139}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Leversen(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-98,-154},{-78,-134}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Tor(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10.5},{10,-10.5}},
        rotation=0,
        origin={-162,142.5})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Tornesch(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-212,126},{-180,158}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Tornesch(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-144,142},{-124,162}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Rei(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={180,-88})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Reitbrook(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(
        extent={{-18,17},{18,-17}},
        rotation=180,
        origin={228,-89})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Reitbrook(compositionDefinedBy=2) annotation (Placement(transformation(extent={{154,-88},{134,-68}})));
equation
   der(m_demand)=m_flow_demand.y1;
   der(m_H2_max)=maxH2MassFlow_Rei.m_flow_H2_max+maxH2MassFlow_Lev.m_flow_H2_max+maxH2MassFlow_Tor.m_flow_H2_max;

  connect(HHNord.m_flow,m_flow_demand. y1) annotation (Line(points={{9,76},{4,76},{4,-164},{42.2,-164}},      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Eimsbuettel.m_flow,m_flow_demand. y1) annotation (Line(points={{-7,33},{4,33},{4,-164},{42.2,-164}},     color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Altona.m_flow,m_flow_demand. y1) annotation (Line(points={{-17,-5},{4,-5},{4,-164},{42.2,-164}},   color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Harburg.m_flow,m_flow_demand. y1) annotation (Line(points={{-5,-82},{4,-82},{4,-164},{42.2,-164}},
                                                                                                color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Bergedorf.m_flow,m_flow_demand. y1) annotation (Line(points={{51,-89},{4,-89},{4,-164},{42.2,-164}},   color={0,0,127},
      pattern=LinePattern.Dash));
  connect(HHMitte.m_flow,m_flow_demand. y1) annotation (Line(points={{41,-30},{4,-30},{4,-164},{42.2,-164}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Wandsbek.m_flow,m_flow_demand. y1) annotation (Line(points={{39,50},{4,50},{4,-164},{42.2,-164}},     color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gasGridHamburg.offTakeEimsbuettel, Eimsbuettel.fluidPortIn) annotation (Line(
      points={{-44.4,34},{-38.5276,34},{-38.5276,33},{-28,33}},
      color={255,255,0},
      thickness=1.5));
  connect(HHNord.fluidPortIn, gasGridHamburg.offTakeNord) annotation (Line(
      points={{30,76},{30,106.647}},
      color={255,255,0},
      thickness=1.5));
  connect(Wandsbek.fluidPortIn, gasGridHamburg.offTakeWandsbek) annotation (Line(
      points={{60,50},{87.4909,50},{87.4909,50.7647}},
      color={255,255,0},
      thickness=1.5));
  connect(HHMitte.fluidPortIn, gasGridHamburg.offTakeMitte) annotation (Line(
      points={{62,-30},{78.4727,-30},{78.4727,-30.8235}},
      color={255,255,0},
      thickness=1.5));
  connect(Altona.fluidPortIn, gasGridHamburg.offTakeAltona) annotation (Line(
      points={{-38,-5},{-50,-5},{-50,-5.11765},{-63.5636,-5.11765}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeHarburg, Harburg.fluidPortIn) annotation (Line(
      points={{-39.8909,-82.2353},{-31.6034,-82.2353},{-31.6034,-82},{-26,-82}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeBergedorf, Bergedorf.fluidPortIn) annotation (Line(
      points={{107.782,-88.9412},{92,-88.9412},{92,-90},{82,-90},{82,-89},{72,-89}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Leversen.gasPort,maxH2MassFlow_Lev. gasPortIn) annotation (Line(
      points={{-158,-155},{-140,-155},{-140,-154}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Lev.gasPortOut,vleCompositionSensor_Leversen. gasPortIn) annotation (Line(
      points={{-120,-154},{-116,-154},{-98,-154}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Tornesch.gasPort, maxH2MassFlow_Tor.gasPortIn) annotation (Line(
      points={{-180,142},{-180,142.5},{-172,142.5}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Reitbrook.gasPort, maxH2MassFlow_Rei.gasPortIn) annotation (Line(
      points={{210,-89},{210,-88},{190,-88}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Reitbrook.gasPortIn, maxH2MassFlow_Rei.gasPortOut) annotation (Line(
      points={{154,-88},{170,-88}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut, gasGridHamburg.GTSTor) annotation (Line(
      points={{-124,142},{-115.418,142},{-115.418,143.529}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Leversen.gasPortOut, gasGridHamburg.GTSLev) annotation (Line(
      points={{-78,-154},{-45.5273,-154},{-45.5273,-152.647}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeBergedorf, vleCompositionSensor_Reitbrook.gasPortOut) annotation (Line(
      points={{107.782,-88.9412},{120.891,-88.9412},{120.891,-88},{134,-88}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Tor.gasPortOut, vleCompositionSensor_Tornesch.gasPortIn) annotation (Line(
      points={{-152,142.5},{-148,142.5},{-148,142},{-144,142}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(extent={{-300,-240},{280,240}}, preserveAspectRatio=false)),
                                                                         Icon(coordinateSystem(extent={{-300,-240},{280,240}})),
    experiment(
      StopTime=3.1536e+007,
      Interval=900,
      Tolerance=1e-008),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for open-loop high pressure gas ring grid of Hamburg.</p>
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
end TestGasGridHamburg;
