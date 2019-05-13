within TransiEnt.Producer.Combined.SmallScaleCHP;
model SmallScaleCHP_L1_idContrMFlow_temp "Model for a small scale CHP plant with a pump with ideal mass flow control to get a given outlet temperature"
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

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=typeOfResource) annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{4,18},{76,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="CHP")}),                                   Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a small scale CHP plant with a pump&nbsp;with&nbsp;ideal&nbsp;mass flow control&nbsp;to&nbsp;get&nbsp;a&nbsp;given&nbsp;outlet&nbsp;temperature. It can be chosen if the outlet set temperature is constant or given by an input.</p>
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
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Dec 2018</p>
</html>"));
end SmallScaleCHP_L1_idContrMFlow_temp;
