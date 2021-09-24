within TransiEnt.Components.Gas.Compressor;
model ValveAndCompressor_mflow


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  import      Modelica.Units.SI;
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Pressure p_before_low=1e5 "Lower limit for hysteresis to limit mass flow for too low pressures" annotation(Dialog(group="Controller"));
  parameter SI.Pressure p_before_high=1.1e5 "Higher limit for hysteresis to limit mass flow for too low pressures" annotation(Dialog(group="Controller"));

  parameter SI.Volume volumeSplit = 0.01 "Volume of the split" annotation(Dialog(group="Split and Junction"));
  parameter SI.Volume volumeJunction = 0.01 "Volume of the junction" annotation(Dialog(group="Split and Junction"));


  parameter SI.Pressure p_startSplit = 1e5 "Start pressure in the split" annotation(Dialog(group="Initial Values"));
  parameter SI.Pressure p_startJunction = 1e5 "Start pressure in the junction" annotation(Dialog(group="Initial Values"));
  parameter SI.MassFraction xi_startSplit[medium.nc-1] = medium.xi_default "Start composition in the split" annotation(Dialog(group="Initial Values"));
  parameter SI.MassFraction xi_startJunction[medium.nc-1] = medium.xi_default "Start composition in the junction" annotation(Dialog(group="Initial Values"));
  parameter SI.Temperature T_startSplit = simCenter.T_ground "Start temperature in the split" annotation(Dialog(group="Initial Values"));
  parameter SI.Temperature T_startJunction = simCenter.T_ground "Start temperature in the Junction" annotation(Dialog(group="Initial Values"));
  parameter SI.SpecificEnthalpy h_startSplit = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(medium, p_startSplit, T_startSplit, xi_startSplit) "Start specific enthalpy in the split" annotation(Dialog(group="Initial Values"));
  parameter SI.SpecificEnthalpy h_startJunction = TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(medium, p_startJunction, T_startJunction, xi_startJunction) "Start specific enthalpy in the Junction" annotation(Dialog(group="Initial Values"));
  parameter Integer initOptionSplit=0 "Type of initialisation" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"));
  parameter Integer initOptionJunction=0 "Type of initialisation" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"));
  parameter Boolean useFluidModelsForSummary=false "True, if fluid models shall be used for the summary" annotation(Dialog(tab="Summary"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  replaceable model Compressor = TransiEnt.Components.Gas.Compressor.CompressorRealGasIsothermal_L1_simple constrainedby TransiEnt.Components.Gas.Compressor.Base.PartialCompressorRealGas_L1_simple                   "Compressor model, change eta_is for normal compressor" annotation(Dialog(group="Compressor"), choicesAllMatching);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  model ValveRecord
    extends TransiEnt.Basics.Icons.Record;
    parameter Boolean useFluidModelsForSummary=true "True, if fluid models shall be used for the summary";

    input SI.MassFlowRate m_flow if useFluidModelsForSummary
                                                "Mass flow rate";
    input SI.PressureDifference Delta_p if useFluidModelsForSummary
                                                       "Pressure difference";
  end ValveRecord;

  model CompressorRecord
    extends TransiEnt.Basics.Icons.Record;
    input SI.MassFlowRate m_flow "Mass flow rate";
    input SI.VolumeFlowRate V_flow "Volume flow rate";
    input SI.Power P_hyd "Hydraulic power";
    input SI.Power P_shaft "Shaft power";
    input SI.Power P_el "Electric power";
    input Real Pi "Pressure ratio";
    input SI.PressureDifference Delta_p "Pressure difference";
    input Real eta "Isentropic efficiency";
  end CompressorRecord;

  inner model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    CompressorRecord compressor;
    ValveRecord valve;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

public
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(rotation=0, extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(rotation=0, extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flowDesired  "Desired mass flow rate"
                        annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={0,100})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2 junction(
    medium=medium,
    volume=volumeJunction,
    initOption=initOptionJunction,
    p_start=p_startJunction,
    h_start=h_startJunction,
    xi_start=xi_startJunction,
    T_start=T_startJunction) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2 split(
    medium=medium,
    volume=volumeSplit,
    initOption=initOptionSplit,
    p_start=p_startSplit,
    h_start=h_startSplit,
    xi_start=xi_startSplit,
    T_start=T_startSplit) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Controller.ControllerValveAndCompressor_mflow controllerValveOrCompressor(p_before_low=p_before_low, p_before_high=p_before_high)
                                                                            annotation (Placement(transformation(extent={{-22,30},{-2,50}})));
public
  Compressor compressor(
    final presetVariableType="m_flow",
    final m_flowInput=true,
    final medium=medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  TransiEnt.Components.Gas.VolumesValvesFittings.Valves.ValveDesiredMassFlow valve(
    hysteresisWithDelta_p=false,
    useFluidModelsForSummary=useFluidModelsForSummary,
    medium=medium,
    p_low=-100000,
    p_high=0) annotation (Placement(transformation(extent={{-10,-36},{10,-24}})));
  TransiEnt.Components.Sensors.RealGas.PressureSensor pressureSensorAfter(medium=medium) annotation (Placement(transformation(extent={{50,0},{70,20}})));
  TransiEnt.Components.Sensors.RealGas.PressureSensor pressureSensoreBefore(medium=medium) annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
public
  inner Summary summary(
    gasPortIn(
      mediumModel=medium,
      xi=split.summary.gasPort1.xi,
      x=split.summary.gasPort1.x,
      m_flow=split.summary.gasPort1.m_flow,
      T=split.summary.gasPort1.T,
      p=split.summary.gasPort1.p,
      h=split.summary.gasPort1.h,
      rho=split.summary.gasPort1.rho),
    gasPortOut(
      mediumModel=medium,
      xi=junction.summary.gasPort3.xi,
      x=junction.summary.gasPort3.x,
      m_flow=junction.summary.gasPort3.m_flow,
      T=junction.summary.gasPort3.T,
      p=junction.summary.gasPort3.p,
      h=junction.summary.gasPort3.h,
      rho=junction.summary.gasPort3.rho),
    compressor(
      m_flow=compressor.summary.gasPortIn.m_flow,
      V_flow=compressor.summary.outline.V_flow,
      P_hyd=compressor.summary.outline.P_hyd,
      P_shaft=compressor.summary.outline.P_shaft,
      P_el=compressor.summary.outline.P_el,
      Pi=compressor.summary.outline.Pi,
      Delta_p=compressor.summary.outline.Delta_p,
      eta=compressor.summary.outline.eta),
    valve(
      useFluidModelsForSummary=useFluidModelsForSummary,
      m_flow=valve.summary.gasPortIn.m_flow,
      Delta_p=valve.gasPortIn.p - gasPortOut.p),
    costs(
      costs=compressor.summary.costs.costs,
      investCosts=compressor.summary.costs.investCosts,
      demandCosts=compressor.summary.costs.demandCosts,
      oMCosts=compressor.summary.costs.oMCosts,
      otherCosts=compressor.summary.costs.otherCosts,
      revenues=compressor.summary.costs.revenues)) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));


equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  connect(compressor.gasPortOut, junction.gasPort1) annotation (Line(
      points={{10,0},{10,0},{20,0}},
      color={255,255,0},
      thickness=1.5));
  connect(junction.gasPort2, valve.gasPortOut) annotation (Line(
      points={{30,-10},{30,-30.8571},{10,-30.8571}},
      color={255,255,0},
      thickness=1.5));
  connect(valve.gasPortIn, split.gasPort2) annotation (Line(
      points={{-10,-30.8571},{-30,-30.8571},{-30,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(split.gasPort3, compressor.gasPortIn) annotation (Line(
      points={{-20,0},{-20,0},{-10,0}},
      color={255,255,0},
      thickness=1.5));
  connect(junction.gasPort3, pressureSensorAfter.gasPortIn) annotation (Line(
      points={{40,0},{50,0}},
      color={255,255,0},
      thickness=1.5));
  connect(controllerValveOrCompressor.p_after, pressureSensorAfter.p) annotation (Line(points={{-2,40},{71,40},{71,10}}, color={0,0,127}));
  connect(split.gasPort1, pressureSensoreBefore.gasPortOut) annotation (Line(
      points={{-40,0},{-48,0},{-48,-4.44089e-016},{-50,0}},
      color={255,255,0},
      thickness=1.5));
  connect(controllerValveOrCompressor.m_flowCompressor, compressor.m_flow_in) annotation (Line(points={{-8,29},{-8,20},{-8,11}}, color={0,0,127}));
  connect(controllerValveOrCompressor.m_flowValve, valve.m_flowDes) annotation (Line(points={{-16,29},{-16,-25.7143},{-10,-25.7143}},
                                                                                                                            color={0,0,127}));
  connect(m_flowDesired, controllerValveOrCompressor.m_flowDesired) annotation (Line(points={{0,100},{0,100},{0,88},{0,70},{-12,70},{-12,50}},        color={0,0,127}));
  connect(gasPortOut, pressureSensorAfter.gasPortOut) annotation (Line(points={{100,0},{70,0}}, color={255,255,0}));
  connect(gasPortIn, pressureSensoreBefore.gasPortIn) annotation (Line(points={{-100,0},{-100,0},{-70,0}}, color={255,255,0}));
  connect(pressureSensoreBefore.p, controllerValveOrCompressor.p_before) annotation (Line(points={{-49,10},{-50,10},{-50,16},{-50,40},{-22,40}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(extent={{-100,-100},{100,100}})), Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Ellipse(extent={{-40,80},{40,0}}, lineColor={0,0,0}),
        Line(points={{-40,-20},{-40,-60},{40,-20},{40,-60},{-40,-20}}, color={0,0,0}),
        Line(points={{-30,66},{40,46}}, color={0,0,0}),
        Line(points={{-30,14},{40,34}}, color={0,0,0}),
        Line(
          points={{-40,40},{-70,40},{-70,0},{-100,0},{-70,0},{-70,-40},{-40,-40}},
          color={255,255,0},
          thickness=0.5),
        Line(
          points={{40,40},{70,40},{70,0},{100,0},{70,0},{70,-40},{40,-40}},
          color={255,255,0},
          thickness=0.5)}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model combines a valve with a compressor delivering a certain mass flow rate. Depending on the sign of the pressure difference the compressor or the valve is used. The type of compressor can be chosen.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>When the pressure difference changes sign, the change of the device is executed without any time delay or time dependent behaviour. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for negligible time delays and time dependencies in turn-on and shut-down behaviour of the components. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: real gas inlet </p>
<p>gasPortOut: real gas outlet </p>
<p>m_flowDesired: input for desired mass flow rate in [kg/s]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Chattering can occur if the pressure difference is around zero.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Feb 10 2017</p>
<p>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (fixed for update to ClaRa 1.3.0)</p>
</html>"));
end ValveAndCompressor_mflow;
