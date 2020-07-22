within TransiEnt.Components.Gas.HeatExchanger;
model HEXTwoRealGasesIdeal_L1 "Ideal heat exchanger for two real gases with fixed temperature at one end"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

  import SI = Modelica.SIunits;
  import Modelica.Constants.eps;
  extends TransiEnt.Basics.Icons.Heat_Exchanger;


  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium1=simCenter.gasModel1 "Main medium whose end temperature is fixed" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium2=simCenter.gasModel1 "Medium which is cooling or heating medium1" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter SI.PressureDifference Delta_p1=0 "Pressure loss in medium1" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.PressureDifference Delta_p2=0 "Pressure loss in medium2" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.Temperature T_out_realGas1=293.15 "Fixed temperature of real gas 1 at its outlet" annotation(Dialog(group="Heat Transfer"));

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

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn1(Medium=medium1) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut1(Medium=medium1) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn2(Medium=medium2) annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut2(Medium=medium2) annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut1(
    vleFluidType=medium1,
    p=gasPortOut1.p,
    h=gasPortOut1.h_outflow,
    xi=gasPortOut1.xi_outflow,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{60,-12},{80,8}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn1(
    vleFluidType=medium1,
    p=gasPortIn1.p,
    h=inStream(gasPortIn1.h_outflow),
    xi=inStream(gasPortIn1.xi_outflow),
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn2(
    vleFluidType=medium2,
    p=gasPortIn2.p,
    h=inStream(gasPortIn2.h_outflow),
    xi=inStream(gasPortIn2.xi_outflow),
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{-10,-82},{10,-62}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut2(
    vleFluidType=medium2,
    p=gasPortOut2.p,
    h=gasPortOut2.h_outflow,
    xi=gasPortOut2.xi_outflow,
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{-10,58},{10,78}})));
public
  inner Summary summary(
    outline(Q_flow=Q_flow),
    gasPortIn1(
      mediumModel=medium1,
      useFluidModelsForSummary=useFluidModelsForSummary,
      xi=inStream(gasPortIn1.xi_outflow),
      x=gasIn1.x,
      m_flow=gasPortIn1.m_flow,
      T=gasIn1.T,
      p=gasPortIn1.p,
      h=inStream(gasPortIn1.h_outflow),
      rho=gasIn1.d),
    gasPortOut1(
      mediumModel=medium1,
      xi=gasPortOut1.xi_outflow,
      x=gasOut1.x,
      m_flow=-gasPortOut1.m_flow,
      T=gasOut1.T,
      p=gasPortOut1.p,
      h=gasPortOut1.h_outflow,
      rho=gasOut1.d),
    gasPortIn2(
      mediumModel=medium2,
      useFluidModelsForSummary=useFluidModelsForSummary,
      xi=inStream(gasPortIn2.xi_outflow),
      x=gasIn2.x,
      m_flow=gasPortIn2.m_flow,
      T=gasIn2.T,
      p=gasPortIn2.p,
      h=inStream(gasPortIn2.h_outflow),
      rho=gasIn2.d),
    gasPortOut2(
      mediumModel=medium2,
      useFluidModelsForSummary=useFluidModelsForSummary,
      xi=gasPortOut2.xi_outflow,
      x=gasOut2.x,
      m_flow=-gasPortOut2.m_flow,
      T=gasOut2.T,
      p=gasPortOut2.p,
      h=gasPortOut2.h_outflow,
      rho=gasOut2.d)) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

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
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn1;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut1;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn2;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut2;
  end Summary;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  gasOut1.T = T_out_realGas1;

  //mass balances
  gasPortIn1.m_flow + gasPortOut1.m_flow = 0;
  gasPortIn2.m_flow + gasPortOut2.m_flow = 0;

  //pressure
  gasPortIn1.p = gasPortOut1.p + Delta_p1;
  gasPortIn2.p = gasPortOut2.p + Delta_p2;

  //energy balances
  -Q_flow =gasPortIn1.m_flow*inStream(gasPortIn1.h_outflow) + gasPortOut1.m_flow*gasPortOut1.h_outflow;
  //Q_flow = fluidPortIn2.m_flow*inStream(fluidPortIn2.h_outflow)+fluidPortOut2.m_flow*fluidPortOut2.h_outflow;
  gasPortOut2.h_outflow = if noEvent(gasPortIn2.m_flow < eps) then inStream(gasPortIn2.h_outflow) else (Q_flow - gasPortIn2.m_flow*inStream(gasPortIn2.h_outflow))/gasPortOut2.m_flow;
  //reverse flow
  gasPortIn1.h_outflow = inStream(gasPortOut1.h_outflow);
  gasPortIn2.h_outflow = inStream(gasPortOut2.h_outflow);

  //compositions
  gasPortOut1.xi_outflow = inStream(gasPortIn1.xi_outflow);
  gasPortOut2.xi_outflow = inStream(gasPortIn2.xi_outflow);
  //reverse flow
  gasPortIn1.xi_outflow = inStream(gasPortOut1.xi_outflow);
  gasPortIn2.xi_outflow = inStream(gasPortOut2.xi_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-26,14},{104,-16}},
          lineColor={28,108,200},
          lineThickness=0.5,
          textString="fixed T")}),
    Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a simple model of a heat exchanger with two real gases. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The detailed heat transfer is not modeled, only an end temperature for one medium is given by a parameter (at outlet of medium1). There are no heat losses, no limitations for heat transfer and no changes in composition of both media. The model only works in the design flow direction. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>This model is only valid for real gases and if the changes of the temperature at outlet1 are very small. The plausibility of the temperatures has to be checked (see 7.).</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn1: Inlet of the first real gas </p>
<p>gasPortOut1: Outlet of the first real gas </p>
<p>gasPortIn2: Inlet of the second real gas </p>
<p>gasPortOut2: Outlet of the second real gas </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_HEXTwoFluids1.png\" alt=\"\"/>: Heat flow transfered from medium2 to medium1</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>Energy balances:</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation_HEXTwoFluids2.png\" alt=\"\"/></p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>The plausability of the temperatures at inlet and outlet of the gases has to be checked. They have to fit to the chosen type of heat exchanger (e.g. concurrent or countercurrent). </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"));
end HEXTwoRealGasesIdeal_L1;
