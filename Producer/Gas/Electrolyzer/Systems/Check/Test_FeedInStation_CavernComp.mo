within TransiEnt.Producer.Gas.Electrolyzer.Systems.Check;
model Test_FeedInStation_CavernComp "Model for testing a feed in station for hydrogen with a compressor and an underground storage"
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
  import TransiEnt;
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-28,-82})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)
                                                                                                  annotation (Placement(transformation(extent={{0,40},{20,60}})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp feedInStation(
    start_pressure=true,
    eta_n=0.75,
    t_overload=900,
    m_flow_start=1e-4,
    P_el_min=1e5,
    alpha_nom=133,
    V_geo=2,
    P_el_n=2e6,
    p_out=5000000,
    p_start=10000000,
    T_start=317.15,
    integrateMassFlow=false)
                    annotation (Placement(transformation(extent={{-38,-64},{-18,-44}})));
    //includeHeatTransfer=true,
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-72,-54})));
  Modelica.Blocks.Sources.Constant constP(k=4e6)  annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Sources.Step stepP(
    height=4e6,
    offset=0,
    startTime=4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,10})));
  Modelica.Blocks.Sources.Ramp rampP(
    startTime=100,
    height=4e6,
    duration=1000)                              annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Constant constM(k=0.01) annotation (Placement(transformation(extent={{40,-66},{20,-46}})));
  Modelica.Blocks.Sources.Step stepM(
    offset=0.01,
    height=-0.005,
    startTime=2)    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,4})));
  Modelica.Blocks.Sources.Ramp rampM(
    height=-0.01,
    duration=1000,
    offset=0.01,
    startTime=2200)                             annotation (Placement(transformation(extent={{40,-36},{20,-16}})));
  inner TransiEnt.ModelStatistics                                         modelStatistics annotation (Placement(transformation(extent={{20,40},{40,60}})));
equation
  connect(feedInStation.gasPortOut, boundaryRealGas_pTxi.gasPort) annotation (Line(
      points={{-28.5,-64.1},{-28.5,-72},{-28,-72}},
      color={255,255,0},
      thickness=1.5));
  connect(feedInStation.epp, ElectricGrid.epp) annotation (Line(
      points={{-38,-54},{-42,-54},{-42,-54},{-62,-54}},
      color={0,135,135},
      thickness=0.5));
  connect(rampM.y, feedInStation.m_flow_feedIn) annotation (Line(points={{19,-26},{4,-26},{-14,-26},{-14,-46},{-18,-46}}, color={0,0,127}));
  connect(rampP.y, feedInStation.P_el_set) annotation (Line(points={{-59,40},{-42,40},{-42,-43.6},{-28,-43.6}},
                                                                                                    color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600, __Dymola_NumberOfIntervals=10000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for FeedInStation_CavernComp</p>
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
end Test_FeedInStation_CavernComp;
