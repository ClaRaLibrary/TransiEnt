within TransiEnt.Producer.Combined.LargeScaleCHP.Check;
model TestTwoBlockCHP "Example how the two block CHP model works"
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
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-100,79},{-80,99}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-70,79},{-50,99}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency Grid(useInputConnector=false) annotation (Placement(transformation(extent={{20,50},{32,62}})));
  TwoBlockCHP                                             Plant(Block_1(
      P_el_init=0,
      Q_flow_init=0,
      h_nom=65*4.2e3,
      p_nom=12e5,
      m_flow_nom=700,
      T_feed_init=338.15), Block_2(
      P_el_init=0,
      Q_flow_init=0,
      p_nom=12e5,
      m_flow_nom=800,
      h_nom=65*4.2e3))  annotation (Placement(transformation(extent={{-60,-22},{10,22}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    Delta_p=0,
    p_const(displayUnit="bar") = 1600000,
    T_const(displayUnit="degC"),
    m_flow_nom=1500)             annotation (Placement(transformation(
        extent={{-7,-8},{7,8}},
        rotation=180,
        origin={31,34})));
  Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP annotation (Placement(transformation(extent={{26,-51},{44,-29}})));
  Modelica.Blocks.Sources.Constant m_flow_set_B1(k=-700)
                                                 annotation (Placement(transformation(extent={{-88,-48},{-68,-28}})));
  Modelica.Blocks.Sources.Constant T_return_set_B1(k=273.15 + 65)
                                                   annotation (Placement(transformation(extent={{-88,-82},{-68,-62}})));
  Modelica.Blocks.Sources.Constant m_flow_set_B2(k=-800)
                                                 annotation (Placement(transformation(extent={{-36,-52},{-16,-32}})));
  Modelica.Blocks.Sources.Constant T_return_set_B2(k=273.15 + 65)
                                                   annotation (Placement(transformation(extent={{-36,-86},{-16,-66}})));
  Modelica.Blocks.Sources.Ramp Q_flow_set1(
    duration=86400,
    offset=0,
    startTime=0,
    height=-220e6)
                 annotation (Placement(transformation(
        extent={{-11,-9.5},{11,9.5}},
        rotation=0,
        origin={-77,57.5})));
  Modelica.Blocks.Sources.RealExpression P_min1(
                                               y=-Plant.Block_1.pQDiagram.P_min)
                                                        annotation (Placement(
        transformation(
        extent={{-11,-9.5},{11,9.5}},
        rotation=0,
        origin={-71,31.5})));
  Modelica.Blocks.Sources.Ramp Q_flow_set2(
    duration=86400,
    offset=0,
    startTime=0,
    height=-165e6)
                 annotation (Placement(transformation(
        extent={{-11,-9.5},{11,9.5}},
        rotation=0,
        origin={-23,65.5})));
  Modelica.Blocks.Sources.RealExpression P_min2(y=-Plant.Block_2.pQDiagram.P_min)
                                                        annotation (Placement(
        transformation(
        extent={{-8,-9.5},{8,9.5}},
        rotation=0,
        origin={-26,37.5})));
  Components.Visualization.PQDiagram_Display PQDiagram1(PQCharacteristics=Base.Characteristics.PQ_Characteristics_WW1()) annotation (Placement(transformation(extent={{56,-32},{86,-4}})));
  Components.Visualization.PQDiagram_Display PQDiagram2(PQCharacteristics=Base.Characteristics.PQ_Characteristics_WW2()) annotation (Placement(transformation(extent={{56,-70},{86,-42}})));
equation
  connect(Plant.epp,Grid. epp) annotation (Line(
      points={{11.2174,18.15},{10,18.15},{10,55.94},{19.94,55.94}},
      color={0,135,135},
      thickness=0.5));
  connect(Plant.outlet, sink.steam_a) annotation (Line(
      points={{11.5217,-2.475},{14,-2.475},{14,34},{24,34}},
      color={175,0,0},
      thickness=0.5));
  connect(Plant.eye, infoBoxLargeCHP.eye) annotation (Line(points={{11.5217,-15.675},{20,-15.675},{20,-38},{24,-38},{24,-38.2},{26.9,-38.2}},color={28,108,200}));
public
function plotResult

  constant String resultFileName = "TestTwoBlockCHP.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=1, position={809, 0, 791, 817}, y={"Plant.Block_1.pQDiagram.P_max", "Plant.Block_1.pQDiagram.P_min",
  "Plant.Block_1.P_el_CHP_is"}, range={0.0, 90000.0, 20000000.0, 160000000.0}, grid=true, colors={{28,108,200}, {199,191,198}, {0,0,0}}, markers={MarkerStyle.None, MarkerStyle.None, MarkerStyle.FilledSquare}, thicknesses={0.5, 0.5, 0.25}, filename=resultFileName);
  createPlot(id=1, position={809, 0, 791, 269}, y={"Plant.Block_1.Q_flow_set_pos.y", "Plant.Block_1.Q_flow_is"}, range={0.0, 90000.0, -300000000.0, 400000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
  createPlot(id=1, position={809, 0, 791, 269}, y={"Plant.Block_1.eta_el", "Plant.Block_1.eta_th", "Plant.Block_1.eta_total"}, range={0.0, 90000.0, -2.0, 3.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFileName);
  createPlot(id=2, position={0, 0, 793, 817}, y={"Plant.Block_2.pQDiagram.P_max", "Plant.Block_2.pQDiagram.P_min",
  "Plant.Block_2.P_el_CHP_is"}, range={0.0, 90000.0, 20000000.0, 140000000.0}, grid=true, colors={{28,108,200}, {199,191,198}, {0,0,0}}, markers={MarkerStyle.None, MarkerStyle.None, MarkerStyle.FilledSquare}, thicknesses={0.5, 0.5, 0.25}, filename=resultFileName);
  createPlot(id=2, position={0, 0, 793, 269}, y={"Plant.Block_2.Q_flow_set_pos.y", "Plant.Block_2.Q_flow_is"}, range={0.0, 90000.0, -400000000.0, 400000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
  createPlot(id=2, position={0, 0, 793, 269}, y={"Plant.Block_2.eta_el", "Plant.Block_2.eta_th", "Plant.Block_2.eta_total"}, range={0.0, 90000.0, -3.0, 3.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(m_flow_set_B1.y, Plant.m_flow_set_B1) annotation (Line(points={{-67,-38},{-53,-38},{-53,-20.075}}, color={0,0,127}));
  connect(T_return_set_B1.y, Plant.T_return_B1) annotation (Line(points={{-67,-72},{-41.4348,-72},{-41.4348,-20.075}}, color={0,0,127}));
  connect(m_flow_set_B2.y, Plant.m_flow_set_B2) annotation (Line(points={{-15,-42},{-9.47826,-42},{-9.47826,-20.35}}, color={0,0,127}));
  connect(T_return_set_B2.y, Plant.T_return_B2) annotation (Line(points={{-15,-76},{1.47826,-76},{1.47826,-20.075}}, color={0,0,127}));
  connect(P_min2.y, Plant.P_set_B2) annotation (Line(points={{-17.2,37.5},{-14.6522,37.5},{-14.6522,23.375}}, color={0,0,127}));
  connect(Q_flow_set2.y, Plant.Q_flow_set_B2) annotation (Line(points={{-10.9,65.5},{-1.56522,65.5},{-1.56522,23.65}}, color={0,0,127}));
  connect(P_min1.y, Plant.P_set_B1) annotation (Line(points={{-58.9,31.5},{-54.2174,31.5},{-54.2174,23.375}}, color={0,0,127}));
  connect(Q_flow_set1.y, Plant.Q_flow_set_B1) annotation (Line(points={{-64.9,57.5},{-37.7826,57.5},{-37.7826,23.375}}, color={0,0,127}));
  connect(Plant.eye_Block2, PQDiagram2.eyeIn) annotation (Line(points={{11.5217,-22},{44,-22},{44,-56},{51.8,-56}}, color={28,108,200}));
  connect(Plant.eye_Block1, PQDiagram1.eyeIn) annotation (Line(points={{11.5217,-18.975},{51.8,-18.975},{51.8,-18}}, color={28,108,200}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=86400, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(coordinateSystem(extent={{-120,-100},{100,100}})));
end TestTwoBlockCHP;
