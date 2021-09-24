within TransiEnt.Consumer.Systems.PVBatteryPoolControl.Controller;
model BatteryConditioningController

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
  //                 Outer Models
  // _____________________________________________

  outer Base.PoolParameter param;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  parameter Integer index(min=1, max=param.nSystems) "This systems index in pool";
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el_cond_set "Setpoint of conditioing controller" annotation (Placement(transformation(extent={{96,-10},{116,10}}), iconTransformation(extent={{96,-10},{116,10}})));

  Modelica.Blocks.Interfaces.RealInput SOC_is[param.nSystems] annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-108,84}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-98,-2})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Sources.Constant constP_el_cond(k=param.P_el_cond)
    annotation (Placement(transformation(extent={{-24,8},{-4,28}})));
  Modelica.Blocks.Sources.Constant zero(k=0)
    annotation (Placement(transformation(extent={{-24,-46},{-4,-26}})));

  Modelica.Blocks.Routing.Extractor
                             extractSOC(nin=param.nSystems,index(start=index, fixed=true))
    annotation (Placement(transformation(extent={{-68,74},{-48,94}})));
  Modelica.Blocks.Discrete.ZeroOrderHold Orderblock(samplePeriod=param.t_trading_intraday)
    annotation (Placement(transformation(extent={{-38,72},{-18,92}})));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold=
        param.SOC_min)
    annotation (Placement(transformation(extent={{0,72},{20,92}})));
  Modelica.Blocks.Logical.And isConditioiningActiveAndNeeded annotation (Placement(transformation(extent={{34,72},{54,92}})));
  Modelica.Blocks.Logical.Switch
         switch1
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.IntegerExpression thisIndex(y=index)
                                                              annotation (Placement(transformation(extent={{-86,42},{-66,62}})));
  Modelica.Blocks.Sources.BooleanExpression isConditioningActive(y=param.useBatteryConditioning) annotation (Placement(transformation(extent={{2,42},{22,62}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(extractSOC.y, Orderblock.u) annotation (Line(
      points={{-47,84},{-44,84},{-44,82},{-40,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Orderblock.y, lessEqualThreshold.u) annotation (Line(
      points={{-17,82},{-2,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lessEqualThreshold.y, isConditioiningActiveAndNeeded.u1) annotation (Line(
      points={{21,82},{32,82}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(zero.y, switch1.u3) annotation (Line(
      points={{-3,-36},{4,-36},{4,-8},{18,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(constP_el_cond.y, switch1.u1) annotation (Line(
      points={{-3,18},{4,18},{4,8},{18,8}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(thisIndex.y, extractSOC.index) annotation (Line(points={{-65,52},{-58,52},{-58,72}}, color={255,127,0}));
  connect(isConditioningActive.y, isConditioiningActiveAndNeeded.u2) annotation (Line(points={{23,52},{28,52},{28,74},{32,74}}, color={255,0,255}));
  connect(isConditioiningActiveAndNeeded.y, switch1.u2) annotation (Line(points={{55,82},{72,82},{72,38},{-46,38},{-46,4},{-46,0},{18,0}}, color={255,0,255}));
  connect(switch1.y, P_el_cond_set) annotation (Line(points={{41,0},{106,0},{106,0}}, color={0,0,127}));
  connect(extractSOC.u, SOC_is) annotation (Line(points={{-70,84},{-108,84},{-108,84}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                           Diagram(graphics,
                                                   coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This controller can be used to add a conditioning setpoint to a battery system. If the state of charge (SOC) falls below a defined threshold it produces a constant setpoint which is applied during at least one trading period (e.g. 15 Minutes for intraday trading). This way an empty storage can be prevented.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Simple controller model without physical modeling</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The controller does not check if the the battery can actually follow the setpoint. For example if the capacity of the battery is smaller than the trading period times the conditionning setpoint, the battery would be full and the setpoint would not be possilbe any more.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_el_cond_set: Setpoint for the battery system. Is supposed to be added to the normal battery controller.</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>No local states or variables.</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>None</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The control output is supposed to be added to a more general battery controller</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>See TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Controller.Check.CheckBatteryConditioiningController</p>
<p>for technical validation.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>None</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 27.03.2017</span></p>
</html>"));
end BatteryConditioningController;
