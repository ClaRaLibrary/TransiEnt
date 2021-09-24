within TransiEnt.Components.Gas.VolumesValvesFittings.Valves;
model ValveRealGas_L1 "Valve for real gas models without phase change with replaceable flow models"


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




  // Modified component of the ClaRa library, version: 1.3.0
  // path: ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1
  // Adapted to real gas ports and media (renamed ports and fluid objects)

//  extends ClaRa.Basics.Icons.Valve;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L1");
  extends TransiEnt.Basics.Icons.Valve;

  import SI = ClaRa.Basics.Units;
protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    parameter Boolean showExpertSummary;
    input SI.VolumeFlowRate V_flow "Volume flow rate";
    input SI.PressureDifference Delta_p "Pressure difference p_out - p_in";
    input Real PR if  showExpertSummary "Pressure ratio, always <1, i.e. dependent on flow direction";
    input Real PR_choked if   showExpertSummary "Critical pressure ratio";
    input Real opening_ "Valve opening in p.u.";
    input Real flowIsChoked "1 if flow is choked, 0 if not";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
  end Summary;
public
  inner parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the component"
    annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model PressureLoss =ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible
    constrainedby ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss "Pressure loss model at the tubes side"
                                            annotation (Dialog(group=
          "Fundamental Definitions"), choicesAllMatching);
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
    annotation (Dialog(group="Fundamental Definitions"));

  parameter Boolean openingInputIsActive=false "True, if  a variable opening is used"
    annotation (Dialog(group="Control Signals"));
  parameter Real opening_const_=1 "A constant opening: =1: open, =0: closed"
    annotation (Dialog(group="Control Signals", enable=not openingInputIsActive));

  inner parameter Boolean checkValve=false "True, if valve is check valve"
    annotation (Evaluate=true, Dialog(group="Fundamental Definitions"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Boolean useStabilisedMassFlow=false "|Expert Settings|Numerical Robustness|";
  input SI.Time Tau= 0.1 "Time Constant of Stabilisation" annotation(Dialog(tab="Expert Settings", group = "Numerical Robustness", enable=useStabilisedMassFlow));

  input Real opening_leak_ = 0 "Leakage valve opening in p.u." annotation(Dialog(tab="Expert Settings", group = "Numerical Robustness"));
  outer TransiEnt.SimCenter simCenter;

protected
  Real opening_ "Valve opening in p.u.";

  SI.MassFlowRate m_flow_ "stabilised mass flow rate";

public
  Modelica.Blocks.Interfaces.RealInput opening_in=opening_ if (openingInputIsActive) "=1: completely open, =0: completely closed"
                                                 annotation (Placement(
        transformation(
        origin={0,80},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,90}))); //

  Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    p=gasPortOut.p,
    vleFluidType=medium,
    h=if (checkValve == true and opening_leak_ <= 0) or opening_ < opening_leak_ then gasPortOut.h_outflow else noEvent(actualStream(gasPortOut.h_outflow)),
    xi=if (checkValve == true and opening_leak_ <= 0) or opening_ < opening_leak_ then gasPortOut.xi_outflow else noEvent(actualStream(gasPortOut.xi_outflow)),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{70,-10},{90,10}})));
protected
  PressureLoss pressureLoss
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    vleFluidType=medium,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    p=gasPortIn.p,
    h=if (checkValve == true and opening_leak_ <= 0) or opening_ < opening_leak_ then inStream(gasPortIn.h_outflow) else noEvent(actualStream(gasPortIn.h_outflow)),
    xi=if (checkValve == true and opening_leak_ <= 0) or opening_ < opening_leak_ then inStream(gasPortIn.xi_outflow) else noEvent(actualStream(gasPortIn.xi_outflow)),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
public
  Summary summary(
    outline(
      showExpertSummary=showExpertSummary,
      V_flow=gasPortIn.m_flow/iCom.rho_in,
            Delta_p = pressureLoss.Delta_p,
            PR = noEvent(min(gasPortOut.p,gasPortIn.p)/max(gasPortIn.p,gasPortOut.p)),
            PR_choked = pressureLoss.PR_choked,
            flowIsChoked= pressureLoss.flowIsChoked,
            opening_= iCom.opening_),
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
      m_flow=gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=gasOut.h,
      rho=gasOut.d)) annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

