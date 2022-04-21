within TransiEnt.Producer.Gas.MethanatorSystem.Check;
model Test_DirectAirCapture



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
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  Modelica.Blocks.Sources.RealExpression realExpression(y=-0.0536) annotation (Placement(transformation(extent={{-82,12},{-62,32}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi1 annotation (Placement(transformation(extent={{76,-16},{56,4}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-68,80},{-48,100}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{56,14},{76,34}})));
  TransiEnt.Producer.Gas.MethanatorSystem.DirectAirCapture_L1 cO2CaptureFromAir_2_1 annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=273.15 + 100) annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=0.0536) annotation (Placement(transformation(extent={{106,-70},{86,-50}})));
  Components.Boundaries.Electrical.ActivePower.Frequency           ElectricGrid1
                                                                                annotation (Placement(transformation(extent={{56,-46},{76,-26}})));
  DirectAirCapture_L1                                         cO2CaptureFromAir_2_2(useInput=false)
                                                                                    annotation (Placement(transformation(extent={{-12,-70},{8,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1
                                                                                    annotation (Placement(transformation(extent={{-48,-70},{-28,-50}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=273.15 + 100) annotation (Placement(transformation(extent={{-82,-70},{-62,-50}})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow(variable_m_flow=true)
                                                                         annotation (Placement(transformation(extent={{76,-76},{56,-56}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(cO2CaptureFromAir_2_1.epp, ElectricGrid.epp) annotation (Line(
      points={{7,7},{56,7},{56,24}},
      color={0,135,135},
      thickness=0.5));
  connect(boundary_pTxi1.gasPort, cO2CaptureFromAir_2_1.gasPortOut_CO2) annotation (Line(
      points={{56,-6},{56,0},{8,0}},
      color={255,255,0},
      thickness=1.5));
  connect(prescribedTemperature.port, cO2CaptureFromAir_2_1.port_a) annotation (Line(points={{-28,0},{-12,0}},     color={191,0,0}));
  connect(realExpression1.y, prescribedTemperature.T) annotation (Line(points={{-61,0},{-50,0}},     color={0,0,127}));
  connect(cO2CaptureFromAir_2_1.mCO2FromAir, realExpression.y) annotation (Line(points={{-14,8},{-20,8},{-20,22},{-61,22}},     color={0,0,127}));
  connect(cO2CaptureFromAir_2_2.epp, ElectricGrid1.epp) annotation (Line(
      points={{7,-53},{56,-53},{56,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(prescribedTemperature1.port, cO2CaptureFromAir_2_2.port_a) annotation (Line(points={{-28,-60},{-12,-60}}, color={191,0,0}));
  connect(realExpression3.y, prescribedTemperature1.T) annotation (Line(points={{-61,-60},{-50,-60}}, color={0,0,127}));
  connect(cO2CaptureFromAir_2_2.gasPortOut_CO2, boundary_Txim_flow.gasPort) annotation (Line(
      points={{8,-60},{56,-60},{56,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow.m_flow, realExpression2.y) annotation (Line(points={{78,-60},{85,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Test_DirectAirCapture;
