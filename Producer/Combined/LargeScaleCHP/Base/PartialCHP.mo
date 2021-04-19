within TransiEnt.Producer.Combined.LargeScaleCHP.Base;
partial model PartialCHP "Partial model of a large scale CHP plant with characteristics specified by PQ boundaries and PQ-Heat input table"
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

   extends TransiEnt.Basics.Icons.SteamCyclewHeatingCondenser;

  // _____________________________________________
  //
  //                Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // Physical constraints
  parameter TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.Generic_PQ_Characteristics PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WW1()
                                                                                                                                                                 "Characteristics of CHP plant" annotation (choicesAllMatching, Dialog(group="Physical Constraints"));

  parameter Modelica.SIunits.Power P_el_n=300e6 "Installed capacity for investment cost calculation" annotation(Dialog(group="Physical Constraints"));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_n_CHP=PQCharacteristics.PQboundaries[end,1]/PQCharacteristics.k_Q_flow "Maximum possible heat flow according to PQ diagram" annotation(Dialog(group="Physical Constraints"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_n_Peak=0 "Additional thermal capacity (e.g. peak load heaters)" annotation(Dialog(group="Physical Constraints"));
  final parameter Modelica.SIunits.HeatFlowRate Q_flow_n_total = Q_flow_n_CHP + Q_flow_n_Peak;

  parameter SI.ActivePower P_el_init=P_el_n "Initial or guess value of output (= state)" annotation(Dialog(group="Initialization", tab="Advanced"));
  parameter SI.HeatFlowRate Q_flow_init=Q_flow_n_total "Initial or guess value of output (= state)" annotation(Dialog(group="Initialization", tab="Advanced"));
  parameter Boolean useEfficiencyForInit = false "True, set efficiency; False set steam generator power at init" annotation(choices(__Dymola_checkBox=true),Dialog(group="Initialization", tab="Advanced"));
  parameter SI.HeatFlowRate Q_flow_SG_init=Q_flow_init+P_el_init "Initial or guess value of output (= state) of steam generator" annotation(Dialog(group="Initialization", tab="Advanced", enable=not useEfficiencyForInit));
  parameter Real eta_el_init = 0.4 "Thermal efficiency used at init time" annotation(Dialog(group="Initialization", tab="Advanced",enable=useEfficiencyForInit));

  parameter Boolean useConstantEfficiencies = false "True, constant efficiency over load" annotation(Evaluate=true, choices(__Dymola_checkBox=true),Dialog(group="Physical Constraints"));
  parameter SI.Efficiency eta_el_const = 0.4 "Constant efficiency used if useConstantEfficiencies=true" annotation(Dialog(group="Physical Constraints", enable=useConstantEfficiencies));
  parameter SI.Efficiency eta_th_const = 0.5 "Constant efficiency used if useConstantEfficiencies=true" annotation(Dialog(group="Physical Constraints", enable=useConstantEfficiencies));
  parameter SI.Efficiency eta_peakload=0.98 "Constant efficiency of peak load heater annotation" annotation(Dialog(group="Physical Constraints"));

  parameter Boolean useConstantSigma = false "True, use constant power to heat ration (sigma) instead of PQ characteristics" annotation(Evaluate=true, choices(__Dymola_checkBox=true),Dialog(group="Physical Constraints"));
  parameter Real sigma= 0.3 "Power to heat ration used only if useConstantSigma=true" annotation(Dialog(group="Physical Constraints", enable = useConstantSigma));

  parameter Integer quantity=1;

  // Statistics

   replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.HardCoal
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs
                                                                                            annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);

   final parameter TransiEnt.Basics.Types.TypeOfResource typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Cogeneration "Type of energy resource for global model statistics" annotation (
    Dialog(group="Statistics"),
    HideResult=true,
    Placement(transformation(extent=100)));

   parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal "Type of primary energy carrier for co2 emissions global statistics" annotation (Dialog(group="Statistics"), HideResult=true);
   parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat typeOfPrimaryEnergyCarrierHeat=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.BlackCoal "Type of primary energy carrier for heat for co2 emissions global statistics" annotation (Dialog(group="Statistics"), HideResult=true);

  parameter TransiEnt.Basics.Types.TypeOfCO2AllocationMethod typeOfCO2AllocationMethod=1 "Type of allocation method" annotation (Dialog(group="Statistics"));

   //Heat parameters

   parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Heating condenser parameters"));
   parameter Boolean integrateHeatFlow=false "True if heat flow shall be integrated";
   parameter Boolean integrateElectricPower=false "True if electric power shall be integrated";
   parameter Boolean integrateElectricPowerChp=false "True if electric power of the chp shall be integrated";
   final parameter SI.Power P_el_n_single=P_el_n/quantity;
   final parameter SI.Power Q_flow_n_CHP_single=Q_flow_n_CHP/quantity;
   Modelica.Blocks.Sources.RealExpression Zero;
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // Set values

  Modelica.Blocks.Interfaces.RealInput P_set( final quantity= "Power", final unit="W", displayUnit="W") annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-84,144}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={-61,112})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={86,144}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={37,112})));

  //Electric power port

  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (
    choicesAllMatching=true,
    Dialog(group="Replaceable Components"),
    Placement(transformation(extent={{90,50},{110,70}}), iconTransformation(extent={{80,42},{110,70}})));

  // Fuid ports

  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut outlet(Medium=medium) annotation (Placement(transformation(extent={{90,-6},{110,14}}), iconTransformation(extent={{92,-16},{112,4}})));

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn inlet(Medium=medium) annotation (Placement(transformation(extent={{90,-34},{110,-14}}), iconTransformation(extent={{92,-44},{112,-24}})));

  // _____________________________________________
  //
  //                Components
  // _____________________________________________

  Modelica.Blocks.Math.Gain Q_flow_set_pos[quantity](each k=-1) "Thermal setpoint sign changed (>0)" annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={46,110})));

  TransiEnt.Producer.Combined.LargeScaleCHP.Base.HeatInputTable Q_flow_set_SG[quantity](
    each final PQCharacteristics=PQCharacteristics,
    each Q_flow_n=Q_flow_n_CHP_single,
    each P_el_n=P_el_n_single)
                        "Steam generator setpoint" annotation (Placement(transformation(extent={{-10,80},{10,100}})));

  PQBoundaries pQDiagram[quantity](
    each final PQCharacteristics=PQCharacteristics,
    each Q_flow_nom=Q_flow_n_CHP_single,
    each P_n=P_el_n_single)
                     "Possible operating regime of electric output for given thermal output" annotation (Placement(transformation(extent={{10,114},{-10,134}})));

  TransiEnt.Components.Sensors.TemperatureSensor T_out_sensor annotation (Placement(transformation(extent={{88,4},{68,24}})));

  TransiEnt.Components.Sensors.TemperatureSensor T_in_sensor annotation (Placement(transformation(extent={{88,-42},{68,-24}})));

  // Statistical Collectors

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Cogeneration) annotation (Placement(transformation(extent={{12,-100},{32,-80}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectPowerEmissions annotation (Placement(transformation(extent={{34,-100},{54,-80}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectHeatingEmissions annotation (Placement(transformation(extent={{56,-100},{76,-80}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CogenerationPlantCost collectCosts(
    Q_flow_fuel_is=Q_flow_input,
    Q_flow_is=-Q_flow_is,
    P_el_is=-P_el_is,
    P_n=P_el_n,
    A_alloc_power=A_cde_alloc_power,
    A_alloc_heat=A_cde_alloc_heat,
    redeclare model PowerPlantCostModel = ProducerCosts) annotation (Dialog(tab="Advanced"), Placement(transformation(
        extent={{-10.5,-10},{10.5,10}},
        rotation=0,
        origin={89.5,-90})));

  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificEmissions(typeOfPrimaryEnergyCarrier=typeOfPrimaryEnergyCarrier);
  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

public
  Modelica.SIunits.Power P_el_is "Actual power generation (>=0)";
  Modelica.SIunits.Power P_el_CHP_is;
  Modelica.SIunits.HeatFlowRate Q_flow_is "Actual thermal power generation (>=0)";
  Modelica.SIunits.HeatFlowRate Q_flow_input;

  Modelica.SIunits.Efficiency eta_el(max=1);
  Modelica.SIunits.Efficiency eta_el_target(max=1) "Calculated from setpoint and plant characteristic";
  Modelica.SIunits.Efficiency eta_th(max=1);
  Modelica.SIunits.Efficiency eta_th_target(max=1) "Calculated from setpoint and plant characteristic";
  Modelica.SIunits.Efficiency eta_total = eta_el + eta_th;

  // Carbon dioxide emissions and allocation
  Modelica.SIunits.MassFlowRate m_flow_cde_total=Q_flow_input*fuelSpecificEmissions.m_flow_CDE_per_Energy;
  Modelica.SIunits.MassFlowRate m_flow_cde_heat=m_flow_cde_total*A_cde_alloc_heat;
  Modelica.SIunits.MassFlowRate m_flow_cde_power=m_flow_cde_total*A_cde_alloc_power;
  Real A_cde_alloc_heat "Allocation factor of total emissions to heat side";
  Real A_cde_alloc_power "Allocation factor of total emissions to power side";

  Modelica.SIunits.Heat Q_gen(start=0, fixed=true,displayUnit="TWh") "Generated thermal energy" annotation(Dialog(group="Initialization", tab="Advanced"));
  Modelica.SIunits.Energy W_el(start=0, fixed=true,displayUnit="TWh") "Generated electric energy"  annotation(Dialog(group="Initialization", tab="Advanced"));
  Modelica.SIunits.Energy W_el_CHP(start=0, fixed=true,displayUnit="TWh") "Generated electric energy in combined heat and power operation"  annotation(Dialog(group="Initialization", tab="Advanced"));

  Real x_CHP=P_el_CHP_is/max(simCenter.P_el_small, P_el_is) "Fraction of actual power generation that is produced in CHP operation";
  Real P_el_star=P_el_is/P_el_n "Power in p.u.";
  //  Real P_set_star=P_set_total.y/P_el_n "Setpoint power in p.u."; part of tsetpoint may come from balancing power request
  Real Q_flow_star=Q_flow_is/max(simCenter.Q_flow_small, Q_flow_n_total) "Thermal output in p.u";
  Real Q_flow_set_star=-Q_flow_set/Q_flow_n_total "Thermal setpoint in p.u";

   //Visualisation

  TransiEnt.Basics.Interfaces.General.EyeOut eye annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  Modelica.Blocks.Nonlinear.VariableLimiter
                                    Q_flow_set_CHP[quantity]                    annotation (Placement(transformation(extent={{32,104},{20,116}})));

 // Modelica.Blocks.Math.MultiSum multiSum[quantity](each k=vector([{1};ones(quantity-1)*(-1)]),nu=quantity)  annotation (Placement(transformation(extent={{74,104},{62,116}})));
  Modelica.Blocks.Math.MultiSum multiSum[quantity](each k=ones(quantity),each nu=quantity)  annotation (Placement(transformation(extent={{70,104},{58,116}})));

  Modelica.Blocks.Sources.RealExpression Q_flow_set_CHP_max(y=Q_flow_n_CHP_single) annotation (Placement(transformation(extent={{50,122},{40,132}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set_CHP_min(y=1e-3) annotation (Placement(transformation(extent={{50,92},{40,102}})));
  replaceable TransiEnt.Producer.Combined.LargeScaleCHP.Base.CHPStates_heatled        plantState(
    Q_flow_min_operating=1,
    Q_flow_max_operating=Q_flow_n_CHP,
    t_startup=0,
    init_state=if Q_flow_init > 0 then TransiEnt.Basics.Types.on1 else TransiEnt.Basics.Types.off) constrainedby TransiEnt.Producer.Combined.LargeScaleCHP.Base.CHPStates_heatled(
    t_startup=t_startup,
    init_state=if Q_flow_init > 0 then TransiEnt.Basics.Types.on1 else TransiEnt.Basics.Types.off)
                               annotation (Placement(transformation(extent={{-5.5,-5},{5.5,5}},
        rotation=180,
        origin={79.5,111})));
equation
    // _____________________________________________
  //
  //          Characteristic Equations
  // _____________________________________________

  P_el_is=-epp.P;
  Q_flow_is=inlet.m_flow*(outlet.h_outflow-inStream(inlet.h_outflow));

  if integrateHeatFlow then
  der(Q_gen)=Q_flow_is;
  else
    Q_gen=0;
  end if;

  if integrateElectricPower then
  der(W_el)=P_el_is;
  else
    W_el=0;
  end if;

  P_el_CHP_is=if useConstantSigma then sigma*Q_flow_is else min(P_el_is, pQDiagram[1].P_min);

if integrateElectricPowerChp then
  der(W_el_CHP)=P_el_CHP_is;
else
  W_el_CHP=0;
end if;

  // Efficiencies
  if not useConstantEfficiencies then
    eta_el=max(0,min(1, P_el_is/max(Q_flow_input,simCenter.Q_flow_small)));
    eta_th=max(0,min(1, Q_flow_is/max(Q_flow_input,simCenter.Q_flow_small)));
    eta_el_target=max(0, min(1, sum(Q_flow_set_SG.P)/max(sum(Q_flow_set_SG.Q_flow_input), simCenter.Q_flow_small)));
    eta_th_target=max(0, min(1, sum(Q_flow_set_SG.Q_flow)/max(sum(Q_flow_set_SG.Q_flow_input), simCenter.Q_flow_small)));
  else
    eta_el=eta_el_const;
    eta_el_target=eta_el_const;
    eta_th=eta_th_const;
    eta_th_target=eta_th_const;
  end if;

  //Eye values

  eye.P=P_el_is;
  eye.Q_flow=Q_flow_is;
  eye.T_supply=T_out_sensor.T_celsius;
  eye.T_return=T_in_sensor.T_celsius;
  eye.p = outlet.p/1e5;
  eye.h_supply = outlet.h_outflow/1e3;
  eye.h_return = inlet.h_outflow/1e3;
  eye.m_flow = -outlet.m_flow;

  (A_cde_alloc_heat, A_cde_alloc_power) =TransiEnt.Components.Statistics.Functions.cogenerationEmissionAllocationFactors(
    typeOfCO2AllocationMethod,
    eta_el,
    eta_th);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  // ------------ Statistics ----------

  // Electric output statistics
  collectElectricPower.powerCollector.P=epp.P;
  connect(modelStatistics.powerCollector[typeOfResource],collectElectricPower.powerCollector);

  //Thermal output statistics
  collectHeatingPower.heatFlowCollector.Q_flow = -Q_flow_is;
  connect(modelStatistics.heatFlowCollector[typeOfResource],collectHeatingPower.heatFlowCollector);

  //Emissions statistics
  collectPowerEmissions.gwpCollector.m_flow_cde=-m_flow_cde_power;
  collectHeatingEmissions.gwpCollector.m_flow_cde=-m_flow_cde_heat;
  connect(modelStatistics.gwpCollector[typeOfPrimaryEnergyCarrier],collectPowerEmissions.gwpCollector);
  connect(modelStatistics.gwpCollectorHeat[typeOfPrimaryEnergyCarrierHeat],collectHeatingEmissions.gwpCollector);

  // Economics statistics

  connect(modelStatistics.costsCollector, collectCosts.costsCollector);

  connect(outlet, T_out_sensor.port) annotation (Line(points={{100,4},{78,4}},             color={175,0,0}, thickness=0.5));

  connect(inlet, T_in_sensor.port) annotation (Line(points={{100,-24},{96,-24},{96,-42},{92,-42},{78,-42}},
                                                                                              color={175,0,0}, thickness=0.5));

  //General Annotations
  for i in 1:quantity loop
  connect(Q_flow_set_CHP[i].limit1, Q_flow_set_CHP_max.y) annotation (Line(points={{33.2,114.8},{33.2,121.4},{39.5,121.4},{39.5,127}}, color={0,0,127}));
  connect(Q_flow_set_CHP[i].limit2, Q_flow_set_CHP_min.y) annotation (Line(points={{33.2,105.2},{36,105.2},{36,97},{39.5,97}},           color={0,0,127}));
  connect(Q_flow_set_pos[i].y, Q_flow_set_CHP[i].u) annotation (Line(points={{39.4,110},{33.2,110}},        color={0,0,127}));
  connect(Q_flow_set_SG[i].Q_flow, Q_flow_set_CHP[i].y) annotation (Line(points={{5.45455,102},{8,102},{8,106},{18,106},{18,110},{19.4,110}},
                                                                                                                                            color={0,0,127}));
  connect(Q_flow_set_CHP[i].y, pQDiagram[i].Q_flow) annotation (Line(points={{19.4,110},{18,110},{18,124},{12,124}},
                                                                                                                   color={0,0,127}));
  connect(multiSum[i].u[1], plantState.Q_flow_set_lim) annotation (Line(points={{70,110},{73.34,110},{73.34,111}}, color={0,0,127}));
  for j in 2:quantity loop
    if j<=i then
       connect(Q_flow_set_CHP[j-1].y, multiSum[i].u[j]) annotation (Line(points={{19.4,110},{18,110},{18,96},{70,96},{70,110}},              color={0,0,127}));
    else
       connect(Zero.y, multiSum[i].u[j]);
    end if;
  end for;
  end for;


  connect(Q_flow_set_pos.u, multiSum.y) annotation (Line(points={{53.2,110},{56.98,110}},                   color={0,0,127}));

  connect(plantState.Q_flow_set, Q_flow_set) annotation (Line(
      points={{85,111},{85,119.5},{86,119.5},{86,144}},
      color={175,0,0},
      pattern=LinePattern.Dash));
   annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,140}}), graphics={
                                                                                Line(
          points={{88,-60},{88,-74}},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),                                     Line(
          points={{88,-60},{-90,-60},{-90,-76}},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),                                     Line(
          points={{66,-60},{66,-74}},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),                                     Line(
          points={{16,-60},{16,-76}},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),                                     Line(
          points={{44,-60},{44,-74}},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled})}), Icon(graphics,
                                                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,140}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This partial model offers a template for the creation of large scale CHP models with condensation-extraction configuration.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The main elements of this partial model are:</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">Set-value interfaces: these consist of one set value for the power production and one set value for the heat production and according to the library&apos;s sign and units convention.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Local sensors (statistics): these consist of power and heat collectors, as well as emissions and cost collectors.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Output interfaces: these consit of one electric power interface and two fluid port interfaces (district heating return and supply).</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Plant&apos;s operation limits: these limits are given in form of PQ diagramms (see component <span style=\"color: #0000ff;\">TransiEnt.Producer.Combined.LargeScaleCHPpackage.Base.pQDiagram</span>) as well as Max and Min operators.</li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Plant&apos;s heat input calculation: this calculation is based on an externally calculated characteristic field (see component <span style=\"color: #ff0000;\">TransiEnt.Distribution.Heat.HeatGridControl.Q_flow_set_SG</span>).</li>
</ul>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">This partial model is used in components such as: </span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">LargeScaleCHP_L1_Meerbeck</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">LargeScaleCHP_L1_TimeConstant</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">LargeScaleCHP_L1_TimeConstant_two_fuels</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">LargeScaleCHP_L1_TimeConstant_w_CtrPower</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">LargeScaleCHP_L1_TimeConstant_w_PeakLoadHeater</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">LargeScaleCHP_L2</span><br></li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica.Blocks.Interfaces.RealInput:&nbsp;Power setpoint&nbsp;</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica.Blocks.Interfaces.RealInput:&nbsp;Heat flow setpoint</p><p></span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Electrical power port can be chosen</p><p></span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.Thermal.FluidPortOut:&nbsp;carrier medium outlet</p><p></span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.Thermal.FluidPortIn:&nbsp;carrier medium inlet</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
</html>"));
end PartialCHP;
