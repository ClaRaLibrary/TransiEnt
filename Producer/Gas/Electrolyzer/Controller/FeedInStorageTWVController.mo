within TransiEnt.Producer.Gas.Electrolyzer.Controller;
model FeedInStorageTWVController "Controller to control the three way valve after the electrolyzer to grid and storage"


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

  import TransiEnt;
  import Modelica.Constants.eps;
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter Boolean StoreAllHydrogen=false "All Hydrogen is stored before beeing fed in";
  parameter SI.Pressure p_minLow=20e5 "Lower limit of the target pressure in storage" annotation (Dialog(tab="General",  group="Controller"));
  parameter SI.Pressure p_maxLow=29e5 "Lower limit of the target pressure in storage" annotation (Dialog(tab="General",  group="Controller"));
  parameter SI.Pressure p_maxHigh=30e5 "Upper limit of the target pressure in storage" annotation (Dialog(tab="General",  group="Controller"));
  parameter SI.Pressure p_minHigh=60e5 "if valve closed and p>p_high, open valve" annotation (Dialog(tab="General", group="Controller"));
  parameter SI.Pressure p_minLow_constantDemand=50e5 "storage can be emptied via 'm_flow_hydrogenDemand_constant' up to 'p_minLow_constantDemand'" annotation (Dialog(tab="General",  group="Controller"));
  parameter SI.MassFlowRate m_flow_hydrogenDemand_constant=0 "constant hydrogen demand if hydrogen is available" annotation (Dialog(tab="General",  group="Controller"));
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.MassFlowRate m_flow_ely_min(start=eps) "Minimal mass flow rate limited to eps"
                                                                                   annotation (Dialog(group="Initialization", showStartAttribute=true));
  Boolean storageFull=hysteresis.y "true if storage is full";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_ely "H2 mass flow out of the electrolyser" annotation (Placement(transformation(extent={{-120,-60},{-80,-20}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_feedIn "maximum mass flow that can be fed into the natural gas system" annotation (Placement(transformation(extent={{-120,20},{-80,60}})));
  Modelica.Blocks.Interfaces.RealOutput splitRatio "split ratio of the three way valve" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=p_maxLow, uHigh=p_maxHigh)
                                                annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,70})));
  TransiEnt.Basics.Interfaces.General.PressureIn p "Pressure in storage" annotation (Placement(transformation(extent={{11,-11},{-11,11}},
        rotation=90,
        origin={0,111}), iconTransformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,110})));
  Modelica.Blocks.Sources.RealExpression realExpression1
                                                        annotation (Placement(transformation(extent={{48,40},{58,52}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis1(uLow=-p_minHigh, uHigh=-p_minLow)        annotation (Placement(transformation(extent={{48,54},{58,64}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(extent={{68,54},{78,64}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=1)   annotation (Placement(transformation(extent={{48,66},{58,78}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{36,56},{42,62}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  m_flow_ely_min = max(eps,m_flow_ely); //always greater than zero => no division by zero in next equation
  if StoreAllHydrogen==true then
    splitRatio= 1;
  //else
  //  splitRatio=min(1,max(0,(m_flow_ely_min-(m_flow_feedIn))/m_flow_ely_min));
  else
    splitRatio=min(1,max(0,(m_flow_ely_min-(m_flow_feedIn))/m_flow_ely_min))+min(1,max(0,switch1.y));
  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(p,hysteresis. u) annotation (Line(points={{0,111},{0,111},{0,82},{8.88178e-016,82}}, color={0,0,127}));
  connect(hysteresis1.y, switch1.u2) annotation (Line(points={{58.5,59},{67,59}}, color={255,0,255}));
  connect(realExpression1.y, switch1.u3) annotation (Line(points={{58.5,46},{64,46},{64,55},{67,55}}, color={0,0,127}));
  connect(realExpression2.y,switch1. u1) annotation (Line(points={{58.5,72},{64,72},{64,63},{67,63}},       color={0,0,127}));
  connect(hysteresis1.u, gain.y) annotation (Line(points={{47,59},{42.3,59}}, color={0,0,127}));
  connect(p, gain.u) annotation (Line(points={{0,111},{0,90},{26,90},{26,59},{35.4,59}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a controller to control the split ratio in a three way valve which splits the mass flow coming from the electrolyzer into the mass flow into the storage and through the bypass around it. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>m_flow_feedIn: input for the possible feed-in mass flow into the natural grid etc. </p>
<p>m_flow_ely: input for the mass flow coming from the electrolyzer </p>
<p>splitRatio: output for the split ratio of the three way valve </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Carsten Bode (c.bode@tuhh.de) in April 2016</p>
</html>"));
end FeedInStorageTWVController;
