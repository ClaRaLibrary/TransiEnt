within TransiEnt.Producer.Combined.LargeScaleCHP;
model H2CofiringCHP "Continuous combined cycle CHP plant with hydrogen cofiring (e.g. from power-2-gas technologies)"
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

  extends Base.PartialCHP(collectCosts(Q_flow_fuel_is=Q_flow_input_basefuel),
    redeclare model ProducerCosts = Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasCCGT,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real P_grad_max_star=0.03/60 "Fraction of nominal power per second (12% per minute)";
  parameter SI.Time T_steamGenerator = 0.5*(0.632/P_grad_max_star) "Time constant of steam generator (overrides value of P_grad_max_star)" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time T_turboGenerator = 60 "Time constant of turbo generator" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time T_heatingCondenser = 40 "Time constant of heating condenser" annotation(Dialog(group="Physical Constraints"));

     //Heating condenser parameters

  parameter Modelica.SIunits.Pressure p_nom(displayUnit="Pa")=1e5 "Nominal pressure" annotation(Dialog(group="Heating condenser parameters"));

  parameter SI.MassFlowRate m_flow_nom=10 "Nominal mass flow rate" annotation(Dialog(group="Heating condenser parameters"));

  parameter SI.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy" annotation(Dialog(group="Heating condenser parameters"));

  parameter SI.Temperature T_feed_init = 120+273.15 "Start temperature of feed water" annotation(Dialog(group="Initialization", tab="Advanced"));

  final parameter SI.SpecificEnthalpy h_start=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      medium,
      p_nom,
      T_feed_init) "Start value of sytsem specific enthalpy" annotation(Dialog(group="Heating condenser parameters"));
  parameter Boolean useGasPort=false "Choose if gas port is used or not" annotation(Dialog(group="Fundamental Definitions"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_gas=simCenter.gasModel1 if useGasPort==true "Gas Medium to be used - only if useGasPort==true" annotation(Dialog(group="Fundamental Definitions",enable=if useGasPort==true then true else false));

  // _____________________________________________
  //
  //             Components
  // _____________________________________________

  ClaRa.Components.HeatExchangers.TubeBundle_L2 HX(
    length=15,
    N_tubes=10,
    N_passes=2,
    h_start=467624,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    m_flow_nom=m_flow_nom,
    p_nom(displayUnit="Pa") = p_nom,
    h_nom=h_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    p_start=1079200) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={62,-10})));

  Modelica.Blocks.Interfaces.BooleanInput h2Available annotation (Placement(transformation(extent={{-124,-60},{-84,-20}}), iconTransformation(extent={{-110,-16},{-78,16}})));
  Modelica.Blocks.Continuous.FirstOrder turboGenerator(
    T=T_turboGenerator,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=P_el_init) annotation (Placement(visible=true, transformation(
        origin={4.1454,43.7058},
        extent={{-10.9091,-10.9091},{10.9091,10.9091}},
        rotation=0)));
  Modelica.Blocks.Continuous.FirstOrder steamGenerator(
    T=T_steamGenerator,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=if useEfficiencyForInit then P_el_init/eta_el_init else Q_flow_SG_init) annotation (Placement(transformation(extent={{-64,12},{-44,32}})));
  Modelica.Blocks.Continuous.FirstOrder heatingCondenser(
    T=T_heatingCondenser,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=Q_flow_init)                              annotation (Placement(transformation(extent={{-8,-20},{12,0}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow(T_ref(displayUnit="degC"))
     annotation (Placement(
        transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={31,-10})));
  Modelica.Blocks.Sources.RealExpression eta_el_source(y=eta_el_target)
                                                                 annotation (Placement(transformation(extent={{-62,44},{-42,64}})));
  Modelica.Blocks.Math.Product product annotation (Placement(transformation(extent={{-30,48},{-22,40}})));
  Modelica.Blocks.Sources.RealExpression eta_th_source(y=eta_th_target)
                                                                 annotation (Placement(transformation(extent={{-62,-34},{-42,-14}})));
  Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(extent={{-26,-14},{-18,-6}})));
  Components.Boundaries.Electrical.ActivePower.Power terminal(change_sign=true) annotation (Placement(transformation(extent={{82,50},{62,70}})));

  Modelica.SIunits.HeatFlowRate Q_flow_input_basefuel = if h2Available then Q_flow_input * (1 - simCenter.k_H2_fraction) else Q_flow_input;
  Consumer.Gas.GasConsumer_HFlow_NCV gasConsumer_HFlow_NCV(medium=medium_gas) if useGasPort==true annotation (Placement(transformation(extent={{60,70},{40,90}})));
  Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium_gas) if useGasPort==true annotation (Placement(transformation(extent={{90,92},{110,112}})));
  Components.Sensors.RealGas.CO2EmissionSensor cO2EmissionOfIdealCombustion if useGasPort                                                 ==true annotation (Placement(transformation(extent={{94,80},{74,100}})));
  Modelica.Blocks.Math.Gain m_flow_cde_gain(k=1) annotation (Placement(transformation(extent={{68,86},{60,94}})));
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
public
  Modelica.SIunits.MassFlowRate m_flow_cde_total_set;
  SI.Power P_limit_off_set[quantity];

  Modelica.Blocks.Math.MultiSum multiSum_Q_flow_SG(nu=quantity)        annotation (Placement(transformation(extent={{-44,80},{-52,72}})));
  Modelica.Blocks.Nonlinear.VariableLimiter P_limit_on[quantity] annotation (Placement(transformation(extent={{-42,100},{-32,110}})));
  Modelica.Blocks.Sources.RealExpression P_limit_off[quantity](y=P_limit_off_set)                                                annotation (Placement(transformation(extent={{-52,76},{-32,96}})));
  Modelica.Blocks.Math.Sum P_limit[quantity](each nin=2)          annotation (Placement(transformation(extent={{-24,98},{-12,110}})));
  Modelica.Blocks.Math.Add add1  [quantity](each k2=-1) annotation (Placement(transformation(extent={{-62,98},{-50,110}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-76,104},{-68,112}})));
