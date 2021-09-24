within TransiEnt.Consumer.Systems.PVBatteryPoolControl.PVBatteryConsumer;
model PoolControlledBatterySystem "Battery system model with communication interface for pool control"

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

  extends TransiEnt.Basics.Icons.Battery;

  // _____________________________________________
  //
  //               Parameters
  // _____________________________________________
  outer Base.PoolParameter param;

  parameter Integer index=1 "Index of this system in pool";

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Blocks.Routing.Extractor  extractP_el_set(final nin=param.nSystems,index(start=index, fixed=true)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,0})));
  Base.PoolControlBus poolControlBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,98})));
  Basics.Blocks.RealToVector insertP_el_is(final nout=param.nSystems, index=index) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-34,40})));
  Basics.Blocks.RealToVector insertSOC(final nout=param.nSystems, index=index) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-34,70})));
  Modelica.Blocks.Sources.IntegerExpression thisIndex(y=index)
                                                              annotation (Placement(transformation(extent={{-84,-30},{-64,-10}})));
  replaceable Storage.Electrical.Base.Battery batterySystem(
    redeclare model StationaryLossModel = Storage.Base.NoStationaryLoss,
    redeclare model CostModel = TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.RedoxFlowBattery,
    StorageModelParams=Storage.Electrical.Specifications.LithiumIon(
        E_start=param.SOC_start*param.E_max_bat,
        E_max=param.E_max_bat,
        E_min=param.SOC_min*param.E_max_bat,
        P_max_unload=param.P_el_max_bat,
        P_max_load=param.P_el_max_bat,
        eta_unload=param.eta_max,
        eta_load=param.eta_max,
        selfDischargeRate=0)) constrainedby Storage.Electrical.Base.Battery annotation (choicesAllMatching=true, Placement(transformation(extent={{-28,-66},{28,-14}})));
  Modelica.Blocks.Sources.RealExpression SOC(y=batterySystem.storageModel.SOC) annotation (Placement(transformation(extent={{-76,60},{-56,80}})));
  Components.Sensors.ElectricActivePower P_is annotation (Placement(transformation(extent={{54,-50},{74,-30}})));
  Basics.Blocks.RealToVector insertP_max_unload_star(final nout=param.nSystems, index=index) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={26,70})));
  Basics.Blocks.RealToVector insertP_max_load_star(final nout=param.nSystems, index=index) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={26,40})));
  Modelica.Blocks.Sources.RealExpression P_max_unload_star(y=batterySystem.batteryPowerLimit.P_max_unload_star)
                                                                               annotation (Placement(transformation(extent={{86,58},{66,78}})));
  Modelica.Blocks.Sources.RealExpression P_max_load_star(y=batterySystem.batteryPowerLimit.P_max_load_star)
                                                                               annotation (Placement(transformation(extent={{76,30},{56,50}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(poolControlBus.P_el_set, extractP_el_set.u) annotation (Line(
      points={{0,98},{0,88},{-94,88},{-94,0},{-72,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(insertSOC.y, poolControlBus.SOC) annotation (Line(
      points={{-23,70},{0,70},{0,98}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(insertP_el_is.y, poolControlBus.P_el_is) annotation (Line(
      points={{-23,40},{0,40},{0,98}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(thisIndex.y, extractP_el_set.index) annotation (Line(points={{-63,-20},{-60,-20},{-60,-12}},
                                                                                             color={255,127,0}));
  connect(extractP_el_set.y, batterySystem.P_set) annotation (Line(points={{-49,0},{3.55271e-015,0},{3.55271e-015,-15.56}}, color={0,0,127}));
  connect(SOC.y, insertSOC.u) annotation (Line(points={{-55,70},{-46,70}}, color={0,0,127}));
  connect(batterySystem.epp, P_is.epp_IN) annotation (Line(
      points={{28,-40},{54.8,-40}},
      color={0,135,135},
      thickness=0.5));
  connect(P_is.epp_OUT, epp) annotation (Line(
      points={{73.4,-40},{100,-40}},
      color={0,135,135},
      thickness=0.5));
  connect(P_is.P, insertP_el_is.u) annotation (Line(points={{60.2,-32.2},{60.2,20},{-60,20},{-60,40},{-46,40}}, color={0,0,127}));
  connect(P_max_unload_star.y, insertP_max_unload_star.u) annotation (Line(points={{65,68},{50,68},{50,70},{38,70}},
                                                                                                     color={0,0,127}));
  connect(P_max_load_star.y, insertP_max_load_star.u) annotation (Line(points={{55,40},{38,40}}, color={0,0,127}));
  connect(insertP_max_unload_star.y, poolControlBus.P_max_unload_star) annotation (Line(points={{15,70},{0,70},{0,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(insertP_max_load_star.y, poolControlBus.P_max_load_star) annotation (Line(points={{15,40},{0,40},{0,98}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{1,3},{6,3}}));
  annotation (Diagram(graphics,
                      coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp: electric power port</p>
<p>poolControlBus</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end PoolControlledBatterySystem;
