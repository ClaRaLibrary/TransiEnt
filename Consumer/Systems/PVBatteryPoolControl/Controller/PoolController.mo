within TransiEnt.Consumer.Systems.PVBatteryPoolControl.Controller;
model PoolController "Collects power potentials and distributes set power shares"

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

  extends TransiEnt.Basics.Icons.DiscreteBlock;
  extends TransiEnt.Basics.Icons.SystemOperator;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer Base.PoolParameter param;
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Base.PoolControlBus poolControlBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,0})));
  Modelica.Blocks.Sources.Constant P_PBB_set_const(k=param.P_el_pbp_total) "Constant setpoint " annotation (Placement(transformation(extent={{-13,35},{1,49}})));
  PBPDispatcher pbpDispatcher(final nout=param.nSystems, P_min_setpoint=param.P_pbp_increment) "Assign primary balancing power bandwidths to the available units" annotation (Placement(transformation(extent={{26,-12},{56,17}})));
  Modelica.Blocks.Sources.ContinuousClock clock annotation (Placement(transformation(extent={{-54,-70},{-34,-50}})));
  Modelica.Blocks.Discrete.ZeroOrderHold holdTradingDuration(samplePeriod=param.t_pbp_interval)
    annotation (Placement(transformation(extent={{-22,-70},{-2,-50}})));
  Modelica.Blocks.Math.RealToInteger realToInteger
    annotation (Placement(transformation(extent={{8,-70},{28,-50}})));

  // _____________________________________________
  //
  //           Variables
  // _____________________________________________

  SI.Power P_PBP_set_sum=sum(pbpDispatcher.P_el_PBP_setpoints);
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(holdTradingDuration.y, realToInteger.u) annotation (Line(
      points={{-1,-60},{6,-60}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(P_PBB_set_const.y, pbpDispatcher.P_el_pbp_set) annotation (Line(points={{1.7,42},{10,42},{10,12.65},{26,12.65}}, color={0,0,127}));

    connect(pbpDispatcher.P_el_PBP_setpoints, poolControlBus.P_el_set_pbp) annotation (Line(points={{57.2,2.5},{64,2.5},{64,-34},{-100,-34},{-100,-12},{-100.1,-12},{-100.1,0.1}},
                                                                                                                                                                                 color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));

  connect(clock.y, holdTradingDuration.u) annotation (Line(points={{-33,-60},{-28,-60},{-24,-60}}, color={0,0,127}));
  connect(realToInteger.y, pbpDispatcher.communicationTrigger) annotation (Line(points={{29,-60},{41,-60},{41,-12.87}}, color={255,127,0}));
  connect(poolControlBus.P_potential_pbp, pbpDispatcher.P_el_PBP_offer) annotation (Line(
      points={{-100.1,0.1},{-78,0.1},{-78,0},{26,0},{26,1.05}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
    annotation (Diagram(graphics,
                        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                 Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple primary balancing power (PBP) pool controller. Input is the PBP setpoint of the pool. Output is the individual setpoint for each unit in the pool (may be zero for units which are not needed).</p>
<p>The assignment uses the Pro-rata method i.e. the merit order list is sorted by the amount of PBP potential. Units with large offers are favoured over units with small offers.</p>
<p>The assignment is recalculated every time the communication trigger changes its value. For now no distinction between the two triggers is implemented but this could be used to e.g. stochastically change setpoint of individuals in pool within a trading period.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The pool controller does not know what the potential is within the communication intervall. This means that only in the distinct instance where the algorithm is running, it would produce a warning message in case the pool demand cant be met (see: TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Controller.Check.CheckPBPDispatcher)</p>
<p>In other words, the plant is responsible to provide the balancing power reserve starting from the point of time when the pool controller changes its setpoint and keep it for the entire communication intervall.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Controller.Check.CheckPoolController&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end PoolController;
