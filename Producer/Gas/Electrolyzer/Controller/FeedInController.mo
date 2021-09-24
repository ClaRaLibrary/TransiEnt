within TransiEnt.Producer.Gas.Electrolyzer.Controller;
model FeedInController "Controlling electrolyzer power comparing set power with maximum allowed H2 that can be fed into the grid, limited to min and max electrolyzer power"

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

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  parameter SI.ActivePower P_el_n=1e6 "Nominal power of electrolyzer";
  //partial-load operational range from 2%-300%
  parameter SI.ActivePower P_el_max = 3*P_el_n "Maximum permitted input power";
  parameter SI.ActivePower P_el_min = 0.02*P_el_n "Minimum permitted input power";
  parameter SI.Efficiency eta_n(
    min=0,
    max=1)=0.75 "Nominal efficiency coefficient (min = 0, max = 1)";

  parameter SI.Efficiency eta_scale(
    min=0,
    max=1)=0 "Sets a with increasing input power linear degrading efficiency coefficient (min = 0, max = 1)";

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "Type of controller" annotation (Dialog(tab="General",  group="Controller"));
  parameter Real k=1 "Gain for controller" annotation (Dialog(tab="General",  group="Controller"));
  parameter Real Ti=0.1 "Integrator time constant" annotation (Dialog(tab="General",  group="Controller"));
  parameter Real Td=0.1 "Derivative time constant" annotation (Dialog(tab="General",  group="Controller"));
  parameter Boolean useMassFlowControl=true "choose if output of FeedInStation is limited by m_flow_feedIn" annotation (Dialog(tab="General"));


protected
  SI.Efficiency eta_min = charline.eta;
  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

public
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_H2 if useMassFlowControl "Current hydrogen mass flow in kg/s"
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,110})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_feedIn if useMassFlowControl "Maximum admissible hydrogen mass flow in kg/s"
                                            annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,110})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el_feedIn "Maximum power considering constraints"
                                      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
 TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set "Desired output power"    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));

  // _____________________________________________
  //
  //               Complex Components
  // _____________________________________________

  TransiEnt.Basics.Blocks.LimPID limPID(
    y_max=P_el_max,
    y_min=0,
    k=k,
    Tau_i=Ti,
    Tau_d=Td,
    controllerType=controllerType) if useMassFlowControl annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-12,60})));
  replaceable model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200        constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline        "Calculate the efficiency" annotation (Placement(transformation(extent={{10,-10},{30,10}})), choicesAllMatching=true);
public
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=P_el_max, uMin=0) annotation (Placement(transformation(extent={{-74,4},{-54,24}})));
protected
  Charline charline(final P_el_n=P_el_n, final eta_n=eta_n, final eta_scale=eta_scale) annotation (Placement(transformation(extent={{-96,-96},{-76,-76}})));

protected
  Modelica.Blocks.Math.Min minimum if useMassFlowControl "Minimum of both input signals" annotation (Placement(transformation(extent={{14,10},{34,30}})));
  Modelica.Blocks.Logical.Switch switch annotation (Placement(transformation(extent={{68,10},{88,-10}})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{14,-32},{34,-12}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=(P_el_set < P_el_min or m_flow_feedIn < eta_min*P_el_min/141.8e6)) if useMassFlowControl annotation (Placement(transformation(extent={{-60,-12},{38,12}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression2(y=(P_el_set < P_el_min)) if useMassFlowControl==false annotation (Placement(transformation(extent={{-60,-12},{38,12}})));
equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  charline.P_el=P_el_min;

  // _____________________________________________
  //
  //             Connect Statements
  // _____________________________________________


  connect(const.y, switch.u1) annotation (Line(points={{35,-22},{50,-22},{50,-8},{66,-8}}, color={0,0,127}));
  connect(switch.y, P_el_feedIn) annotation (Line(points={{89,0},{110,0}}, color={0,0,127}));
  if useMassFlowControl then
  connect(minimum.y, switch.u3) annotation (Line(points={{35,20},{42,20},{48,20},{48,8},{66,8}}, color={0,0,127}));
  connect(limPID.y, minimum.u1) annotation (Line(points={{-1,60},{4,60},{4,26},{12,26}}, color={0,0,127}));
  connect(m_flow_feedIn,limPID. u_s) annotation (Line(
      points={{-30,110},{-30,60},{-24,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow_H2,limPID. u_m) annotation (Line(points={{30,110},{30,110},{30,42},{-12,42},{-12,48}},      color={0,0,127}));
  connect(booleanExpression.y, switch.u2) annotation (Line(points={{42.9,0},{66,0},{66,0}}, color={255,0,255}));
  connect(limiter.y, minimum.u2) annotation (Line(points={{-53,14},{12,14}}, color={0,0,127}));
  else
  connect(limiter.y,switch.u3);
  connect(booleanExpression2.y, switch.u2);
  end if;


  connect(P_el_set, limiter.u) annotation (Line(points={{-110,0},{-88,0},{-88,14},{-76,14}}, color={0,127,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a controller for the PtG plant in operation mode RE with limited hydrogen output.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Controller considers minimum and maximum power of electrolyzer. If desired power is too low, output signal is zero.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Three inputs: mass flow from PtG plant; maximum permitted mass flow; available RE power</p>
<p>One output: desired electrical power of PtG plant</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Definiton of minimum and maximum power of PtG plant is required. </p>
<p>Depending on application adjustment of PID controller will be helpful.</p>
<p>If useMassFlowControl=true, the electrical power of the electrolyzer will no more be limited by given m_flow_feed. This simplifies the controller if limitation is not needed.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de) in Sep 2016</p>
<p>Model modified by Oliver Schülting (oliver.schuelting@tuhh.de) in April 2019: added Boolean useMassFlowControl</p>
</html>"));
end FeedInController;
