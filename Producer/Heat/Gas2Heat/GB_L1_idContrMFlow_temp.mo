within TransiEnt.Producer.Heat.Gas2Heat;
model GB_L1_idContrMFlow_temp "Model for gas boilers with a pump with ideal mass flow control to get a given outlet temperature"

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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Electrical.Base.PartialNaturalGasUnit(final useSecondGasPort=false);
  extends TransiEnt.Producer.Heat.Base.XtH_L1_idContrMFlow_temp_base;


  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real eta = 0.95 "Coefficient of performance at nominal conditions according to EN14511" annotation(Dialog(group="Technical Specifications"));

  parameter SI.SpecificEnthalpy HoC_fuel=40e6 "Heat of combustion of fuel, will be used if gasport is deactivated in model" annotation (Dialog(group="Fundamental Definitions", enable=useConstantHoC), choices(
      choice=simCenter.HeatingValue_natGas "Natural gas",
      choice=simCenter.HeatingValue_LightOil "Oil",
      choice=simCenter.HeatingValue_Wood "Wood pellets"));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  SI.EnthalpyFlowRate H_flow "Consumed gas enthalpy flow rate";

  Modelica.Blocks.Math.Division division annotation (Placement(transformation(extent={{-68,78},{-48,98}})));

   Modelica.Blocks.Sources.RealExpression realExpression1(y=H_flow) annotation (Placement(transformation(extent={{-96,84},{-76,104}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________


  Modelica.Blocks.Sources.RealExpression HoC_constant(y=HoC_fuel) if not useGasPort annotation (Placement(transformation(extent={{-98,52},{-78,72}})));

equation
  H_flow=-Q_flow/eta;

  if useGasPort then
    connect(vleNCVSensor.NCV,division. u2) annotation (Line(points={{53,92},{44,92},{44,110},{-100,110},{-100,82},{-70,82}}, color={0,0,127}));
    connect(m_flow_gas,division. y) annotation (Line(points={{8,88},{-47,88}},   color={0,0,127}));
  end if;
  connect(division.u1, realExpression1.y) annotation (Line(points={{-70,94},{-75,94}}, color={0,0,127}));
  connect(HoC_constant.y, division.u2) annotation (Line(points={{-77,62},{-70,62},{-70,72},{-74,72},{-74,82},{-70,82}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{22,18},{58,-18}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-42,-2},{-14,-2},{-8,8},{4,-12},{10,-2},{38,-2}},        color={162,29,33},
          origin={38,2},
          rotation=90)}),                                        Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a gas boiler with a pump with ideal mass flow control to get a given outlet temperature. It can be chosen if the outlet set temperature is constant or given by an input.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The efficiency is constant.</p>
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
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>This model is only valid for ideal controls, i.e. ideally tuned controls with no control errors.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>T_out_set: set point for outlet temperature</p>
<p>Q_flow_set: set point heat flow rate (negative for producers)</p>
<p>fluidPortIn: inlet for fluid</p>
<p>fluidPortOut: outlet for fluid</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p><span style=\"font-family: Courier New; color: #0000ff;\">if </span><span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow)&gt;fluidOut.h<span style=\"font-family: Courier New; color: #0000ff;\"> then</span></p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">if </span>-Q_flow_set&lt;Q_flow_small<span style=\"font-family: Courier New; color: #0000ff;\"> or not </span>allowOverheat<span style=\"font-family: Courier New; color: #0000ff;\"> then</span></p>
<p><span style=\"font-family: Courier New;\">fluidPortOut.m_flow=0;</span></p>
<p><span style=\"font-family: Courier New;\">fluidPortOut.h_outflow=<span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow);</p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">else</span></p>
<p><span style=\"font-family: Courier New;\">fluidPortOut.h_outflow=Q_flow_set/fluidPortOut.m_flow+<span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow);</p>
<p><span style=\"font-family: Courier New;\">fluidPortOut.m_flow=-m_flow_max;<span style=\"color: #006400;\"> //maximum mass flow to keep the temperature increase at a minimum</span></p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">end if</span>;</p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">else</span></p>
<p><span style=\"font-family: Courier New;\">fluidPortOut.h_outflow=fluidOut.h;</span></p>
<p><span style=\"font-family: Courier New;\">fluidPortOut.m_flow=-<span style=\"color: #ff0000;\">max</span>(0,<span style=\"font-family: Courier New; color: #ff0000;\">min</span>(m_flow_max,-Q_flow_set/(fluidPortOut.h_outflow-<span style=\"font-family: Courier New; color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow))));</p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">end if</span>;</p>
<p><span style=\"font-family: Courier New;\">Q_flow=fluidPortOut.m_flow*(fluidPortOut.h_outflow-<span style=\"color: #ff0000;\">inStream</span>(fluidPortIn.h_outflow));</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The model is only working properly in design flow direction. Reverse flow is not supported!</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Dec 2018</p>
<p>Model modified by Jan Westphal (j.westphal@tuhh.de), Jul 2019 (added boolean for using gas port)</p>
</html>"));
end GB_L1_idContrMFlow_temp;
