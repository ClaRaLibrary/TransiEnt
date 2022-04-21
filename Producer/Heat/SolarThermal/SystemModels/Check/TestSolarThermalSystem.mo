within TransiEnt.Producer.Heat.SolarThermal.SystemModels.Check;
model TestSolarThermalSystem



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

  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter(ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Berlin_3600s_2012 temperature,
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_3600s_TMY wind)) annotation (Placement(transformation(extent={{-84,78},{-64,98}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Producer.Heat.SolarThermal.SystemModels.SolarThermalSystem_5LayerStorage solarThermalSystem_5LayerStorage annotation (Placement(transformation(extent={{-22,-34},{8,-8}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource annotation (Placement(transformation(
        extent={{11,-12},{-11,12}},
        rotation=270,
        origin={36,-83})));
  Modelica.Blocks.Sources.Ramp ramp1(
    startTime=3600,
    duration=36000,
    height=2e3,
    offset=5e3) annotation (Placement(transformation(extent={{-52,50},{-32,70}})));

  Modelica.Blocks.Sources.Constant const(k=2e3) annotation (Placement(transformation(extent={{2,50},{22,70}})));

  TransiEnt.Producer.Heat.SolarThermal.SystemModels.SolarThermalSystem_10LayerStorage solarThermalSystem_10LayerStorage1 annotation (Placement(transformation(extent={{24,-36},{62,-4}})));
  TransiEnt.Producer.Heat.SolarThermal.SystemModels.SolarThermalSystem_3LayerStorage solarThermalSystem_3LayerStorage annotation (Placement(transformation(extent={{-72,-34},{-44,-8}})));
equation

  connect(gasSource.gasPort, solarThermalSystem_5LayerStorage.gasPortIn) annotation (Line(
      points={{36,-72},{38,-72},{38,-46},{1.86364,-46},{1.86364,-33.87}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp1.y, solarThermalSystem_5LayerStorage.Q_flow_demand_heating) annotation (Line(points={{-31,60},{-13.6818,60},{-13.6818,-8.65}}, color={0,0,127}));
  connect(const.y, solarThermalSystem_5LayerStorage.Q_flow_demand_hotwater) annotation (Line(points={{23,60},{36,60},{36,2},{-2.77273,2},{-2.77273,-8.65}}, color={0,0,127}));
  connect(ramp1.y, solarThermalSystem_3LayerStorage.Q_flow_demand_heating) annotation (Line(points={{-31,60},{-22,60},{-22,10},{-64,10},{-64,-8.65},{-63.46,-8.65}}, color={0,0,127}));
  connect(ramp1.y, solarThermalSystem_10LayerStorage1.Q_flow_demand_heating) annotation (Line(points={{-31,60},{-6,60},{-6,8},{38,8},{38,-7.07692},{39.3267,-7.07692}}, color={0,0,127}));
  connect(const.y, solarThermalSystem_3LayerStorage.Q_flow_demand_hotwater) annotation (Line(points={{23,60},{28,60},{28,16},{-20,16},{-20,0},{-56,0},{-56,-8.65},{-52.26,-8.65}}, color={0,0,127}));
  connect(const.y, solarThermalSystem_10LayerStorage1.Q_flow_demand_hotwater) annotation (Line(points={{23,60},{48,60},{48,-7.07692},{49.46,-7.07692}}, color={0,0,127}));
  connect(solarThermalSystem_3LayerStorage.gasPortIn, gasSource.gasPort) annotation (Line(
      points={{-47.5,-33.87},{-44,-33.87},{-44,-30},{-36,-30},{-36,-48},{36,-48},{36,-72}},
      color={255,255,0},
      thickness=1.5));
  connect(solarThermalSystem_10LayerStorage1.gasPortIn, gasSource.gasPort) annotation (Line(
      points={{57.5667,-35.6308},{57.5667,-35.8846},{36,-35.8846},{36,-72}},
      color={255,255,0},
      thickness=1.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=864000),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for SolarThermalSystem</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestSolarThermalSystem;
