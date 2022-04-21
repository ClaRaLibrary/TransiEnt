within TransiEnt.Components.Boundaries.Heat.Check;
model Test_Heatflow_L2 "Model for testing Heatflow_L2"



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





  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressureSink(
    m_flow_nom=1,
    Delta_p=1000,
    p_const=simCenter.p_nom[1],
    T_const(displayUnit="degC") = 323.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={72,-28})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow massFlowSource(
    m_flow_nom=0,
    m_flow_const=1,
    p_nom=simCenter.p_nom[2],
    T_const(displayUnit="degC") = 343.15) annotation (Placement(transformation(extent={{-70,-38},{-50,-18}})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L2 heatflow(
    use_Q_flow_in=false,
    Q_flow_const=80e3,
    initOption=1,
    T_start=323.15) annotation (Placement(transformation(extent={{-23,-28},{36,28}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out(unitOption=2)
                                                                annotation (Placement(transformation(extent={{60,-66},{80,-46}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in(unitOption=2)
                                                               annotation (Placement(transformation(extent={{-70,-66},{-50,-46}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
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
  connect(pressureSink.steam_a, heatflow.fluidPortOut) annotation (Line(
      points={{62,-28},{62,-28},{24.2,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(temperatureSensor_in.port, heatflow.fluidPortIn) annotation (Line(
      points={{-60,-66},{-11.2,-66},{-11.2,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(temperatureSensor_out.port, heatflow.fluidPortOut) annotation (Line(
      points={{70,-66},{24.2,-66},{24.2,-28}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for Heatflow_L2</p>
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
end Test_Heatflow_L2;
