within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Controller;
model BatteryManagementSystem
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

  extends TransiEnt.Basics.Icons.DiscreteBlock;
  extends TransiEnt.Basics.Icons.SystemOperator;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer Base.PoolParameter param;

  // _____________________________________________
  //
  //                Parameters
  // _____________________________________________

  parameter Integer index(min=1, max=param.nSystems) "This systems index in pool";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_surplus "Surplus power (=-P_residual)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-98,100})));
  Base.PoolStoragePBPPotential P_PB_offer(index=index) annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
  Controller.BatteryConditioningController P_BatCond_set(index=index)
                                                         "Battery conditioning setpoint" annotation (Placement(transformation(extent={{64,4},{32,34}})));
  Modelica.Blocks.Math.Add3 P_set_total(
    k1=1,
    k2=1,
    k3=1)  annotation (Placement(transformation(extent={{7,45},{19,57}})));
  Base.PoolControlBus poolControlBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={120,18})));
  Basics.Blocks.RealToVector P_set_battery_bus(final nout=param.nSystems, index=index) "Place value in bus" annotation (Placement(transformation(extent={{82,46},{102,66}})));
  Basics.Blocks.RealToVector P_PB_offer_bus(final nout=param.nSystems, index=index) annotation (Placement(transformation(extent={{82,-30},{102,-10}})));
  Modelica.Blocks.Routing.Extractor
                                  P_el_set_pbp(final nin=param.nSystems,index(start=index, fixed=true)) annotation (Placement(transformation(extent={{102,-64},{82,-44}})));
  Modelica.Blocks.Math.Add P_el_max_net_bat(k2=-1) "Maximum battery power after pbp" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-120,10})));
  Modelica.Blocks.Sources.Constant P_el_max_bat(k=param.P_el_max_bat) annotation (Placement(transformation(extent={{-96,-22},{-108,-10}})));
  BatteryPrimaryBalancingController PBPController(P_n=param.P_el_pbp_total) "Primary balancing power controller" annotation (Placement(transformation(
        extent={{-15.5,-16},{15.5,16}},
        rotation=90,
        origin={-36,-13.5})));
  Modelica.Blocks.Routing.Extractor
                                  SOC(final nin=param.nSystems,index(start=index, fixed=true)) annotation (Placement(transformation(extent={{102,-94},{82,-74}})));
  Modelica.Blocks.Nonlinear.VariableLimiter P_set_battery_base(strict=true) "Base Setpoint for battery (maximum autarky)  considering pbp setpoint" annotation (Placement(transformation(extent={{-88,47},{-68,67}})));
  Modelica.Blocks.Math.Gain switchSign1(
                                      k=-1)
    annotation (Placement(transformation(extent={{-108,44},{-100,52}})));
  Modelica.Blocks.Math.Add P_set_base_total annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={18,-8})));

  Base.LimitConditioning P_set_limit_cond annotation (Placement(transformation(extent={{-58,46},{-38,66}})));
  Modelica.Blocks.Sources.IntegerConstant thisIndex(k=index) annotation (Placement(transformation(extent={{52,-72},{64,-60}})));
 TransiEnt.Basics.Interfaces.General.FrequencyIn delta_f  "Input signal connector"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-146,-78}), iconTransformation(extent={{-112,-88},{-72,-48}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_BatCond_set.P_el_cond_set, P_set_total.u3) annotation (Line(
      points={{31.04,19},{2,19},{2,46.2},{5.8,46.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_set_battery_bus.y, poolControlBus.P_el_set) annotation (Line(
      points={{103,56},{118,56},{118,18},{120,18}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(P_PB_offer_bus.y, poolControlBus.P_potential_pbp) annotation (Line(
      points={{103,-20},{108,-20},{108,18},{118,18},{118,17.9},{120.1,17.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(P_el_max_net_bat.u1, P_el_max_bat.y) annotation (Line(
      points={{-114,-2},{-114,-16},{-108.6,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(poolControlBus.P_el_set_pbp, P_el_set_pbp.u) annotation (Line(
      points={{120.1,17.9},{120.1,-54},{104,-54}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(PBPController.P_el_pbp_set, P_set_total.u2) annotation (Line(
      points={{-31.52,2.93},{-31.52,51},{5.8,51}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(poolControlBus.SOC, SOC.u) annotation (Line(
      points={{120,18},{120,-84},{104,-84}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(P_el_max_net_bat.y, P_set_battery_base.limit1) annotation (Line(
      points={{-120,21},{-120,65},{-90,65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_set_battery_base.limit2, switchSign1.y) annotation (Line(
      points={{-90,49},{-90,48},{-99.6,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_el_max_net_bat.y, switchSign1.u) annotation (Line(
      points={{-120,21},{-120,48},{-108.8,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_el_set_pbp.y, PBPController.P_el_pbp_band_set) annotation (Line(
      points={{81,-54},{-23.2,-54},{-23.2,-29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_el_set_pbp.y, P_el_max_net_bat.u2) annotation (Line(
      points={{81,-54},{-126,-54},{-126,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_set_base_total.y, P_PB_offer.P_is) annotation (Line(
      points={{24.6,-8},{44,-8},{44,-18},{46,-18},{46,-16.1},{50.3,-16.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_set_battery_base.y, P_set_limit_cond.P_set_base) annotation (Line(
      points={{-67,57},{-62,57},{-62,56.8},{-58.6,56.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_set_total.u1, P_set_limit_cond.P_set_limit) annotation (Line(
      points={{5.8,55.8},{-6,55.8},{-6,56},{-37,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SOC.y, P_set_limit_cond.SOC) annotation (Line(
      points={{81,-84},{-66,-84},{-66,52},{-58.6,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thisIndex.y, P_el_set_pbp.index) annotation (Line(points={{64.6,-66},{74,-66},{92,-66}}, color={255,127,0}));
  connect(thisIndex.y, SOC.index) annotation (Line(points={{64.6,-66},{74,-66},{74,-98},{92,-98},{92,-96}}, color={255,127,0}));
  connect(P_PB_offer.P_potential_PBP, P_PB_offer_bus.u) annotation (Line(points={{71,-20},{80,-20}},   color={0,0,127}));
  connect(P_BatCond_set.P_el_cond_set, P_set_base_total.u1) annotation (Line(points={{31.04,19},{2,19},{2,-4},{2,-4.4},{6,-4.4},{10.8,-4.4}},    color={0,0,127}));
  connect(P_set_limit_cond.P_set_limit, P_set_base_total.u2) annotation (Line(points={{-37,56},{-6,56},{-6,-12},{-6,-12},{2,-12},{2,-11.6},{10.8,-11.6}},color={0,0,127}));
  connect(delta_f, PBPController.delta_f) annotation (Line(points={{-146,-78},{-48.8,-78},{-48.8,-29}}, color={0,0,127}));
  connect(P_surplus, P_set_battery_base.u) annotation (Line(points={{-98,100},{-98,57},{-90,57}}, color={0,0,127}));
  connect(poolControlBus.SOC, P_BatCond_set.SOC_is) annotation (Line(
      points={{120,18},{63.68,18},{63.68,18.7}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(P_PB_offer.P_max_load_star, poolControlBus.P_max_load_star) annotation (Line(points={{50.1,-22.3},{32,-22.3},{32,-38},{120,-38},{120,18}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(P_PB_offer.P_max_unload_star, poolControlBus.P_max_unload_star) annotation (Line(points={{50.3,-26.9},{40,-26.9},{40,-36},{120,-36},{120,18}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(PBPController.SOC, SOC.y) annotation (Line(points={{-36,-29},{-36,-29},{-36,-84},{81,-84}}, color={0,0,127}));
  connect(P_set_total.y, P_set_battery_bus.u) annotation (Line(points={{19.6,51},{19.6,55},{80,55},{80,56}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{120,100}}), graphics={Text(
          extent={{-4,-78},{40,-82}},
          lineColor={28,108,200},
          textString="State of Charge (SOC) of battery"), Text(
          extent={{0,-48},{44,-52}},
          lineColor={28,108,200},
          textString="External primary balancing setpoint")}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Controller.Check.CheckBatteryManagementSystem&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end BatteryManagementSystem;
