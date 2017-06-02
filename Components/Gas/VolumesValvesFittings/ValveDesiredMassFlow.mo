within TransiEnt.Components.Gas.VolumesValvesFittings;
model ValveDesiredMassFlow "Simple valve with prescribed mass flow rate"

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

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium used in the valve" annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);
  parameter Boolean hysteresisWithDelta_p=true "true: hysteresis uses pressure difference, false: hysteresis uses inlet pressure"
                                                                                                  annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.PressureDifference Delta_p_low=1e3 "Lower value for hysteresis with pressure difference" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.PressureDifference Delta_p_high=1e5 "Upper value for hyseteresis with pressure difference" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Pressure p_low=1e5 "Lower value for hysteresis with inlet pressure" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Pressure p_high=1.1e5 "Upper value for hyseteresis with inlet pressure" annotation(Dialog(group="Fundamental Definitions"));

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
  Modelica.Blocks.Interfaces.RealInput m_flowDes "Desired mass flow" annotation (Placement(transformation(extent={{-120,40},{-80,80}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=if hysteresisWithDelta_p then Delta_p_low else p_low, uHigh=if hysteresisWithDelta_p then Delta_p_high else p_high) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TILMedia.VLEFluid_ph gasIn(
    vleFluidType=medium,
    p=gasPortIn.p,
    h=actualStream(gasPortIn.h_outflow),
    xi=actualStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  TILMedia.VLEFluid_ph gasOut(
    vleFluidType=medium,
    p=gasPortOut.p,
    h=actualStream(gasPortOut.h_outflow),
    xi=actualStream(gasPortOut.xi_outflow),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{70,-12},{90,8}})));

public
  Summary summary(
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
      rho=gasOut.d))
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

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
  gasPortIn.m_flow = if valveOpen then max(m_flowDes,0) else 0;

  gasPortIn.m_flow+gasPortOut.m_flow = 0;
  gasPortIn.h_outflow = inStream(gasPortOut.h_outflow);
  gasPortOut.h_outflow = inStream(gasPortIn.h_outflow);
  gasPortIn.xi_outflow = inStream(gasPortOut.xi_outflow);
  gasPortOut.xi_outflow = inStream(gasPortIn.xi_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (defaultComponentName="valve_mFlow",
  Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,60}},
        grid={2,2}), graphics={Bitmap(
          extent={{-100,70},{100,-50}},
          imageSource="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",
          fileName="modelica://ClaRa/figures/Components/Valve.png")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-50},{100,70}},
        grid={2,2})),Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This model represents a simple valve for real gases which ensures a given mass flow. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This model works like an ideally controlled valve to ensure a given mass flow. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>This model is only valid for real gases.</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn: Inlet of the real gas </p>
<p>gasPortOut: Outlet of the real gas </p>
<p>m_flowDes: Input for the desired mass flow </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>Make sure that there is always a negative pressure gradient in the direction of the mass flow to ensure a physically possible use of the valve.</p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"));
end ValveDesiredMassFlow;
