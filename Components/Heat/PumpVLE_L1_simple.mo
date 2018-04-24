within TransiEnt.Components.Heat;
model PumpVLE_L1_simple "A pump for VLE mixtures with a volume flow rate depending on drive power and pressure difference only"
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

//copied from ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple, version 1.3.0
//added cost record and eta_el
//modified summary

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Components.Heat.Base.Pump_Base;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter TransiEnt.Basics.Types.TypeOfResource typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer "Type of energy resource for global model statistics";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real eta_mech = 0.98 "Mechanic efficiency of the drive"
   annotation (Dialog(group="Fundamental Definitions"));
  parameter Real eta_el = 0.97 "Electric efficiency of the drive"
   annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure Delta_p_eps=100 "|Expert Settings| Numerical Robustnes|Small pressure difference for linearisation around zero";

  parameter ClaRa.Components.TurboMachines.Compressors.Fundamentals.PresetVariableType presetVariableType="V_flow" "Specifies which variable is preset"
                                                                                            annotation (Dialog(group="General Settings"));

  parameter Boolean use_P_elInput=false "= true, if P_el defined by input"
    annotation(Dialog(enable=(presetVariableType=="P_shaft"), group="Electrical power"));

  parameter SI.Power    P_el_fixed = 5e3 "Fixed value for electrical power"
    annotation(Dialog(enable=(not use_P_elInput and presetVariableType=="P_shaft"),group="Electrical power"));

   parameter Boolean use_Delta_p_input=false "= true, if Delta_p defined by input"
    annotation(Dialog(enable=(presetVariableType=="dp"), group="Pressure Increase"));
  parameter SI.Pressure    Delta_p_fixed = 0.1e5 "Fixed value for pressure increase"
    annotation(Dialog(enable=(not use_Delta_p_input and presetVariableType=="dp"),group="Pressure Increase"));

  parameter Boolean m_flowInput=false "= true, if m_flow defined by input"
    annotation(Dialog(enable=(presetVariableType=="m_flow"), group="Mass Flow Rate"));
  parameter SI.MassFlowRate    m_flow_fixed=0.5 "Fixed value for gas mass flow rate"
    annotation(Dialog(enable=(not m_flowInput and presetVariableType=="m_flow"),group="Mass Flow Rate"));

  parameter Boolean V_flowInput=false "= true, if V_flow defined by input"
    annotation(Dialog(enable=(presetVariableType=="V_flow"), group="Volume Flow Rate"));
  parameter SI.VolumeFlowRate    V_flow_fixed=0.5e-3 "Fixed value for gas volume flow rate"
    annotation(Dialog(enable=(not V_flowInput and presetVariableType=="V_flow"),group="Volume Flow Rate"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free "Specific demand-related cost per electric energy" annotation (Dialog(group="Demand-related Cost"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  replaceable model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "General Cost Model" annotation(Dialog(group="Statistics"),choicesAllMatching);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=0,
    powerOut=fluidPortIn.m_flow*(fluidIn.h - fluidOut.h),
    powerAux=(P_el - fluidPortIn.m_flow*(fluidOut.h - fluidIn.h))) if contributeToCycleSummary;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");
  Modelica.Blocks.Interfaces.RealInput dp_in if
    use_Delta_p_input "Prescribed pressure increase"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},  rotation=270,
        origin={80,110}),
                iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,110})));
  Modelica.Blocks.Interfaces.RealInput P_el_in if
     use_P_elInput "Prescribed pressure increase"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},  rotation=270,
        origin={34,110}),
                iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,110})));
  Modelica.Blocks.Interfaces.RealInput V_flow_in if V_flowInput "Prescribed volume flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},   rotation=270,
        origin={-32,110}),
               iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,110})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in if
                                                  m_flowInput "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
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
      P_shaft=P_el*eta_el,
      P_el=P_el,
      W_el=collectElectricPower.E,
      Pi=fluidPortOut.p/fluidPortIn.p,
      Delta_p=fluidPortOut.p - fluidPortIn.p,
      eta=eta_mech*eta_el),
    fluidPortIn(
      mediumModel=medium,
      xi=fluidIn.xi,
      x=fluidIn.x,
      m_flow=fluidPortIn.m_flow,
      T=fluidIn.T,
      p=fluidPortIn.p,
      h=fluidIn.h,
      rho=fluidIn.d),
    fluidPortOut(
      mediumModel=medium,
      xi=fluidOut.xi,
      x=fluidOut.x,
      m_flow=-fluidPortOut.m_flow,
      T=fluidOut.T,
      p=fluidPortOut.p,
      h=fluidOut.h,
      rho=fluidOut.d),
    costs(
      costs=collectCosts.costsCollector.Costs,
      investCosts=collectCosts.costsCollector.InvestCosts,
      demandCosts=collectCosts.costsCollector.DemandCosts,
      oMCosts=collectCosts.costsCollector.OMCosts,
      otherCosts=collectCosts.costsCollector.OtherCosts,
      revenues=collectCosts.costsCollector.Revenues)) annotation (Placement(transformation(extent={{-100,-114},{-80,-94}})));
