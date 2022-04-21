within TransiEnt.Components.Gas.Reactor.Check;
model TestControllerH2AndH2OForReformer


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

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_SG_var vle_ng7_sg;

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundaryRealGas_Txim_flow1(
    medium=vle_ng7_sg,
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true) annotation (Placement(transformation(extent={{-102,-20},{-82,0}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi1(medium=vle_ng7_sg, variable_p=true) annotation (Placement(transformation(extent={{100,-20},{80,0}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor massComp_In(medium=vle_ng7_sg, compositionDefinedBy=1) annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    offset=-1,
    duration=1000,
    startTime=1000)
                  annotation (Placement(transformation(extent={{-134,22},{-114,42}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=500,
    offset=373.15,
    duration=1000,
    startTime=3000)
                   annotation (Placement(transformation(extent={{-134,-8},{-114,12}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=1000,
    startTime=7000,
    height=-29e5,
    offset=30e5)   annotation (Placement(transformation(extent={{132,-14},{112,6}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=[0,0.55,0.02,0.02,0.01,0.20,0.20,0,0; 5000,0.55,0.02,0.02,0.01,0.20,0.20,0,0; 6000,0.30,0.20,0.15,0.10,0.00,0.00,0,0.20; 100000,0.30,0.20,0.15,0.10,0.00,0.00,0,0.20])
                                                                                            annotation (Placement(transformation(extent={{-134,-38},{-114,-18}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor molarComp_Out(medium=vle_ng7_sg, compositionDefinedBy=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={64,0})));
  Controller.ControllerH2ForReformer controllerH2ForReformer(desiredMolarRatio=
        0.6) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,32})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_H2(
    variable_m_flow=true,
    medium=vle_ng7_sg,
    xi_const={0,0,0,0,0,0,0,0},
    T_const=293.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-14,16})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor vleMassflowSensor(medium=vle_ng7_sg, xiNumber=vleMassflowSensor.medium.nc) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-32,42},{-24,50}})));
  TransiEnt.Components.Gas.Reactor.Prereformer_L1 prereformer annotation (Placement(transformation(extent={{28,-20},{48,0}})));

  Modelica.Units.SI.MoleFraction molarRatioSC=molarComp_Out.fraction[7]/molarComp_Out.fraction[1];
  Modelica.Units.SI.MoleFraction molarRatioHC=molarComp_Out.fraction[9]/molarComp_Out.fraction[1];
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2 junction_feed_hydrogen(
    volume=0.01,
    medium=vle_ng7_sg,
    xi(start={0.234539,0.00852871,0.00852871,0.00426435,0.0852871,0.0852871,0.573565,0}),
    h(start=726e3),
    p(start=32e5)) annotation (Placement(transformation(extent={{-24,0},{-4,-20}})));
  Controller.ControllerH2OForReformer_StoCbeforeSMR controllerH2OForReformer(desiredMolarRatio=2) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-34,-50})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_H2O(
    variable_m_flow=true,
    medium=vle_ng7_sg,
    xi_const={0,0,0,0,0,0,1,0},
    T_const=873.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={12,-34})));
  Modelica.Blocks.Math.Gain gain1(
                                 k=-1) annotation (Placement(transformation(extent={{-16,-54},{-8,-46}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2 junction_feed_water(
    volume=0.01,
    medium=vle_ng7_sg,
    xi(start={0.234539,0.00852871,0.00852871,0.00426435,0.0852871,0.0852871,0.573565,0}),
    h(start=726e3),
    p(start=32e5)) annotation (Placement(transformation(extent={{2,-20},{22,0}})));
equation
  connect(ramp.y,boundaryRealGas_Txim_flow1. m_flow) annotation (Line(points={{-113,32},{-113,32},{-110,32},{-110,-4},{-104,-4}},
                                                                                                    color={0,0,127}));
  connect(ramp1.y,boundaryRealGas_Txim_flow1. T) annotation (Line(points={{-113,2},{-113,2},{-112,2},{-112,-10},{-104,-10}},
                                                                                            color={0,0,127}));
  connect(ramp2.y,boundaryRealGas_pTxi1. p) annotation (Line(points={{111,-4},{102,-4}},
                                                                                     color={0,0,127}));
  connect(combiTimeTable.y,boundaryRealGas_Txim_flow1. xi) annotation (Line(points={{-113,-28},{-110,-28},{-110,-16},{-104,-16}},
                                                                                                    color={0,0,127}));
  connect(vleMassflowSensor.m_flow, controllerH2ForReformer.m_flow_feed) annotation (Line(points={{-29,0},{-28,0},{-28,2},{-28,10},{-46,10},{-46,22}}, color={0,0,127}));
  connect(gain.y, source_H2.m_flow) annotation (Line(points={{-23.6,46},{-20,46},{-20,28}}, color={0,0,127}));
  connect(junction_feed_hydrogen.gasPort2, source_H2.gasPort) annotation (Line(
      points={{-14,0},{-14,3},{-14,6}},
      color={255,255,0},
      thickness=0.75));
  connect(gain1.y, source_H2O.m_flow) annotation (Line(points={{-7.6,-50},{6,-50},{6,-46}},    color={0,0,127}));
  connect(junction_feed_hydrogen.gasPort3, junction_feed_water.gasPort1) annotation (Line(
      points={{-4,-10},{2,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(source_H2O.gasPort, junction_feed_water.gasPort2) annotation (Line(
      points={{12,-24},{12,-24},{12,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(controllerH2OForReformer.m_flow_feed, vleMassflowSensor.m_flow) annotation (Line(points={{-30,-40},{-30,-40},{-30,0},{-29,0}}, color={0,0,127}));
  connect(boundaryRealGas_Txim_flow1.gasPort, massComp_In.gasPortIn) annotation (Line(
      points={{-82,-10},{-79,-10},{-76,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(prereformer.gasPortOut, molarComp_Out.gasPortIn) annotation (Line(
      points={{48,-10},{51,-10},{54,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(molarComp_Out.gasPortOut, boundaryRealGas_pTxi1.gasPort) annotation (Line(
      points={{74,-10},{77,-10},{80,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_feed_water.gasPort3, prereformer.gasPortIn) annotation (Line(
      points={{22,-10},{28,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(controllerH2OForReformer.m_flow_steam, gain1.u) annotation (Line(points={{-24,-50},{-16.8,-50}}, color={0,0,127}));
  connect(massComp_In.fraction, controllerH2ForReformer.xi) annotation (Line(points={{-55,0},{-54,0},{-54,22}}, color={0,0,127}));
  connect(massComp_In.fraction, controllerH2OForReformer.xi) annotation (Line(points={{-55,0},{-54,0},{-54,-18},{-38,-18},{-38,-40}}, color={0,0,127}));
  connect(controllerH2ForReformer.m_flow_hydrogen_recycle, gain.u) annotation (Line(points={{-50,42},{-50,46},{-38,46},{-32.8,46}}, color={0,0,127}));
  connect(massComp_In.gasPortOut, vleMassflowSensor.gasPortIn) annotation (Line(
      points={{-56,-10},{-50,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(vleMassflowSensor.gasPortOut,junction_feed_hydrogen. gasPort1) annotation (Line(
      points={{-30,-10},{-24,-10}},
      color={255,255,0},
      thickness=1.5));
  annotation (
    Diagram(coordinateSystem(extent={{-140,-60},{140,100}}, preserveAspectRatio=false), graphics={           Text(
          extent={{-58,92},{58,74}},
          lineColor={0,140,72},
          textString="1000-2000 s mass flow from 1 to 2 kg/s
3000-4000 s temperature from 100 to 600 C
5000-6000 s composition changes
7000-8000 s pressure at output from 30 to 1 bar
manually change desired molar ratio"),
                                 Text(
          extent={{-16,56},{12,46}},
          lineColor={0,140,72},
          textString="check molar ratio")}),
    Icon(graphics,
         coordinateSystem(extent={{-140,-60},{140,100}})),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the ControllerH2forReformer and the ControllerH2OforReformer</p>
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
end TestControllerH2AndH2OForReformer;
