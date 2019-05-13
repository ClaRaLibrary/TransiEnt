within TransiEnt.Producer.Gas.MethanatorSystem.Controller;
model MassFlowFeedInSystemController
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

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

    parameter SI.ActivePower P_el_max "Maximum power of electrolyzer" annotation (Dialog(tab="General", group="Electrolyzer"));
    parameter SI.Efficiency eta_n_ely(min=0,max=1) "Nominal Efficiency" annotation (Dialog(tab="General", group="Electrolyzer"));
    parameter Boolean useMassFlowControl=true "choose if output of FeedInStation is limited by m_flow_feedIn - if 'false': m_flow_feedIn has no effect - should only be used if FeedInStatin_hydrogen has no storage" annotation (Dialog(tab="General"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

      TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set "Input for electric power" annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-120,0})));
      TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_feed "Input for mass flow rate" annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=270,
      origin={-60,120})));
      TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el_ely "Output for electric power" annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={110,0})));
      TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_feed_ely "Output for mass flow rate" annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={110,80})));
      TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_feed_CH4_is "Input for mass flow rate of CH4"  annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=270,
      origin={60,120})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable Modelica.Blocks.Continuous.LimPID PID(
    y_start=0,
    initType=Modelica.Blocks.Types.InitPID.NoInit,
    yMax=1,
    yMin=-1,
    k=2,
    Td=1000,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=1e-7) if
               useMassFlowControl                          annotation (Placement(transformation(extent={{-20,80},{0,100}})));


Modelica.Blocks.Math.Division division if useMassFlowControl annotation (Placement(transformation(extent={{-20,52},{0,72}})));
Modelica.Blocks.Sources.RealExpression realExpression(y=2.0422868) if useMassFlowControl annotation (Placement(transformation(extent={{-60,46},{-40,66}})));
Modelica.Blocks.Math.Add add if useMassFlowControl annotation (Placement(transformation(extent={{68,58},{88,78}})));
Basics.Interfaces.General.MassFlowRateIn m_flow_feed_H2 "Input for mass flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
Modelica.Blocks.Math.Add add1 if useMassFlowControl
                             annotation (Placement(transformation(extent={{24,46},{44,66}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

connect(P_el_set, P_el_ely) annotation (Line(points={{-120,0},{110,0},{110,0}}, color={0,0,127}));

  if useMassFlowControl then
  connect(add.u2, add1.y) annotation (Line(points={{66,62},{56,62},{56,56},{45,56}}, color={0,0,127}));
  connect(division.y, add1.u1) annotation (Line(points={{1,62},{22,62}}, color={0,0,127}));
  connect(add1.u2, m_flow_feed_H2) annotation (Line(points={{22,50},{0,50},{0,-120}}, color={0,0,127}));
connect(PID.u_m, m_flow_feed_CH4_is) annotation (Line(points={{-10,78},{-10,78},{60,78},{60,96},{60,120}},       color={0,0,127}));
connect(division.u2, realExpression.y) annotation (Line(points={{-22,56},{-30,56},{-39,56}}, color={0,0,127}));
connect(division.u1, m_flow_feed) annotation (Line(points={{-22,68},{-60,68},{-60,120}}, color={0,0,127}));
connect(PID.u_s, m_flow_feed) annotation (Line(points={{-22,90},{-60,90},{-60,120}}, color={0,0,127}));
connect(add.y, m_flow_feed_ely) annotation (Line(points={{89,68},{94,68},{94,80},{110,80}}, color={0,0,127}));
connect(add.u1, PID.y) annotation (Line(points={{66,74},{40,74},{12,74},{12,90},{1,90}}, color={0,0,127}));
  else
    connect(m_flow_feed,m_flow_feed_ely);
  end if;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is used to control the Electrolyzer in a Methanator system.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn&nbsp;P_el_set&nbsp;&quot;Input&nbsp;for&nbsp;electric&nbsp;power&quot;&nbsp;</p>
<p>TransiEnt.Basics.Interfaces.General.MassFlowRateIn&nbsp;m_flow_feed&nbsp;&quot;Input&nbsp;for&nbsp;mass&nbsp;flow&nbsp;rate&quot;&nbsp;</p>
<p>TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_feed_H2 &quot;Input for mass flow rate of H2 output&quot; </p>
<p>TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut&nbsp;P_el_ely&nbsp;&quot;Output&nbsp;for&nbsp;electric&nbsp;power&quot;&nbsp;</p>
<p>TransiEnt.Basics.Interfaces.General.MassFlowRateOut&nbsp;m_flow_feed_ely&nbsp;&quot;Output&nbsp;for&nbsp;mass&nbsp;flow&nbsp;rate&quot;&nbsp;</p>
<p>TransiEnt.Basics.Interfaces.General.MassFlowRateIn&nbsp;m_flow_feed_CH4_is&nbsp;&quot;Input&nbsp;for&nbsp;mass&nbsp;flow&nbsp;rate&nbsp;of&nbsp;CH4&quot;&nbsp;</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de)</p>
</html>"));
end MassFlowFeedInSystemController;