equation
  // _____________________________________________
  //
  //         Characteristic Equations
  // _____________________________________________

  if useGasPort==false then
    m_flow_cde_total_set=Q_flow_input*fuelSpecificEmissions.m_flow_CDE_per_Energy;
  else
    m_flow_cde_total_set=m_flow_cde_gain.y;
  end if;

  Q_flow_input = steamGenerator.u;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  //Connect statements
  connect(outlet, HX.outlet) annotation (Line(
      points={{100,4},{65,4},{65,0},{62,0}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inlet, HX.inlet) annotation (Line(
      points={{100,-24},{62,-24},{62,-20}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));

  //Annotations
  connect(eta_el_source.y,product. u2) annotation (Line(points={{-41,54},{-41,54},{-36,54},{-34.8,54},{-34.8,46.4},{-30.8,46.4}}, color={0,0,127}));
  connect(product.y,turboGenerator. u) annotation (Line(points={{-21.6,44},{-8.94552,44},{-8.94552,43.7058}}, color={0,0,127}));
  connect(eta_th_source.y,product1. u2) annotation (Line(points={{-41,-24},{-32,-24},{-32,-12.4},{-26.8,-12.4}}, color={0,0,127}));
  connect(turboGenerator.y, terminal.P_el_set) annotation (Line(points={{16.1454,43.7058},{26,43.7058},{26,44},{46,44},{46,78},{78,78},{78,72}},
                                                                                                                                      color={0,0,127}));
  connect(steamGenerator.y,product. u1) annotation (Line(points={{-43,22},{-38,22},{-38,41.6},{-30.8,41.6}}, color={0,0,127}));
  connect(steamGenerator.y,product1. u1) annotation (Line(points={{-43,22},{-36,22},{-36,-7.6},{-26.8,-7.6}}, color={0,0,127}));
  connect(product1.y,heatingCondenser. u) annotation (Line(points={{-17.6,-10},{-14,-10},{-10,-10}},   color={0,0,127}));
  connect(heatingCondenser.y,prescribedHeatFlow. Q_flow) annotation (Line(points={{13,-10},{22,-10}},                  color={0,0,127}));
  connect(prescribedHeatFlow.port, HX.heat) annotation (Line(points={{40,-10},{52,-10}},                   color={191,0,0}));
  connect(terminal.epp, epp) annotation (Line(
      points={{82,60},{82,60},{82,60},{100,60}},
      color={0,135,135},
      thickness=0.5));
  if useGasPort==true then
    connect(steamGenerator.y,gasConsumer_HFlow_NCV. H_flow) annotation (Line(points={{-43,22},{-38,22},{-38,-4},{-92,-4},{-92,70},{40,70},{40,80},{39,80}},     color={0,0,127}));
   connect(cO2EmissionOfIdealCombustion.gasPortOut, gasConsumer_HFlow_NCV.fluidPortIn) annotation (Line(
      points={{74,80},{60,80}},
      color={255,255,0},
      thickness=1.5));
   connect(cO2EmissionOfIdealCombustion.gasPortIn, gasPortIn) annotation (Line(
      points={{94,80},{100,80},{100,102}},
      color={255,255,0},
      thickness=1.5));
   connect(cO2EmissionOfIdealCombustion.m_flow_cde,m_flow_cde_gain.u) annotation (Line(points={{73,96.8},{72,96.8},{72,90},{68.8,90}}, color={0,0,127}));
  else
    connect(Zero.y,m_flow_cde_gain.u);
  end if;

  for i in 1:quantity loop
    P_limit_off_set[i]=if Q_flow_set_CHP[i].y<=Q_flow_set_CHP_min.y then -pQDiagram[i].P_min else 0;
  end for;

for i in 1:quantity loop
  connect(P_limit_on[i].y,P_limit[i].u[1]) annotation (Line(points={{-31.5,105},{-25.2,105},{-25.2,103.4}},        color={0,0,127}));
  connect(pQDiagram[i].P_max, P_limit_on[i].limit1) annotation (Line(points={{-11,128.4},{-48,128.4},{-48,109},{-43,109}},       color={0,0,127}));
  connect(pQDiagram[i].P_min, P_limit_on[i].limit2) annotation (Line(points={{-11,121},{-46,121},{-46,101},{-43,101}},     color={0,0,127}));
  connect(P_limit_off[i].y,P_limit[i]. u[2]) annotation (Line(points={{-31,86},{-28,86},{-28,104.6},{-25.2,104.6}},                    color={0,0,127}));
  connect(P_limit[i].y, Q_flow_set_SG[i].P) annotation (Line(points={{-11.4,104},{-7.27273,104},{-7.27273,102}},  color={0,0,127}));
  connect(add1[i].y, P_limit_on[i].u) annotation (Line(points={{-49.4,104},{-46,104},{-46,105},{-43,105}}, color={0,0,127}));
  connect(gain.y, add1[i].u1) annotation (Line(
    points={{-67.6,108},{-66.08,108},{-66.08,107.6},{-63.2,107.6}},
    color={0,135,135},
    pattern=LinePattern.Dash));
  connect(Q_flow_set_SG[i].Q_flow_input, multiSum_Q_flow_SG.u[i]) annotation (Line(
      points={{-0.909091,79},{-0.909091,76},{-44,76}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  if i==1 then
    connect(Zero.y,add1[i].u2);
  else
    connect(P_limit_on[i-1].y, add1[i].u2) annotation (Line(points={{-31.5,105},{-30,105},{-30,96},{-63.2,96},{-63.2,100.4}}, color={0,0,127}));
  end if;
  end for;

  connect(P_set, gain.u) annotation (Line(points={{-84,144},{-84,108},{-76.8,108}}, color={0,0,127}));
  connect(multiSum_Q_flow_SG.y, steamGenerator.u) annotation (Line(points={{-52.68,76},{-80,76},{-80,22},{-66,22}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}})), Icon(coordinateSystem(extent={{-100,-100},{100,120}}),
                                                                                                         graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-72,-42},{-72,-22},{-52,-30},{-52,-36},{-72,-42}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-18,-42},{-18,-22},{-38,-30},{-38,-36},{-18,-42}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{56,-30},{56,-10},{36,-18},{36,-24},{56,-30}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{64,-36},{50,-52}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-72,-56},{-72,-42}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-52,-30},{-52,-18},{-38,-18},{-38,-30}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-18,-42},{-18,-50},{-2,-50},{-2,86}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{36,-18},{36,4},{14,4},{10,4}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{56,-30},{56,-36}}, color={0,0,0}),
        Line(
          points={{56,-52},{56,-58}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{56,-20},{66,-20},{66,60},{84,60}},
          color={0,140,72},
          thickness=0.5),
        Line(
          points={{-78,0},{-52,0},{-48,-12}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-42,40},{-42,-12}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{90,-36},{78,-36},{78,-48},{54,-48},{60,-44},{54,-40},{72,-40},{72,-6},{102,-6}},
          color={162,29,33},
          thickness=0.5),
        Rectangle(
          extent={{-14,78},{12,-4}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-40,-12},{-50,-24}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{-48,-16},{-42,-22}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(points={{-48,-16},{-42,-22}}, color={0,0,0}),
        Line(
          points={{-48,-22},{-42,-16}},
          color={0,0,0},
          thickness=0.5)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>This model is in fact very similar to the component <a href=\"modelica://TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP\">TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP</a>. The main difference consists in the fact that this component, together with the component <a href=\"modelica://TransiEnt.Producer.Gas.Electrolyzer.Systems.ElectrolyzerAndCavern\">TransiEnt.Producer.Gas.Electrolyzer.Systems.ElectrolyzerAndCavern</a><span style=\"color: #0000ff;\"> </span>can be used to simulate combined cycle plants with hydrogen co-firing.</p>
<p>The co-firing rate depends on the global parameter deifined in <span style=\"color: #0000ff;\">SimCenter.k_H2_fraction</span>. </p>
<p>The acutal logic which decides the times and quantities at which hydrogen can be co-fired are defined in the cavern component.</p>
<p>The emissions calculated by the cost-collector sensor depend exclusively on the ammount of natural gas being consumed (which can be more or less depending on the selected co-firing rate) and its specific fuel emissions. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_set: input for Power in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_set: input for heat flow rate in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">outlet: FluidPortOut</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">inlet: FluidPortIn</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">eye: EyeOut</span></p>
<p>h2Available: BooleanInput</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">gasPortIn: RealGasPortIn</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: choice of power port</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Ricardo Peniche, 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Schülting (oliver.schuelting@tuhh.de) in Nov 2018: added gasPort</span></p>
</html>"));
end H2CofiringCHP;
