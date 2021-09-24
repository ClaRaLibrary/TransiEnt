within TransiEnt.Producer.Gas.MethanatorSystem;
model DirectAirCapture_L1

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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Model;
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 annotation(Dialog(group="Fundamental Definitions"));
  parameter Modelica.Units.SI.Energy EnergyDemandThermal=7.92e6;
  parameter Modelica.Units.SI.Energy EnergyDemandElectrical=2.52e6;
  parameter Boolean useInput=true "true if input for mCO2FromAir shall be used, false if gas pressure boundary shall be used";
  parameter SI.Pressure p_boundary=simCenter.p_eff_2+simCenter.p_amb_const "Constant pressure value for pressure boundary" annotation(enable=not useInput);
  parameter Boolean integrateCDE=simCenter.integrateCDE "true if CDE shall be integrated" annotation(Dialog(group="Statistics"));
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Electricity "Type of primary energy carrier for co2 emissions global statistics" annotation (Dialog(group="Statistics"), HideResult=not simCenter.isExpertMode);
  parameter TransiEnt.Basics.Types.TypeOfResource typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Storage;
  final parameter Integer idx_CO2 = Modelica.Math.BooleanVectors.firstTrueIndex(Modelica.Utilities.Strings.isEqual(fill("Carbon_Dioxide",medium.nc),TransiEnt.Basics.Functions.GasProperties.shortenCompName(medium.vleFluidNames)));
  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut_CO2(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealInput mCO2FromAir if useInput annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp constrainedby TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort  "Choice of power port" annotation (choicesAllMatching=true,Dialog(group="Replaceable Components"), Placement(transformation(extent={{-10,-110},{10,-90}}),
                                                                                                                                                                                                      iconTransformation(extent={{80,60},{100,80}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissions(typeOfEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Electricity, integrateCDE=integrateCDE)
                                                                                                                                                            annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=EnergyDemandThermal)  annotation (Placement(transformation(extent={{-66,58},{-46,78}})));
  Modelica.Blocks.Math.Product product annotation (Placement(transformation(extent={{-38,64},{-18,84}})));

  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary annotation (choicesAllMatching=true,Dialog(group="Replaceable Components"), Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-46})));

  Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(extent={{46,-62},{26,-42}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow1(medium=medium,variable_m_flow=true,
    xi_const=cat(
        1,
        zeros(idx_CO2 - 1),
        {1},
        zeros(medium.nc - 1 - idx_CO2))) if useInput                                                                                 annotation (Placement(transformation(extent={{62,-10},{82,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation (Placement(transformation(extent={{-64,-10},{-84,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=-EnergyDemandElectrical) annotation (Placement(transformation(extent={{82,-68},{62,-48}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=typeOfResource)
                                                                                                       annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi(medium=medium,p_const=p_boundary,
    xi_const=cat(
        1,
        zeros(idx_CO2 - 1),
        {1},
        zeros(medium.nc - 1 - idx_CO2))) if                                                                   not useInput annotation (Placement(transformation(extent={{54,18},{74,38}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor(medium=medium,xiNumber=0) if not useInput annotation (Placement(transformation(extent={{100,28},{80,48}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  // _____________________________________________
  //
  //              Private Functions
  // _____________________________________________
  Modelica.Blocks.Math.Gain m_flow_CO2(k=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,30})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  collectElectricPower.powerCollector.P=epp.P;
  collectGwpEmissions.gwpCollector.m_flow_cde=-m_flow_CO2.y;
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(modelStatistics.gwpCollector[typeOfPrimaryEnergyCarrier],collectGwpEmissions.gwpCollector);
  connect(product.u2, realExpression.y) annotation (Line(points={{-40,68},{-45,68}}, color={0,0,127}));
  connect(epp, powerBoundary.epp) annotation (Line(
      points={{0,-100},{0,-56}},
      color={0,135,135},
      thickness=0.5));
  connect(gasPortOut_CO2, boundary_Txim_flow1.gasPort) annotation (Line(
      points={{100,0},{82,0}},
      color={255,255,0},
      thickness=1.5));
  connect(port_a, prescribedHeatFlow.port) annotation (Line(points={{-100,0},{-84,0}}, color={191,0,0}));
  connect(prescribedHeatFlow.Q_flow, product.y) annotation (Line(points={{-64,0},{-14,0},{-14,74},{-17,74}}, color={0,0,127}));
  connect(mCO2FromAir, product.u1) annotation (Line(points={{-120,80},{-40,80}}, color={0,0,127}));
  connect(mCO2FromAir, boundary_Txim_flow1.m_flow) annotation (Line(points={{-120,80},{-56,80},{-56,90},{52,90},{52,6},{60,6}}, color={0,0,127}));
  connect(mCO2FromAir, product1.u1) annotation (Line(points={{-120,80},{-56,80},{-56,90},{52,90},{52,-46},{48,-46}}, color={0,0,127}));
  connect(product1.y, powerBoundary.P_el_set) annotation (Line(points={{25,-52},{12,-52}}, color={0,0,127}));
  connect(realExpression2.y, product1.u2) annotation (Line(points={{61,-58},{48,-58}}, color={0,0,127}));
  connect(modelStatistics.powerCollector[typeOfResource],collectElectricPower.powerCollector);
  connect(massFlowSensor.m_flow, product1.u1) annotation (Line(points={{79,38},{102,38},{102,54},{52,54},{52,-46},{48,-46}},
                                                                                                                           color={0,0,127}));
  connect(massFlowSensor.m_flow, product.u1) annotation (Line(points={{79,38},{102,38},{102,54},{52,54},{52,90},{-56,90},{-56,80},{-40,80}},
                                                                                                                                           color={0,0,127}));
  connect(m_flow_CO2.u, mCO2FromAir) annotation (Line(points={{20,42},{20,90},{-56,90},{-56,80},{-120,80}}, color={0,0,127}));
  connect(massFlowSensor.m_flow, m_flow_CO2.u) annotation (Line(points={{79,38},{102,38},{102,54},{20,54},{20,42}},
                                                                                                                  color={0,0,127}));
  connect(boundary_pTxi.gasPort, massFlowSensor.gasPortOut) annotation (Line(
      points={{74,28},{80,28}},
      color={255,255,0},
      thickness=1.5));
  connect(massFlowSensor.gasPortIn, gasPortOut_CO2) annotation (Line(
      points={{100,28},{100,0}},
      color={255,255,0},
      thickness=1.5));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model can be used to model a direc-air-capture (DAC) - plant for carbon-capture from air.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Define electrical (EnergyDemandElectrical) and thermal (ThermalDemandElectrical) energy demand which is needed to capture 1kg CO2.</p>
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
<p>Model modified by Carsten Bode (c.bode@tuhh.de), Feb 2021 (extended to work with any fluid with CO2, added option to switch between pressure and mass flow source)</p>
</html>"), Icon(graphics={
        Ellipse(extent={{-64,62},{-34,14}}, lineColor={28,108,200}),
        Ellipse(extent={{-34,50},{-4,2}}, lineColor={28,108,200}),
        Ellipse(extent={{-4,38},{26,-10}}, lineColor={28,108,200}),
        Ellipse(extent={{26,26},{56,-22}}, lineColor={28,108,200}),
        Ellipse(extent={{-64,12},{-34,-36}},  lineColor={28,108,200}),
        Ellipse(extent={{-34,0},{-4,-48}}, lineColor={28,108,200}),
        Ellipse(extent={{-4,-12},{26,-60}}, lineColor={28,108,200}),
        Ellipse(extent={{26,-24},{56,-72}}, lineColor={28,108,200}),
        Line(points={{-64,70},{2,70}}, color={28,108,200}),
        Line(points={{-62,70},{56,22}}, color={28,108,200}),
        Line(points={{56,22},{56,-80},{-64,-32},{-64,70}}, color={28,108,200}),
        Line(points={{56,22},{98,22}}, color={28,108,200}),
        Line(points={{2,70},{94,34}}, color={28,108,200}),
        Line(points={{56,-80},{60,-80}}, color={28,108,200}),
        Ellipse(extent={{-52,42},{-46,32}}, lineColor={28,108,200}),
        Line(points={{-56,58},{-52,40}}, color={28,108,200}),
        Line(points={{-54,60},{-50,42}}, color={28,108,200}),
        Line(points={{-46,34},{-42,18}}, color={28,108,200}),
        Line(points={{-48,32},{-44,16}}, color={28,108,200}),
        Line(points={{-46,36},{-34,36}}, color={28,108,200}),
        Line(points={{-46,38},{-34,38}}, color={28,108,200}),
        Line(points={{-64,38},{-52,38}}, color={28,108,200}),
        Line(points={{-64,36},{-52,36}}, color={28,108,200}),
        Line(points={{-58,20},{-52,34}}, color={28,108,200}),
        Line(points={{-56,18},{-50,32}}, color={28,108,200}),
        Line(points={{-46,40},{-40,54}}, color={28,108,200}),
        Line(points={{-48,42},{-42,56}}, color={28,108,200}),
        Ellipse(extent={{-22,30},{-16,20}}, lineColor={28,108,200}),
        Line(points={{-26,46},{-22,28}}, color={28,108,200}),
        Line(points={{-24,48},{-20,30}}, color={28,108,200}),
        Line(points={{-16,22},{-12,6}},  color={28,108,200}),
        Line(points={{-18,20},{-14,4}},  color={28,108,200}),
        Line(points={{-16,24},{-4,24}},  color={28,108,200}),
        Line(points={{-16,26},{-4,26}},  color={28,108,200}),
        Line(points={{-34,26},{-22,26}}, color={28,108,200}),
        Line(points={{-34,24},{-22,24}}, color={28,108,200}),
        Line(points={{-28,8},{-22,22}},  color={28,108,200}),
        Line(points={{-26,6},{-20,20}},  color={28,108,200}),
        Line(points={{-16,28},{-10,42}}, color={28,108,200}),
        Line(points={{-18,30},{-12,44}}, color={28,108,200}),
        Ellipse(extent={{8,18},{14,8}},     lineColor={28,108,200}),
        Line(points={{4,34},{8,16}},     color={28,108,200}),
        Line(points={{6,36},{10,18}},    color={28,108,200}),
        Line(points={{14,10},{18,-6}},   color={28,108,200}),
        Line(points={{12,8},{16,-8}},    color={28,108,200}),
        Line(points={{14,12},{26,12}},   color={28,108,200}),
        Line(points={{14,14},{26,14}},   color={28,108,200}),
        Line(points={{-4,14},{8,14}},    color={28,108,200}),
        Line(points={{-4,12},{8,12}},    color={28,108,200}),
        Line(points={{2,-4},{8,10}},     color={28,108,200}),
        Line(points={{4,-6},{10,8}},     color={28,108,200}),
        Line(points={{14,16},{20,30}},   color={28,108,200}),
        Line(points={{12,18},{18,32}},   color={28,108,200}),
        Ellipse(extent={{38,6},{44,-4}},    lineColor={28,108,200}),
        Line(points={{34,22},{38,4}},    color={28,108,200}),
        Line(points={{36,24},{40,6}},    color={28,108,200}),
        Line(points={{44,-2},{48,-18}},  color={28,108,200}),
        Line(points={{42,-4},{46,-20}},  color={28,108,200}),
        Line(points={{44,0},{56,0}},     color={28,108,200}),
        Line(points={{44,2},{56,2}},     color={28,108,200}),
        Line(points={{26,2},{38,2}},     color={28,108,200}),
        Line(points={{26,0},{38,0}},     color={28,108,200}),
        Line(points={{32,-16},{38,-2}},  color={28,108,200}),
        Line(points={{34,-18},{40,-4}},  color={28,108,200}),
        Line(points={{44,4},{50,18}},    color={28,108,200}),
        Line(points={{42,6},{48,20}},    color={28,108,200}),
        Ellipse(extent={{38,-44},{44,-54}}, lineColor={28,108,200}),
        Line(points={{34,-28},{38,-46}}, color={28,108,200}),
        Line(points={{36,-26},{40,-44}}, color={28,108,200}),
        Line(points={{44,-52},{48,-68}}, color={28,108,200}),
        Line(points={{42,-54},{46,-70}}, color={28,108,200}),
        Line(points={{44,-50},{56,-50}}, color={28,108,200}),
        Line(points={{44,-48},{56,-48}}, color={28,108,200}),
        Line(points={{26,-48},{38,-48}}, color={28,108,200}),
        Line(points={{26,-50},{38,-50}}, color={28,108,200}),
        Line(points={{32,-66},{38,-52}}, color={28,108,200}),
        Line(points={{34,-68},{40,-54}}, color={28,108,200}),
        Line(points={{44,-46},{50,-32}}, color={28,108,200}),
        Line(points={{42,-44},{48,-30}}, color={28,108,200}),
        Ellipse(extent={{8,-32},{14,-42}},  lineColor={28,108,200}),
        Line(points={{4,-16},{8,-34}},   color={28,108,200}),
        Line(points={{6,-14},{10,-32}},  color={28,108,200}),
        Line(points={{14,-40},{18,-56}}, color={28,108,200}),
        Line(points={{12,-42},{16,-58}}, color={28,108,200}),
        Line(points={{14,-38},{26,-38}}, color={28,108,200}),
        Line(points={{14,-36},{26,-36}}, color={28,108,200}),
        Line(points={{-4,-36},{8,-36}},  color={28,108,200}),
        Line(points={{-4,-38},{8,-38}},  color={28,108,200}),
        Line(points={{2,-54},{8,-40}},   color={28,108,200}),
        Line(points={{4,-56},{10,-42}},  color={28,108,200}),
        Line(points={{14,-34},{20,-20}}, color={28,108,200}),
        Line(points={{12,-32},{18,-18}}, color={28,108,200}),
        Ellipse(extent={{-22,-20},{-16,-30}},
                                            lineColor={28,108,200}),
        Line(points={{-26,-4},{-22,-22}},color={28,108,200}),
        Line(points={{-24,-2},{-20,-20}},color={28,108,200}),
        Line(points={{-16,-28},{-12,-44}},
                                         color={28,108,200}),
        Line(points={{-18,-30},{-14,-46}},
                                         color={28,108,200}),
        Line(points={{-16,-26},{-4,-26}},color={28,108,200}),
        Line(points={{-16,-24},{-4,-24}},color={28,108,200}),
        Line(points={{-34,-24},{-22,-24}},
                                         color={28,108,200}),
        Line(points={{-34,-26},{-22,-26}},
                                         color={28,108,200}),
        Line(points={{-28,-42},{-22,-28}},
                                         color={28,108,200}),
        Line(points={{-26,-44},{-20,-30}},
                                         color={28,108,200}),
        Line(points={{-16,-22},{-10,-8}},color={28,108,200}),
        Line(points={{-18,-20},{-12,-6}},color={28,108,200}),
        Ellipse(extent={{-52,-8},{-46,-18}},lineColor={28,108,200}),
        Line(points={{-56,8},{-52,-10}}, color={28,108,200}),
        Line(points={{-54,10},{-50,-8}}, color={28,108,200}),
        Line(points={{-46,-16},{-42,-32}},
                                         color={28,108,200}),
        Line(points={{-48,-18},{-44,-34}},
                                         color={28,108,200}),
        Line(points={{-46,-14},{-34,-14}},
                                         color={28,108,200}),
        Line(points={{-46,-12},{-34,-12}},
                                         color={28,108,200}),
        Line(points={{-64,-12},{-52,-12}},
                                         color={28,108,200}),
        Line(points={{-64,-14},{-52,-14}},
                                         color={28,108,200}),
        Line(points={{-58,-30},{-52,-16}},
                                         color={28,108,200}),
        Line(points={{-56,-32},{-50,-18}},
                                         color={28,108,200}),
        Line(points={{-46,-10},{-40,4}}, color={28,108,200}),
        Line(points={{-48,-8},{-42,6}},  color={28,108,200})}));
end DirectAirCapture_L1;
