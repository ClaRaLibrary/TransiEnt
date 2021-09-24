within TransiEnt.Components.Boundaries.Heat;
model Heatflow_L1_idContrMFlow_temp "Heat flow boundary with pump with ideal mass flow control to get a given outlet temperature"

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

  extends Base.Heatflow_L1_idContr_temp_base;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set "Setpoint value of the heat flow, should be negative" annotation (Placement(transformation(extent={{120,-20},{80,20}}),   iconTransformation(extent={{120,-20},{80,20}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  Q_flow=fluidPortOut.m_flow*(fluidPortOut.h_outflow-inStream(fluidPortIn.h_outflow));

  fluidPortOut.m_flow=min(0,Q_flow_set/(fluidPortOut.h_outflow-inStream(fluidPortIn.h_outflow)));

   annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-56,-18},{-24,14}},
          startAngle=0,
          endAngle=360), Line(
          points={{-50,2},{-40,14},{-40,-18},{-40,14},{-30,2}},
          color={0,0,0},
          thickness=0.5)}),                                       Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a heat flow boundary with a pump whose mass flow is ideally controlled to get a given outlet temperature. It can be chosen if the outlet set temperature is constant or given by an input.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The mass flow is calculated based on a heat flow rate and a given constant outlet temperature. There is no volume considered.</p>
<p>There are no pressure losses included (pressures at inlet and outlet are given from the outside).</p>
<p>The model calculates any mass flow that is necessary to reach the given temperature but limits the mass flow so that no flow reversal occurs.</p>
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
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end Heatflow_L1_idContrMFlow_temp;
