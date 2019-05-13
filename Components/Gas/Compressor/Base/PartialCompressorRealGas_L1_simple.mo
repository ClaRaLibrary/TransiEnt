within TransiEnt.Components.Gas.Compressor.Base;
partial model PartialCompressorRealGas_L1_simple "Partial compressor model for real gases with constant efficiency"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  import SI = Modelica.SIunits;
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Boolean allow_reverseFlow = false;
  final parameter TransiEnt.Basics.Types.TypeOfResource typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer "Type of energy resource for global model statistics";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation" annotation(Dialog(tab="Summary and Visualisation"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 annotation (Dialog(group="Fundamental Definitions"));

  parameter SI.Efficiency eta_mech = 0.95 "Mechanical efficiency" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Efficiency eta_el = 0.97 "Electrical efficiency" annotation (Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Components.TurboMachines.Compressors.Fundamentals.PresetVariableType presetVariableType="V_flow" "Specifies which variable is preset"
                                                                                            annotation (Dialog(group="Fundamental Definitions"));

  parameter Boolean use_P_elInput=false "= true, if P_el defined by input" annotation(Dialog(enable=(presetVariableType=="P_shaft"), group="Electrical power"));
  parameter SI.Power P_el_fixed = 5e3 "Fixed value for electrical power" annotation(Dialog(enable=(not use_P_elInput and presetVariableType=="P_shaft"),group="Electrical power"));
  parameter Boolean use_Delta_p_input=false "= true, if Delta_p defined by input" annotation(Dialog(enable=(presetVariableType=="dp"), group="Pressure Increase"));
  parameter SI.Pressure Delta_p_fixed = 0.1e5 "Fixed value for pressure increase" annotation(Dialog(enable=(not use_Delta_p_input and presetVariableType=="dp"),group="Pressure Increase"));
  parameter Boolean m_flowInput=false "= true, if m_flow defined by input" annotation(Dialog(enable=(presetVariableType=="m_flow"), group="Mass Flow Rate"));
  parameter SI.MassFlowRate m_flow_fixed=0.5 "Fixed value for gas mass flow rate" annotation(Dialog(enable=(not m_flowInput and presetVariableType=="m_flow"),group="Mass Flow Rate"));
  parameter Boolean V_flowInput=false "= true, if V_flow defined by input" annotation(Dialog(enable=(presetVariableType=="V_flow"), group="Volume Flow Rate"));
  parameter SI.VolumeFlowRate V_flow_fixed=0.5e-3 "Fixed value for gas volume flow rate" annotation(Dialog(enable=(not V_flowInput and presetVariableType=="V_flow"),group="Volume Flow Rate"));

  parameter Boolean integrateElPower=simCenter.integrateElPower "true if electric powers shall be integrated" annotation (Dialog(group="Statistics"));
  parameter Boolean calculateCost=simCenter.calculateCost "true if cost shall be calculated"  annotation (Dialog(group="Statistics"));
  parameter SI.Power P_el_n = 1e3 "Nominal power for cost calculation" annotation(Dialog(group="Statistics"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free "Specific demand-related cost per electric energy" annotation (Dialog(group="Statistics"));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  Real hOut;
  SI.Pressure Delta_p(final start=100) "pressure increase" annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Power P_hyd "Hydraulic power";
  SI.Power P_shaft "Drive power";
  SI.Power P_el "Electrical power";
  SI.VolumeFlowRate V_flow;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  replaceable model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "General Cost Record" annotation(Dialog(group="Statistics"),choicesAllMatching);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut=-P_hyd,
    powerAux=-P_hyd + P_el) if contributeToCycleSummary;
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium, m_flow(min=if allow_reverseFlow then -Modelica.Constants.inf else 1e-5)) "inlet flow" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium, m_flow(max=if allow_reverseFlow then Modelica.Constants.inf else -1e-5)) "outlet flow" annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.General.PressureDifferenceIn dp_in if  use_Delta_p_input "Prescribed pressure increase" annotation (Placement(transformation(extent={{-10,-10},{10,10}},  rotation=270,
        origin={80,110}),
                iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,110})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_in if use_P_elInput "Prescribed electric power" annotation (Placement(transformation(extent={{-10,-10},{10,10}},  rotation=270,
        origin={34,110}),
                iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,110})));
  TransiEnt.Basics.Interfaces.General.VolumeFlowRateIn V_flow_in if  V_flowInput "Prescribed volume flow rate" annotation (Placement(transformation(extent={{-10,-10},{10,10}},   rotation=270,
        origin={-32,110}),
               iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,110})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_in if m_flowInput "Prescribed mass flow rate" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=270,
        origin={-80,110}),
                       iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,110})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.VLEFluid_ph gasIn(
    p=gasPortIn.p,
    h=inStream(gasPortIn.h_outflow),
    xi=inStream(gasPortIn.xi_outflow),
    vleFluidType=medium,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-90,-12},{-70,8}})));
  TILMedia.VLEFluid_ph gasOut(
    h=hOut,
    p=gasPortOut.p,
    xi=gasIn.xi,
    vleFluidType=medium,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{70,-12},{90,8}})));
  ClaRa.Components.TurboMachines.Compressors.Fundamentals.GetInputsHydraulic getInputs annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,40})));
  Modelica.Blocks.Sources.Constant Delta_p_in_(k=0) if not use_Delta_p_input;
  Modelica.Blocks.Sources.Constant m_flow_in_(k=0) if not m_flowInput;
  Modelica.Blocks.Sources.Constant V_flow_in_(k=0) if not V_flowInput;
  Modelica.Blocks.Sources.Constant P_el_in_(k=0) if not use_P_elInput;
