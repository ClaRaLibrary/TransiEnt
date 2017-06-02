within TransiEnt.Components.Sensors.IdealGas.Check;
model TestIdealGasSensors
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

extends TransiEnt.Basics.Icons.Checkmodel;

  TransiEnt.Components.Sensors.IdealGas.GasMassflowSensor fuelGasMassflowSensor(xiNumber=7) annotation (Placement(transformation(extent={{-28,0},{-8,20}})));
  TransiEnt.Components.Gas.Combustion.FullConversion_idealGas combustion annotation (Placement(transformation(extent={{2,-18},{38,18}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryIdealGas_pTxi fuelBoundary(gasModel=simCenter.gasModel2, variable_xi=true) annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryIdealGas_pTxi exhaustBoundary(gasModel=simCenter.exhaustGasModel) annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  TransiEnt.Components.Sensors.IdealGas.GasMassflowSensor exhaustGasMassflowSensor(xiNumber=2, medium=simCenter.exhaustGasModel) annotation (Placement(transformation(extent={{52,0},{72,20}})));
  TransiEnt.Components.Boundaries.Gas.IdealGasCompositionByWtFractions_stepVariation idealGasCompositionByWtFractions_stepVariation(
    xiNumber=7,
    period=10,
    stepsize=0.1) annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_NG7_H2_var gasModel2, redeclare TransiEnt.Basics.Media.Gases.Gas_ExhaustGas exhaustGasModel) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation
  combustion.gasPortIn.m_flow=1;

  connect(fuelBoundary.gasPort, fuelGasMassflowSensor.inlet) annotation (Line(
      points={{-42,0},{-42,0},{-28,0}},
      color={255,213,170},
      thickness=1.25));
  connect(fuelGasMassflowSensor.outlet, combustion.gasPortIn) annotation (Line(
      points={{-8,0},{-14,0},{2,0}},
      color={255,213,170},
      thickness=1.25));
  connect(combustion.gasPortOut, exhaustGasMassflowSensor.inlet) annotation (Line(
      points={{38,0},{52,0}},
      color={255,213,170},
      thickness=1.25));
  connect(exhaustGasMassflowSensor.outlet, exhaustBoundary.gasPort) annotation (Line(
      points={{72,0},{80,0}},
      color={255,213,170},
      thickness=1.25));
  connect(fuelBoundary.xi, idealGasCompositionByWtFractions_stepVariation.xi) annotation (Line(points={{-64,-6},{-68,-6},{-68,0},{-74,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=110, Tolerance=1e-006),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestIdealGasSensors;