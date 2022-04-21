within TransiEnt.Producer.Heat.Base;
partial model XtH_L1_idContrMFlow_temp_base "Base class for heat producers with a pump with ideal mass flow control to get a given outlet temperature"


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

  extends TransiEnt.Basics.Icons.Model;
  import      Modelica.Units.SI;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium to be used"      annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Boolean use_varTemp=false "true if variable temperature input should be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.HeatFlowRate Q_flow_n = 3.5e3 "Nominal heat flow rate" annotation(Dialog(group="Technical Specifications"));
  parameter SI.Temperature T_out_set_const=46 + 273.15 "Constant outlet temperature" annotation(Dialog(group="Technical Specifications",enable=not use_varTemp));
  parameter SI.MassFlowRate m_flow_max=1e10 "Maximum mass flow" annotation(Dialog(group="Technical Specifications"));
  parameter Boolean allowOverheat=false "true if the heat producer is allowed to supply heat even if the outlet temperature is higher than T_out_const then" annotation(Dialog(group="Technical Specifications"));
  parameter SI.HeatFlowRate Q_flow_small=1 "Small heat flow rate under which the heat supply stops" annotation(Dialog(enable=allowOverheat,group="Numerical Stability"));
  parameter TransiEnt.Basics.Types.TypeOfResource typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional "Select the kind of resource" annotation (Dialog(group="Statistics"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=medium) annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_out_set=T_out_set_in if use_varTemp "Setpoint value of the output temperature" annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-60}),
                         iconTransformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-50,100})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set "Setpoint value of the heat flow, should be negative" annotation (Placement(transformation(extent={{120,-20},{80,20}}),   iconTransformation(extent={{120,-20},{80,20}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.Empty
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT fluidOut(
    vleFluidType=medium,
    p=fluidPortOut.p,
    T=T_out_set_in) annotation (Placement(transformation(extent={{30,-80},{50,-60}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts_HeatProducer(
    redeclare model HeatingPlantCostModel = ProducerCosts,
    Q_flow_fuel_is=0,
    m_flow_CDE_is=0,
    Q_flow_n=Q_flow_n,
    Q_flow_is=Q_flow,
    consumes_H_flow=false,
    produces_m_flow_CDE=false)
                         annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=typeOfResource) annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Temperature T_out_set_in;
  SI.HeatFlowRate Q_flow;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  if not use_varTemp then
    T_out_set_in=T_out_set_const;
  end if;

  if inStream(fluidPortIn.h_outflow)>fluidOut.h then
    if -Q_flow_set<Q_flow_small or not allowOverheat then
      fluidPortOut.m_flow=0;
      fluidPortOut.h_outflow=inStream(fluidPortIn.h_outflow);
    else
      fluidPortOut.h_outflow=Q_flow_set/fluidPortOut.m_flow+inStream(fluidPortIn.h_outflow);
      fluidPortOut.m_flow=-m_flow_max; //maximum mass flow to keep the temperature increase at a minimum
    end if;
  else
    fluidPortOut.h_outflow=fluidOut.h;
    fluidPortOut.m_flow=-max(0,min(m_flow_max,-Q_flow_set/(fluidPortOut.h_outflow-inStream(fluidPortIn.h_outflow))));
  end if;

  fluidPortIn.m_flow+fluidPortOut.m_flow=0;
  fluidPortIn.h_outflow=inStream(fluidPortOut.h_outflow);

  Q_flow=fluidPortOut.m_flow*(fluidPortOut.h_outflow-inStream(fluidPortIn.h_outflow));

  collectHeatingPower.heatFlowCollector.Q_flow=Q_flow;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Consumer],collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.costsCollector, collectCosts_HeatProducer.costsCollector);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-40,14},{-40,58},{40,58},{40,-100}},
          color={175,0,0},
          thickness=0.5),
        Line(
          points={{-40,-100},{-40,-18}},
          color={175,0,0},
          thickness=0.5),          Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-56,-18},{-24,14}},
          startAngle=0,
          endAngle=360), Line(
          points={{-50,2},{-40,14},{-40,-18},{-40,14},{-30,2}},
          color={0,0,0},
          thickness=0.5),          Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{0,-40},{80,40}},
          startAngle=0,
          endAngle=360)}),                                       Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a base class for heat producers with a pump with ideal mass flow control to get a given outlet temperature. It can be chosen if the outlet set temperature is constant or given by an input.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The mass flow is calculated based on a heat flow rate and a given constant outlet temperature. There is no volume considered.</p>
