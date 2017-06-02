within TransiEnt.Components.Gas.Compressor;
model ValveAndCompressor_dp

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import SI = Modelica.SIunits;
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
  parameter SI.Volume volumeSplit = 0.01 "Volume of the split" annotation(Dialog(group="Split and Junction"));
  parameter SI.Volume volumeJunction = 0.01 "Volume of the junction" annotation(Dialog(group="Split and Junction"));

  parameter SI.Pressure p_startSplit = 1e5 "Start pressure in the split" annotation(Dialog(group="Initial Values"));
  parameter SI.Pressure p_startJunction = 1e5 "Start pressure in the junction" annotation(Dialog(group="Initial Values"));
  parameter SI.MassFraction xi_startSplit[medium.nc-1] = medium.xi_default "Start composition in the split" annotation(Dialog(group="Initial Values"));
  parameter SI.MassFraction xi_startJunction[medium.nc-1] = medium.xi_default "Start composition in the junction" annotation(Dialog(group="Initial Values"));
  parameter SI.SpecificEnthalpy h_startSplit = 800e3 "Start specific enthalpy in the split" annotation(Dialog(group="Initial Values"));
  parameter SI.SpecificEnthalpy h_startJunction = 800e3 "Start specific enthalpy in the Junction" annotation(Dialog(group="Initial Values"));
  parameter ClaRa.Basics.Choices.Init initTypeSplit=ClaRa.Basics.Choices.Init.noInit "Type of initialisation" annotation(Dialog(group="Initial Values", choicesAllMatching));
  parameter ClaRa.Basics.Choices.Init initTypeJunction=ClaRa.Basics.Choices.Init.noInit "Type of initialisation" annotation(Dialog(group="Initial Values", choicesAllMatching));

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
  record ValveRecord
    extends TransiEnt.Basics.Icons.Record;
    input SI.MassFlowRate m_flow "Mass flow rate";
    input SI.PressureDifference Delta_p "Pressure difference";
  end ValveRecord;

  record CompressorRecord
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
  Modelica.Blocks.Interfaces.RealInput dp_desired(
    final quantity="PressureDifference",
    final unit="Pa",
    displayUnit="bar") "Desired pressure difference" annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={0,100})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction(
    medium=medium,
    volume=volumeJunction,
    p_start=p_startJunction,
    xi_start=xi_startJunction,
    h_start=h_startJunction,
    initType=initTypeJunction) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 split(
    medium=medium,
    volume=volumeSplit,
    p_start=p_startSplit,
    xi_start=xi_startSplit,
    h_start=h_startSplit,
    initType=initTypeSplit) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Controller.ControllerValveAndCompressor_dp                                     controllerValveOrCompressor annotation (Placement(transformation(extent={{-10,32},{10,52}})));

  Compressor compressor(
    medium=medium,
    presetVariableType="dp",
    use_Delta_p_input=true) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  VolumesValvesFittings.ValveDesiredMassFlow                          valve(
    medium=medium)
              annotation (Placement(transformation(extent={{-10,-36},{10,-24}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensoreBefore(medium=medium) annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
public
  inner Summary  summary(gasPortIn(mediumModel=medium,xi=split.summary.gasPort1.xi,x=split.summary.gasPort1.x,m_flow=split.summary.gasPort1.m_flow,  T=split.summary.gasPort1.T, p=split.summary.gasPort1.p, h=split.summary.gasPort1.h, rho=split.summary.gasPort1.rho),
                         gasPortOut(mediumModel=medium,xi=junction.summary.gasPort3.xi,x=junction.summary.gasPort3.x,m_flow=junction.summary.gasPort3.m_flow,  T=junction.summary.gasPort3.T, p=junction.summary.gasPort3.p, h=junction.summary.gasPort3.h, rho=junction.summary.gasPort3.rho),
                         compressor(m_flow=compressor.summary.gasPortIn.m_flow,V_flow=compressor.summary.outline.V_flow,P_hyd=compressor.summary.outline.P_hyd,P_shaft=compressor.summary.outline.P_shaft,P_el=compressor.summary.outline.P_el,Pi=compressor.summary.outline.Pi,Delta_p=compressor.summary.outline.Delta_p,eta=compressor.summary.outline.eta),
                         valve(m_flow=valve.summary.gasPortIn.m_flow,Delta_p=valve.gasPortIn.p-gasPortOut.p),
                         costs(costs=compressor.summary.costs.costs,investCosts=compressor.summary.costs.investCosts,demandCosts=compressor.summary.costs.demandCosts,oMCosts=compressor.summary.costs.oMCosts,otherCosts=compressor.summary.costs.otherCosts,revenues=compressor.summary.costs.revenues))
  annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

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
      points={{30,-10},{30,-30},{10,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(valve.gasPortIn, split.gasPort2) annotation (Line(
      points={{-10,-30},{-30,-30},{-30,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(split.gasPort3, compressor.gasPortIn) annotation (Line(
      points={{-20,0},{-20,0},{-10,0}},
      color={255,255,0},
      thickness=1.5));
  connect(split.gasPort1, massFlowSensoreBefore.gasPortOut) annotation (Line(
      points={{-40,0},{-48,0},{-48,-4.44089e-016},{-50,0}},
      color={255,255,0},
      thickness=1.5));
  connect(junction.gasPort3, gasPortOut) annotation (Line(
      points={{40,0},{100,0},{100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(dp_desired, controllerValveOrCompressor.dp_desired) annotation (Line(points={{0,100},{0,100},{0,68},{0,52}},                   color={0,0,127}));
  connect(massFlowSensoreBefore.m_flow, controllerValveOrCompressor.m_flow) annotation (Line(points={{-49,10},{-38,10},{-38,42},{-10,42}}, color={0,0,127}));
  connect(controllerValveOrCompressor.dp_comp, compressor.dp_in) annotation (Line(points={{4,31},{8,31},{8,11}}, color={0,0,127}));
  connect(gasPortIn, massFlowSensoreBefore.gasPortIn) annotation (Line(
      points={{-100,0},{-86,0},{-70,0}},
      color={255,255,0},
      thickness=1.5));
  connect(controllerValveOrCompressor.m_flow_valve, valve.m_flowDes) annotation (Line(points={{-4,31},{-4,24},{-16,24},{-16,-24},{-10,-24}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
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
<p>This model combines a valve with a compressor delivering a certain pressure difference. Depending on the sign of the pressure difference the compressor or the valve is used. The type of compressor can be chosen.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>When the pressure difference changes sign, the change of the device is executed without any time delay or time dependent behaviour. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for negligible time delays and time dependencies in turn-on and shut-down behaviour of the components. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: real gas inlet </p>
<p>gasPortOut: real gas outlet </p>
<p>dp_desired: input for desired pressure difference </p>
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
<p><br>Modified by Lisa Andresen (andresen@tuhh.de) on Feb 16 2017 (changed output from m_flowDesired to dp_desired)</p>
</html>"));
end ValveAndCompressor_dp;
