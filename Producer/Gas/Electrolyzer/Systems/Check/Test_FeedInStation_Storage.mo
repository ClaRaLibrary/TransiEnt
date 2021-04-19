within TransiEnt.Producer.Gas.Electrolyzer.Systems.Check;
model Test_FeedInStation_Storage "Model for testing a feed in station for hydrogen with a storage"
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
  import TransiEnt;
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-28,-82})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)
                                                                                                  annotation (Placement(transformation(extent={{30,40},{50,60}})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_Storage feedInStation(
    usePowerPort=true,
    start_pressure=true,
    includeHeatTransfer=false,
    eta_n=0.75,
    t_overload=900,
    m_flow_start=1e-4,
    P_el_min=1e5,
    k=1e11,
    V_geo=1,
    p_out=5000000,
    p_start=5000000,
    integrateMassFlow=false)
                     annotation (Placement(transformation(extent={{-38,-64},{-18,-44}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(
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
    duration=1500,
    height=4e6)                                 annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
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
  inner TransiEnt.ModelStatistics                                         modelStatistics annotation (Placement(transformation(extent={{40,40},{60,60}})));
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
  connect(rampP.y, feedInStation.P_el_set) annotation (Line(points={{-59,40},{-28,40},{-28,-43.6}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-96,98},{100,58}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="#LA, 12.09.2016:
- with two ramps, simulate 3600 s
- p_start= 50 bar, V_geo=100 m3
- P-controlled with k=1e10
- look at electrolyzer power compared to set power: electrolyzer starts when P_set>P_min, regulates down when storage is full
and shuts down when P(m_flow_set)<P_min & storage is full; when max. time in overload is exceeded, it regulates down to rated power
- look at produced hydrogen mass flow compared to set mass flow, at charge and discharge mass flows
- look at storage power")}),
    experiment(StopTime=3600, __Dymola_NumberOfIntervals=10000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for FeedInStation_Storage</p>
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
end Test_FeedInStation_Storage;
