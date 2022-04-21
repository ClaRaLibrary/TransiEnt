within TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Check;
model TestEnergyConverter_All



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





  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter(
    redeclare Basics.Tables.HeatGrid.HeatingCurves.HeatingCurveEnergieverbundWilhelmsburgMitte heatingCurve,
    useHomotopy=true,
    redeclare TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_3600s_TMY temperature,
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_3600s_TMY wind)) annotation (Placement(transformation(extent={{-108,100},{-88,120}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  TransiEnt.Basics.Tables.Combined.HouseholdConsumption householdConsumer1(redeclare TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables demand_combined) annotation (Placement(transformation(extent={{-100,14},{-80,34}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage apparentPower(Use_input_connector_f=false, Use_input_connector_v=false) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-105,-77})));
  EnergyConverter EC_boiler(redeclare Systems.Boiler systems(useGasPort=true)) annotation (Placement(transformation(extent={{-100,-4},{-80,16}})));
  TransiEnt.Components.Electrical.Grid.PiModel Cable(l=5) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-105,-53})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource annotation (Placement(transformation(extent={{42,-78},{26,-62}})));

  TransiEnt.Basics.Tables.Combined.HouseholdConsumption consumer2(redeclare TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables demand_combined) annotation (Placement(transformation(extent={{-74,14},{-54,34}})));
  EnergyConverter EC_pV_boiler(redeclare Systems.PV_Boiler systems(waterHeating="electrical")) annotation (Placement(transformation(extent={{-74,-4},{-54,16}})));
  TransiEnt.Basics.Tables.Combined.HouseholdConsumption consumer3(redeclare TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables demand_combined) annotation (Placement(transformation(extent={{-50,14},{-30,34}})));
  EnergyConverter EC_solarHeating_boiler(redeclare Systems.solarThermal_Boiler systems(useGasPort=true, SpaceHeating=false)) annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
  EnergyConverter EC_cHP_boiler(redeclare Systems.CHP_Boiler_Storage systems) annotation (Placement(transformation(extent={{-24,-4},{-4,16}})));
  TransiEnt.Basics.Tables.Combined.HouseholdConsumption consumer4(redeclare TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables demand_combined) annotation (Placement(transformation(extent={{-24,14},{-4,34}})));
  EnergyConverter EC_pV_boiler_elHeater(redeclare Systems.PV_elHeater systems) annotation (Placement(transformation(extent={{2,-4},{22,16}})));
  TransiEnt.Basics.Tables.Combined.HouseholdConsumption consumer5(redeclare TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables demand_combined) annotation (Placement(transformation(extent={{2,14},{22,34}})));
  TransiEnt.Basics.Tables.Combined.HouseholdConsumption consumer6(redeclare TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables demand_combined) annotation (Placement(transformation(extent={{26,14},{46,34}})));
  EnergyConverter EC_heatPump(redeclare Systems.HeatPump systems) annotation (Placement(transformation(extent={{26,-4},{46,16}})));
  TransiEnt.Basics.Tables.Combined.HouseholdConsumption consumer7(redeclare TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables demand_combined) annotation (Placement(transformation(extent={{76,14},{96,34}})));
  EnergyConverter EC_dHN(redeclare Systems.DHN_Substation systems) annotation (Placement(transformation(extent={{76,-4},{96,16}})));
  TransiEnt.Basics.Tables.Combined.HouseholdConsumption consumer8(redeclare TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables demand_combined) annotation (Placement(transformation(extent={{50,14},{70,34}})));
  EnergyConverter EC_pV_heatPump(redeclare Systems.PV_HeatPump systems) annotation (Placement(transformation(extent={{50,-4},{70,16}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(p_const=simCenter.p_nom[2], T_const(displayUnit="degC") = 338.15) annotation (Placement(transformation(extent={{44,-52},{60,-36}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi1(p_const=simCenter.p_nom[1], T_const(displayUnit="degC") = 308.15) annotation (Placement(transformation(
        extent={{7,-8},{-7,8}},
        rotation=270,
        origin={89,-54})));

equation

  connect(apparentPower.epp, Cable.epp_p) annotation (Line(
      points={{-105,-70},{-104.965,-70},{-104.965,-60},{-105,-60}},
      color={0,127,0},
      thickness=0.5));
  connect(Cable.epp_n, EC_boiler.epp) annotation (Line(
      points={{-105,-46},{-106,-46},{-106,-16},{-98,-16},{-98,0},{-97.8,0}},
      color={0,127,0},
      thickness=0.5));
  connect(gasSource.gasPort, EC_boiler.gasPortIn) annotation (Line(
      points={{26,-70},{-82,-70},{-82,0.1},{-82.1,0.1}},
      color={255,255,0},
      thickness=1.5));
  connect(EC_pV_boiler.gasPortIn, gasSource.gasPort) annotation (Line(
      points={{-56.1,0.1},{-56.1,-70},{26,-70}},
      color={255,255,0},
      thickness=1.5));
  connect(EC_solarHeating_boiler.gasPortIn, gasSource.gasPort) annotation (Line(
      points={{-32.1,0.1},{-32.1,-34},{-32,-34},{-32,-70},{26,-70}},
      color={255,255,0},
      thickness=1.5));
  connect(EC_cHP_boiler.gasPortIn, gasSource.gasPort) annotation (Line(
      points={{-6.1,0.1},{-6.1,-70},{26,-70}},
      color={255,255,0},
      thickness=1.5));
  connect(EC_pV_boiler_elHeater.gasPortIn, gasSource.gasPort) annotation (Line(
      points={{19.9,0.1},{19.9,-70},{26,-70}},
      color={255,255,0},
      thickness=1.5));
  connect(Cable.epp_n, EC_pV_boiler.epp) annotation (Line(
      points={{-105,-46},{-104,-46},{-104,-16},{-71.8,-16},{-71.8,0}},
      color={0,127,0},
      thickness=0.5));
  connect(Cable.epp_n, EC_solarHeating_boiler.epp) annotation (Line(
      points={{-105,-46},{-106,-46},{-106,-16},{-47.8,-16},{-47.8,0}},
      color={0,127,0},
      thickness=0.5));
  connect(Cable.epp_n, EC_cHP_boiler.epp) annotation (Line(
      points={{-105,-46},{-104,-46},{-104,-16},{-22,-16},{-22,-8},{-21.8,-8},{-21.8,0}},
      color={0,127,0},
      thickness=0.5));
  connect(Cable.epp_n, EC_pV_boiler_elHeater.epp) annotation (Line(
      points={{-105,-46},{-106,-46},{-106,-16},{4.2,-16},{4.2,0}},
      color={0,127,0},
      thickness=0.5));
  connect(EC_heatPump.epp, Cable.epp_n) annotation (Line(
      points={{28.2,0},{28.2,-16},{-105,-16},{-105,-46}},
      color={0,127,0},
      thickness=0.5));
  connect(EC_pV_heatPump.epp, Cable.epp_n) annotation (Line(
      points={{52.2,0},{52.2,-16},{-105,-16},{-105,-46}},
      color={0,127,0},
      thickness=0.5));
  connect(EC_dHN.epp, Cable.epp_n) annotation (Line(
      points={{78.2,0},{78.2,-16},{-105,-16},{-105,-46}},
      color={0,127,0},
      thickness=0.5));
  connect(consumer7.demand, EC_dHN.demand) annotation (Line(
      points={{86.2,19.8},{86.2,15.9},{86.1,15.9},{86.1,9.1}},
      color={95,95,95},
      pattern=LinePattern.Dash));
  connect(consumer8.demand, EC_pV_heatPump.demand) annotation (Line(
      points={{60.2,19.8},{60.2,13.9},{60.1,13.9},{60.1,9.1}},
      color={95,95,95},
      pattern=LinePattern.Dash));
  connect(consumer6.demand, EC_heatPump.demand) annotation (Line(
      points={{36.2,19.8},{36.2,12.9},{36.1,12.9},{36.1,9.1}},
      color={95,95,95},
      pattern=LinePattern.Dash));
  connect(consumer5.demand, EC_pV_boiler_elHeater.demand) annotation (Line(
      points={{12.2,19.8},{12.2,14.9},{12.1,14.9},{12.1,9.1}},
      color={95,95,95},
      pattern=LinePattern.Dash));
  connect(consumer4.demand, EC_cHP_boiler.demand) annotation (Line(
      points={{-13.8,19.8},{-13.8,13.9},{-13.9,13.9},{-13.9,9.1}},
      color={95,95,95},
      pattern=LinePattern.Dash));
  connect(consumer3.demand, EC_solarHeating_boiler.demand) annotation (Line(
      points={{-39.8,19.8},{-39.8,13.9},{-39.9,13.9},{-39.9,9.1}},
      color={95,95,95},
      pattern=LinePattern.Dash));
  connect(consumer2.demand, EC_pV_boiler.demand) annotation (Line(
      points={{-63.8,19.8},{-63.8,14.9},{-63.9,14.9},{-63.9,9.1}},
      color={95,95,95},
      pattern=LinePattern.Dash));
  connect(EC_dHN.waterPortIn, boundaryVLE_pTxi.steam_a) annotation (Line(
      points={{84.4,0},{84,0},{84,-44},{60,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(EC_dHN.waterPortOut, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{87.8,0},{88,0},{88,-47},{89,-47}},
      color={175,0,0},
      thickness=0.5));
  connect(householdConsumer1.demand, EC_boiler.demand) annotation (Line(
      points={{-89.8,19.8},{-89.8,12.9},{-89.9,12.9},{-89.9,9.1}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}}), graphics={
        Text(
          extent={{-96,52},{-84,42}},
          lineColor={28,108,200},
          textString="Gas 
boiler"),
        Text(
          extent={{-70,54},{-58,44}},
          lineColor={28,108,200},
          textString="PV+
gas 
boiler"),
        Text(
          extent={{-44,62},{-32,52}},
          lineColor={28,108,200},
          textString="Solar 
heating 
+
gas 
boiler"),
        Text(
          extent={{-16,60},{-6,50}},
          lineColor={28,108,200},
          textString="CHP
+
gas 
boiler"),
        Text(
          extent={{4,70},{16,60}},
          lineColor={28,108,200},
          textString="PV
+
gas 
boiler
+
electric
heater"),
        Text(
          extent={{30,52},{42,42}},
          lineColor={28,108,200},
          textString="Heat
pump"), Text(
          extent={{54,58},{66,48}},
          lineColor={28,108,200},
          textString="PV
+
Heat
pump"), Text(
          extent={{80,52},{92,42}},
          lineColor={28,108,200},
          textString="District
Heating"),
        Text(
          extent={{-72,-84},{82,-142}},
          textColor={28,108,200},
          textString="Look at and compare epp.P, gasPortIn.m_flow and 
demand of different energy converters
")}),
    experiment(
      StopTime=1864000,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test model for the EnergyConverter.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>(none)</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2019</span></p>
</html>"));
end TestEnergyConverter_All;
