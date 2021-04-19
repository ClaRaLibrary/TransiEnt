within TransiEnt.Producer.Combined.LargeScaleCHP;
model CHP "Recommended model for large scale, combined heat and power plants with second order dynamics, three operating states and optional control power"
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

  extends TransiEnt.Producer.Combined.LargeScaleCHP.Base.PartialCHP(m_flow_cde_total=m_flow_cde_total_set, Q_flow_set_CHP_max(y=if hysteresis.y then Q_flow_n_CHP_single else 2e-3));
   extends TransiEnt.Producer.Electrical.Base.ControlPower.PartialBalancingPowerProvider(
     P_n=P_el_n,
     primaryBalancingController(P_n=P_el_n),
     P_el_grad_max_SB=P_grad_max_star,
     redeclare TransiEnt.Producer.Electrical.Base.ControlPower.CombinedHeatAndPower controlPowerModel(
       P_min_t=pQDiagram[1].P_min,
       P_max_t=pQDiagram[1].P_max,
       P_pr_max=primaryBalancingController.P_pr_max,
       P_grad_max_star=P_el_grad_max_SB,
       is_running=isRunning.y,
       P_PB_set=primaryBalancingController.P_PBP_set,
       P_SB_set=P_SB_set_internal,
       P_el_is=P_el_is,
       P_n=P_el_n),
     isExternalSecondaryController=true,
     isSecondaryControlActive=false,
     final typeOfBalancingPowerResource=typeOfResource);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real P_grad_max_star=0.03/60 "Fraction of nominal power per second (12% per minute)" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Power P_el_min_operating=min(PQCharacteristics.PQboundaries[:,3])*P_el_n_single/max(PQCharacteristics.PQboundaries[:,2]) "Minimum operating thermal power used to determine plant state" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time T_steamGenerator = 0.5*(0.632/P_grad_max_star) "Time constant of steam generator (overrides value of P_grad_max_star)" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time T_turboGenerator = 60 "Time constant of turbo generator" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time T_heatingCondenser = 40 "Time constant of heating condenser" annotation(Dialog(group="Physical Constraints"));

  parameter SI.Temperature T_feed_init = 100+273.15 "Start temperature of feed water" annotation(Dialog(group="Initialization", tab="Advanced"));

  parameter SI.Pressure p_min_operating=-1.2e5;
  parameter SI.Pressure p_min_operating_backIn=-1e5;

  //Heating condenser parameters

  parameter Modelica.SIunits.Pressure p_nom(displayUnit="Pa")=1e5 "Nominal pressure" annotation(Dialog(group="Heating condenser parameters", tab="Advanced"));
  parameter SI.MassFlowRate m_flow_nom=10 "Nominal mass flow rate" annotation(Dialog(group="Heating condenser parameters", tab="Advanced"));
  parameter SI.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy" annotation(Dialog(group="Heating condenser parameters", tab="Advanced"));
  final parameter SI.SpecificEnthalpy h_start=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      medium,
      p_nom,
      T_feed_init) "Start value of sytsem specific enthalpy" annotation(Dialog(group="Heating condenser parameters", tab="Advanced"));

  parameter SI.Time t_startup=3600 "Time between startup signal and minimum load operation" annotation(Dialog(group="Physical Constraints"));

  parameter SI.Inertia J=10*P_el_n/(100*3.14)^2 "Lumped moment of inertia of whole power plant" annotation(Dialog(group="Physical Constraints"));

  parameter Integer nSubgrid=1 "Index of subgrid for moment of inertia statistics" annotation (Dialog(group="Statistics"));

  parameter Boolean fixedStartValue_w = false "Whether or not the start value of the angular velocity of the plants mechanical components is fixed"
   annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true), Dialog(tab="Advanced", group="Initialization"));
  parameter Boolean useGasPort=false "Choose if gas port is used or not" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean usePowerBoundary=true;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_gas=simCenter.gasModel1 "Gas Medium to be used - only if useGasPort==true" annotation(Dialog(group="Fundamental Definitions",enable=if useGasPort==true then true else false));
  parameter Boolean isPrimaryControlActive = true annotation ( choices(__Dymola_checkBox=true), Dialog(group="Frequency Control", tab="Block control"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium_gas) if useGasPort == true annotation (Placement(transformation(extent={{90,92},{110,112}})));

  // _____________________________________________
  //
  //               Components
  // _____________________________________________
  TransiEnt.Basics.Blocks.FirstOrder    P(
    Tau=T_turboGenerator,
    initOption=2,
    y_start=P_el_init)                                            annotation (Placement(visible=true, transformation(
        origin={-39.8546,7.7058},
        extent={{-10.9091,-10.9091},{10.9091,10.9091}},
        rotation=0)));
  TransiEnt.Basics.Blocks.FirstOrder    steamGenerator(
    Tau=T_steamGenerator,
    initOption=1,
    y_start=if useEfficiencyForInit then P_el_init/eta_el_init else Q_flow_SG_init)   annotation (Placement(transformation(extent={{-110,-24},{-90,-4}})));
  TransiEnt.Basics.Blocks.FirstOrder    Q_flow_CHP(
    Tau=T_heatingCondenser,
    initOption=2,
    y_start=Q_flow_init)   annotation (Placement(transformation(extent={{-60,-46},{-40,-26}})));

  TransiEnt.Components.Boundaries.Heat.Heatflow_L1 HX(change_sign=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={56,-10})));

  Modelica.Blocks.Math.Product
                            ElectricEfficiency           annotation (Placement(transformation(extent={{-82,12},{-74,4}})));
  Modelica.Blocks.Sources.RealExpression eta_th_is(y=eta_th_target)
                                                             annotation (Placement(transformation(extent={{-102,-48},{-82,-28}})));
  Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(extent={{-74,-40},{-66,-32}})));

  Modelica.Blocks.Math.MultiSum P_set_electric(          nu=2)                                 annotation (Placement(transformation(extent={{-66,12},{-58,4}})));
  Modelica.Blocks.Sources.RealExpression eta_el_is(y=eta_el_target)
                                                             annotation (Placement(transformation(extent={{-112,0},{-92,20}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_peak(y=min(Q_flow_n_Peak, max(0, -Q_flow_set - Q_flow_n_CHP)))
                                                                                                        annotation (Placement(transformation(extent={{-44,-64},{-24,-44}})));
  Modelica.Blocks.Math.Sum Q_flow(nin=2) annotation (Placement(transformation(extent={{-18,-47},{-8,-37}})));

  SI.Power P_limit_off_set[quantity];
  SI.Power P_set_single[quantity];
  Real activePowerPlants;

  Modelica.Blocks.Sources.BooleanExpression isRunning(y=plantState.operating.active) annotation (Placement(transformation(extent={{-16,14},{4,34}})));
  Modelica.Blocks.Nonlinear.VariableLimiter P_limit_on[quantity] annotation (Placement(transformation(extent={{-42,100},{-32,110}})));
  Modelica.Blocks.Sources.RealExpression P_limit_off[quantity](y=P_limit_off_set)                                                annotation (Placement(transformation(extent={{-50,78},{-30,98}})));
  Modelica.Blocks.Math.Sum P_set_total(nin=2, k=-ones(2))
                                              "Schedule plus agc setpoint" annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-72,107})));
  Modelica.Blocks.Math.Sum P_limit[quantity](nin=2)          annotation (Placement(transformation(extent={{-24,98},{-12,110}})));
  TransiEnt.Consumer.Gas.GasConsumer_HFlow_NCV gasConsumer_HFlow_NCV(medium=medium_gas) if useGasPort == true annotation (Placement(transformation(extent={{34,60},{14,80}})));

