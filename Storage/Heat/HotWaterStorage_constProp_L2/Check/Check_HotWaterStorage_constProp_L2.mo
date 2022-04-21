within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L2.Check;
model Check_HotWaterStorage_constProp_L2


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

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  HotWaterStorage_constProp_L2 storage(
    m_flow_nom=1000,
    T_max=393.15,
    height=10,
    d=5,
    T_start(displayUnit="K") = 79 + 273.15,
    T_amb=288.15) annotation (Placement(transformation(extent={{-26,-22},{26,26}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    T_const=40 + 273,
    m_flow_const=10,
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,-18})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={48,22})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source1(
    T_const=80 + 273,
    variable_m_flow=true,
    variable_T=false,
    m_flow_const=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-38,22})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-38,-18})));
  TransiEnt.Basics.Blocks.Sources.TemperatureExpression
                                   T_stor_set(y=353.15)      annotation (Placement(transformation(extent={{-122,18},{-102,38}})));
  Modelica.Blocks.Continuous.LimPID PI(
    yMax=20,
    yMin=1,
    k=1e4,
    controllerType=Modelica.Blocks.Types.SimpleController.PI) annotation (Placement(transformation(extent={{-80,18},{-60,38}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureGridOut(medium=simCenter.fluid1, unitOption=1) annotation (Placement(transformation(extent={{16,30},{36,50}})));
  Modelica.Blocks.Sources.Step step(
    height=-5,
    offset=10,
    startTime=3600) annotation (Placement(transformation(extent={{92,-24},{70,-2}})));
  HotWaterStorage_constProp_L2 storage1(
    useFluidPorts=false,
    m_flow_nom=1000,
    T_max=393.15,
    height=10,
    d=5,
    T_start=352.15,
    T_amb=288.15) annotation (Placement(transformation(extent={{-26,-170},{26,-122}})));
  TransiEnt.Basics.Blocks.Sources.TemperatureExpression
                                   T_stor_set1(y(displayUnit="degC") = 353.15)
                                                              annotation (Placement(transformation(extent={{-114,-130},{-94,-110}})));
  Modelica.Blocks.Continuous.LimPID PI1(
    Ti=0.1,
    yMax=5e6,
    yMin=1,
    k=1e10,
    controllerType=Modelica.Blocks.Types.SimpleController.PI) annotation (Placement(transformation(extent={{-76,-130},{-56,-110}})));
  Modelica.Blocks.Sources.Step step1(
    height=-5,
    offset=10,
    startTime=3600) annotation (Placement(transformation(extent={{114,-188},{92,-166}})));
  TransiEnt.Basics.Blocks.Sources.TemperatureExpression T_supply_grid(y(displayUnit="K") = storage1.T_stor - (40 + 273.15)) annotation (Placement(transformation(extent={{118,-152},{92,-124}})));
  Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(extent={{76,-176},{58,-158}})));
  Modelica.Blocks.Math.Gain gain1(k=storage1.cp)
                                          annotation (Placement(transformation(extent={{48,-174},{34,-160}})));
equation
  connect(storage.fpGridIn, source.steam_a) annotation (Line(
      points={{13.52,-17.2},{20.76,-17.2},{20.76,-18},{30,-18}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(storage.fpGridOut, sink.steam_a) annotation (Line(
      points={{16.12,21.68},{21.06,21.68},{21.06,22},{38,22}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));

  connect(sink1.steam_a, storage.fpGenOut) annotation (Line(
      points={{-28,-18},{-16.64,-18},{-16.64,-17.68}},
      color={0,131,169},
      thickness=0.5));
  connect(storage.fpGenIn, source1.steam_a) annotation (Line(
      points={{-16.12,21.2},{-28,21.2},{-28,22}},
      color={175,0,0},
      thickness=0.5));
  connect(storage.fpGridOut, temperatureGridOut.port) annotation (Line(
      points={{16.12,21.68},{26,21.68},{26,30}},
      color={175,0,0},
      thickness=0.5));
  connect(T_stor_set.y, PI.u_s) annotation (Line(points={{-101,28},{-82,28}},                   color={0,0,127}));
  connect(PI.u_m, storage.T_stor_out) annotation (Line(points={{-70,16},{-70,4},{-134,4},{-134,50},{-5,50},{-5,38},{-4.68,38},{-4.68,25.04}}, color={0,0,127}));
  connect(PI.y, source1.m_flow) annotation (Line(points={{-59,28},{-50,28}},                   color={0,0,127}));
  connect(step.y, source.m_flow) annotation (Line(points={{68.9,-13},{52,-12}}, color={0,0,127}));
  connect(T_stor_set1.y, PI1.u_s) annotation (Line(points={{-93,-120},{-78,-120}},                       color={0,0,127}));
  connect(PI1.u_m, storage1.T_stor_out) annotation (Line(points={{-66,-132},{-66,-138},{-132,-138},{-132,-90},{-4.68,-90},{-4.68,-122.96}}, color={0,0,127}));
  connect(product1.u1, T_supply_grid.y) annotation (Line(points={{77.8,-161.6},{86,-161.6},{86,-138},{90.7,-138}}, color={0,0,127}));
  connect(product1.u2, step1.y) annotation (Line(points={{77.8,-172.4},{84,-172.4},{84,-177},{90.9,-177}}, color={0,0,127}));
  connect(gain1.u, product1.y) annotation (Line(points={{49.4,-167},{57.1,-167}}, color={0,0,127}));
  connect(gain1.y, storage1.Q_flow_demand) annotation (Line(points={{33.3,-167},{32,-167},{32,-146},{26,-146}},                     color={0,0,127}));
  connect(PI1.y, storage1.Q_flow_store) annotation (Line(points={{-55,-120},{-32,-120},{-32,-146},{-24.44,-146}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-220},{120,100}})),
    experiment(StopTime=10000, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Tester for HotWaterStorage_constProp_L2</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de) in July 2021 (added model without FluidPorts).</span></p>
</html>"),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Icon(coordinateSystem(extent={{-140,-220},{120,100}})));
end Check_HotWaterStorage_constProp_L2;
