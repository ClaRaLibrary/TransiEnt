within TransiEnt.SystemGeneration.Superstructure.Components.HeatingGridSystems;
model WasteHeatUsage_HeatPort


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

  extends TransiEnt.Basics.Icons.HeatFlowModel;
  extends TransiEnt.SystemGeneration.Superstructure.Components.HeatingGridSystems.PartialWasteHeatUsage(hotWaterStorage1(
      V=V_storage,
      h=(100/(Modelica.Constants.pi)*V_storage)^(1/3),
      T_start={378.15,378.15,378.15,378.15,378.15,378.15}));
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Volume V_storage=1e6;
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation (Placement(transformation(extent={{-112,-10},{-92,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut electricPowerOut annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,110})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Sensors.TemperatureSensor tempAfterConsumer1(unitOption=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-74,-34})));
  TransiEnt.Components.Heat.HEX_ideal hEX_ideal(Delta_p=0) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-56,0})));
  TransiEnt.Components.Heat.PumpVLE_L1_simple pumpVLE_L1_simple(
    presetVariableType="m_flow",
    m_flowInput=true,
    m_flow_fixed=2) annotation (Placement(transformation(extent={{-44,16},{-56,28}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=max(0, (-port_a.Q_flow - fixedHeatFlow.Q_flow)/(4.182e3*80))) annotation (Placement(transformation(extent={{-100,38},{-80,58}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=-1e-4) annotation (Placement(transformation(extent={{-116,-30},{-96,-10}})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler.ElectricBoiler electricBoiler(
    Q_flow_n=1e99,
    usePowerPort=true,
    redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
    redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=0.99) "Power Boundary for ComplexPowerPort") annotation (Placement(transformation(extent={{-26,14},{-42,30}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=if tempBeforeConsumer1.T < 373.15 and electricBoiler.fluidPortIn.m_flow >= 1e-5 then -electricBoiler.fluidPortIn.m_flow*4.1863e3*(373.15 - tempBeforeConsumer1.T) else 0) annotation (Placement(transformation(extent={{-100,54},{-80,74}})));
  TransiEnt.Components.Sensors.ElectricPowerComplex electricPowerComplex annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,72})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(threeWayValveVLE_L2_1.inlet, tempAfterConsumer1.port) annotation (Line(
      points={{-22,-34},{-64,-34}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hEX_ideal.waterPortOut, threeWayValveVLE_L2_1.inlet) annotation (Line(
      points={{-56,-10},{-56,-34},{-22,-34}},
      color={175,0,0},
      thickness=0.5));
  connect(pumpVLE_L1_simple.fluidPortOut, hEX_ideal.waterPortIn) annotation (Line(
      points={{-56,22},{-56,10}},
      color={175,0,0},
      thickness=0.5));
  connect(hEX_ideal.heatport, port_a) annotation (Line(points={{-65.8,0},{-102,0}}, color={191,0,0}));
  connect(realExpression4.y, pumpVLE_L1_simple.m_flow_in) annotation (Line(points={{-79,48},{-45.2,48},{-45.2,28.6}}, color={0,0,127}));
  connect(fixedHeatFlow.port, hEX_ideal.heatport) annotation (Line(points={{-96,-20},{-90,-20},{-90,0},{-65.8,0}}, color={191,0,0}));
  connect(joinVLE_L2_Y.outlet, electricBoiler.fluidPortIn) annotation (Line(
      points={{-22,22},{-25.68,22}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pumpVLE_L1_simple.fluidPortIn, electricBoiler.fluidPortOut) annotation (Line(
      points={{-44,22},{-42.16,22}},
      color={175,0,0},
      thickness=0.5));
  connect(realExpression2.y, electricBoiler.Q_flow_set) annotation (Line(points={{-79,64},{-25.68,64},{-25.68,22.8}},
                                                                                                              color={0,0,127}));
  connect(electricBoiler.epp, electricPowerComplex.epp_IN) annotation (Line(
      points={{-34,13.84},{-34,2},{-6.10623e-16,2},{-6.10623e-16,62.8}},
      color={28,108,200},
      thickness=0.5));
  connect(electricPowerComplex.epp_OUT, epp) annotation (Line(
      points={{6.10623e-16,81.4},{6.10623e-16,90.7},{0,90.7},{0,100}},
      color={28,108,200},
      thickness=0.5));
  connect(electricPowerComplex.Q, electricPowerOut) annotation (Line(
      points={{8.6,63.8},{40,63.8},{40,110}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model is used in superstructure to model the storage and usage of excess heat from PtG. </p>
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
end WasteHeatUsage_HeatPort;
