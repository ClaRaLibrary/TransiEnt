within TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.Check;
model TestSteamReformer3 "Test um die Dynamik der Gleichgewichtsbestimmung zu berprfen"
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
    p_reformer=1.5e5,
    V_reac=0.0024,
    d_kat=1870) annotation (Placement(transformation(extent={{-8,-26},{40,24}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow SourceSynGas(
    variable_m_flow=false,
    medium=reformer.Syngas,
    variable_xi=true,
    xi_const={0.6,0,0,0.05,0,0},
    variable_T=false,
    T_const=580 + 273.15,
    m_flow_const=4e-3) annotation (Placement(transformation(extent={{-34,-12},{-14,8}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi sink(
    variable_p=false,
    variable_xi=false,
    T_const=585 + 273.15,
    medium=reformer.Syngas,
    p_const=1.5e5) annotation (Placement(transformation(
        extent={{-16,-16},{16,16}},
        rotation=180,
        origin={80,0})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow    fixedTemperature(Q_flow=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={12,64})));
  TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.Controller.OC_SC_Controller OC_SC_Controller annotation (Placement(transformation(extent={{-62,-18},{-42,2}})));
  Modelica.Blocks.Sources.Constant OC(k=0.3)
    annotation (Placement(transformation(extent={{-92,-46},{-72,-26}})));
  Modelica.Blocks.Sources.Ramp SC(
    duration=4000,
    startTime=1000,
    height=0.5,
    offset=0.75)
    annotation (Placement(transformation(extent={{-96,22},{-76,42}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation
  connect(fixedTemperature.port, reformer.heatport) annotation (Line(
      points={{12,54},{12,23.25},{16.24,23.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(reformer.drain, sink.gas_a) annotation (Line(
      points={{40,-1.75},{52,-1.75},{52,0},{64,0}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(SourceSynGas.gas_a, reformer.feed) annotation (Line(
      points={{-14,-2},{-7.52,-2},{-7.52,-1.75}},
      color={118,106,98},
      thickness=0.5,
      smooth=Smooth.None));
  connect(OC_SC_Controller.Xi_Reformer, SourceSynGas.xi) annotation (Line(
      points={{-41.8,-7.6},{-38.9,-7.6},{-38.9,-8},{-34,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SC.y, OC_SC_Controller.SC_R) annotation (Line(
      points={{-75,32},{-68,32},{-68,-4},{-60,-4},{-60,-3.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(OC.y, OC_SC_Controller.OC_R) annotation (Line(
      points={{-71,-36},{-70,-36},{-70,-12},{-68,-12},{-68,-12},{-60,-12},{-60,-11.2}},
      color={0,0,127},
      smooth=Smooth.None));
public
function plotResult

  constant String resultFileName = "TestSteamReformer3.mat";

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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{22,-52},{74,-100}},
          lineColor={28,108,200},
          textString="Component indices are:

1        -        Methane
2        -        Oxygen
3        -        Carbon dioxide
4        -        Water
5        -        Hydrogen
6        -        Carbon monoxide
7        -        Nitrogen

"), Text( extent={{-48,-48},{4,-96}},
          lineColor={28,108,200},
          textString="Look at:
reformer.T_reformer
reformer.T_gas

for every i:
reformer.x_i_start[i]
reformer.x_i[i]")}),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end TestSteamReformer3;
