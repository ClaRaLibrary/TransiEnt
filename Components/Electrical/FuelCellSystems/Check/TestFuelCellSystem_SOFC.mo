within TransiEnt.Components.Electrical.FuelCellSystems.Check;
model TestFuelCellSystem_SOFC "SOFC Fuel cell system with steam reformer and electricity led control"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  import TransiEnt;

  extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage ElectricGrid(
    Use_input_connector_f=false,
    Use_input_connector_v=false,
    v_boundary=230) annotation (Placement(transformation(extent={{72,22},{92,42}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower HouseholdDemandFromGrid(
    useInputConnectorQ=false,
    Q_el_set_const=0,
    useCosPhi=false) annotation (Placement(transformation(extent={{30,14},{10,34}})));
  TransiEnt.Components.Sensors.ElectricReactivePower LocalPowerSensor annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={54,32})));
  FuelCell.Controller.PowerController PowerController(k=100, i_min=20) annotation (Placement(transformation(
        extent={{14,13},{-14,-13}},
        rotation=180,
        origin={-32,-53})));
  FuelCell.SOFC                                                                                 FC(
    i_cell(start=0),
    A_cell=0.0361,
    no_Cells=20,
    cp=850,
    m=5,
    ka=0.1,
    I_shutdown=0.1,
    T_nom=760 + 273.15,
    T_start=760 + 273.15) annotation (Placement(transformation(extent={{16,-62},{60,-20}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi SinkAir(
    variable_p=false,
    variable_xi=false,
    p_const=1e5,
    T_const=500 + 273.15,
    medium=FC.Air)        annotation (Placement(transformation(
        extent={{-7,-8},{7,8}},
        rotation=180,
        origin={75,-48})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi SinkFluegas(
    variable_p=false,
    variable_xi=false,
    p_const=1e5,
    T_const=500 + 273.15,
    medium=FC.Syngas) annotation (Placement(transformation(
        extent={{-6,-9},{6,9}},
        rotation=180,
        origin={92,-25})));
  FuelCell.Controller.LambdaController                                                     LambdaHController(m_flow_rampup=0.00025, k=5e-2) annotation (Placement(transformation(extent={{-60,-94},{-86,-68}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow SourceNaturalGas(
    variable_T=false,
    variable_xi=true,
    xi_const={0.6,0,0,0.05,0,0},
    m_flow_const=5.1e-2,
    T_const=500 + 273.15,
    variable_m_flow=true,
    medium=FC.Syngas) annotation (Placement(transformation(extent={{-88,7},{-68,-13}})));
  TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.Controller.OC_SC_Controller OC_SC_Controller annotation (Placement(transformation(extent={{-64,20},{-84,40}})));
  Modelica.Blocks.Sources.Constant SC_set(k=1.5) annotation (Placement(transformation(extent={{-94,52},{-74,72}})));
  Modelica.Blocks.Sources.Constant OC_set(k=0.3) annotation (Placement(transformation(extent={{-64,52},{-44,72}})));
  TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.SteamReformer_NaturalGas_to_H2 SteamReformer(
    eps=1e-6,
    d_kat=1850,
    cp=850,
    scale_kat=2,
    V_reac=0.0024,
    p_reformer=150000,
    T_reformer(fixed=true, start=20 + 273)) annotation (Placement(transformation(extent={{-40,-25},{0,19}})));
  TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.Controller.TemperatureController TemperatureController(T_target=510 + 273, Q_nom=2e3) annotation (Placement(transformation(extent={{-30,26},{-10,44}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow SourceAir(
    variable_xi=false,
    T_const=simCenter.T_amb_const,
    xi_const={0.01,0.6},
    variable_m_flow=false,
    m_flow_const=5e-4,
    medium=FC.Air)     annotation (Placement(transformation(
        extent={{6.5,-9},{-6.5,9}},
        rotation=180,
        origin={8.5,-65})));
  Modelica.Blocks.Sources.Step ElectricLoad(
    offset=800,
    height=600,
    startTime=1000) annotation (Placement(transformation(extent={{-2,36},{14,52}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Components.Electrical.FuelCellSystems.Base.SyngasSensor FuelCellSensor annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={74,-26})));
  TransiEnt.Components.Electrical.FuelCellSystems.Base.SyngasSensor ReformerSensor annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-55,-3})));
  TransiEnt.Components.Electrical.FuelCellSystems.Base.FuelCellSystemEfficiency SystemEfficiency annotation (Placement(transformation(extent={{8,62},{28,82}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_in_CH4(y=ReformerSensor.Q_flow_in_CH4)
                                                       annotation (Placement(transformation(extent={{-14,72},{0,80}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_in_evaporator(y=ReformerSensor.Q_flow_in_evaporator)
                                                              annotation (Placement(transformation(extent={{-14,66},{0,74}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_in_preheater(y=ReformerSensor.Q_flow_in_preheater)
                                                             annotation (Placement(transformation(extent={{-14,60},{0,68}})));
  Modelica.Blocks.Sources.RealExpression P_el(y=-FC.P_el)
                                              annotation (Placement(transformation(extent={{-6,82},{8,90}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_out_cooling(y=-FC.Q_flow)
                                                            annotation (Placement(transformation(extent={{-6,88},{8,96}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_exhaustGasLatent(y=FuelCellSensor.Q_flow_exhaustGasLatent)
                                                                 annotation (Placement(transformation(extent={{48,88},{28,96}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_exhaustGasChemical(y=FuelCellSensor.Q_flow_exhaustGasChemical)
                                                                   annotation (Placement(transformation(extent={{48,82},{28,90}})));
  TransiEnt.Components.Visualization.DynDisplay dynDisplay(
    varname="eta_el",
    x1=100*SystemEfficiency.eta_el,
    unit="%") annotation (Placement(transformation(extent={{78,59},{98,79}})));
  TransiEnt.Components.Visualization.DynDisplay dynDisplay1(
    varname="eta_th",
    x1=100*SystemEfficiency.eta_th,
    unit="%") annotation (Placement(transformation(extent={{56,59},{76,79}})));
  TransiEnt.Components.Visualization.DynDisplay dynDisplay2(
    varname="Q_flow_th",
    unit="kW",
    x1=1e-3*SystemEfficiency.Q_gen_total) annotation (Placement(transformation(extent={{56,79},{76,99}})));
  TransiEnt.Components.Visualization.DynDisplay dynDisplay3(
    varname="P_el",
    unit="kW",
    x1=1e-3*SystemEfficiency.P_gen_total) annotation (Placement(transformation(extent={{78,79},{98,99}})));
  TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformer simpleTransformer(U_S=0.733) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={42,-4})));
equation

  connect(TemperatureController.heatport, SteamReformer.heatport) annotation (Line(points={{-20.3,29.69},{-20.3,18.34},{-19.8,18.34}}, color={191,0,0}));
  connect(SourceNaturalGas.xi, OC_SC_Controller.Xi_Reformer) annotation (Line(points={{-88,3},{-94,3},{-94,30.4},{-84.2,30.4}}, color={0,0,127}));
  connect(OC_SC_Controller.SC_R, SC_set.y) annotation (Line(points={{-66,34.8},{-62,34.8},{-62,46},{-68,46},{-68,62},{-73,62}}, color={0,0,127}));
  connect(OC_set.y, OC_SC_Controller.OC_R) annotation (Line(points={{-43,62},{-40,62},{-40,46},{-58,46},{-58,28},{-66,28},{-66,26.8}}, color={0,0,127}));
  connect(FC.feeda, SourceAir.gas_a) annotation (Line(
      points={{16.88,-52.55},{16.88,-65},{15,-65}},
      color={255,170,85},
      thickness=0.5));
  connect(LocalPowerSensor.epp_OUT, ElectricGrid.epp) annotation (Line(points={{63.4,32},{71.9,32},{71.9,31.9}}, color={0,127,0}));
  connect(LocalPowerSensor.epp_IN, HouseholdDemandFromGrid.epp) annotation (Line(points={{44.8,32},{38,32},{38,24},{32,24},{30,24},{30,23.9},{30.1,23.9}},
                                                                                                    color={0,127,0}));
  connect(ElectricLoad.y, HouseholdDemandFromGrid.P_el_set) annotation (Line(points={{14.8,44},{26,44},{26,36}}, color={0,0,127}));
  connect(FC.draina, SinkAir.gas_a) annotation (Line(
      points={{59.56,-48.35},{68.78,-48.35},{68.78,-48},{68,-48}},
      color={255,170,85},
      thickness=0.5));
  connect(PowerController.y, FC.I_load) annotation (Line(points={{-16.6,-53},{-2,-53},{-2,-42},{2,-42},{2,-42.26},{19.96,-42.26}}, color={0,0,127}));
  connect(LambdaHController.y, SourceNaturalGas.m_flow) annotation (Line(points={{-87.04,-81},{-87.04,-82},{-92,-82},{-92,-9},{-88,-9}},   color={0,0,127}));
  connect(FC.lambda_H, LambdaHController.u1) annotation (Line(points={{45.04,-64.1},{45.04,-73.2},{-60,-73.2}}, color={0,0,127}));
  connect(LocalPowerSensor.P, PowerController.deltaP) annotation (Line(points={{50.2,24.2},{50.2,18},{100,18},{100,-88},{-54,-88},{-54,-46},{-46,-46},{-46,-45.2},{-44.6,-45.2}}, color={0,0,127}));
  connect(FC.V_stack, PowerController.V_cell) annotation (Line(points={{60.44,-40.16},{72,-40.16},{84,-40.16},{84,-84},{-52,-84},{-52,-60.02},{-44.6,-60.02}}, color={0,0,127}));
  connect(FC.drainh, FuelCellSensor.gasPortIn) annotation (Line(
      points={{60,-26.93},{63,-26.93},{63,-26},{66.16,-26}},
      color={255,170,85},
      thickness=0.5));
  connect(FuelCellSensor.gasPortOut, SinkFluegas.gas_a) annotation (Line(
      points={{81.84,-26},{84,-26},{84,-25},{86,-25}},
      color={255,170,85},
      thickness=0.5));
  connect(Q_flow_in_CH4.y, SystemEfficiency.Q_flow_in_CH4) annotation (Line(points={{0.7,76},{8,76},{8,75.6}}, color={0,0,127}));
  connect(SystemEfficiency.Q_flow_in_evaporator, Q_flow_in_evaporator.y) annotation (Line(points={{8,71.6},{4,71.6},{4,70},{0.7,70}}, color={0,0,127}));
  connect(Q_flow_in_preheater.y, SystemEfficiency.Q_flow_in_preheater) annotation (Line(points={{0.7,64},{4,64},{4,68},{8,68},{8,67.4}}, color={0,0,127}));
  connect(SystemEfficiency.P_el, P_el.y) annotation (Line(points={{12,82},{12,82},{12,86},{8.7,86}}, color={0,0,127}));
  connect(Q_flow_out_cooling.y, SystemEfficiency.Q_flow_out_cooling) annotation (Line(points={{8.7,92},{15.8,92},{15.8,82}}, color={0,0,127}));
  connect(Q_flow_exhaustGasLatent.y, SystemEfficiency.Q_flow_out_exhaustGasLatent) annotation (Line(points={{27,92},{20,92},{20,82}}, color={0,0,127}));
  connect(Q_flow_exhaustGasChemical.y, SystemEfficiency.Q_flow_out_exhaustGasChemical) annotation (Line(points={{27,86},{24.8,86},{24.8,82}}, color={0,0,127}));
  connect(SteamReformer.drain, FC.feedh) annotation (Line(
      points={{0,-3.66},{6,-3.66},{6,-4},{16.44,-4},{16.44,-26.51}},
      color={255,170,85},
      thickness=0.5));
  connect(SteamReformer.feed, ReformerSensor.gasPortOut) annotation (Line(
      points={{-39.6,-3.66},{-41.8,-3.66},{-41.8,-3},{-48.14,-3}},
      color={255,170,85},
      thickness=0.5));
  connect(ReformerSensor.gasPortIn, SourceNaturalGas.gas_a) annotation (Line(
      points={{-61.86,-3},{-61.86,-3},{-68,-3}},
      color={255,170,85},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "TestFuelCellSystem_SOFC.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=2, position={809, 0, 791, 817}, y={"ElectricLoad.y", "FC.epp.P", "LocalPowerSensor.P"}, range={0.0, 0.042, -2000.0, 2000.0}, grid=true, colors={{238,46,47}, {28,108,200}, {0,140,72}}, patterns={LinePattern.Solid, LinePattern.Solid, LinePattern.Dot}, markers={MarkerStyle.None, MarkerStyle.None, MarkerStyle.Circle}, filename=resultFileName);
createPlot(id=2, position={809, 0, 791, 160}, y={"SteamReformer.xi_h2"}, range={0.0, 0.042, -0.02, 0.06}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=2, position={809, 0, 791, 159}, y={"LambdaHController.Lambda_H_target", "LambdaHController.u1"}, range={0.0, 0.042, -1.0, 2.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=2, position={809, 0, 791, 160}, y={"PowerController.i_max", "PowerController.i_min", "FC.I_load"}, range={0.0, 0.042, 0.0, 200.0}, grid=true, subPlot=4, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFileName);
createPlot(id=2, position={809, 0, 791, 159}, y={"PowerController.V_cell"}, range={0.0, 0.042, -10.0, 20.0}, grid=true, subPlot=5, colors={{28,108,200}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(HouseholdDemandFromGrid.epp, simpleTransformer.epp_p) annotation (Line(points={{30.1,23.9},{42,23.9},{42,6}}, color={0,127,0}));
  connect(simpleTransformer.epp_n, FC.epp) annotation (Line(points={{42,-14},{40,-14},{40,-18},{36,-18},{36,-28.82},{38,-28.82}}, color={0,127,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-20,100},{100,58}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),
    experiment(StopTime=3600, __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput);
end TestFuelCellSystem_SOFC;