//protected
  Modelica.Blocks.Sources.RealExpression Zero(y=0);
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
public
  Modelica.SIunits.MassFlowRate m_flow_cde_total_set;

  TransiEnt.Components.Sensors.RealGas.CO2EmissionSensor cO2EmissionOfIdealCombustion if useGasPort == true annotation (Placement(transformation(extent={{70,70},{50,90}})));
  Modelica.Blocks.Math.Gain m_flow_cde_gain(k=1) annotation (Placement(transformation(extent={{44,84},{36,92}})));
  Modelica.Blocks.Math.MultiSum multiSum_Q_flow_SG(nu=quantity) annotation (Placement(transformation(extent={{-44,80},{-52,72}})));
  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power
                                                               powerBoundary(change_sign=true) if usePowerBoundary
                                                                             constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary                          "Choice of power boundary model. The power boundary model must match the power port." annotation (choices(choice(redeclare TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary "PowerBoundary for ActivePowerPort"),choice( redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "Power Boundary for ComplexPowerPort")), Dialog(group="Replaceable Components"), Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=0,
        origin={92,26})));
  Modelica.Blocks.Sources.RealExpression fuelMassFlow_set(y=if P_set + Q_flow_set >= 0 then 0 else steamGenerator.y + Q_flow_peak.y/eta_peakload) if
                                                                                                                      useGasPort annotation (Placement(transformation(extent={{-22,60},{-2,80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=gasPortIn.p) if useGasPort  annotation (Placement(transformation(extent={{110,76},{130,96}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=p_min_operating, uHigh=p_min_operating_backIn)
                                                annotation (Placement(transformation(extent={{140,76},{160,96}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter if useGasPort  annotation (Placement(transformation(extent={{-92,102},{-82,112}})));
  Modelica.Blocks.Sources.RealExpression realExpression1 if useGasPort   annotation (Placement(transformation(extent={{-102,108},{-96,114}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=if hysteresis.y then -P_el_n else 0) if useGasPort
                                                                    annotation (Placement(transformation(extent={{-102,100},{-96,106}})));
  replaceable TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=1) if usePowerBoundary==false  constrainedby TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator             "Choice of generator model. The generator model must match the power port." annotation (
    Dialog(group="Replaceable Components"),
    choicesAllMatching=true,
    Placement(transformation(
        extent={{-11.5,-12},{11.5,12}},
        rotation=0,
        origin={68.5,36})));
    replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter if usePowerBoundary==false  constrainedby TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem   "Choice of excitation system model with voltage control" annotation (
    Dialog(group="Replaceable Components"),
    choicesAllMatching=true,
    Placement(transformation(
        extent={{-4,-4.5},{4,4.5}},
        rotation=-90,
        origin={68.5,60})));
  TransiEnt.Components.Boundaries.Mechanical.Power prescribedPower(change_sign=true) if usePowerBoundary==false  annotation (Placement(transformation(extent={{-20,2},{-6,16}})));
  TransiEnt.Components.Mechanical.TwoStateInertiaWithIdealClutch Shaft(
    omega(fixed=fixedStartValue_w, start=2*simCenter.f_n*Modelica.Constants.pi),
    J=1e-3,
    nSubgrid=nSubgrid) if usePowerBoundary==false  annotation (choicesAllMatching=true, Placement(transformation(extent={{2,0},{20,19}})));
  Components.Boundaries.Mechanical.Frequency frequency(useInputConnector=false, f_set_const=50);
  Components.Mechanical.ConstantInertia constantInertia(J=J) annotation (Placement(transformation(extent={{28,0},{48,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression3[quantity](y=-P_set_single)                                                  annotation (Placement(transformation(extent={{-86,78},{-66,98}})));
equation

  for i in 1:quantity loop
    P_limit_off_set[i]=if noEvent(Q_flow_set_CHP[i].y<=Q_flow_set_CHP_min.y) then -pQDiagram[i].P_min else 0;
  end for;

  if useGasPort==false then
    m_flow_cde_total_set=Q_flow_input*fuelSpecificEmissions.m_flow_CDE_per_Energy;
  else
    m_flow_cde_total_set=m_flow_cde_gain.y;
  end if;

  Q_flow_input=multiSum_Q_flow_SG.y+Q_flow_peak.y/eta_peakload;

  activePowerPlants=noEvent(floor(-Q_flow_set/Q_flow_n_CHP_single-Modelica.Constants.eps)+1);

  for i in 1:quantity loop
    if activePowerPlants<i then
      P_set_single[i]=0;
    elseif i==1 then
      P_set_single[i]=P_set+(max(0,activePowerPlants-1))*pQDiagram[i].P_min;
    else
      P_set_single[i]=P_set+(max(0,activePowerPlants-i))*pQDiagram[i].P_min+sum(P_limit_on[1:i-1].y);
    end if;
  end for;

  // _____________________________________________
  //
  //               Connect Statements
  // ____________________________________________

  //Annotations
  connect(ElectricEfficiency.y, P_set_electric.u[1]) annotation (Line(points={{-73.6,8},{-70,8},{-70,6.6},{-66,6.6}},
                                                                                                            color={0,0,127}));
  connect(eta_el_is.y, ElectricEfficiency.u2) annotation (Line(points={{-91,10},{-88,10},{-88,10.4},{-82.8,10.4}},
                                                                                                                 color={0,0,127}));
  connect(eta_th_is.y, product1.u2) annotation (Line(points={{-81,-38},{-74.8,-38},{-74.8,-38.4}}, color={0,0,127}));
  connect(Q_flow_peak.y, Q_flow.u[2]) annotation (Line(points={{-23,-54},{-20,-54},{-20,-41.5},{-19,-41.5}},
                                                                                                         color={0,0,127}));
//  connect(P_SB_set_internal,P_set_total. u[2]) annotation (Line(points={{-156,60},{-98,60},{-98,105.5}},             color={0,0,127}));

connect(Zero.y,P_set_total. u[2]);
  connect(inlet, HX.fluidPortIn) annotation (Line(
      points={{100,-24},{90,-24},{90,-22},{66,-22},{66,-16}},
      color={175,0,0},
      thickness=0.5));
  connect(HX.fluidPortOut, outlet) annotation (Line(
      points={{66,-4},{66,4},{100,4}},
      color={175,0,0},
      thickness=0.5));
  connect(Q_flow.y, HX.Q_flow_prescribed) annotation (Line(points={{-7.5,-42},{4,-42},{4,-16},{48,-16}},     color={0,0,127}));
  if useGasPort==true then
   connect(cO2EmissionOfIdealCombustion.gasPortOut, gasConsumer_HFlow_NCV.fluidPortIn) annotation (Line(
      points={{50,70},{34,70}},
      color={255,255,0},
      thickness=1.5));
   connect(cO2EmissionOfIdealCombustion.gasPortIn, gasPortIn) annotation (Line(
      points={{70,70},{86,70},{86,102},{100,102}},
      color={255,255,0},
      thickness=1.5));
   connect(cO2EmissionOfIdealCombustion.m_flow_cde, m_flow_cde_gain.u) annotation (Line(points={{49,86.8},{48,86.8},{48,88},{44.8,88}},
                                                                                                                                    color={0,0,127}));
   connect(fuelMassFlow_set.y, gasConsumer_HFlow_NCV.H_flow) annotation (Line(points={{-1,70},{13,70}}, color={0,0,127}));
  else
    connect(Zero.y,m_flow_cde_gain.u);
  end if;

  for i in 1:quantity loop
  connect(P_limit_on[i].y,P_limit[i].u[1]) annotation (Line(points={{-31.5,105},{-25.2,105},{-25.2,103.4}},        color={0,0,127}));
  connect(pQDiagram[i].P_max, P_limit_on[i].limit1) annotation (Line(points={{-11,128.4},{-48,128.4},{-48,109},{-43,109}},       color={0,0,127}));
  connect(pQDiagram[i].P_min, P_limit_on[i].limit2) annotation (Line(points={{-11,121},{-46,121},{-46,101},{-43,101}},     color={0,0,127}));
  connect(P_limit_off[i].y,P_limit[i]. u[2]) annotation (Line(points={{-29,88},{-28,88},{-28,104.6},{-25.2,104.6}},                    color={0,0,127}));
  connect(P_limit[i].y, Q_flow_set_SG[i].P) annotation (Line(points={{-11.4,104},{-7.27273,104},{-7.27273,102}},  color={0,0,127}));
  //connect(add1[i].y, P_limit_on[i].u) annotation (Line(points={{-49.4,104},{-46,104},{-46,105},{-43,105}}, color={0,0,127}));

  connect(Q_flow_set_SG[i].Q_flow_input, multiSum_Q_flow_SG.u[i]) annotation (Line(
      points={{-0.909091,79},{-0.909091,76},{-44,76}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  end for;
  if usePowerBoundary then
  connect(powerBoundary.epp, epp) annotation (Line(
      points={{96,26},{100,26},{100,60}},
      color={0,135,135},
      thickness=0.5));
  connect(P.y, powerBoundary.P_el_set) annotation (Line(points={{-27.8546,7.7058},{-20,7.7058},{-20,-4},{94.4,-4},{94.4,30.8}},
                                                                                                                         color={0,0,127}));
  connect(P.u, P_set_electric.y) annotation (Line(points={{-52.9455,7.7058},{-55.4727,7.7058},{-55.4727,8},{-57.32,8}}, color={0,0,127}));
  connect(Zero.y,P_set_electric.u[2]);
  connect(frequency.mpp, gridFrequencySensor.mpp);
  else
  connect(gridFrequencySensor.mpp, Generator.mpp) annotation (Line(points={{33.2,54},{44,54},{44,36},{57,36}}, color={95,95,95}));
  connect(primaryBalancingController.P_PBP_set, P_set_electric.u[2]) annotation (Line(
      points={{-28.6,54},{-68,54},{-68,9.4},{-66,9.4}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(Generator.epp, epp) annotation (Line(
      points={{80.115,35.88},{88.0575,35.88},{88.0575,60},{100,60}},
      color={0,135,135},
      thickness=0.5));
  connect(Exciter.y,Generator. E_input) annotation (Line(points={{68.5,55.76},{68.5,51.88},{68.155,51.88},{68.155,47.88}}, color={0,0,127}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{68.5,64},{88,64},{88,60},{100,60}},
      color={0,135,135},
      thickness=0.5));
  connect(isRunning.y, Shaft.isRunning) annotation (Line(points={{5,24},{10.91,24},{10.91,17.765}},  color={255,0,255}));
  connect(prescribedPower.P_mech_set, P.y) annotation (Line(points={{-13,17.26},{-19.5,17.26},{-19.5,7.7058},{-27.8546,7.7058}},
                                                                                                                           color={0,0,127}));
  connect(P.u, P_set_electric.y) annotation (Line(points={{-52.9455,7.7058},{-55.4727,7.7058},{-55.4727,8},{-57.32,8}}, color={0,0,127}));
  end if;



  connect(steamGenerator.y, product1.u1) annotation (Line(points={{-89,-14},{-86,-14},{-86,-33.6},{-74.8,-33.6}}, color={0,0,127}));
  connect(steamGenerator.y, ElectricEfficiency.u1) annotation (Line(points={{-89,-14},{-86,-14},{-86,5.6},{-82.8,5.6}}, color={0,0,127}));

  connect(Q_flow_CHP.u, product1.y) annotation (Line(points={{-62,-36},{-65.6,-36}},           color={0,0,127}));
  connect(Q_flow_CHP.y, Q_flow.u[1]) annotation (Line(points={{-39,-36},{-30,-36},{-30,-42.5},{-19,-42.5}},               color={0,0,127}));




  connect(multiSum_Q_flow_SG.y, steamGenerator.u) annotation (Line(points={{-52.68,76},{-128,76},{-128,-14},{-112,-14}},color={0,0,127}));


if  useGasPort then
  connect(variableLimiter.y, P_set_total.u[1]) annotation (Line(points={{-81.5,107},{-79.75,107},{-79.75,106.5},{-78,106.5}},  color={0,0,127}));
  connect(variableLimiter.u, P_set) annotation (Line(points={{-93,107},{-104,107},{-104,122},{-84,122},{-84,144}},  color={0,0,127}));
  connect(variableLimiter.limit2, realExpression2.y) annotation (Line(points={{-93,103},{-95.7,103}},   color={0,0,127}));
  connect(realExpression1.y, variableLimiter.limit1) annotation (Line(points={{-95.7,111},{-93,111}},                               color={0,0,127}));
  connect(realExpression.y, hysteresis.u) annotation (Line(points={{131,86},{138,86}},                   color={0,0,127}));
else
  connect(hysteresis.u,Zero.y);
  connect(P_set_total.u[1],P_set);
end if;


  connect(Shaft.mpp_a, prescribedPower.mpp) annotation (Line(points={{2,9.5},{0,9.5},{0,9},{-6,9}}, color={95,95,95}));
  connect(constantInertia.mpp_b, Generator.mpp) annotation (Line(points={{48,10},{57,10},{57,36}}, color={95,95,95}));
  connect(constantInertia.mpp_a, Shaft.mpp_b) annotation (Line(points={{28,10},{24,10},{24,9.5},{20,9.5}}, color={95,95,95}));
  connect(realExpression3.y, P_limit_on.u) annotation (Line(points={{-65,88},{-48,88},{-48,106},{-44,106},{-44,105},{-43,105}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,140}})), Icon(graphics,
                                                                                                         coordinateSystem(extent={{-100,-100},{100,140}}, preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a combined heat and power plant</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>P_set: input for Power in [W]</p>
<p>Q_flow_set: input for heat flow rate in [W]</p>
<p>outlet: FluidPortOut</p>
<p>inlet: FluidPortIn</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">eye: EyeOut</span></p>
<p>P_SB_set: input for electric power in [W]</p>
<p>gasPortIn: RealGasPortIn</p>
<p>epp: choice of power port</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Cascading CHP-plants:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Via parameter &apos;quantity&apos; the whole CHP-plant is devided into several cascading CHP-plants which start up after one another. This implementation repeats the characteristic PQ-field several times. In total, the nominal electrical and thermal power add up to the nominal electrical and thermal power the whole CHP-plant. This is a way for a simple representation of several CHP-plants without having to model several instances of a CHP-plant-model.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Calculation of failures:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">CHP-plant turns off when gas pressure falls below &apos;p_min_operating&apos; and turns on agains if gas pressure increases above &apos;p_min_operating_backIn&apos;. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Producer.Combined.LargeScaleCHP.Check.TestCHP_startup&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Nov 2018: added possibility to model cascading CHP-plants</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Nov 2018: added gasPort</span></p>
</html>"));
end CHP;
