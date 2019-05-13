within TransiEnt.Producer.Heat.Gas2Heat;
model GHP_L1_idContrMFlow_temp "Model for gas heat pumps with a pump with ideal mass flow control to get a given outlet temperature"
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

  extends TransiEnt.Producer.Heat.Base.XtH_L1_idContrMFlow_temp_base;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Boolean use_T_source_input_K = false "False, use outer ambient conditions" annotation(Dialog(group="Fundamental Definitions"));
  parameter Real COP_n = 1.37726 "Coefficient of performance at nominal conditions according to EN14511" annotation(Dialog(group="Technical Specifications"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.TemperatureIn T_source_input_K if use_T_source_input_K "Input ambient temperature in Kelvin" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60})));
protected
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_source_internal;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  SI.TemperatureDifference DeltaT "Temperature difference between water and air";
  Real COP "Coefficient of performance";
  SI.EnthalpyFlowRate H_flow "Consumed gas enthalpy flow rate";
  SI.Temperature T_source_var=20+273.15 "Air temperature" annotation(Dialog(group="Fundamental Definitions",enable=not use_T_source_input_K));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  if not use_T_source_input_K then
    T_source_internal=T_source_var;
  end if;

  H_flow=-Q_flow/COP;

  DeltaT=T_out_set_in - T_source_internal;
  COP=COP_n*1/1.37726*(4e-5*DeltaT^2-0.0111*DeltaT+1.7);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(T_source_input_K, T_source_internal);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{22,22},{58,-22}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{54,6},{62,6},{58,0},{62,-6},{54,-6},{58,0},{54,6}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,-18},{50,-26}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{16,6},{28,-6}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{18,4},{22,-6},{26,4}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{30,26},{50,18}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a gas heat pump with a pump&nbsp;with&nbsp;ideal&nbsp;mass flow control&nbsp;to&nbsp;get&nbsp;a&nbsp;given&nbsp;outlet&nbsp;temperature. It can be chosen if the outlet set temperature is constant or given by an input.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The COP does not depend on part load.</p>
<p>The mass flow is calculated based on a heat flow rate and a given constant outlet temperature. There is no volume considered.</p>
<p>There are no pressure losses included (pressures at inlet and outlet are given from the outside).</p>
<p>Overheating, i.e. exceeding the set outlet temperature, can be turned on or off.</p>
<p>The model calculates any mass flow that is necessary to reach the given temperature but limits the mass flow so that no flow reversal occurs and that the given maximum mass flow is not exceeded. </p>
<p>If the specific enthalpy at the inlet exceeds the set specific enthalpy, two cases will be distinguished:</p>
<ul>
<li>If the set value for the heat flow rate is below the given small value or overheating is not allowed, the mass flow is set to zero and the specific enthalpy is just passed through the fluid ports. </li>
<li>Otherwise the maximum mass flow rate is set.</li>
</ul>
<p>The heat flow rate is always calculated according to the actual specific enthalpies and the mass flow rate.</p>
<p>For more details see the equations.</p>
<p>The COP curve is taken from [1].</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>This model is only valid for ideal controls, i.e. ideally tuned controls with no control errors.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>T_out_set: set point for outlet temperature</p>
<p>T_source_input_K: input for the heat source of heat pump</p>
<p>Q_flow_set: set point heat flow rate (negative for producers)</p>
<p>fluidPortIn: inlet for fluid</p>
<p>fluidPortOut: outlet for fluid</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #0000ff;\">if&nbsp;</span><span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow)&gt;fluidOut.h<span style=\"font-family: Courier New; color: #0000ff;\">&nbsp;then</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #0000ff;\">if&nbsp;</span>-Q_flow_set&lt;Q_flow_small<span style=\"font-family: Courier New; color: #0000ff;\">&nbsp;or&nbsp;not&nbsp;</span>allowOverheat<span style=\"font-family: Courier New; color: #0000ff;\">&nbsp;then</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fluidPortOut.m_flow=0;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fluidPortOut.h_outflow=<span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow);</p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #0000ff;\">else</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fluidPortOut.h_outflow=Q_flow_set/fluidPortOut.m_flow+<span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow);</p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fluidPortOut.m_flow=-m_flow_max;<span style=\"color: #006400;\">&nbsp;//maximum&nbsp;mass&nbsp;flow&nbsp;to&nbsp;keep&nbsp;the&nbsp;temperature&nbsp;increase&nbsp;at&nbsp;a&nbsp;minimum</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #0000ff;\">end&nbsp;if</span>;</p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #0000ff;\">else</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;fluidPortOut.h_outflow=fluidOut.h;</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;fluidPortOut.m_flow=-<span style=\"color: #ff0000;\">max</span>(0,<span style=\"font-family: Courier New; color: #ff0000;\">min</span>(m_flow_max,-Q_flow_set/(fluidPortOut.h_outflow-<span style=\"font-family: Courier New; color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow))));</p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #0000ff;\">end&nbsp;if</span>;</p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;Q_flow=fluidPortOut.m_flow*(fluidPortOut.h_outflow-<span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow));</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The model is only working properly in design flow direction. Reverse flow is not supported!</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] A. Palzer, <i>Sektor&uuml;bergreifende Modellierung und Optimierung eines zuk&uuml;nftigen deutschen Energiesystems unter Ber&uuml;cksichtigung von Energieeffizienzma&szlig;nahmen im Geb&auml;udesektor</i>. Stuttgart: Fraunhofer Verlag, 2016.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end GHP_L1_idContrMFlow_temp;
