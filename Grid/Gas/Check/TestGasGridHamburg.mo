within TransiEnt.Grid.Gas.Check;
model TestGasGridHamburg "High pressure gas grid of Hamburg with constant gross calorific value at consumption side"
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

  extends TransiEnt.Basics.Icons.Checkmodel;

  //Scaling factors
  parameter Real f_gasDemand=simCenter.f_gasDemand "Scale factor for gas demand";
  parameter Real f_Rei=0.465119;
  parameter Real f_Lev=0.268173;
  parameter Real f_Tor=1 - f_Rei - f_Lev;

  //FeedIn Control
  parameter Real phi_H2max=0.1 annotation (Evaluate=false);

  //Pipe Network
  parameter Real Nper10km=2 "Number of discrete volumes in 10 km pipe length";
  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation (Dialog(group="Fundamental Definitions"), choices(
      choice=1 "ClaRa formulation",
      choice=2 "TransiEnt formulation 1a",
      choice=3 "TransiEnt formulation 1b",
      choice=4 "Quasi-Stationary"));
  replaceable model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "Pressure loss model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  // Variable declarations
  SI.Mass m_demand(
    start=0,
    fixed=true,
    stateSelect=StateSelect.never) "Gas demand";
  SI.Mass m_H2_max(
    start=0,
    fixed=true,
    stateSelect=StateSelect.never) "Maximal H2 mass that could be fed into the gas grid";
  SI.Mass m_gas_import=-(GTS_Tornesch.m + GTS_Leversen.m + GTS_Reitbrook.m) "Gas demand with H2 fed into the grid";

  inner TransiEnt.SimCenter simCenter(
    p_amb=101343,
    T_amb=283.15,
    useConstCompInGasComp=true,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2) annotation (Placement(transformation(extent={{-300,212},{-271,242}})));

  TransiEnt.Grid.Gas.GasGridHamburg gasGridHamburg(
    Nper10km=Nper10km,
    volume_junction=10,
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(extent={{-164,-196},{214,184}})));

  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Harburg(
    N_cv=if integer(Nper10km*Harburg.length/10000) < 1 then 1 else integer(Nper10km*Harburg.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[1],
    diameter=districtPipes.diameter[1],
    N_tubes=districtPipes.N_ducts[1],
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(extent={{-28,-91},{-8,-71}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Altona(
    N_cv=if integer(Nper10km*Altona.length/10000) < 1 then 1 else integer(Nper10km*Altona.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[2],
    diameter=districtPipes.diameter[2],
    N_tubes=districtPipes.N_ducts[2],
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(extent={{-46,-15},{-26,5}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Eimsbuettel(
    N_cv=if integer(Nper10km*Eimsbuettel.length/10000) < 1 then 1 else integer(Nper10km*Eimsbuettel.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[3],
    diameter=districtPipes.diameter[3],
    N_tubes=districtPipes.N_ducts[3],
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(extent={{-36,25},{-16,45}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow HHNord(
    N_cv=if integer(Nper10km*HHNord.length/10000) < 1 then 1 else integer(Nper10km*HHNord.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[4],
    diameter=districtPipes.diameter[4],
    N_tubes=districtPipes.N_ducts[4],
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={14,92})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Wandsbek(
    N_cv=if integer(Nper10km*Wandsbek.length/10000) < 1 then 1 else integer(Nper10km*Wandsbek.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[5],
    diameter=districtPipes.diameter[5],
    N_tubes=districtPipes.N_ducts[5],
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={66,50})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow HHMitte(
    N_cv=if integer(Nper10km*HHMitte.length/10000) < 1 then 1 else integer(Nper10km*HHMitte.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[6],
    diameter=districtPipes.diameter[6],
    N_tubes=districtPipes.N_ducts[6],
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={62,-31})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Bergedorf(
    N_cv=if integer(Nper10km*Bergedorf.length/10000) < 1 then 1 else integer(Nper10km*Bergedorf.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[7],
    diameter=districtPipes.diameter[7],
    N_tubes=districtPipes.N_ducts[7],
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={72,-66})));

  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-270,212},{-239,242}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Lev(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-128,-160})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi GTS_Leversen(m(fixed=true)) annotation (Placement(transformation(extent={{-188,-177},{-156,-145}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Leversen(compositionDefinedBy=2, flowDefinition=3) annotation (Placement(transformation(extent={{-96,-160},{-76,-140}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Tor(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10.5},{10,-10.5}},
        rotation=0,
        origin={-162,142.5})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi GTS_Tornesch(m(fixed=true)) annotation (Placement(transformation(extent={{-212,126},{-180,158}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Tornesch(compositionDefinedBy=2, flowDefinition=3) annotation (Placement(transformation(extent={{-144,142},{-124,162}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Rei(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={180,-66})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi GTS_Reitbrook(m(fixed=true)) annotation (Placement(transformation(
        extent={{-18,17},{18,-17}},
        rotation=180,
        origin={228,-67})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Reitbrook(compositionDefinedBy=2, flowDefinition=3) annotation (Placement(transformation(extent={{154,-66},{134,-46}})));
  inner TransiEnt.Basics.Records.PipeParameter ringPipes(
    N_pipes=12,
    length={2353.4,9989.1,10203.5,11846.6,7285.6,10878.7,4420.5,11961.1,10915.2,13932.2,28366.9,16710},
    diameter(displayUnit="m") = {0.6,0.4,0.4,0.4,0.4,0.4,0.5,0.4,0.4,0.607307197,0.6,0.5},
    m_flow_nom={20.2,10.1,10.1,12.4,0.3,10.5,21.9,6.7,10.1,30.6,3.6,32.4},
    Delta_p_nom(displayUnit="Pa") = {10605,63939.6,63939.6,184435.5,56.5,125548.4,67207.8,56975.5,116965.7,140705.4,3963.8,133488.2}) annotation (Placement(transformation(extent={{-296,186},{-276,206}})));
  inner TransiEnt.Basics.Records.PipeParameter districtPipes(
    N_pipes=7,
    f_mFlow={0.0869,0.1346,0.1199,0.1688,0.187,0.2267,0.076},
    length={3774,5152,2739,10564,4075,9480,6770},
    diameter={0.221,0.221,0.221,0.221,0.221,0.221,0.221},
    N_ducts={4,5,5,6,7,8,3},
    m_flow_nom={7.83,12.12,10.8,15.2,16.83,20.42,6.84},
    Delta_p_nom(displayUnit="Pa") = {31226.22,78102.46,31207.91,126637.22,63836.59,152213.2,73490.95}) annotation (Placement(transformation(extent={{-266,186},{-246,206}})));

  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP V_flow_demand_stp(constantfactor=simCenter.f_gasDemand) annotation (Placement(transformation(extent={{78,-146},{42,-110}})));

  Modelica.Blocks.Math.Gain shareHar(k=districtPipes.f_mFlow[1]) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={5,-81})));
  Modelica.Blocks.Math.Gain shareAlt(k=districtPipes.f_mFlow[2]) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-12,-6})));
  Modelica.Blocks.Math.Gain shareEim(k=districtPipes.f_mFlow[3]) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-6,36})));
  Modelica.Blocks.Math.Gain shareNor(k=districtPipes.f_mFlow[4]) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={-6,92})));
  Modelica.Blocks.Math.Gain shareWan(k=districtPipes.f_mFlow[5]) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={44,50})));
  Modelica.Blocks.Math.Gain shareMit(k=districtPipes.f_mFlow[6]) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={39,-31})));
  Modelica.Blocks.Math.Gain shareBer(k=districtPipes.f_mFlow[7]) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={47,-66})));

  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2_isoth junction_Leversen(final volume=gasGridHamburg.volume_junction) annotation (Placement(transformation(extent={{96,-76},{116,-56}})));
equation
  der(m_demand) = V_flow_demand_stp.y1;
  der(m_H2_max) = maxH2MassFlow_Rei.m_flow_H2_max + maxH2MassFlow_Lev.m_flow_H2_max + maxH2MassFlow_Tor.m_flow_H2_max;

  connect(gasGridHamburg.offTakeEimsbuettel, Eimsbuettel.fluidPortIn) annotation (Line(
      points={{-42.8176,35.3529},{-38.5276,35.3529},{-38.5276,35},{-36,35}},
      color={255,255,0},
      thickness=1.5));
  connect(HHNord.fluidPortIn, gasGridHamburg.offTakeNord) annotation (Line(
      points={{24,92},{29.4471,92},{29.4471,106.882}},
      color={255,255,0},
      thickness=1.5));
  connect(Wandsbek.fluidPortIn, gasGridHamburg.offTakeWandsbek) annotation (Line(
      points={{76,50},{87.2588,50},{87.2588,52.1176}},
      color={255,255,0},
      thickness=1.5));
  connect(HHMitte.fluidPortIn, gasGridHamburg.offTakeMitte) annotation (Line(
      points={{72,-31},{78.3647,-31},{78.3647,-29.4706}},
      color={255,255,0},
      thickness=1.5));
  connect(Altona.fluidPortIn, gasGridHamburg.offTakeAltona) annotation (Line(
      points={{-46,-5},{-50,-5},{-50,-4.88235},{-61.7176,-4.88235}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeHarburg, Harburg.fluidPortIn) annotation (Line(
      points={{-41.7059,-82},{-31.6034,-82},{-31.6034,-81},{-28,-81}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Leversen.gasPort, maxH2MassFlow_Lev.gasPortIn) annotation (Line(
      points={{-156,-161},{-138,-161},{-138,-160}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Lev.gasPortOut, vleCompositionSensor_Leversen.gasPortIn) annotation (Line(
      points={{-118,-160},{-114,-160},{-96,-160}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Tornesch.gasPort, maxH2MassFlow_Tor.gasPortIn) annotation (Line(
      points={{-180,142},{-180,142.5},{-172,142.5}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Reitbrook.gasPort, maxH2MassFlow_Rei.gasPortIn) annotation (Line(
      points={{210,-67},{210,-66},{190,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Reitbrook.gasPortIn, maxH2MassFlow_Rei.gasPortOut) annotation (Line(
      points={{154,-66},{170,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut, gasGridHamburg.GTSTor) annotation (Line(
      points={{-124,142},{-132.871,142},{-132.871,141.529}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Leversen.gasPortOut, gasGridHamburg.GTSLev) annotation (Line(
      points={{-76,-160},{-57.2706,-160},{-57.2706,-160.235}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Tor.gasPortOut, vleCompositionSensor_Tornesch.gasPortIn) annotation (Line(
      points={{-152,142.5},{-148,142.5},{-148,142},{-144,142}},
      color={255,255,0},
      thickness=1.5));
  connect(shareWan.y, Wandsbek.m_flow) annotation (Line(points={{50.6,50},{50,50},{55,50}}, color={0,0,127}));
  connect(shareNor.y, HHNord.m_flow) annotation (Line(points={{0.6,92},{0.6,92},{3,92}}, color={0,0,127}));
  connect(Eimsbuettel.m_flow, shareEim.y) annotation (Line(points={{-15,35},{-14,35},{-14,36},{-12.6,36}}, color={0,0,127}));
  connect(Altona.m_flow, shareAlt.y) annotation (Line(points={{-25,-5},{-16,-5},{-16,-6},{-18.6,-6}}, color={0,0,127}));
  connect(Harburg.m_flow, shareHar.y) annotation (Line(points={{-7,-81},{-2.7,-81}}, color={0,0,127}));

  connect(shareWan.u, V_flow_demand_stp.y1) annotation (Line(
      points={{36.8,50},{24,50},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareEim.u, V_flow_demand_stp.y1) annotation (Line(
      points={{1.2,36},{24,36},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareAlt.u, V_flow_demand_stp.y1) annotation (Line(
      points={{-4.8,-6},{24,-6},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareMit.u, V_flow_demand_stp.y1) annotation (Line(
      points={{30.6,-31},{24,-31},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareHar.u, V_flow_demand_stp.y1) annotation (Line(
      points={{13.4,-81},{24,-81},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareBer.u, V_flow_demand_stp.y1) annotation (Line(
      points={{38.6,-66},{24,-66},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareNor.u, V_flow_demand_stp.y1) annotation (Line(
      points={{-13.2,92},{-18,92},{-18,72},{24,72},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(HHMitte.m_flow, shareMit.y) annotation (Line(points={{51,-31},{48,-31},{46.7,-31}}, color={0,0,127}));
  connect(vleCompositionSensor_Reitbrook.gasPortOut, junction_Leversen.gasPort3) annotation (Line(
      points={{134,-66},{116,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Leversen.gasPort2, gasGridHamburg.offTakeBergedorf) annotation (Line(
      points={{106,-76},{106,-82},{106,-88.7059},{106.159,-88.7059}},
      color={255,255,0},
      thickness=1.5));
  connect(Bergedorf.fluidPortIn, junction_Leversen.gasPort1) annotation (Line(
      points={{82,-66},{96,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(shareBer.y, Bergedorf.m_flow) annotation (Line(points={{54.7,-66},{61,-66}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-300,-240},{280,240}}, preserveAspectRatio=false)),
    Icon(graphics, coordinateSystem(extent={{-300,-240},{280,240}})),
    experiment(
      StopTime=2592000,
      Interval=900,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for open-loop high pressure gas ring grid of Hamburg with constant gas composition.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The methodology is described in [1].</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(none)</p>
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
<p>[1] L. Andresen, P. Dubucq, R. Peniche Garcia, G. Ackermann, A. Kather, and G. Schmitz, &ldquo;Transientes Verhalten gekoppelter Energienetze mit hohem Anteil Erneuerbarer Energien: Abschlussbericht des Verbundvorhabens,&rdquo; Hamburg, 2017.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), May 2020 (updated to new models and improved numerical behavior)</p>
</html>"),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestGasGridHamburg;
