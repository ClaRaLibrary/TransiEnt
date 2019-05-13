within TransiEnt.Producer.Combined.LargeScaleCHP.Check;
model TestContinuousCHP_startup "Example how the continuous plant model behaves when ramping up"
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
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-100,79},{-80,99}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-70,79},{-50,99}})));
  Modelica.Blocks.Sources.RealExpression P_min(y=-Plant.pQDiagram.P_min)
                                                        annotation (Placement(
        transformation(
        extent={{-11,-9.5},{11,9.5}},
        rotation=0,
        origin={-49,25.5})));
  TransiEnt.Components.Boundaries.Electrical.Frequency Grid(useInputConnector=false) annotation (Placement(transformation(extent={{20,50},{32,62}})));
  ContinuousCHP Plant(
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal,
    typeOfCO2AllocationMethod=2,
    h_nom=547e3,
    eta_th_const=0.696296,
    p_nom=20e5,
    m_flow_nom=750,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.HardCoal,
    PQCharacteristics=Base.Characteristics.PQ_Characteristics_WT(),
    P_el_n=200e6,
    Q_flow_n_CHP=290e6,
    Q_flow_n_Peak=0,
    T_feed_init=363.15,
    P_el_init=0,
    Q_flow_init=0,
    Q_flow_SG_init=0) annotation (Placement(transformation(extent={{-36,-22},{10,22}})));

  Modelica.Blocks.Sources.Ramp Q_flow_set(
    height=-290e6,
    duration=86400,
    offset=0,
    startTime=0) annotation (Placement(transformation(
        extent={{-11,-9.5},{11,9.5}},
        rotation=0,
        origin={-19,47.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(T_const(displayUnit="degC") = 338.15, m_flow_const=1000) annotation (Placement(transformation(
        extent={{-7,-9},{7,9}},
        rotation=180,
        origin={35,-10})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{46,1},{82,22}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    m_flow_nom=577.967,
    Delta_p=0,
    p_const(displayUnit="bar") = 1600000,
    T_const(displayUnit="degC")) annotation (Placement(transformation(
        extent={{-7,-8},{7,8}},
        rotation=180,
        origin={31,34})));
  Components.Visualization.PQDiagram_Display PQDiagram(PQCharacteristics=Base.Characteristics.PQ_Characteristics_WT()) annotation (Placement(transformation(extent={{66,-34},{96,-6}})));
  Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP annotation (Placement(transformation(extent={{26,-51},{44,-29}})));
equation
  connect(Plant.epp,Grid. epp) annotation (Line(
      points={{8.85,6.6},{10,6.6},{10,56},{20,56}},
      color={0,135,135},
      thickness=0.5));
  connect(Plant.P_set,P_min. y) annotation (Line(points={{-27.03,16.8667},{-27.03,25.5},{-36.9,25.5}},
                                                                                           color={0,0,127}));
  connect(Q_flow_set.y, Plant.Q_flow_set) annotation (Line(points={{-6.9,47.5},{-4,47.5},{-4,16.8667},{-4.49,16.8667}},   color={0,0,127}));
  connect(Plant.outlet, sink.steam_a) annotation (Line(
      points={{10.46,-4.76667},{14,-4.76667},{14,34},{24,34}},
      color={175,0,0},
      thickness=0.5));
  connect(source.steam_a, Plant.inlet) annotation (Line(
      points={{28,-10},{22,-10},{22,-9.9},{10.46,-9.9}},
      color={0,131,169},
      thickness=0.5));
  connect(source.eye, quadruple.eye) annotation (Line(points={{28,-2.8},{28,-2.8},{28,-10},{28,11.5},{46,11.5}},
                                                                                                             color={190,190,190}));
  connect(Plant.eye, PQDiagram.eyeIn) annotation (Line(points={{12.3,-20.1667},{20,-20.1667},{20,-20},{61.8,-20}}, color={28,108,200}));
  connect(Plant.eye, infoBoxLargeCHP.eye) annotation (Line(points={{12.3,-20.1667},{20,-20.1667},{20,-38},{24,-38},{24,-38.2},{26.9,-38.2}}, color={28,108,200}));
public
function plotResult

  constant String resultFileName = "TestContinuousCHPs_startup.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={639, 0, 835, 629}, y={"Plant.pQDiagram.P_max", "Plant.pQDiagram.P_min", "Plant.P_el_CHP_is",
"Plant.P_el_set_pos.y"}, range={0.0, 1450.0, -50000000.0, 250000000.0}, grid=true, colors={{28,108,200}, {199,191,198}, {0,0,0}, {238,46,47}}, markers={MarkerStyle.None, MarkerStyle.None, MarkerStyle.FilledSquare, MarkerStyle.None}, thicknesses={0.5, 0.5, 0.25, 0.25}, filename=resultFileName);
createPlot(id=1, position={639, 0, 835, 205}, y={"Plant.Q_flow_set_pos.y", "Plant.Q_flow_is"}, range={0.0, 1450.0, -100000000.0, 300000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={639, 0, 835, 206}, y={"Plant.eta_el", "Plant.eta_th", "Plant.eta_total"}, range={0.0, 1450.0, -0.2, 1.0000000000000002}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(graphics,
         coordinateSystem(extent={{-120,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for upramping continous chp plants</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestContinuousCHP_startup;
