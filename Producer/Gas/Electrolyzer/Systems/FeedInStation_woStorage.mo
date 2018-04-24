within TransiEnt.Producer.Gas.Electrolyzer.Systems;
model FeedInStation_woStorage

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialFeedInStation;

  // _____________________________________________
  //
  //          Constants and Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel3 "|General|Hydrogen model to be used";
  parameter SI.ActivePower P_el_n=1e6 "|Electrolyzer|Nominal power of electrolyzer";
  parameter SI.ActivePower P_el_max=1.68*P_el_n "|Electrolyzer|Maximum power of electrolyzer";
  parameter SI.ActivePower P_el_min=0.05*P_el_n "|Electrolyzer|Minimal power of electrolyzer";
  parameter SI.ActivePower P_el_overload=1.0*P_el_n "|Electrolyzer|Power at which overload region begins";
  parameter SI.ActivePower P_el_cooldown=P_el_n "Power below which cooldown of electrolyzer starts" annotation(Dialog(group="Electrolyzer"));
  parameter SI.MassFlowRate m_flow_start=0.0 "|Initialization|Sets initial value for m_flow from a buffer";
  //parameter SI.Temperature T_Init=283.15 "|Initialization|Sets initial value for T";
  parameter Modelica.SIunits.Efficiency eta_n(
    min=0,
    max=1)=0.75 "|Electrolyzer|Nominal efficency coefficient (min = 0, max = 1)";
  parameter Modelica.SIunits.Efficiency eta_scale(
    min=0,
    max=1)=0 "|Electrolyzer|Sets a with increasing input power linear degrading efficiency coefficient (min = 0, max = 1)";
  parameter SI.AbsolutePressure p_out=35e5 "|Electrolyzer|Hydrogen output pressure from electrolyzer";
  parameter SI.Temperature T_out=283.15 "|Electrolyzer|Hydrogen output temperature from electrolyzer";
  parameter Real specificWaterConsumption=10 "|Electrolyzer|Mass of water per mass of hydrogen";
  parameter Real t_overload=0.5*3600 "|Electrolyzer|Maximum time the ely can work in overload in seconds";
  parameter Real coolingToHeatingRatio=1 "|Electrolyzer|Defines how much faster electrolyzer cools down than heats up";
  parameter Integer startState=1 "|Electrolyzer|Initial state of the electrolyzer (1: ready to overheat, 2: working in overload, 3: cooling down)";

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI "|Controller|Type of controller for feed-in control";
  parameter Real k=1e8 "|Controller|Gain for feed-in control";
  parameter Real Ti=1 "|Controller|Integrator time constant for feed-in control";
  parameter Real Td=0.1 "|Controller|Derivative time constant for feed-in control";

  replaceable model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200        constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline        "|Electrolyzer|Calculate the efficiency" annotation (__Dymola_choicesAllMatching=true);
  replaceable model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder        constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerDynamics        "|Electrolyzer|Dynamic behavior of electrolyser" annotation (__Dymola_choicesAllMatching=true);

  //Statistics
  replaceable model CostSpecsElectrolyzer = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "|Statistics||Cost configuration electrolyzer" annotation (choicesAllMatching=true);
  parameter Real Cspec_demAndRev_other_water=simCenter.Cspec_demAndRev_other_water "|Statistics||Specific demand-related cost per cubic meter water of electrolyzer";
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el_electrolyzer=simCenter.Cspec_demAndRev_free "|Statistics||Specific demand-related cost per electric energy for electrolyzer";


  // _____________________________________________
  //
  //               Complex Components
  // _____________________________________________

protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.Power P_el "Consumed electric power";
    input SI.Energy W_el "Consumed electric energy";
    input SI.Mass mass_H2 "Produced hydrogen mass";
    input SI.Efficiency eta "Efficiency of the electrolyzer";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOutElectrolyzer;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sourceH2(
    variable_m_flow=true,
    final medium=medium,
    xi_const=zeros(sourceH2.medium.nc - 1)) annotation (Placement(transformation(extent={{-44,-44},{-28,-28}})));

  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    startTime=3,
    height=m_flow_start,
    offset=-m_flow_start)
                         annotation (Placement(transformation(extent={{-64,-38},{-50,-25}})));
public
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer(
    final P_el_n=P_el_n,
    final P_el_max=P_el_max,
    final eta_n=eta_n,
    final eta_scale=eta_scale,
    final T_out=T_out,
    final medium=medium,
    redeclare model Dynamics = Dynamics,
    redeclare model Charline = Charline,
    redeclare model CostSpecsGeneral = CostSpecsElectrolyzer,
    specificWaterConsumption=specificWaterConsumption,
    Cspec_demAndRev_other=Cspec_demAndRev_other_water,
    Cspec_demAndRev_el=Cspec_demAndRev_el_electrolyzer) annotation (Placement(transformation(extent={{-16,-16},{16,16}})));
protected
  TransiEnt.Components.Gas.VolumesValvesFittings.ValveDesiredPressureBefore valve_pBeforeValveDes(final medium=medium, p_BeforeValveDes=p_out) annotation (Placement(transformation(
        extent={{-8,-4},{8,4}},
        rotation=270,
        origin={20,-12})));

  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor(medium=medium, xiNumber=medium.nc) annotation (Placement(transformation(
        extent={{7,6},{-7,-6}},
        rotation=90,
        origin={6,-49})));

  TransiEnt.Basics.Adapters.Gas.RealH2_to_RealNG h2toNG(final medium_h2=medium) annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={0,-68})));

