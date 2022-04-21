within TransiEnt.Producer.Gas.Electrolyzer.Systems.Check;
model Test_FeedInStation_woStorage "Model for testing a feed in station without a storage"


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
  import TransiEnt;
  Modelica.Blocks.Sources.Constant constP(k=4e6)  annotation (Placement(transformation(extent={{-50,32},{-30,52}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi(p_const=2500000, m_flow_nom=0) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-26,-82})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)
                                                                                                  annotation (Placement(transformation(extent={{70,40},{90,60}})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation(
    usePowerPort=true,
    eta_n=0.75,
    P_el_n=1e6,
    P_el_min=1e5,
    k=1e10,
    m_flow_start=0.001,
    t_overload=900,
    startState=1,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    P_el_max=3*feedInStation.P_el_n,
    P_el_overload=1.5*feedInStation.P_el_n,
    p_out=5000000) annotation (Placement(transformation(extent={{-36,-64},{-16,-44}})));
  Modelica.Blocks.Sources.Constant constM(k=0.01) annotation (Placement(transformation(extent={{32,40},{12,60}})));
  Modelica.Blocks.Sources.Step stepP(
    height=2.98e6,
    offset=0.02e6,
    startTime=5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,-20})));
  Modelica.Blocks.Sources.Step stepM(
    offset=0.01,
    height=-0.005,
    startTime=5) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={22,20})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-68,-54})));
  Modelica.Blocks.Sources.Ramp rampP(
    duration=2500,
    height=4e6,
    startTime=100)                              annotation (Placement(transformation(extent={{-78,32},{-58,52}})));
  Modelica.Blocks.Sources.Ramp rampM(
    height=-0.01,
    duration=1000,
    offset=0.01,
    startTime=2200)                             annotation (Placement(transformation(extent={{32,-20},{12,0}})));
  Modelica.Blocks.Sources.Ramp rampP1(
    duration=1000,
    startTime=2200,
    height=-4e6,
    offset=4e6)                                 annotation (Placement(transformation(extent={{-78,0},{-58,20}})));
  Modelica.Blocks.Sources.Ramp rampM1(
    height=+0.01,
    offset=0,
    startTime=100,
    duration=1500)                              annotation (Placement(transformation(extent={{32,-52},{12,-32}})));
  inner TransiEnt.ModelStatistics                                         modelStatistics annotation (Placement(transformation(extent={{80,40},{100,60}})));
equation
  connect(feedInStation.epp, ElectricGrid.epp) annotation (Line(
      points={{-36,-54},{-42,-54},{-42,-54},{-58,-54}},
      color={0,135,135},
      thickness=0.5));
  connect(feedInStation.gasPortOut, boundaryRealGas_pTxi.gasPort) annotation (Line(
      points={{-26.5,-64.1},{-26.5,-68.05},{-26,-68.05},{-26,-72}},
      color={255,255,0},
      thickness=1.5));
  connect(rampP1.y, feedInStation.P_el_set) annotation (Line(points={{-57,10},{-26,10},{-26,-43.6}}, color={0,0,127}));
  connect(rampM1.y, feedInStation.m_flow_feedIn) annotation (Line(points={{11,-42},{11,-42},{-12,-42},{-12,-46},{-16,-46}}, color={0,0,127}));

  // _____________________________________________
  //
  //             Private functions
  // _____________________________________________
protected
  function plotResult

  constant String resultFileName = "Check_FeedInStation_woStorage.mat";

  output String resultFile;

  algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots(false);

  createPlot(id=1, position={0, 0, 1234, 646}, y={"feedInStation.P_el_set", "feedInStation.epp.P", "feedInStation.P_el_max","feedInStation.P_el_overload"}, range={0.0, 3600.0, -1000000.0, 5000000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {0,0,0}});
  createPlot(id=1, position={0, 0, 1234, 212}, y={"feedInStation.m_flow_feedIn", "feedInStation.h2toNG.gasPortIn.m_flow"}, range={0.0, 3600.0, -0.005, 0.015}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}});
  createPlot(id=1, position={0, 0, 1234, 212}, y={"feedInStation.electrolyzer.eta"}, range={0.0, 3600.0, 0.6000000000000001, 1.0}, grid=true, subPlot=3, colors={{28,108,200}});

  resultFile := "Successfully plotted results for file: " + resultFile;

  end plotResult;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-98,98},{84,60}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="#LA, 12.09.2016
- with two ramps, simulate 3600 s
- P-controlled with k=1e10
- look at electrolyzer power compared to set power: electrolyzer starts when P_set > P_min and shuts down
when P(m_flow_set) < P_min; when max. time in overload is exceeded, it regulates down to rated power
- look at produced hydrogen mass flow compared to set mass flow
- look at efficiency"), Text(
          extent={{4,-64},{82,-80}},
          lineColor={28,108,200},
          textString="eta_min(1e5 W) = 0.95
- > m_flow_min = 6.6996e-4 kg/s

m_flow_n (eta_n=0.75, P_el_n=1e6) = 5.29e-3 kg/s",
          horizontalAlignment=TextAlignment.Left)}),
    experiment(StopTime=3600, __Dymola_NumberOfIntervals=10000),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(executeCall=TransiEnt.Storage.PtG.Check.Check_FeedInStation_woStorage.plotResult() "Plot example results"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for FeedInStation_woStorage</p>
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
end Test_FeedInStation_woStorage;
