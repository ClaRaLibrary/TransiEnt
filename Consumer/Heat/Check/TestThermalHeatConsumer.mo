within TransiEnt.Consumer.Heat.Check;
model TestThermalHeatConsumer


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




    extends TransiEnt.Basics.Icons.Checkmodel;

  ThermalHeatConsumer consumer(
    m_flow_nom=simCenter.m_flow_nom,
    Ti_ctrl=500,
    k_ctrl=10,
    kc_nom=1.2e7,
    T_amb_path="ambient/Temperature_Hamburg-Fuhlsbuettel_3600s_01012012_31122012.txt",
    G=1e7)        annotation (Placement(transformation(extent={{-28,-26},{30,26}})));
  TransiEnt.Components.Heat.Grid.IdealizedExpansionVessel sink(p=420000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={80,-10})));
  inner TransiEnt.SimCenter simCenter(m_flow_nom=4115) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi Source(
    T_const=137 + 273.15,
    p_const=4.6e5,
    variable_T=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={25,60})));
  Modelica.Blocks.Sources.Cosine T_feed(
    amplitude=10,
    f=1/86400,
    phase=1.5707963267949,
    offset=273.15 + 70,
    startTime=0) annotation (Placement(transformation(extent={{-21,49},{-1,69}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
equation
  connect(consumer.fluidPortOut,sink.waterPort)  annotation (Line(
      points={{30,-20.8},{62,-20.8},{62,8},{80,8},{80,0}},
      color={175,0,0},
      thickness=0.5));
  connect(Source.steam_a, consumer.fluidPortIn) annotation (Line(
      points={{35,60},{48,60},{48,-10.4},{30,-10.4}},
      color={0,131,169},
      thickness=0.5));
  connect(T_feed.y, Source.T) annotation (Line(points={{0,59},{9,59},{9,60},{15,60}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestThermalHeatConsumer.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={0, 0, 1615, 703}, y={"Source.eye.T"}, range={0.0, 660000.0, 50.0, 90.0}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={0, 0, 1615, 172}, y={"consumer.T_Room.T"}, range={0.0, 660000.0, 19.400000000000002, 20.200000000000003}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={0, 0, 1615, 171}, y={"consumer.tamb.y1"}, range={0.0, 660000.0, 0.0, 15.0}, grid=true, subPlot=3, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={0, 0, 1615, 171}, y={"consumer.Valve.opening_in"}, range={0.0, 660000.0, 0.0, 1.5}, grid=true, subPlot=4, colors={{28,108,200}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),           Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for a thermal heat consumer with a variable feed temperature</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"),
    experiment(StopTime=1),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestThermalHeatConsumer;
