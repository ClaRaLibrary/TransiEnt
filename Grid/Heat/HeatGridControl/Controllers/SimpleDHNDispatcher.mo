within TransiEnt.Grid.Heat.HeatGridControl.Controllers;
model SimpleDHNDispatcher


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  extends TransiEnt.Basics.Icons.SystemOperator;

  // _____________________________________________
  //
  //          Components
  // _____________________________________________

  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345(datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic) annotation (Placement(transformation(extent={{-97,24},{-77,44}})));
//  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingLoadCharline heatingLoadCharline(CharLine=HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH()) annotation (Placement(transformation(extent={{-67,27},{-47,47}})));
  TransiEnt.Grid.Heat.HeatGridControl.Controllers.DHNPowerScheduler_L0 dHN_PowerScheduler_L1 annotation (Placement(transformation(extent={{17,-17},{63,21}})));
  TransiEnt.Basics.Blocks.HoldBlock holdBlock annotation (Placement(transformation(extent={{17,35},{37,55}})));
  TransiEnt.Basics.Tables.ElectricGrid.ElectricityPrices.SpotPriceElectricity_Phelix_3600s_2012 spotPriceElectricity_Phelix_3600s_2012_1 annotation (Placement(transformation(extent={{-27,35},{-7,55}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el_WT
    annotation (Placement(transformation(extent={{100,62},{120,82}})));
  Modelica.Blocks.Math.MultiSum PoutWWsum(nu=2, k={-1,-1})
    annotation (Placement(transformation(extent={{74,-2},{86,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el_WW
    annotation (Placement(transformation(extent={{100,4},{120,24}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_WT
    annotation (Placement(transformation(extent={{100,42},{120,62}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_WW
    annotation (Placement(transformation(extent={{100,-32},{120,-12}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_WT
    annotation (Placement(transformation(extent={{100,22},{120,42}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_WW
    annotation (Placement(transformation(extent={{100,-58},{120,-38}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_peak
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Math.Gain sign(k=-1)
    annotation (Placement(transformation(extent={{80,66},{92,78}})));
  Modelica.Blocks.Math.Gain sign1(k=-1)
    annotation (Placement(transformation(extent={{82,46},{94,58}})));
  Modelica.Blocks.Math.Gain sign2(k=-1)
    annotation (Placement(transformation(extent={{82,-28},{94,-16}})));
  Modelica.Blocks.Math.Gain sign3(k=-1)
    annotation (Placement(transformation(extent={{82,26},{94,38}})));
  Modelica.Blocks.Math.Gain sign4(k=-1)
    annotation (Placement(transformation(extent={{82,-54},{94,-42}})));
  Modelica.Blocks.Math.Gain sign5(k=-1)
    annotation (Placement(transformation(extent={{82,-86},{94,-74}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_peak
    annotation (Placement(transformation(extent={{100,-108},{120,-88}})));
  Modelica.Blocks.Math.Gain sign6(k=-1)
    annotation (Placement(transformation(extent={{72,-104},{84,-92}})));
  TransiEnt.Grid.Heat.HeatGridControl.SupplyAndReturnTemperatureDHG supplyandReturnTemperature annotation (Placement(transformation(extent={{-82,-26},{-62,-6}})));
  DHG_FeedForward_Controller dHG_FeedForward_Controller annotation (Placement(transformation(extent={{-52,-10},{-22,10}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_center(y=(dHG_FeedForward_Controller.m_flow_i[3] + dHG_FeedForward_Controller.m_flow_i[4])*dHG_FeedForward_Controller.delta_h.y)
                                                                                                                                          annotation (Placement(transformation(extent={{34,-88},{54,-68}})));
  Modelica.Blocks.Sources.RealExpression m_flow_center(y=dHG_FeedForward_Controller.m_flow_i[3] + dHG_FeedForward_Controller.m_flow_i[4]) annotation (Placement(transformation(extent={{34,-106},{54,-86}})));
  HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline(CharLine=HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH(), SummerDayTypicalHeatLoadCharLine=true) annotation (Placement(transformation(extent={{-68,36},{-48,56}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(temperatureHH_900s_01012012_0000_31122012_2345.y1, heatingLoadCharline.T_amb) annotation (Line(
      points={{-76,34},{-76,35.5},{-69,35.5},{-69,47}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(holdBlock.u,spotPriceElectricity_Phelix_3600s_2012_1. y1) annotation (
     Line(
      points={{15,45},{4,45},{4,45},{-6,45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHN_PowerScheduler_L1.spotPrice,holdBlock. y) annotation (Line(
      points={{40,22.9},{40,45},{38,45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHN_PowerScheduler_L1.P_out_WW1, PoutWWsum.u[1]) annotation (Line(
      points={{65.3,7.7},{73.65,7.7},{73.65,6.1},{74,6.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHN_PowerScheduler_L1.P_out_WW2, PoutWWsum.u[2]) annotation (Line(
      points={{65.3,0.1},{73.65,0.1},{73.65,1.9},{74,1.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PoutWWsum.y, P_el_WW) annotation (Line(
      points={{87.02,4},{98,4},{98,14},{110,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHN_PowerScheduler_L1.P_out_WT, sign.u) annotation (Line(
      points={{65.3,15.3},{74,15.3},{74,72},{78.8,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sign.y, P_el_WT) annotation (Line(
      points={{92.6,72},{110,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sign1.y, Q_flow_WT) annotation (Line(
      points={{94.6,52},{110,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sign3.y, m_flow_WT) annotation (Line(
      points={{94.6,32},{110,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sign2.y, Q_flow_WW) annotation (Line(
      points={{94.6,-22},{110,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sign4.y, m_flow_WW) annotation (Line(
      points={{94.6,-48},{110,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sign5.y, Q_flow_peak) annotation (Line(
      points={{94.6,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sign6.y, m_flow_peak) annotation (Line(
      points={{84.6,-98},{110,-98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureHH_900s_01012012_0000_31122012_2345.y1, supplyandReturnTemperature.T_amb) annotation (Line(points={{-76,34},{-84,34},{-84,-16}}, color={0,0,127}));
  connect(heatingLoadCharline.Q_flow, dHG_FeedForward_Controller.Q_dot_DH_Targ) annotation (Line(
      points={{-47,46},{-42,46},{-42,11},{-36,11}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(temperatureHH_900s_01012012_0000_31122012_2345.value, dHG_FeedForward_Controller.T_ambient) annotation (Line(points={{-78.2,34},{-64,34},{-64,0},{-47,0}}, color={0,0,127}));
  connect(dHG_FeedForward_Controller.Q_flow_i[1], dHN_PowerScheduler_L1.Q_flow_Target_WT) annotation (Line(points={{-21,5.8},{-3.5,5.8},{-3.5,11.5},{14.7,11.5}}, color={0,0,127}));
  connect(dHG_FeedForward_Controller.Q_flow_i[1], sign1.u) annotation (Line(points={{-21,5.8},{-21,24},{-34,24},{-34,68},{66,68},{66,52},{80.8,52}}, color={0,0,127}));
  connect(dHG_FeedForward_Controller.m_flow_i[1], sign3.u) annotation (Line(points={{-21,-4.8},{-4,-4.8},{-4,-36},{-106,-36},{-106,62},{62,62},{62,32},{80.8,32}}, color={0,0,127}));
  connect(dHG_FeedForward_Controller.Q_flow_i[2], dHN_PowerScheduler_L1.Q_flow_Target_WW) annotation (Line(points={{-21,5.8},{-8,5.8},{10,5.8},{10,-7.5},{14.7,-7.5}}, color={0,0,127}));
  connect(dHG_FeedForward_Controller.Q_flow_i[2], sign2.u) annotation (Line(points={{-21,5.8},{10,5.8},{10,-22},{80.8,-22}}, color={0,0,127}));
  connect(dHG_FeedForward_Controller.m_flow_i[2], sign4.u) annotation (Line(points={{-21,-4.8},{-21,-4},{2,-4},{2,-48},{80.8,-48}}, color={0,0,127}));
  connect(Q_flow_center.y, sign5.u) annotation (Line(points={{55,-78},{68,-78},{68,-80},{80.8,-80}}, color={0,0,127}));
  connect(m_flow_center.y, sign6.u) annotation (Line(points={{55,-96},{62,-96},{62,-98},{70.8,-98}}, color={0,0,127}));
  connect(temperatureHH_900s_01012012_0000_31122012_2345.y1, heatingLoadCharline.T_amb) annotation (Line(points={{-76,34},{-74,34},{-74,40},{-72,40},{-72,47},{-69,47}}, color={0,0,127}));
  connect(heatingLoadCharline.Q_flow, dHG_FeedForward_Controller.Q_dot_DH_Targ) annotation (Line(
      points={{-47,46},{-36,46},{-36,11}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  annotation (Diagram(graphics,
                      coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false)),                               Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-16,46},{56,-16}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-7,51},{7,-51}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={1,-35},
          rotation=90,
          pattern=LinePattern.None)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Sets heat and mass flow as well as supply and return temperature according to outside temperature and charline of the city.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Uses DHNPowerScheduler_L0 to determine Power of CHPs depending on the heat demand.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_WT: output for electric power in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_WW: output for electric power in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_WT: output for heat flow rate in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_WW: output for heat flow rate in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">m_flow_WT: output for mass flow rate in [kg/s]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">m_flow_WW: output for mass flow rate in [kg/s]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_peak: output for heat flow rate in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">m_flow_peak: output for mass flow rate in [kg/s]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end SimpleDHNDispatcher;
