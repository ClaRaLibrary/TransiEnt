within TransiEnt.Producer.Heat.Gas2Heat.SmallGasBoiler.Check;
model TestBoilers_HoldTemperature_L2 "Comparison of two boilers to hold a set temperature"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//

  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter(
    redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_NG7_H2_var gasModel2,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    redeclare TransiEnt.Basics.Tables.HeatGrid.HeatingCurves.HeatingCurveEONHanse heatingCurve)
    annotation (Placement(transformation(extent={{-110,80},{-90,100}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow waterSource(
    variable_T=false,
    m_flow_const=10,
    variable_m_flow=true,
    T_const=273.15 + 70)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-20,-82})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi waterSink(p_const=simCenter.p_nom[2]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={32,-82})));
  TransiEnt.Components.Boundaries.Gas.IdealGasCompositionByWtFractions gasCompositionByWtFractions(xi_in=simCenter.gasModel2.xi_default) annotation (Placement(transformation(extent={{-106,26},{-90,42}})));
  Modelica.Blocks.Sources.RealExpression T_supply_set(y=273.15 + 110)
    annotation (Placement(transformation(extent={{-106,-38},{-82,-14}})));

  Gasboiler_dynamic_L2 BoilerVarXi(
    modulating=false,
    condensing=false,
    Q_flow_n=5e6,
    volume=10.5,
    stages=1,
    holdTemperature=true,
    fixedSupplyTemperature=true,
    T_init=80,
    lambda=1)     annotation (Placement(transformation(extent={{-12,-60},{24,-24}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=750/3.6 - BoilerVarXi.Q_flow_n/BoilerVarXi.cp_water/50,
    offset=BoilerVarXi.Q_flow_n/BoilerVarXi.cp_water/50,
    startTime=2400,
    duration=1800)
    annotation (Placement(transformation(extent={{-104,-86},{-84,-66}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryIdealGas_pTxi gasSink(gasModel=simCenter.exhaustGasModel) annotation (Placement(transformation(extent={{66,-52},{46,-32}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryIdealGas_pTxi gasSource(gasModel=simCenter.gasModel2, variable_xi=true) annotation (Placement(transformation(extent={{-54,-52},{-34,-32}})));
  Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation gasCompositionByWtFractions_stepVariation(
    xi(
    start =  simCenter.gasModel2.xi_default),
    period=900,
    xiNumber=7,
    stepsize=0.011687) annotation (Placement(transformation(extent={{-104,-50},{-88,-34}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow waterSource1(
    variable_T=false,
    m_flow_const=10,
    variable_m_flow=true,
    T_const=273.15 + 70)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-18,-6})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi waterSink1(p_const=simCenter.p_nom[2]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={34,-6})));
  Gasboiler_dynamic_L2 BoilerConstXi(
    modulating=false,
    condensing=false,
    Q_flow_n=5e6,
    volume=10.5,
    stages=1,
    holdTemperature=true,
    T_init=80,
    lambda=1)     annotation (Placement(transformation(extent={{-10,16},{26,52}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryIdealGas_pTxi gasSink1(gasModel=simCenter.exhaustGasModel) annotation (Placement(transformation(extent={{68,24},{48,44}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryIdealGas_pTxi gasSource1(gasModel=simCenter.gasModel2, variable_xi=true) annotation (Placement(transformation(extent={{-52,24},{-32,44}})));
equation

  connect(BoilerVarXi.waterPortIn, waterSource.steam_a) annotation (Line(
      points={{-4.08,-56.76},{-4.08,-82},{-10,-82}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(BoilerVarXi.waterPortOut, waterSink.steam_a) annotation (Line(
      points={{16.08,-56.76},{16.08,-82},{22,-82}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_supply_set.y, BoilerVarXi.T_supply_set) annotation (Line(
      points={{-80.8,-26},{-34,-26},{-34,-33},{-10.92,-33}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSource.gasPort, BoilerVarXi.gasPortIn) annotation (Line(
      points={{-34,-42},{-12,-42}},
      color={255,213,170},
      thickness=0.5,
      smooth=Smooth.None));
  connect(BoilerVarXi.gasPortOut, gasSink.gasPort) annotation (Line(
      points={{24,-42},{46,-42}},
      color={255,213,170},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, waterSource.m_flow) annotation (Line(
      points={{-83,-76},{-32,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasCompositionByWtFractions_stepVariation.xi, gasSource.xi) annotation (Line(points={{-88,-42},{-70,-42},{-70,-48},{-56,-48}}, color={0,0,127}));
  connect(BoilerConstXi.waterPortIn, waterSource1.steam_a) annotation (Line(
      points={{-2.08,19.24},{-2.08,-6},{-8,-6}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(BoilerConstXi.waterPortOut, waterSink1.steam_a) annotation (Line(
      points={{18.08,19.24},{18.08,-6},{24,-6}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(T_supply_set.y, BoilerConstXi.T_supply_set) annotation (Line(
      points={{-80.8,-26},{-70,-26},{-70,50},{-26,50},{-26,43},{-8.92,43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSource1.gasPort, BoilerConstXi.gasPortIn) annotation (Line(
      points={{-32,34},{-10,34}},
      color={255,213,170},
      thickness=0.5,
      smooth=Smooth.None));
  connect(BoilerConstXi.gasPortOut, gasSink1.gasPort) annotation (Line(
      points={{26,34},{48,34}},
      color={255,213,170},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, waterSource1.m_flow) annotation (Line(
      points={{-83,-76},{-58,-76},{-58,0},{-30,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasCompositionByWtFractions.xi, gasSource1.xi) annotation (Line(points={{-90,34},{-72,34},{-72,28},{-54,28}}, color={0,0,127}));

  // _____________________________________________
  //
  //             Private functions
  // _____________________________________________
protected
  function plotResult

  constant String resultFileName = "TestBoiler_HoldTemperature_L2.mat";

  output String resultFile;

  algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots(false);

  createPlot(id=1, position={0, 0, 664, 882}, y={"BoilerVarXi.Q_flow_set_internal", "BoilerVarXi.Q_flow_out", "BoilerConstXi.Q_flow_out"}, range={0.0, 3600.0, -500000.0, 2500000.0}, grid=true, filename=resultFile, colors={{28,108,200}, {238,46,47}, {0,140,72}}, patterns={LinePattern.Solid, LinePattern.Solid, LinePattern.Dash});
  createPlot(id=1, position={0, 0, 664, 290}, y={"BoilerVarXi.T_supply_set_internal", "BoilerVarXi.T_return","BoilerConstXi.T_supply"}, range={0.0, 3600.0, 40.0, 100.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}}, patterns={LinePattern.Solid, LinePattern.Solid, LinePattern.Dash});
  createPlot(id=1, position={0, 0, 664, 291}, y={"BoilerVarXi.waterPortIn.m_flow"}, range={0.0, 3600.0, -2.0, 10.0}, grid=true, subPlot=3, colors={{28,108,200}});
  createPlot(id=2, position={680, 0, 662, 882}, y={"BoilerVarXi.xi_fuel[7]", "BoilerConstXi.xi_fuel[7]"}, range={0.0, 3600.0, -0.1, 0.8}, grid=true, filename=resultFile, colors={{28,108,200}, {238,46,47}});
  createPlot(id=2, position={680, 0, 662, 290}, y={"BoilerVarXi.m_flow_fuel", "BoilerConstXi.m_flow_fuel"}, range={0.0, 3600.0, -0.01, 0.060000000000000005}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}});
  createPlot(id=2, position={680, 0, 662, 291}, y={"BoilerVarXi.collectGwpEmissions.gwpCollector.m_flow_cde", "BoilerConstXi.collectGwpEmissions.gwpCollector.m_flow_cde"}, range={0.0, 3600.0, -0.16, 0.01999999999999999}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}});

  resultFile := "Successfully plotted results for file: " + resultFile;

  end plotResult;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{100,100}}), graphics={Text(
          extent={{-72,98},{90,68}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="#LA, 24.11.2016:
- Simulate and execute \"Plot example results\" under \"Commands\" tab
- Plot 1: Look at dynamic behavior of the boiler. It can be changed by defining a different Q_flow_n and volume.
- Plot 2: Look at the hydrogen mass fraction (component 7) and its influence on the fuel consumption and CO2 emissions")}),
                                          Icon(graphics,
                                               coordinateSystem(extent={{-120,-100},
            {100,100}})),
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(executeCall=TransiEnt.Producer.Heat.SmallGasBoiler.Check.TestBoiler_HoldTemperature_L2.plotResult() "Plot example results"));
end TestBoilers_HoldTemperature_L2;
