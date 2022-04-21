within TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Check;
model TestSmallScaleCHP_simple_with_control


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

  Control.ControlBoilerCHP_modulatingBoiler_HeatLed Controller(Q_n_CHP=8000, Q_n_Boiler=15000) annotation (Placement(transformation(extent={{-84,-2},{-64,18}})));
  SmallScaleCHP_simple smallScaleCHP_simple1(
    useGasPort=true,
    useFluidPorts=false,
    useHeatPort=false,
    change_sign=true) annotation (Placement(transformation(extent={{-28,-4},{-2,22}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi annotation (Placement(transformation(extent={{40,-84},{20,-64}})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{78,-76},{98,-56}})));
  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L2.HotWaterStorage_constProp_L2 Storage(
    useFluidPorts=false,
    height=2,
    d=0.5) annotation (Placement(transformation(extent={{48,26},{68,46}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{20,26},{38,44}})));
  Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler gasBoilerGasAdaptive(
    useFluidPorts=false,
    useHeatPort=false,
    change_sign=true,
    integrateHeatFlow=false) annotation (Placement(transformation(extent={{-56,-36},{-36,-16}})));
  Basics.Tables.Combined.HouseholdConsumption consumer(redeclare Basics.Tables.Combined.CombinedTables.Demand_3Tables demand_combined(
      relativepath_el="electricity/Household/ElectricityDemand_20Households_measured_5-6MWh_3600s.csv",
      relativepath_heating="heat/Household/Heating_SLP_TMY-Hamburg_HMF_35MWh_3600s.txt",
      relativepath_dhw="heat/Household/HotWater_20Households_VEDIS_3MWh_60s.txt")) annotation (Placement(transformation(extent={{62,74},{82,94}})));
  Modelica.Blocks.Sources.RealExpression Q_Demand1(y=consumer.demand.heatingPowerDemand) annotation (Placement(transformation(extent={{100,26},{82,44}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-92,78},{-72,98}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-56,78},{-36,98}})));

equation

  connect(smallScaleCHP_simple1.gasPortIn,boundary_pTxi. gasPort) annotation (Line(
      points={{-2,3.8},{20,3.8},{20,-74}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid.epp,smallScaleCHP_simple1. epp) annotation (Line(
      points={{78,-66},{46,-66},{46,-32},{16,-32},{16,-1.14},{-2.26,-1.14}},
      color={0,135,135},
      thickness=0.5));
  connect(Storage.SoC, Controller.SoC) annotation (Line(points={{59.8,45.6},{60,45.6},{60,54},{-88,54},{-88,8},{-83.8,8}}, color={0,0,127}));
  connect(Controller.Q_flow_set_CHP, smallScaleCHP_simple1.Q_flow_set) annotation (Line(
      points={{-63.5,7.9},{-28,7.9},{-28,9}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(Controller.Q_flow_set_boiler, gasBoilerGasAdaptive.Q_flow_set) annotation (Line(
      points={{-63.5,0.3},{-63.5,-7.85},{-46,-7.85},{-46,-16}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(gasBoilerGasAdaptive.Q_flow_gen,add. u1) annotation (Line(
      points={{-35,-29.2},{-38,-29.2},{-38,40.4},{18.2,40.4}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(smallScaleCHP_simple1.Q_flow_gen,add. u2) annotation (Line(
      points={{-0.96,10.82},{12,10.82},{12,30},{18.2,30},{18.2,29.6}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(boundary_pTxi.gasPort,gasBoilerGasAdaptive. gasIn) annotation (Line(
      points={{20,-74},{20,-36},{-45.8,-36}},
      color={255,255,0},
      thickness=1.5));
  connect(add.y, Storage.Q_flow_store) annotation (Line(points={{38.9,35},{48.6,36}}, color={0,0,127}));
  connect(Storage.Q_flow_demand, Q_Demand1.y) annotation (Line(
      points={{68,36},{68,35},{81.1,35}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=4320000,
      Interval=900.00288,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for small scale CHP in combination with controller.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4.Interfaces</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
</html>"));
end TestSmallScaleCHP_simple_with_control;