public
  inner Summary summary(
    outline(
      V_flow=V_flow,
      P_hyd=P_hyd,
      P_shaft=P_shaft,
      P_el=P_el,
      W_el=collectElectricPower.E,
      Pi=gasPortOut.p/gasPortIn.p,
      Delta_p=gasPortOut.p - gasPortIn.p,
      eta=eta_mech*eta_el),
    gasPortIn(
      mediumModel=medium,
      xi=gasIn.xi,
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=gasIn.h,
      rho=gasIn.d),
    gasPortOut(
      mediumModel=medium,
      xi=gasOut.xi,
      x=gasOut.x,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=gasOut.h,
      rho=gasOut.d),
    costs(
      costs=collectCosts.costsCollector.Costs,
      investCosts=collectCosts.costsCollector.InvestCosts,
      demandCosts=collectCosts.costsCollector.DemandCosts,
      oMCosts=collectCosts.costsCollector.OMCosts,
      otherCosts=collectCosts.costsCollector.OtherCosts,
      revenues=collectCosts.costsCollector.Revenues)) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

protected
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=typeOfResource, integrateElPower=integrateElPower)
                                                                                                                                      annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    der_E_n=P_el_n,
    redeclare model CostRecordGeneral = CostSpecsGeneral,
    E_n=0,
    Cspec_demAndRev_el=Cspec_demAndRev_el,
    P_el=P_el,
    produces_P_el=false,
    produces_Q_flow=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    consumes_H_flow=false,
    produces_other_flow=false,
    consumes_other_flow=false,
    produces_m_flow_CDE=false,
    consumes_m_flow_CDE=false,
    calculateCost=calculateCost)
               annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));


protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.VolumeFlowRate V_flow "Volume flow rate";
    input SI.Power P_hyd "Hydraulic power";
    input SI.Power P_shaft "Shaft power";
    input SI.Power P_el "Electric power";
    input SI.Work W_el "Electric work";
    input Real Pi "Pressure ratio";
    input SI.PressureDifference Delta_p "Pressure difference";
    input Real eta "Isentropic efficiency";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;



