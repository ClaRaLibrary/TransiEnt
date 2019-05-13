within TransiEnt.Components.Boundaries.Heat.Check;
model Test_HeatflowExternal_L2 "Model for testing Heatflow_External_L2"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  inner TransiEnt.SimCenter simCenter(Q_flow_n=100e3, m_flow_nom=1) annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    h_const=50*4200,
    m_flow_nom=1,
    Delta_p=1000,
    p_const=simCenter.p_nom[1]) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={72,-28})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    p_nom=simCenter.p_nom[2],
    m_flow_const=14,
    h_const=70*4200) annotation (Placement(transformation(extent={{-70,-38},{-50,-18}})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L2 heatflow(
    use_Q_flow_in=true,
    initOption=1,
    Q_flow_n=2.2e6,
    m_flow_nom=14,
    C=2.5e7,
    T_start=342.15)
                  annotation (Placement(transformation(extent={{-23,-28},{36,28}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T tILTemperatureSensor_out(unitOption=2)
                                                                   annotation (Placement(transformation(extent={{60,-66},{80,-46}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T tILTemperatureSensor_in(unitOption=2)
                                                                  annotation (Placement(transformation(extent={{-70,-66},{-50,-46}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=8,
    startTime=1,
    height=700e3,
    offset=1500e3)
    annotation (Placement(transformation(extent={{-42,26},{-22,46}})));
  Modelica.Blocks.Sources.Sine Q_flow_consumer(
    freqHz=2/86400,
    offset=1500e3,
    amplitude=700e3) annotation (Placement(transformation(extent={{6,50},{-8,64}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(massFlowSource.steam_a, heatflow.fluidPortIn) annotation (Line(
      points={{-50,-28},{-12,-28},{-12,-28},{-11.2,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(massFlowSink.steam_a, heatflow.fluidPortOut) annotation (Line(
      points={{62,-28},{62,-28},{24.2,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tILTemperatureSensor_in.port, heatflow.fluidPortIn) annotation (Line(
      points={{-60,-66},{-11.2,-66},{-11.2,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(tILTemperatureSensor_out.port, heatflow.fluidPortOut) annotation (
      Line(
      points={{70,-66},{24.2,-66},{24.2,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatflow.Q_flow_prescribed, Q_flow_consumer.y) annotation (Line(points={{-11.2,22.4},{-11.2,57},{-8.7,57}},   color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(
      StopTime=43200,
      Interval=300,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for Heatflow_External_L2</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
end Test_HeatflowExternal_L2;