public
  TransiEnt.Producer.Gas.Electrolyzer.Controller.TotalFeedInController controlTotalEly(
    P_el_n=P_el_n,
    P_el_overload=P_el_overload,
    P_el_max=P_el_max,
    t_overload=t_overload,
    coolingToHeatingRatio=coolingToHeatingRatio,
    k=k,
    P_el_min=P_el_min,
    eta_n=eta_n,
    eta_scale=eta_scale,
    startState=startState,
    redeclare model Charline = Charline,
    controllerType=controllerType,
    Ti=Ti,
    Td=Td,
    P_el_cooldown=P_el_cooldown)
           annotation (Placement(transformation(extent={{-10,56},{10,76}})));
public
  inner Summary summary(
    outline(
      P_el=electrolyzer.summary.outline.P_el,
      W_el=electrolyzer.summary.outline.W_el,
      mass_H2=electrolyzer.summary.outline.mass_H2,
      eta=electrolyzer.summary.outline.eta),
    gasPortOutElectrolyzer(
      mediumModel=electrolyzer.summary.gasPortOut.mediumModel,
      xi=electrolyzer.summary.gasPortOut.xi,
      x=electrolyzer.summary.gasPortOut.x,
      m_flow=electrolyzer.summary.gasPortOut.m_flow,
      T=electrolyzer.summary.gasPortOut.T,
      p=electrolyzer.summary.gasPortOut.p,
      h=electrolyzer.summary.gasPortOut.h,
      rho=electrolyzer.summary.gasPortOut.rho),
    gasPortOut(
      mediumModel=simCenter.gasModel1,
      xi=gasOut.xi,
      x=gasOut.x,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=gasOut.h,
      rho=gasOut.d),
    costs(
      costs=electrolyzer.summary.costs.costs,
      investCosts=electrolyzer.summary.costs.investCosts,
      demandCosts=electrolyzer.summary.costs.demandCosts,
      oMCosts=electrolyzer.summary.costs.oMCosts,
      otherCosts=electrolyzer.summary.costs.otherCosts,
      revenues=electrolyzer.summary.costs.revenues)) annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));
protected
  TILMedia.VLEFluid_ph gasOut(
    vleFluidType=simCenter.gasModel1,
    deactivateTwoPhaseRegion=true,
    h=actualStream(gasPortOut.h_outflow),
    p=gasPortOut.p,
    xi=actualStream(gasPortOut.xi_outflow)) annotation (Placement(transformation(extent={{12,-98},{32,-78}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  connect(ramp.y,sourceH2.m_flow) annotation (Line(points={{-49.3,-31.5},{-49.3,-31.2},{-45.6,-31.2}},
                                                                                                  color={0,0,127}));
  connect(electrolyzer.epp, epp) annotation (Line(
      points={{-16,0},{-16,0},{-100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(controlTotalEly.P_el_ely, electrolyzer.P_el_set) annotation (Line(points={{0,55},{0,38},{0,19.2},{-6.4,19.2}},
                                                                                                       color={0,0,127},
      pattern=LinePattern.Dash));
  connect(P_el_set, controlTotalEly.P_el_set) annotation (Line(points={{0,108},{0,74.8}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(m_flow_feedIn, controlTotalEly.m_flow_feedIn) annotation (Line(points={{108,70},{42,70},{9.2,70}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(electrolyzer.gasPortOut, valve_pBeforeValveDes.gasPortIn) annotation (Line(
      points={{16,0},{20,0},{20,-4}},
      color={255,255,0},
      thickness=1.5));
  connect(gasPortOut, h2toNG.gasPortOut) annotation (Line(
      points={{0,-96},{0,-96},{0,-76},{-4.996e-016,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(h2toNG.gasPortIn, massflowSensor.gasPortOut) annotation (Line(
      points={{4.996e-016,-60},{0,-60},{0,-56},{-2.66454e-015,-56}},
      color={255,255,0},
      thickness=1.5));
  connect(sourceH2.gasPort, massflowSensor.gasPortIn) annotation (Line(
      points={{-28,-36},{0,-36},{0,-42}},
      color={255,255,0},
      thickness=1.5));
  connect(valve_pBeforeValveDes.gasPortOut, massflowSensor.gasPortIn) annotation (Line(
      points={{20,-20},{20,-36},{0,-36},{0,-42},{-1.77636e-015,-42}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensor.m_flow_aux, controlTotalEly.m_flow_ely) annotation (Line(
      points={{6,-41.3},{6,-40},{40,-40},{40,62},{9.2,62}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (defaultComponentName="feedInStation",Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-150,20},{150,-20}},
          lineColor={0,134,134},
          textString="%name",
          origin={0,149},
          rotation=360)}),
  Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This model represents a feed in station where hydrogen is produced with an electrolyzer and fed directly into a natural gas grid. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>see sub models </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>see sub models </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>P_el_set: input for the set value for the electric power </p>
<p>m_flow_feedIn: input for the possible feed-in mass flow into the natural grid etc. </p>
<p>epp: electric power port for the electrolyzer </p>
<p>gasPortOut: outlet of the hydrogen </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>For start up, a small hydrogen mass flow for the electrolyzer can be set to allow for simpler initialisation. </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de) in September 2016<br> </p>
</html>"));
end FeedInStation_woStorage;
