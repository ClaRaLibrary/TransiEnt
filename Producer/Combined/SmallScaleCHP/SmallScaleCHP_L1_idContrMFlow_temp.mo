within TransiEnt.Producer.Combined.SmallScaleCHP;
model SmallScaleCHP_L1_idContrMFlow_temp "Model for a small scale CHP plant with a pump with ideal mass flow control to get a given outlet temperature"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  extends TransiEnt.Producer.Electrical.Base.PartialNaturalGasUnit;
  extends TransiEnt.Producer.Heat.Base.XtH_L1_idContrMFlow_temp_base(Q_flow_n=P_el_n/eta_el*eta_th);



  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Power P_el_n=3.5e3 "Nominal electric power" annotation (Dialog(group="Technical Specifications"));
  parameter SI.Efficiency eta_el = 0.3 "Constant electric efficiency" annotation (Dialog(group="Technical Specifications"));
  parameter SI.Efficiency eta_th = 0.6 "Constant thermal efficiency" annotation (Dialog(group="Technical Specifications"));

  replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.Empty
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);
  parameter Boolean usePowerPort=false "True if power port shall be used" annotation (Dialog(group="Technical Specifications"));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=typeOfResource) annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
   Modelica.Blocks.Sources.RealExpression realExpression(y=P_el) annotation (Placement(transformation(extent={{-72,52},{-52,72}})));
  replaceable Components.Boundaries.Electrical.ActivePower.Power powerBoundary if
                                                                                usePowerPort constrainedby Components.Boundaries.Electrical.ActivePower.Power "Choice of power boundary model. The power boundary model must match the power port." annotation (
    choices(choice(redeclare TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary "PowerBoundary for ActivePowerPort"), choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "Power Boundary for ComplexPowerPort")),
    Dialog(group="Replaceable Components"),
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-28,40})));
  replaceable Basics.Interfaces.Electrical.ActivePowerPort            epp if usePowerPort constrainedby Basics.Interfaces.Electrical.ActivePowerPort            "Choice of power port" annotation(choicesAllMatching=true, Dialog(group="Replaceable Components"), Placement(transformation(extent={{-110,-10},{-90,10}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(y=H_flow) if
                                                                     useGasPort annotation (Placement(transformation(extent={{-98,84},{-78,104}})));
  Modelica.Blocks.Math.Division division if useGasPort annotation (Placement(transformation(extent={{-68,78},{-48,98}})));
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  SI.EnthalpyFlowRate H_flow "Consumed gas enthalpy flow rate";
  SI.Power P_el "Electric power";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  H_flow=-(Q_flow + P_el)/(eta_el + eta_th);
  P_el = Q_flow*eta_el/eta_th;

  collectElectricPower.powerCollector.P =-P_el;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.powerCollector[collectElectricPower.typeOfResource], collectElectricPower.powerCollector);
  if usePowerPort then
  connect(realExpression.y,powerBoundary. P_el_set) annotation (Line(points={{-51,62},{-34,62},{-34,52}}, color={0,0,127}));
  connect(powerBoundary.epp,epp)  annotation (Line(
      points={{-38,40},{-60,40},{-60,0},{-100,0}},
      color={0,135,135},
      thickness=0.5));
  end if;

  if useGasPort then
  connect(vleNCVSensor.NCV,division. u2) annotation (Line(points={{53,92},{44,92},{44,110},{-100,110},{-100,82},{-70,82}}, color={0,0,127}));
  connect(division.u1, realExpression1.y) annotation (Line(points={{-70,94},{-77,94}}, color={0,0,127}));
  connect(m_flow_gas,division. y) annotation (Line(points={{8,88},{-47,88}},   color={0,0,127}));
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{4,18},{76,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="CHP")}),                                   Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a small scale CHP plant with a pump with ideal mass flow control to get a given outlet temperature. It can be chosen if the outlet set temperature is constant or given by an input.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The efficiencies are constant.</p>
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
<p><span style=\"font-family: Courier New; color: #0000ff;\">if </span></span><span style=\"color: #ff0000;\">inStream(fluidPortIn.h_outflow)&gt;fluidOut.h<span style=\"font-family: Courier New; color: #0000ff;\"> then</span></p>
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
<p>Model modified by Jan Westphal (j.westphal@tuhh.de), Jul 2019 (added power port, added boolean for using gas port)</p>
</html>"));
end SmallScaleCHP_L1_idContrMFlow_temp;
