within TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.Check;
model TestSteamReformer2 "Test um die Dynamik der Gleichgewichtsbestimmung zu berprfen"
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.SteamReformer_NaturalGas_to_H2 reformer(
    eps=1e-6,
    cp=850,
    T_reformer(fixed=true, start=500 + 273),
    scale_kat=4,
    V_reac=0.0024,
    d_kat=1870,
    p_reformer=150000) annotation (Placement(transformation(extent={{8,-26},{56,24}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow SourceSynGas(
    variable_m_flow=false,
    variable_xi=true,
    medium=reformer.Syngas,
    xi_const={0.6,0,0,0.05,0,0},
    T_const=585 + 273.15,
    variable_T=true,
    m_flow_const=2e-4) annotation (Placement(transformation(extent={{-22,-12},{-2,8}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi sink(
    variable_p=false,
    variable_xi=false,
    T_const=585 + 273.15,
    medium=reformer.Syngas,
    p_const=1.5e5) annotation (Placement(transformation(
        extent={{-11,-12},{11,12}},
        rotation=180,
        origin={79,-2})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow    fixedTemperature(Q_flow=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={32,42})));
  TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.Controller.OC_SC_Controller OC_SC_Controller annotation (Placement(transformation(extent={{-54,-16},{-34,4}})));
  Modelica.Blocks.Sources.Constant SC(k=1.2)
    annotation (Placement(transformation(extent={{-86,24},{-66,44}})));
  Modelica.Blocks.Sources.Ramp     OC(
    height=0.2,
    offset=0.2,
    duration=4000,
    startTime=1000)
    annotation (Placement(transformation(extent={{-84,-58},{-64,-38}})));
  Modelica.Blocks.Sources.Ramp     OC1(
    height=45,
    duration=4000,
    offset=585 + 273,
    startTime=1000)
    annotation (Placement(transformation(extent={{-50,36},{-30,56}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation
  connect(OC_SC_Controller.Xi_Reformer, SourceSynGas.xi) annotation (Line(
      points={{-33.8,-5.6},{-27.9,-5.6},{-27.9,-8},{-22,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SC.y, OC_SC_Controller.SC_R) annotation (Line(
      points={{-65,34},{-62,34},{-62,-1.2},{-52,-1.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(OC.y, OC_SC_Controller.OC_R) annotation (Line(
      points={{-63,-48},{-62,-48},{-62,-9.2},{-52,-9.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(OC1.y, SourceSynGas.T) annotation (Line(
      points={{-29,46},{-26,46},{-26,-2},{-22,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(reformer.drain, sink.gas_a) annotation (Line(
      points={{56,-1.75},{68,-1.75},{68,-2}},
      color={255,170,85},
      thickness=0.5));
  connect(reformer.feed, SourceSynGas.gas_a) annotation (Line(
      points={{8.48,-1.75},{-2,-1.75},{-2,-2}},
      color={255,170,85},
      thickness=0.5));
  connect(fixedTemperature.port, reformer.heatport) annotation (Line(points={{32,32},{32,23.25},{32.24,23.25}}, color={191,0,0}));
public
function plotResult

  constant String resultFileName = "TestSteamReformer2.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 324}, y={"reformer.T_reformer", "reformer.T_reformer_min"}, range={0.0, 1000.0, 494.0, 502.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 159}, y={"reformer.T_gas"}, range={0.0, 1000.0, 540.0, 543.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=2, position={0, 0, 793, 681}, y={"reformer.x_i_start[1]", "reformer.x_i[1]"}, range={0.0, 1000.0, 0.25000000000000006, 0.4000000000000001}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=2, position={0, 0, 793, 93}, y={"reformer.x_i_start[2]", "reformer.x_i[2]"}, range={0.0, 1000.0, 0.05, 0.15000000000000002}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=2, position={0, 0, 793, 93}, y={"reformer.x_i_start[3]", "reformer.x_i[3]"}, range={0.0, 1000.0, -0.05, 0.10000000000000002}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=2, position={0, 0, 793, 93}, y={"reformer.x_i_start[4]", "reformer.x_i[4]"}, range={0.0, 1000.0, 0.30000000000000004, 0.5}, grid=true, subPlot=4, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=2, position={0, 0, 793, 93}, y={"reformer.x_i_start[5]", "reformer.x_i[5]"}, range={0.0, 1000.0, -0.2, 0.2}, grid=true, subPlot=5, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=2, position={0, 0, 793, 93}, y={"reformer.x_i_start[6]", "reformer.x_i[6]"}, range={0.0, 1000.0, -0.005, 0.005}, grid=true, subPlot=6, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=2, position={0, 0, 793, 93}, y={"reformer.x_i_start[7]", "reformer.x_i[7]"}, range={0.0, 1000.0, 0.0, 0.2}, grid=true, subPlot=7, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{20,-52},{72,-100}},
          lineColor={28,108,200},
          textString="Component indices are:

1        -        Methane
2        -        Oxygen
3        -        Carbon dioxide
4        -        Water
5        -        Hydrogen
6        -        Carbon monoxide
7        -        Nitrogen

"), Text( extent={{-50,-48},{2,-96}},
          lineColor={28,108,200},
          textString="Look at:
reformer.T_reformer
reformer.T_gas

for every i:
reformer.x_i_start[i]
reformer.x_i[i]")}),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end TestSteamReformer2;
