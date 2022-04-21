within TransiEnt.SystemGeneration.Superstructure.Components.Controller;
model ControlPowerPlant



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

  extends Base.ControlPowerPlant_Base;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Time failure1_powerPlant_table[:,:]=[0,1; 1,1; 2,1; 3,1; 4,1] "failure of powerplant" annotation (dialog(tab="Failures"));
  parameter Modelica.Units.SI.Time failure2_powerPlant_table[:,:]=[0,1; 1,1; 2,1; 3,1; 4,1] "failure of powerplant 2" annotation (dialog(tab="Failures"));
  parameter Modelica.Units.SI.Time failure3_powerPlant_table[:,:]=[0,1; 1,1; 2,1; 3,1; 4,1] "failure of powerplant 3" annotation (dialog(tab="Failures"));
  parameter Modelica.Units.SI.Time failure4_powerPlant_table[:,:]=[0,1; 1,1; 2,1; 3,1; 4,1] "failure of powerplant 4" annotation (dialog(tab="Failures"));
  parameter Modelica.Units.SI.Time failure5_powerPlant_table[:,:]=[0,1; 1,1; 2,1; 3,1; 4,1] "failure of powerplant 5" annotation (dialog(tab="Failures"));

  parameter Modelica.Units.SI.Pressure p_min;
  parameter Modelica.Units.SI.Pressure p_min_backin;
  parameter Real[DifferentTypesOfPowerPlants] powerPlants_P_el_n;

  parameter Integer n_gasPortOut_split=1 annotation (Dialog(group="GasPortSplitter"));
  parameter Real splitRatio[max(1, n_gasPortOut_split)]={0.1} annotation (Dialog(group="GasPortSplitter"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set_in[DifferentTypesOfPowerPlants] if DifferentTypesOfPowerPlants >= 1 annotation (Placement(transformation(rotation=0, extent={{-124,-12},{-101,11}})));
  Modelica.Blocks.Interfaces.RealOutput P_max_PowerPlant_out[DifferentTypesOfPowerPlants] annotation (Placement(transformation(rotation=0, extent={{99,35},{109,45}})));
  Modelica.Blocks.Interfaces.RealOutput P_el_set_out[DifferentTypesOfPowerPlants] annotation (Placement(transformation(rotation=0, extent={{100,-44},{110,-34}})));
  Modelica.Blocks.Interfaces.RealInput p_gas[n_gasPortOut_split] if DifferentTypesOfPowerPlants >= 1 annotation (Placement(transformation(rotation=0, extent={{-124,-52},{-101,-29}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_max_PowerPlant_in[DifferentTypesOfPowerPlants] if DifferentTypesOfPowerPlants >= 1 annotation (Placement(transformation(rotation=0, extent={{-124,28},{-101,51}})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  FailureController_internal failureController_internal(
    quantity=DifferentTypesOfPowerPlants,
    failure1_table=failure1_powerPlant_table,
    failure2_table=failure2_powerPlant_table,
    failure3_table=failure3_powerPlant_table,
    failure4_table=failure4_powerPlant_table,
    failure5_table=failure5_powerPlant_table) annotation (Placement(transformation(extent={{-18,20},{-2,36}})));
  Modelica.Blocks.Sources.RealExpression realExpression[DifferentTypesOfPowerPlants](each y=-1) annotation (Placement(transformation(extent={{-40,16},{-30,30}})));
  Modelica.Blocks.Math.Product product1[DifferentTypesOfPowerPlants] annotation (Placement(transformation(extent={{72,48},{88,32}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay[DifferentTypesOfPowerPlants](each delayTime=120) annotation (Placement(transformation(extent={{34,0},{46,12}})));
  Modelica.Blocks.Math.Max maximum[DifferentTypesOfPowerPlants] annotation (Placement(transformation(extent={{46,-44},{56,-34}})));
  Modelica.Blocks.Math.Product product3[DifferentTypesOfPowerPlants] annotation (Placement(transformation(extent={{4,-34},{24,-14}})));
  Modelica.Blocks.Sources.RealExpression realExpression1[DifferentTypesOfPowerPlants](y=powerPlants_P_el_n) annotation (Placement(transformation(extent={{-24,-24},{-8,-12}})));
  Modelica.Blocks.Math.Min min[DifferentTypesOfPowerPlants] annotation (Placement(transformation(extent={{54,8},{66,20}})));

  ControlGasPressure controlGasPressure(
    each p_min=p_min,
    each p_min_backin=p_min_backin,
    each controllerType=Modelica.Blocks.Types.SimpleController.P,
    each n_gasPortOut_split=n_gasPortOut_split,
    each splitRatio=splitRatio,
    each k=1e-4) annotation (Placement(transformation(extent={{-70,12},{-54,28}})));
  TransiEnt.Basics.Blocks.FirstOrder firstOrder[n_gasPortOut_split](each Tau=50) annotation (Placement(transformation(extent={{-94,-46},{-82,-34}})));
  Modelica.Blocks.Math.Product product[DifferentTypesOfPowerPlants] annotation (Placement(transformation(extent={{-24,39},{-12,51}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=DifferentTypesOfPowerPlants) annotation (Placement(transformation(extent={{-48,30},{-36,42}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(realExpression.y, failureController_internal.value_in) annotation (Line(points={{-29.5,23},{-20,23},{-20,21.6},{-19.6,21.6}}, color={0,0,127}));
  connect(realExpression1.y, product3.u1) annotation (Line(points={{-7.2,-18},{2,-18}}, color={0,0,127}));
  connect(product3.y, maximum.u1) annotation (Line(points={{25,-24},{34,-24},{34,-36},{45,-36}}, color={0,0,127}));
  connect(fixedDelay.u, min.u1) annotation (Line(points={{32.8,6},{32.8,17.6},{52.8,17.6}}, color={0,0,127}));
  connect(fixedDelay.y, min.u2) annotation (Line(points={{46.6,6},{50,6},{50,10},{52,10},{52,10.4},{52.8,10.4}}, color={0,0,127}));
  connect(min.y, product1.u1) annotation (Line(points={{66.6,14},{70,14},{70,35.2},{70.4,35.2}}, color={0,0,127}));
  connect(P_el_set_out, maximum.y) annotation (Line(points={{105,-39},{56.5,-39}}, color={0,0,127}));
  connect(failureController_internal.value_out, fixedDelay.u) annotation (Line(points={{-1.2,21.6},{4,21.6},{4,6},{32.8,6}}, color={0,0,127}));
  connect(P_el_set_in, maximum.u2) annotation (Line(points={{-112.5,-0.5},{-54,-0.5},{-54,-42},{45,-42}}, color={0,127,127}));
  connect(product1.y, P_max_PowerPlant_out) annotation (Line(points={{88.8,40},{104,40}}, color={0,0,127}));

  connect(fixedDelay.u, product3.u2) annotation (Line(points={{32.8,6},{-30,6},{-30,-30},{2,-30}}, color={0,0,127}));
  connect(p_gas, firstOrder.u) annotation (Line(points={{-112.5,-40.5},{-103.25,-40.5},{-103.25,-40},{-95.2,-40}}, color={0,0,127}));
  connect(product.y, product1.u2) annotation (Line(points={{-11.4,45},{64,45},{64,44.8},{70.4,44.8}}, color={0,0,127}));
  connect(P_max_PowerPlant_in, product.u1) annotation (Line(points={{-112.5,39.5},{-72,39.5},{-72,48.6},{-25.2,48.6}}, color={0,127,127}));
  connect(replicator.y, product.u2) annotation (Line(points={{-35.4,36},{-30,36},{-30,41.4},{-25.2,41.4}}, color={0,0,127}));
  connect(controlGasPressure.y, replicator.u) annotation (Line(points={{-53.2,20},{-52,20},{-52,36},{-49.2,36}}, color={0,0,127}));
  connect(firstOrder.y, controlGasPressure.p_gas) annotation (Line(points={{-81.4,-40},{-76,-40},{-76,13.6},{-71.6,13.6}}, color={0,0,127}));
  annotation (Line(points={{-34,-50},{-54,-50},{-54,-40.5},{-112.5,-40.5}}, color={0,0,127}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller for power plants in superstructure. Desired electrical power has to be defined via input. This model can be used to model failures via timetable or failures because of too low gas pressure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
</html>"));
end ControlPowerPlant;
