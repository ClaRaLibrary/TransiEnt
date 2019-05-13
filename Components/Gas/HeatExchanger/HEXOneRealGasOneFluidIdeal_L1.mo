within TransiEnt.Components.Gas.HeatExchanger;
model HEXOneRealGasOneFluidIdeal_L1 "Ideal heat exchanger for one real gas and one fluid with fixed temperature at one end"

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
  //import Modelica.Constants.eps;
  extends TransiEnt.Basics.Icons.Heat_Exchanger;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumRealGas=simCenter.gasModel1 "Real gas medium" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumFluid=simCenter.fluid1 "Fluid medium" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter SI.PressureDifference Delta_p_realGas=0 "Pressure loss in real gas" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.PressureDifference Delta_p_fluid=0 "Pressure loss in fluid" annotation(Dialog(group="Fundamental Definitions"));

  parameter Boolean fixedTemperatureRealGas=true "true if the real gas temperature is fixed" annotation(Dialog(group="Heat Transfer"));
  parameter SI.Temperature T_out_fixed=293.15 "Fixed temperature of one of the mediums at its outlet" annotation(Dialog(group="Heat Transfer"));

  parameter Real eps=1e-10 "Small number under which equations change due to small mass flows" annotation(Dialog(group="Numerics"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=mediumRealGas) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=mediumRealGas) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=mediumFluid) annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=mediumFluid) annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
protected
  TILMedia.VLEFluid_ph gasOut(
    vleFluidType=mediumRealGas,
    p=gasPortOut.p,
    h=actualStream(gasPortOut.h_outflow),
    xi=actualStream(gasPortOut.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{60,-12},{80,8}})));
  TILMedia.VLEFluid_ph gasIn(
    vleFluidType=mediumRealGas,
    p=gasPortIn.p,
    h=actualStream(gasPortIn.h_outflow),
    xi=actualStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));
  TILMedia.VLEFluid_ph fluidIn(
    vleFluidType=mediumFluid,
    p=fluidPortIn.p,
    h=actualStream(fluidPortIn.h_outflow),
    xi=actualStream(fluidPortIn.xi_outflow)) annotation (Placement(transformation(extent={{-10,-82},{10,-62}})));
  TILMedia.VLEFluid_ph fluidOut(
    vleFluidType=mediumFluid,
    p=fluidPortOut.p,
    h=actualStream(fluidPortOut.h_outflow),
    xi=actualStream(fluidPortOut.xi_outflow)) annotation (Placement(transformation(extent={{-10,58},{10,78}})));
public
  inner Summary summary(
    outline(
      Q_flow=Q_flow),
    gasPortIn(
      mediumModel=mediumRealGas,
      xi=gasIn.xi,
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=gasIn.h,
      rho=gasIn.d),
    gasPortOut(
      mediumModel=mediumRealGas,
      xi=gasOut.xi,
      x=gasOut.x,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=gasOut.h,
      rho=gasOut.d),
    fluidPortIn(
      mediumModel=mediumFluid,
      xi=fluidIn.xi,
      x=fluidIn.x,
      m_flow=fluidPortIn.m_flow,
      T=fluidIn.T,
      p=fluidPortIn.p,
      h=fluidIn.h,
      rho=fluidIn.d),
    fluidPortOut(
      mediumModel=mediumFluid,
      xi=fluidOut.xi,
      x=fluidOut.x,
      m_flow=-fluidPortOut.m_flow,
      T=fluidOut.T,
      p=fluidPortOut.p,
      h=fluidOut.h,
      rho=fluidOut.d)) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  SI.HeatFlowRate Q_flow "Heat flow from medium2 to medium1";

  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.HeatFlowRate Q_flow "Transfered heat flow";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.FlangeRealGas fluidPortIn;
    TransiEnt.Basics.Records.FlangeRealGas fluidPortOut;
  end Summary;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if fixedTemperatureRealGas then
    gasOut.T=T_out_fixed;
  else
    fluidOut.T=T_out_fixed;
  end if;

  //mass balances
  gasPortIn.m_flow + gasPortOut.m_flow = 0;
  fluidPortIn.m_flow + fluidPortOut.m_flow = 0;

  //pressure
  gasPortIn.p = gasPortOut.p + Delta_p_realGas;
  fluidPortIn.p = fluidPortOut.p + Delta_p_fluid;

  //energy balances
  -Q_flow =gasPortIn.m_flow*inStream(gasPortIn.h_outflow) + gasPortOut.m_flow*gasPortOut.h_outflow;
  //Q_flow = fluidPortIn2.m_flow*inStream(fluidPortIn2.h_outflow)+fluidPortOut2.m_flow*fluidPortOut2.h_outflow;
  fluidPortOut.h_outflow = if noEvent(fluidPortIn.m_flow < eps) then inStream(fluidPortIn.h_outflow) else (Q_flow - fluidPortIn.m_flow*inStream(fluidPortIn.h_outflow))/fluidPortOut.m_flow;
  //reverse flow
  gasPortIn.h_outflow = inStream(gasPortOut.h_outflow);
  fluidPortIn.h_outflow = inStream(fluidPortOut.h_outflow);

  //compositions
  gasPortOut.xi_outflow = inStream(gasPortIn.xi_outflow);
  fluidPortOut.xi_outflow = inStream(fluidPortIn.xi_outflow);
  //reverse flow
  gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);
  fluidPortIn.xi_outflow = inStream(fluidPortOut.xi_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-26,14},{104,-16}},
          lineColor={28,108,200},
          lineThickness=0.5,
          textString=DynamicSelect("fixed T", if fixedTemperatureRealGas then "fixed T" else "")), Text(
          extent={{-58,92},{72,62}},
          lineColor={28,108,200},
          lineThickness=0.5,
          textString=DynamicSelect("fixed T", if not
                                                    (fixedTemperatureRealGas) then "fixed T" else ""))}),
    Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a simple model of a heat exchanger with one real gas and one VLE fluid. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The detailed heat transfer is not modeled, only an end temperature for one medium is given by a parameter. There are no heat losses, no limitations for heat transfer and no changes in composition of both media. The model only works in the design flow direction. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>This model is only valid for one real gas and one fluid and if the changes of the temperature at the outlet with constant temperature are very small. The plausibility of the temperatures has to be checked (see 7.).</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn: Inlet of the real gas </p>
<p>gasPortOut: Outlet of the real gas </p>
<p>fluidPortIn: Inlet of the VLE fluid </p>
<p>fluidPortOut: Outlet of the VLE fluid </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_HEXTwoFluids1.png\" alt=\"\"/>: Heat flow transfered from medium2 to medium1</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>Energy balances:</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_HEXTwoFluids2.png\" alt=\"\"/></p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>The plausability of the temperatures at inlet and outlet of the media has to be checked. They have to fit to the chosen type of heat exchanger (e.g. concurrent or countercurrent). </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Mon Apr 24 2017<br> </p>
</html>"));
end HEXOneRealGasOneFluidIdeal_L1;
