within TransiEnt.SystemGeneration.Superstructure.Components.Controller;
model ControlCO2


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

  extends Base.ControlCO2_Base;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  parameter Real powertToGas_P_el_n=1;
  parameter Real powerToGas_eta_n=1;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Boolean y_start_hysteresis1=false;
  parameter Boolean y_start_hysteresis2=false;
  parameter Boolean CCSInPowerPlants;
  parameter Boolean CO2NeededForPowerToGas;
  parameter Integer usageOfWasteHeatOfPtG;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.Hysteresis hysteresis1(
    uLow=9e9,
    uHigh=1e10,
    pre_y_start=y_start_hysteresis1) if CCSInPowerPlants annotation (Placement(transformation(extent={{-54,10},{-34,30}})));
  Modelica.Blocks.Logical.Not not2 if CCSInPowerPlants annotation (Placement(transformation(extent={{-26,10},{-6,30}})));
  Modelica.Blocks.Sources.RealExpression realExpression15(y=if powerToGas_plant1_P_el_set.y > 0 and powerToGas_plant1_m_flowHydrogen.y < 0 then -5.4585*(-powerToGas_plant1_m_flowHydrogen.y - simCenter.m_flow_small) else 0) if CO2NeededForPowerToGas annotation (Placement(transformation(extent={{-62,-20},{-40,-2}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis2(
    uLow=0,
    uHigh=powertToGas_P_el_n*powerToGas_eta_n/(141.79e6 - 219972)*5.45*1*3600,
    pre_y_start=y_start_hysteresis2) if CO2NeededForPowerToGas annotation (Placement(transformation(extent={{-86,-40},{-66,-20}})));
  Modelica.Blocks.Logical.Not not3 if CO2NeededForPowerToGas annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Logical.Switch switch2 if CO2NeededForPowerToGas annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Modelica.Blocks.Sources.RealExpression zero annotation (Placement(transformation(rotation=0, extent={{-60,-60},{-40,-40}})));

  Modelica.Blocks.Math.Gain powerToGas_plant1_m_flowGasOut(k=1) if CO2NeededForPowerToGas annotation (Placement(transformation(extent={{-88,-50},{-78,-40}})));
  Modelica.Blocks.Math.Gain powerToGas_plant1_m_flowHydrogen(k=1) if CO2NeededForPowerToGas annotation (Placement(transformation(extent={{-88,-62},{-78,-52}})));
  Modelica.Blocks.Math.Gain powerToGas_plant1_P_el_n(k=1) if CO2NeededForPowerToGas annotation (Placement(transformation(extent={{-88,-86},{-78,-76}})));
  Modelica.Blocks.Math.Gain powerToGas_plant1_eta(k=1) if CO2NeededForPowerToGas annotation (Placement(transformation(extent={{-88,-74},{-78,-64}})));
  Modelica.Blocks.Math.Gain powerToGas_plant1_P_el_set(k=1) if CO2NeededForPowerToGas annotation (Placement(transformation(extent={{-88,-98},{-78,-88}})));
equation

  connect(hysteresis1.y, not2.u) annotation (Line(points={{-33,20},{-28,20}}, color={255,0,255}));
  connect(hysteresis2.y, not3.u) annotation (Line(points={{-65,-30},{-62,-30}}, color={255,0,255}));
  connect(realExpression15.y, switch2.u1) annotation (Line(points={{-38.9,-11},{-30,-11},{-30,-22},{-22,-22}},
                                                                                                       color={0,0,127}));
  connect(not3.y, switch2.u2) annotation (Line(points={{-39,-30},{-22,-30}},
                                                                           color={255,0,255}));
  connect(zero.y, switch2.u3) annotation (Line(points={{-39,-50},{-30,-50},{-30,-38},{-22,-38}},
                                                                                           color={0,0,127}));
  connect(controlBus.co2System_mCO2FromAir, switch2.y) annotation (Line(
      points={{100,0},{6,0},{6,-30},{1,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(controlBus.powerPlantSystem_useCCS, not2.y) annotation (Line(
      points={{100,0},{60,0},{60,20},{-5,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.co2System_m_gasStorage, hysteresis1.u) annotation (Line(
      points={{100,0},{-98,0},{-98,20},{-56,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.co2System_m_gasStorage, hysteresis2.u) annotation (Line(
      points={{100,0},{-94,0},{-94,-30},{-88,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.powerToGas_plant1_m_flowGasOut, powerToGas_plant1_m_flowGasOut.u) annotation (Line(
      points={{100,0},{-98,0},{-98,-45},{-89,-45}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.powerToGas_plant1_m_flowHydrogen, powerToGas_plant1_m_flowHydrogen.u) annotation (Line(
      points={{100,0},{-98,0},{-98,-57},{-89,-57}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.powerToGas_plant1_P_el_n, powerToGas_plant1_P_el_n.u) annotation (Line(
      points={{100,0},{-98,0},{-98,-81},{-89,-81}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.powerToGas_plant1_etaFeedIn, powerToGas_plant1_eta.u) annotation (Line(
      points={{100,0},{-98,0},{-98,-69},{-89,-69}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.powerToGas_P_el_set, powerToGas_plant1_P_el_set.u) annotation (Line(
      points={{100,0},{-98,0},{-98,-93},{-89,-93}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-80},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller for CO<sub>2</sub> mass flows in superstructure for DAC-Plant and CCS of power plants depending on CO<sub>2</sub> storage. </p>
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
end ControlCO2;