equation
  //____________________ Boundary equations _________________

  if presetVariableType == "dp" then
    if use_Delta_p_input then
      Delta_p = getInputs.dp_in;
    else
      Delta_p = Delta_p_fixed;
    end if;
  elseif presetVariableType == "m_flow" then
    if m_flowInput then
      gasPortIn.m_flow = getInputs.m_flow_in;
    else
      gasPortIn.m_flow = m_flow_fixed;
    end if;
  elseif presetVariableType == "V_flow" then
    if V_flowInput then
      V_flow = getInputs.V_flow_in;
    else
      V_flow = V_flow_fixed;
    end if;
  else
    if use_P_elInput then
      P_el = getInputs.P_shaft_in;
    else
      P_el = P_el_fixed;
    end if;
  end if;

  Delta_p =gasPortOut.p - gasPortIn.p;
  V_flow =gasPortIn.m_flow/gasIn.d;

  gasPortIn.m_flow + gasPortOut.m_flow = 0.0;
  gasPortOut.xi_outflow = inStream(gasPortIn.xi_outflow);
  gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);
  gasPortOut.h_outflow = gasOut.h;
  gasPortIn.h_outflow = actualStream(gasPortOut.h_outflow);
  P_hyd/eta_mech = P_shaft;
  P_shaft/eta_el = P_el;

  //collectors
  collectElectricPower.powerCollector.P=P_el;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.powerCollector[typeOfResource],collectElectricPower.powerCollector);
  connect(modelStatistics.costsCollector,collectCosts.costsCollector);
  connect(Delta_p_in_.y, getInputs.dp_in);
  connect(V_flow_in_.y, getInputs.V_flow_in);
  connect(m_flow_in_.y, getInputs.m_flow_in);
  connect(P_el_in_.y, getInputs.P_shaft_in);
  connect(m_flow_in, getInputs.m_flow_in) annotation (Line(
      points={{-80,110},{-80,76},{-8,76},{-8,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(V_flow_in, getInputs.V_flow_in) annotation (Line(
      points={{-32,110},{-32,88},{-2,88},{-2,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_el_in, getInputs.P_shaft_in) annotation (Line(
      points={{34,110},{34,88},{2,88},{2,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp_in, getInputs.dp_in) annotation (Line(
      points={{80,110},{80,76},{8,76},{8,52}},
      color={0,0,127},
      smooth=Smooth.None));

                                                annotation (
              Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                      graphics={
        Ellipse(
          extent={{100,-100},{-100,100}},
          lineColor={215,215,215},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-92,92},{92,-92}},
          lineColor={215,215,215},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,94},{-2,94}},
          lineColor={0,134,171},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,92},{90,22},{92,32},{12,92},{-2,92}},
          lineColor={0,134,171},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,-92},{12,-92},{88,-34},{94,-20},{-2,-92}},
          lineColor={0,134,171},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a partial model for real gas compressors. It is a modified version of the model ClaRa.Components.TurboMachines.Compressors.CompressorGas_L1_simple from ClaRa version 1.2.1. The model is documented there and here only the changes are described. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model was changed to work with real gases and mechanical and electrical efficiencies were added. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for real gases and positive pressure differences. Variable efficiencies and time-dependent behavior are not considered.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: real gas inlet </p>
<p>gasPortOut: real gas outlet </p>
<p>m_flow_in: input for mass flow rate in kg/s</p>
<p>V_flow_in: input for volume flow rate in m3/s</p>
<p>P_el_in: input for electrical power in W</p>
<p>dp_in: input for pressure difference in Pa</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>Delta_p&nbsp;&quot;pressure&nbsp;increase&quot;</p>
<p>P_hyd&nbsp;&quot;Hydraulic&nbsp;power&quot;</p>
<p>P_shaft&nbsp;&quot;Drive&nbsp;power&quot;</p>
<p>P_el&nbsp;&quot;Electrical&nbsp;power&quot;</p>
<p>V_flow &quot;Volume flow rate&quot;</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Sep 20 2016</p>
</html>"));
end PartialCompressorRealGas_L1_simple;