<p>There are no pressure losses included (pressures at inlet and outlet are given from the outside).</p>
<p>Overheating, i.e. exceeding the set outlet temperature, can be turned on or off.</p>
<p>The model calculates any mass flow that is necessary to reach the given temperature but limits the mass flow so that no flow reversal occurs and that the given maximum mass flow is not exceeded. </p>
<p>If the specific enthalpy at the inlet exceeds the set specific enthalpy, two cases will be distinguished:</p>
<ul>
<li>If the set value for the heat flow rate is below the given small value or overheating is not allowed, the mass flow is set to zero and the specific enthalpy is just passed through the fluid ports. </li>
<li>Otherwise the maximum mass flow rate is set.</li>
</ul>
<p>The heat flow rate is always calculated according to the actual specific enthalpies and the mass flow rate.</p>
<p>For more details see the equations.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>This model is only valid for ideal controls, i.e. ideally tuned controls with no control errors.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>T_out_set: set point for outlet temperature</p>
<p>Q_flow_set: set point heat flow rate (negative for producers)</p>
<p>fluidPortIn: inlet for fluid</p>
<p>fluidPortOut: outlet for fluid</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p><span style=\"font-family: Courier New;\">  <span style=\"color: #0000ff;\">if </span><span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow)&gt;fluidOut.h<span style=\"font-family: Courier New; color: #0000ff;\"> then</span></p>
<p><span style=\"font-family: Courier New;\">    <span style=\"color: #0000ff;\">if </span>-Q_flow_set&lt;Q_flow_small<span style=\"font-family: Courier New; color: #0000ff;\"> or not </span>allowOverheat<span style=\"font-family: Courier New; color: #0000ff;\"> then</span></p>
<p><span style=\"font-family: Courier New;\">      fluidPortOut.m_flow=0;</span></p>
<p><span style=\"font-family: Courier New;\">      fluidPortOut.h_outflow=<span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow);</p>
<p><span style=\"font-family: Courier New;\">    <span style=\"color: #0000ff;\">else</span></p>
<p><span style=\"font-family: Courier New;\">      fluidPortOut.h_outflow=Q_flow_set/fluidPortOut.m_flow+<span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow);</p>
<p><span style=\"font-family: Courier New;\">      fluidPortOut.m_flow=-m_flow_max;<span style=\"color: #006400;\"> //maximum mass flow to keep the temperature increase at a minimum</span></p>
<p><span style=\"font-family: Courier New;\">    <span style=\"color: #0000ff;\">end if</span>;</p>
<p><span style=\"font-family: Courier New;\">  <span style=\"color: #0000ff;\">else</span></p>
<p><span style=\"font-family: Courier New;\">    fluidPortOut.h_outflow=fluidOut.h;</span></p>
<p><span style=\"font-family: Courier New;\">    fluidPortOut.m_flow=-<span style=\"color: #ff0000;\">max</span>(0,<span style=\"font-family: Courier New; color: #ff0000;\">min</span>(m_flow_max,-Q_flow_set/(fluidPortOut.h_outflow-<span style=\"font-family: Courier New; color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow))));</p>
<p><span style=\"font-family: Courier New;\">  <span style=\"color: #0000ff;\">end if</span>;</p>
<p><span style=\"font-family: Courier New;\">  Q_flow=fluidPortOut.m_flow*(fluidPortOut.h_outflow-<span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow));</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The model is only working properly in design flow direction. Reverse flow is not supported!</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end XtH_L1_idContrMFlow_temp_base;