protected
  inner ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.ICom iCom(
    p_in=gasPortIn.p,
    p_out=gasPortOut.p,
    opening_leak_=opening_leak_,
    rho_in(start=1) = if (checkValve == true and opening_leak_ <= 0) or opening_ < opening_leak_ then gasIn.d else (if useHomotopy then homotopy(ClaRa.Basics.Functions.Stepsmoother(
      10,
      -10,
      pressureLoss.Delta_p)*gasIn.d + ClaRa.Basics.Functions.Stepsmoother(
      -10,
      10,
      pressureLoss.Delta_p)*gasOut.d, gasIn.d) else ClaRa.Basics.Functions.Stepsmoother(
      10,
      -10,
      pressureLoss.Delta_p)*gasIn.d + ClaRa.Basics.Functions.Stepsmoother(
      -10,
      10,
      pressureLoss.Delta_p)*gasOut.d),
    gamma_in=gasIn.gamma,
    gamma_out=gasOut.gamma,
    opening_=opening_,
    h_in=gasIn.h,
    p_crit=gasIn.crit.p,
    p_vap_in=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidObjectFunctions.bubblePressure_Txi(max(gasIn.T,gasOut.T),gasIn.xi, gasIn.vleFluidPointer)) "if (checkValve == true and opening_leak_<=0) or opening_<opening_leak_ then gasIn.d else (if useHomotopy then homotopy(ClaRa.Basics.Functions.Stepsmoother(1e-5, -1e-5, gasPortIn.m_flow)*fluidIn.d + ClaRa.Basics.Functions.Stepsmoother(-1e-5, 1e-5, gasPortIn.m_flow)*gasOut.d, gasIn.d) else ClaRa.Basics.Functions.Stepsmoother(1e-5, -1e-5, gasPortIn.m_flow)*gasIn.d + ClaRa.Basics.Functions.Stepsmoother(-1e-5, 1e-5, gasPortIn.m_flow)*gasOut.d)" annotation (Placement(transformation(extent={{-60,-52},{-40,-32}})));
public
  ClaRa.Basics.Interfaces.EyeOut eye if showData annotation (Placement(transformation(extent={{90,-68},{110,-48}}), iconTransformation(extent={{90,-50},{110,-30}})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1] annotation (Placement(transformation(extent={{45,-59},{47,-57}})));

equation
  if (not openingInputIsActive) then
    opening_ = noEvent(min(1,max(opening_leak_,opening_const_)));

  end if;

  if useStabilisedMassFlow then
    der(m_flow_)= (pressureLoss.m_flow - m_flow_)/Tau;
  else
     m_flow_= pressureLoss.m_flow;
  end if;

//_________________Energy balance___________________________________
// Isenthalpic state transformation (no storage and no loss of energy)
  gasPortIn.h_outflow = inStream(gasPortOut.h_outflow);
  gasPortOut.h_outflow = inStream(gasPortIn.h_outflow);

//_______________Mass balance (no storage)__________________________
  gasPortIn.m_flow + gasPortOut.m_flow = 0;
  //inlet.m_flow = pressureLoss.m_flow;
  gasPortIn.m_flow = m_flow_;

//______________ No chemical reaction taking place:_________________
  gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);
  gasPortOut.xi_outflow = inStream(gasPortIn.xi_outflow);

//______________Eye port variable definition________________________
  eye_int[1].m_flow =-gasPortOut.m_flow;
  eye_int[1].T =gasOut.T - 273.15;
  eye_int[1].s =gasOut.s/1e3;
  eye_int[1].p =gasPortOut.p/1e5;
  eye_int[1].h =gasOut.h/1e3;

  connect(eye,eye_int[1])  annotation (Line(
      points={{100,-58},{46,-58}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

initial equation
  if useStabilisedMassFlow then
    m_flow_=pressureLoss.m_flow;
  end if;

  annotation (defaultComponentName="valve",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,80}},
        initialScale=0.1),
                     graphics={
        Line(
          points={{-100,46},{98,-46}},
          color={150,25,48},
          smooth=Smooth.None,
          thickness=0.5, visible=checkValve),
        Ellipse(
          extent={{-104,52},{-92,40}},
          lineColor={150,25,48},
          lineThickness=0.5,
          fillColor={150,25,48},
          fillPattern=FillPattern.Solid, visible=checkValve)}),
    Diagram(graphics,
            coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,80}},
        initialScale=0.1)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a valve for real gases. It is a modified version of the model ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 from ClaRa version 1.2.1. The model is documented there and here only the changes are described. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The two-phase region is deactivated. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for real gases without phase change.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasportIn: inlet for real gas</p>
<p>gasportOut: outlet for real gas</p>
<p>opening:in: realinput</p>
<p>eye</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Apr 2016</p>
<p>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (updated to ClaRa 1.3.0)</p>
</html>"));
end ValveRealGas_L1;
