within TransiEnt.Producer.Gas.SteamMethaneReformerSystem.Check;
model TestSMRSystem_noH2Loop_wContr


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

  TransiEnt.Producer.Gas.SteamMethaneReformerSystem.SMRSystem_noH2Loop sMRSystem_sufficientH2inFeed(
    redeclare model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.SMR,
    H_flow_H2_n=200e6,
    N_cv_SMR=10,
    Cspec_demAndRev_el=simCenter.Cspec_demAndRev_el_70_150_GWh,
    Cspec_demAndRev_other_water=simCenter.Cspec_demAndRev_other_water) annotation (Placement(transformation(extent={{-60,-30},{60,30}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi                source(
    xi_const=source.medium.xi_default*(1 - 0.1),
    medium=Basics.Media.Gases.VLE_VDIWA_NG7_SG_var(),
    T_const=293.15) annotation (Placement(transformation(extent={{-128,-10},{-108,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkHydrogen(medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var(), p_const=2000000) annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature_HEX_feed(each T(displayUnit="degC") = 864.18)    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-50,50})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature_HEX_H2O(each T(displayUnit="degC") = 864.18)
                                         annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-26,80})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature_SMR(each T(displayUnit="K") = 1625) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,50})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkWasteGas(
    T_const(displayUnit="K"),
    medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var(),
    p_const=100000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={50,78})));
  Components.Gas.Compressor.CompressorRealGasIsentropicEff_L1_simple compressorRealGasIsentropicEff_L1_simple(
    presetVariableType="m_flow",
    m_flowInput=true,
    medium=Basics.Media.Gases.VLE_VDIWA_NG7_SG_var()) annotation (Placement(transformation(extent={{-98,10},{-78,-10}})));
  Components.Gas.Reactor.Controller.ControllerFeedForReformer controllerFeedForReformer(k=1, controllerType=Modelica.Blocks.Types.SimpleController.PI) annotation (Placement(transformation(extent={{-106,-30},{-86,-50}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=0.1,
    f=1/10000,
    offset=1.17) annotation (Placement(transformation(extent={{-64,-40},{-72,-32}})));
equation
  connect(sMRSystem_sufficientH2inFeed.gasPortOut_hydrogen, sinkHydrogen.gasPort) annotation (Line(
      points={{60,0},{70,0},{80,0}},
      color={255,255,0},
      thickness=1.5));
  connect(fixedTemperature_HEX_feed.port, sMRSystem_sufficientH2inFeed.heatFeedPreheater) annotation (Line(points={{-50,40},{-50,30}},               color={191,0,0}));
  connect(fixedTemperature_HEX_H2O.port, sMRSystem_sufficientH2inFeed.heatSteamPreheater) annotation (Line(points={{-26,70},{-26,70},{-26,30},{-25,30}},      color={191,0,0}));
  connect(fixedTemperature_SMR.port, sMRSystem_sufficientH2inFeed.heatSMR) annotation (Line(points={{-1.77636e-015,40},{-1.77636e-015,30},{0,30}},
                                                                                                                                 color={191,0,0}));
  connect(sinkWasteGas.gasPort, sMRSystem_sufficientH2inFeed.gasPortOut_offGas) annotation (Line(
      points={{50,68},{50,68},{50,30}},
      color={255,255,0},
      thickness=1.5));
  connect(source.gasPort, compressorRealGasIsentropicEff_L1_simple.gasPortIn) annotation (Line(
      points={{-108,0},{-98,0}},
      color={255,255,0},
      thickness=1.5));
  connect(compressorRealGasIsentropicEff_L1_simple.gasPortOut, sMRSystem_sufficientH2inFeed.gasPortIn) annotation (Line(
      points={{-78,0},{-60,0}},
      color={255,255,0},
      thickness=1.5));
  connect(controllerFeedForReformer.m_flow_feed, compressorRealGasIsentropicEff_L1_simple.m_flow_in) annotation (Line(points={{-96,-30},{-96,-11}}, color={0,0,127}));
  connect(sMRSystem_sufficientH2inFeed.massflow_H2_out, controllerFeedForReformer.m_flow_H2) annotation (Line(points={{62.5,24},{74,24},{74,-44},{-86.2,-44}}, color={0,0,127}));
  connect(sine.y, controllerFeedForReformer.m_flow_set_H2) annotation (Line(points={{-72.4,-36},{-86.2,-36}}, color={0,0,127}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{100,100}})),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{100,100}})),
    experiment(StopTime=10000),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the SMRSystem_noH2Loop with a controller</p>
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
end TestSMRSystem_noH2Loop_wContr;
