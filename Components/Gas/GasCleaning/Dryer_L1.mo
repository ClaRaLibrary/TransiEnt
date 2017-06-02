within TransiEnt.Components.Gas.GasCleaning;
model Dryer_L1 "Ideally dries a syngas flow"

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

  extends TransiEnt.Basics.Icons.Model;

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Basics.Media.Gases.VLE_VDIWA_SG6_var medium "Medium in the dryer";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.PressureDifference pressureLoss=0e5 "Pressure loss in hydrogen flow direction" annotation(Dialog(group="Fundamental Definitions"));

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
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=medium) annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TILMedia.VLEFluid_ph gasIn(
    vleFluidType=medium,
    p=gasPortIn.p,
    h=inStream(gasPortIn.h_outflow),
    xi=inStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true)  annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));

  TILMedia.VLEFluid_ph gasOut(
    vleFluidType=medium,
    p=gasPortOut.p,
    h=gasPortOut.h_outflow,
    xi=gasPortOut.xi_outflow,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{60,-12},{80,8}})));

  TILMedia.VLEFluid_ph fluidOut(
    vleFluidType=medium,
    p=fluidPortOut.p,
    h=fluidPortOut.h_outflow,
    xi=fluidPortOut.xi_outflow,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,58},{10,78}})));
public
  inner Summary summary(
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
    fluidPortOut(
      mediumModel=medium,
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
  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.FlangeRealGas fluidPortOut;
  end Summary;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //mass balance
  gasPortIn.m_flow + gasPortOut.m_flow + fluidPortOut.m_flow = 0;
  fluidPortOut.m_flow = -gasIn.xi[3]*gasPortIn.m_flow;

  //pressure
  gasPortOut.p = gasPortIn.p - pressureLoss;

  //adiabatic
  fluidOut.T = gasIn.T;
  gasOut.T = gasIn.T;

  //components
  //gasOut_water
  fluidOut.xi[1:2] = zeros(2);
  fluidOut.xi[3] = 1;     //only H2O
  fluidOut.xi[4:5] = zeros(2);
  //gasOut_syngas
  for i in {1,2,4,5} loop
    gasOut.xi[i] = gasIn.xi[i]/(1 - gasIn.xi[3]);
  end for;
  gasOut.xi[3] = 0;        //no water left

  //reverse flow
  gasPortIn.h_outflow =inStream(gasPortOut.h_outflow);
  gasPortIn.xi_outflow =inStream(gasPortOut.xi_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,20},{100,-20}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.HorizontalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-50,20},{50,-20}},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.HorizontalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-50,16},{50,-16}},
          lineThickness=0.5,
          fillPattern=FillPattern.CrossDiag,
          fillColor={255,255,255},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{30,4},{42,-8}},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255},
          pattern=LinePattern.None),
        Polygon(
          points={{30,-2},{31,3},{33,6},{34,10},{34,14},{38,10},{40,6},{42,2},{42,-2},{30,-2}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-8,4},{4,-8}},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255},
          pattern=LinePattern.None),
        Polygon(
          points={{-8,-2},{-7,3},{-5,6},{-4,10},{-4,14},{0,10},{2,6},{4,2},{4,-2},{-8,-2}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-26,-4},{-14,-16}},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255},
          pattern=LinePattern.None),
        Polygon(
          points={{-26,-10},{-25,-5},{-23,-2},{-22,2},{-22,6},{-18,2},{-16,-2},{-14,-6},{-14,-10},{-26,-10}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-46,4},{-34,-8}},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255},
          pattern=LinePattern.None),
        Polygon(
          points={{-46,-2},{-45,3},{-43,6},{-42,10},{-42,14},{-38,10},{-36,6},{-34,2},{-34,-2},{-46,-2}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,-2},{22,-14}},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255},
          pattern=LinePattern.None),
        Polygon(
          points={{10,-8},{11,-3},{13,0},{14,4},{14,8},{18,4},{20,0},{22,-4},{22,-8},{10,-8}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a dryer which completely separates all the water in the incoming real gas stream. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>All the water is separated ideally, no rest humidity is left in the stream. A constant pressure loss is assumed and the temperature is constant. Within the dryer there is no cooling, the cooling has to be done beforehand. </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>The model is only valid if the remaining water in the stream is negligible. </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>gasPortIn: real gas inlet </p>
<p>gasPortOut: real gas outlet </p>
<p>fluidPortOut: water outlet </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>The outgoing water mass flow is calculated using the incoming mass flow and composition. The remaining mass fractions and the mass flow rate are scaled under consideration of the water loss.  </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>The model only works in design flow direction. </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"));
end Dryer_L1;
