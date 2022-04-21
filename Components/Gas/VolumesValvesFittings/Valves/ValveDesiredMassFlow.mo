within TransiEnt.Components.Gas.VolumesValvesFittings.Valves;
model ValveDesiredMassFlow "Simple valve with prescribed mass flow rate"



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

  import      Modelica.Units.SI;
  extends TransiEnt.Basics.Icons.Valve;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium used in the valve" annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);
  parameter Boolean checkValve=false "true: valve only works in design flow direction" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean hysteresisWithDelta_p=true "true: hysteresis uses pressure difference, false: hysteresis uses inlet pressure"
                                                                                                  annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.PressureDifference Delta_p_low=1e3 "Lower value for hysteresis with pressure difference" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.PressureDifference Delta_p_high=1e5 "Upper value for hyseteresis with pressure difference" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Pressure p_low=1e5 "Lower value for hysteresis with inlet pressure" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Pressure p_high=1.1e5 "Upper value for hyseteresis with inlet pressure" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean useLeakageMassFlow=false "Constant leakage gas mass flow of 'm_flow_small' to avoid zero mass flow"  annotation(Dialog(group="Numerical Stability"));
  parameter SI.MassFlowRate m_flow_small=simCenter.m_flow_small "leakage mass flow if useLeakageMassFlow=true" annotation(Dialog(group="Numerical Stability",enable=useLeakageMassFlow));
  parameter Boolean useFluidModelsForSummary=false "True, if fluid models shall be used for the summary" annotation(Dialog(tab="Summary"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flowDes "Desired mass flow" annotation (Placement(transformation(extent={{-120,40},{-80,80}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  //protected
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=if hysteresisWithDelta_p then Delta_p_low else p_low, uHigh=if hysteresisWithDelta_p then Delta_p_high else p_high) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    vleFluidType=medium,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    p=gasPortIn.p,
    h=noEvent(actualStream(gasPortIn.h_outflow)),
    xi=noEvent(actualStream(gasPortIn.xi_outflow)),
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    vleFluidType=medium,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    p=gasPortOut.p,
    h=noEvent(actualStream(gasPortOut.h_outflow)),
    xi=noEvent(actualStream(gasPortOut.xi_outflow)),
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{70,-12},{90,8}})));

public
  Summary summary(gasPortIn(
      mediumModel=medium,
      useFluidModelsForSummary=useFluidModelsForSummary,
      xi=noEvent(actualStream(gasPortIn.xi_outflow)),
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=noEvent(actualStream(gasPortIn.h_outflow)),
      rho=gasIn.d), gasPortOut(
      mediumModel=medium,
      useFluidModelsForSummary=useFluidModelsForSummary,
      xi=noEvent(actualStream(gasPortOut.xi_outflow)),
      x=gasOut.x,
      m_flow=gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=noEvent(actualStream(gasPortOut.h_outflow)),
      rho=gasOut.d)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Boolean valveOpen "true if the valve is open";

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
  end Summary;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  hysteresis.u = if hysteresisWithDelta_p then gasPortIn.p-gasPortOut.p else gasPortIn.p;
  valveOpen=hysteresis.y;
  if useLeakageMassFlow then
    gasPortIn.m_flow = if valveOpen then (if checkValve then max(max(m_flow_small,m_flowDes),0) else m_flowDes) else m_flow_small;
  else
    gasPortIn.m_flow = if valveOpen then (if checkValve then max(m_flowDes,0) else m_flowDes) else 0;
  end if;

//_______________Mass balance (no storage)__________________________
  gasPortIn.m_flow+gasPortOut.m_flow = 0;

//_________________Energy balance___________________________________
// Isenthalpic state transformation (no storage and no loss of energy)
  gasPortIn.h_outflow = inStream(gasPortOut.h_outflow);
  gasPortOut.h_outflow = inStream(gasPortIn.h_outflow);

//______________ No chemical reaction taking place:_________________
  gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);
  gasPortOut.xi_outflow = inStream(gasPortIn.xi_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (defaultComponentName="valve_mFlow",
  Icon(graphics,
       coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,80}},
        initialScale=0.1)),
    Diagram(graphics,
            coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,80}},
        initialScale=0.1)),
                     Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a simple valve for real gases which ensures a given mass flow. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This model works like an ideally controlled valve to ensure a given mass flow. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>This model is only valid for real gases.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: Inlet of the real gas </p>
<p>gasPortOut: Outlet of the real gas </p>
<p>m_flowDes: Input for the desired mass flow in kg/s</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Make sure that there is always a negative pressure gradient in the direction of the mass flow to ensure a physically possible use of the valve.</p>
<p>Via parameter &apos;useLeakageMassFlow&apos; a small mass flow of &apos;m_flow_small&apos; is always flowing through valve (to avoid Zero-Mass-Flow problems)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Apr 2016</p>
<p>Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Nov 2018: added useLeakageMassFlow</p>
<p>Model modified by Carsten Bode (c.bode@tuhh.de) in Dec 2020: added checkValve option</p>
</html>"));
end ValveDesiredMassFlow;