protected
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=typeOfResource) annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    der_E_n=0,
    E_n=0,
    redeclare model CostRecordGeneral = CostSpecsGeneral,
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
    consumes_m_flow_CDE=false)
               annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  SI.Power    P_el "Electrical power";
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.VolumeFlowRate V_flow "Volume flow rate";
    input SI.Power P_hyd "Hydraulic power";
    input SI.Power P_shaft "Shaft power";
    input SI.Power P_el "Electric power";
    input SI.Work W_el "Electric work";
    input Real Pi "Pressure ratio";
    input SI.PressureDifference Delta_p "Pressure difference";
    input SI.Efficiency eta "Isentropic efficiency";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas fluidPortIn;
    TransiEnt.Basics.Records.FlangeRealGas fluidPortOut;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if presetVariableType == "dp" then
    if use_Delta_p_input then
      Delta_p = getInputs.dp_in;
    else
      Delta_p = Delta_p_fixed;
    end if;
  elseif presetVariableType == "m_flow" then
    if m_flowInput then
      fluidPortIn.m_flow = getInputs.m_flow_in;
    else
      fluidPortIn.m_flow = m_flow_fixed;
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

  P_hyd=P_el*eta_mech*eta_el;
  V_flow= P_hyd/(Delta_p+Delta_p_eps);
  fluidPortIn.m_flow = V_flow*fluidIn.d;
  fluidPortIn.h_outflow = inStream(fluidPortOut.h_outflow);
                                              // This is a dummy - flow reversal is not supported!
//____________________ Balance equations ___________________
  fluidPortIn.m_flow + fluidPortOut.m_flow = 0.0 "Mass balance";
  Delta_p=fluidPortOut.p - fluidPortIn.p
                           "Momentum balance";
//   inStream(inlet.h_outflow) + outlet.h_outflow + P_hyd/inlet.m_flow/eta_hyd = 0.0
//     "Energy balance";
  fluidPortOut.h_outflow = inStream(fluidPortIn.h_outflow) + P_el*eta_mech*eta_el/(fluidPortIn.m_flow + 1e-6) "Energy balance";

  //no chemical reactions
  fluidPortOut.xi_outflow = inStream(fluidPortIn.xi_outflow);
  fluidPortIn.xi_outflow = inStream(fluidPortOut.xi_outflow);

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
  annotation (Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This model represents a vle fluid pump. It is a modified version of the model ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple from ClaRa version 1.2.1. The model is documented there and here only the changes are described. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model was changed to work with changing compositions and a constant electrical efficiency was added. Also, more inputs are available. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>Only valid for real gases and positive pressure differences. Variable efficiencies and time-dependent behavior are not considered.</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>fluidPortIn: vle fluid inlet </p>
<p>fluidPortOut: vle fluid outlet </p>
<p>m_flow_in: input for mass flow rate </p>
<p>V_flow_in: input for volume flow rate </p>
<p>P_el_in: input for electrical power </p>
<p>dp_in: input for pressure difference </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>The electrical power is determined using the mechanical and electrical efficiencies.</p>
<p><br><img src=\"modelica://TransiEnt/Images/equations/equation_CompressorRealGasesIsentropicEff.png\" alt=\"\"/><br></p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Apr 2017<br> </p>
</html>"),Icon(graphics));
end PumpVLE_L1_simple;
