within TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.Check;
model TestSteamReformer1 "Test dynamic of mass composition"
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
  TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.SteamReformer_NaturalGas_to_H2 reformer(
    eps=1e-6,
    d_kat=1850,
    cp=850,
    T_reformer(fixed=true, start=500 + 273),
    scale_kat=4,
    V_reac=0.0024,
    p_reformer=150000) annotation (Placement(transformation(extent={{10,-16},{58,34}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi SinkSyngas(
    variable_p=false,
    variable_xi=false,
    T_const=585 + 273.15,
    medium=reformer.Syngas,
    p_const=1e5) "Sink for H2 rich syngas" annotation (Placement(transformation(
        extent={{-10,-12},{10,12}},
        rotation=180,
        origin={82,14})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow    fixedTemperature(Q_flow=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={34,56})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow SourceSynGas(
    variable_m_flow=false,
    variable_xi=true,
    T_const=585 + 273.15,
    xi_const={0.6,0,0,0.05,0,0},
    m_flow_const=2e-4,
    variable_T=false,
    medium=reformer.Syngas) "Source for methan rich gas (e.g. Natural Gas)" annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
  TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.Controller.OC_SC_Controller OC_SC_Controller annotation (Placement(transformation(extent={{-54,-18},{-34,2}})));
  Modelica.Blocks.Sources.Constant SC(k=1.2)
    annotation (Placement(transformation(extent={{-88,4},{-68,24}})));
  Modelica.Blocks.Sources.Constant OC(k=0.2)
    annotation (Placement(transformation(extent={{-88,-34},{-68,-14}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation
  connect(SC.y,OC_SC_Controller. SC_R) annotation (Line(
      points={{-67,14},{-62,14},{-62,-3.2},{-52,-3.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(OC.y,OC_SC_Controller. OC_R) annotation (Line(
      points={{-67,-24},{-62,-24},{-62,-11.2},{-52,-11.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(reformer.drain, SinkSyngas.gas_a) annotation (Line(
      points={{58,8.25},{64,8.25},{64,8},{68,8},{68,14},{72,14}},
      color={255,170,85},
      thickness=0.5));
  connect(reformer.feed, SourceSynGas.gas_a) annotation (Line(
      points={{10.48,8.25},{2.24,8.25},{2.24,0},{-2,0}},
      color={255,170,85},
      thickness=0.5));
  connect(fixedTemperature.port, reformer.heatport) annotation (Line(points={{34,46},{34,33.25},{34.24,33.25}}, color={191,0,0}));
  connect(OC_SC_Controller.Xi_Reformer, SourceSynGas.xi) annotation (Line(points={{-33.8,-7.6},{-27.9,-7.6},{-27.9,-6},{-22,-6}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestSteamReformer1.mat";

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
          extent={{-62,-46},{-10,-94}},
          lineColor={28,108,200},
          textString="Look at:
reformer.T_reformer
reformer.T_gas

for every i:
reformer.x_i_start[i]
reformer.x_i[i]"), Text(
          extent={{8,-50},{60,-98}},
          lineColor={28,108,200},
          textString="Component indices are:

1        -        Methane
2        -        Oxygen
3        -        Carbon dioxide
4        -        Water
5        -        Hydrogen
6        -        Carbon monoxide
7        -        Nitrogen

")}),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end TestSteamReformer1;
