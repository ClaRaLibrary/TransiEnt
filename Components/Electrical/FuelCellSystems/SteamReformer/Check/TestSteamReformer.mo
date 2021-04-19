within TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.Check;
model TestSteamReformer "Test dynamic of steam reformer"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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
    p_reformer=150000,
    d_kat=1870)        annotation (Placement(transformation(extent={{10,-16},{58,34}})));
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
    medium=reformer.Syngas,
    variable_T=true)        "Source for methan rich gas (e.g. Natural Gas)" annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
  TransiEnt.Components.Electrical.FuelCellSystems.SteamReformer.Controller.OC_SC_Controller OC_SC_Controller annotation (Placement(transformation(extent={{-54,-18},{-34,2}})));
  Modelica.Blocks.Sources.Constant OC(k=0.2)
    annotation (Placement(transformation(extent={{-88,-34},{-68,-14}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Modelica.Blocks.Sources.Ramp SC1(
    duration=4000,
    startTime=1000,
    height=0.5,
    offset=0.75)
    annotation (Placement(transformation(extent={{-88,6},{-68,26}})));
  Modelica.Blocks.Sources.Ramp T_ramp(
    height=45,
    duration=4000,
    offset=585 + 273,
    startTime=6000) annotation (Placement(transformation(extent={{-54,34},{-34,54}})));
equation
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
equation
  connect(SC1.y, OC_SC_Controller.SC_R) annotation (Line(points={{-67,16},{-60,16},{-60,-3.2},{-52,-3.2}}, color={0,0,127}));
  connect(T_ramp.y, SourceSynGas.T) annotation (Line(points={{-33,44},{-28,44},{-28,0},{-22,0}}, color={0,0,127}));
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
    experiment(StopTime=11000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for SteamReformer with constant O/C ratio at reformer inlet. The S/C ratio and temperature are ramped up to show the behavior of the reformer.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4.Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p>Model created by Simon Weilbach (simon.weilbach@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Several test models combined to this one by Carsten Bode (c.bode@tuhh.de) on 21.11.2018</span></p>
</html>"));
end TestSteamReformer;
