within TransiEnt.Producer.Gas.Electrolyzer.Controller;
model FeedInController "Controlling electrolyzer power comparing set power with maximum allowed H2 that can be fed into the grid, limited to min and max electrolyzer power"
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

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "|Controller|Type of controller";
  parameter Real k=1 "|Controller|Gain for controller";
  parameter Real Ti=0.1 "|Controller|Integrator time constant";
  parameter Real Td=0.1 "|Controller|Derivative time constant";

protected
  SI.Efficiency eta_min = charline.eta;
  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

public
  Modelica.Blocks.Interfaces.RealInput m_flow_H2 "Current hydrogen mass flow in kg/s"
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,110})));
  Modelica.Blocks.Interfaces.RealInput m_flow_feedIn "Maximum admissible hydrogen mass flow in kg/s"
                                            annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,110})));
  Modelica.Blocks.Interfaces.RealOutput P_el_feedIn "Maximum power considering constraints"
                                      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput P_el_set "Desired output power"    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));

  // _____________________________________________
  //
  //               Complex Components
  // _____________________________________________

  TransiEnt.Basics.Blocks.SmoothLimPID limPID(
    k=k,
    yMax=P_el_max,
    Ti=Ti,
    Td=Td,
    controllerType=controllerType,
    yMin=0,
    thres=0.1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-12,60})));
  replaceable model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200        constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline        "Calculate the efficiency" annotation (Placement(transformation(extent={{10,-10},{30,10}})), choicesAllMatching=true);
protected
  Charline charline(final P_el_n=P_el_n, final eta_n=eta_n, final eta_scale=eta_scale) annotation (Placement(transformation(extent={{-96,-96},{-76,-76}})));

protected
  Modelica.Blocks.Math.Min minimum "Minimum of both input signals" annotation (Placement(transformation(extent={{14,10},{34,30}})));
  Modelica.Blocks.Logical.Switch switch annotation (Placement(transformation(extent={{68,10},{88,-10}})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{14,-32},{34,-12}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=(P_el_set < P_el_min or m_flow_feedIn < eta_min*P_el_min/141.8e6)) annotation (Placement(transformation(extent={{-60,-12},{38,12}})));
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

  connect(m_flow_feedIn,limPID. u_s) annotation (Line(
      points={{-30,110},{-30,60},{-24,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow_H2,limPID. u_m) annotation (Line(points={{30,110},{30,110},{30,42},{-12,42},{-12,48}},
                                                                                                    color={0,0,127}));
  connect(P_el_set, minimum.u2) annotation (Line(points={{-110,0},{-88,0},{-88,14},{12,14}}, color={0,0,127}));
  connect(const.y, switch.u1) annotation (Line(points={{35,-22},{50,-22},{50,-8},{66,-8}}, color={0,0,127}));
  connect(minimum.y, switch.u3) annotation (Line(points={{35,20},{42,20},{48,20},{48,8},{66,8}}, color={0,0,127}));
  connect(switch.y, P_el_feedIn) annotation (Line(points={{89,0},{110,0}}, color={0,0,127}));
  connect(booleanExpression.y, switch.u2) annotation (Line(points={{42.9,0},{66,0},{66,0}}, color={255,0,255}));
  connect(limPID.y, minimum.u1) annotation (Line(points={{-1,60},{4,60},{4,26},{12,26}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a controller for the PtG plant in operation mode RE with limited hydrogen output.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Controller considers minimum and maximum power of electrolyzer. If desired power is too low, output signal is zero.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Three inputs: mass flow from PtG plant; maximum permitted mass flow; available RE power</p>
<p>One output: desired electrical power of PtG plant</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Definiton of minimum and maximum power of PtG plant is required. </p>
<p>Depending on application adjustment of PID controller will be helpful.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<h4><span style=\"color: #008000\">9. References</span></h4>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de) in Sep 2016</p>
</html>"));
end FeedInController;
