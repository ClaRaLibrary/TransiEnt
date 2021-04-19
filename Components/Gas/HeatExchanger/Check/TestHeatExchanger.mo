within TransiEnt.Components.Gas.HeatExchanger.Check;
model TestHeatExchanger
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

  TransiEnt.Components.Gas.HeatExchanger.HEXTwoRealGasesIdeal_L1 hEXTwoRealGasesIdeal_L1(
    medium2=simCenter.gasModel3,
    Delta_p1=10000,
    Delta_p2=100000,
    T_out_realGas1=323.15) annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_gas1(m_flow_const=-1, T_const=573.15) annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_gas2(
    medium=simCenter.gasModel3,
    m_flow_const=-1,
    T_const=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,30})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_gas2(medium=simCenter.gasModel3, p_const=1500000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,90})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_gas1(p_const=1500000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-30,60})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1)
                                                                                                           annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOuterTIdeal_L1 hEXOneRealGasOuterTIdeal_L1(Delta_p=10000, T_fluidOutConst=323.15) annotation (Placement(transformation(extent={{-70,0},{-50,-20}})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOuterQflowIdeal_L1 hEXOneRealGasOuterQflowIdeal_L1(medium=simCenter.gasModel3, Delta_p=100000) annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_gas4(
    medium=simCenter.gasModel3,
    m_flow_const=-1,
    T_const=293.15) annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_gas4(medium=simCenter.gasModel3, p_const=1500000) annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_gas3(m_flow_const=-1, T_const=573.15) annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_gas3(p_const=1500000) annotation (Placement(transformation(extent={{-20,-20},{-40,0}})));
  HEXOneRealGasOneFluidIdeal_L1 hEXOneRealGasOneFluidIdeal_L1(
    Delta_p_realGas=10000,
    Delta_p_fluid=100000,
    T_out_fixed=323.15) annotation (Placement(transformation(extent={{50,50},{70,70}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_gas5(m_flow_const=-1, T_const=573.15) annotation (Placement(transformation(extent={{20,50},{40,70}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_gas5(p_const=1500000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={90,60})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(m_flow_const=1, T_const(displayUnit="degC") = 283.15)
                                                                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,30})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(p_const(displayUnit="bar") = 1000000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,90})));
  HEXOneRealGasOneFluidIdeal_L1 hEXOneRealGasOneFluidIdeal_L1_1(
    fixedTemperatureRealGas=false,
    Delta_p_realGas=10000,
    Delta_p_fluid=100000,
    T_out_fixed=323.15) annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_gas6(m_flow_const=-10, T_const=293.15) annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_gas6(p_const=1500000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={90,-40})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow1(m_flow_const=1, T_const(displayUnit="degC") = 423.15)
                                                                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-70})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi1(
                                                                        p_const(displayUnit="bar") = 1000000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-10})));
equation
  connect(sink_gas2.gasPort, hEXTwoRealGasesIdeal_L1.gasPortOut2) annotation (Line(
      points={{-60,80},{-60,76},{-60,70}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXTwoRealGasesIdeal_L1.gasPortOut1, sink_gas1.gasPort) annotation (Line(
      points={{-50,60},{-40,60}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXTwoRealGasesIdeal_L1.gasPortIn2, source_gas2.gasPort) annotation (Line(
      points={{-60,50},{-60,50},{-60,40}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXTwoRealGasesIdeal_L1.gasPortIn1, source_gas1.gasPort) annotation (Line(
      points={{-70,60},{-80,60}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXOneRealGasOuterQflowIdeal_L1.heat, hEXOneRealGasOuterTIdeal_L1.heat) annotation (Line(points={{-60,-30},{-60,-30},{-60,-20}}, color={191,0,0}));
  connect(sink_gas3.gasPort, hEXOneRealGasOuterTIdeal_L1.gasPortOut) annotation (Line(
      points={{-40,-10},{-40,-10},{-50,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(source_gas3.gasPort, hEXOneRealGasOuterTIdeal_L1.gasPortIn) annotation (Line(
      points={{-80,-10},{-80,-10},{-70,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(sink_gas4.gasPort, hEXOneRealGasOuterQflowIdeal_L1.gasPortOut) annotation (Line(
      points={{-40,-40},{-40,-40},{-50,-40}},
      color={255,255,0},
      thickness=1.5));
  connect(source_gas4.gasPort, hEXOneRealGasOuterQflowIdeal_L1.gasPortIn) annotation (Line(
      points={{-80,-40},{-80,-40},{-70,-40}},
      color={255,255,0},
      thickness=1.5));
  connect(source_gas5.gasPort, hEXOneRealGasOneFluidIdeal_L1.gasPortIn) annotation (Line(
      points={{40,60},{45,60},{50,60}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXOneRealGasOneFluidIdeal_L1.gasPortOut, sink_gas5.gasPort) annotation (Line(
      points={{70,60},{76,60},{80,60}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXOneRealGasOneFluidIdeal_L1.fluidPortOut, boundaryVLE_pTxi.steam_a) annotation (Line(
      points={{60,70},{60,75},{60,80}},
      color={175,0,0},
      thickness=0.5));
  connect(hEXOneRealGasOneFluidIdeal_L1.fluidPortIn, boundaryVLE_Txim_flow.steam_a) annotation (Line(
      points={{60,50},{60,45},{60,40}},
      color={175,0,0},
      thickness=0.5));
  connect(source_gas6.gasPort, hEXOneRealGasOneFluidIdeal_L1_1.gasPortIn) annotation (Line(
      points={{40,-40},{45,-40},{50,-40}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXOneRealGasOneFluidIdeal_L1_1.gasPortOut, sink_gas6.gasPort) annotation (Line(
      points={{70,-40},{76,-40},{80,-40}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXOneRealGasOneFluidIdeal_L1_1.fluidPortOut, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{60,-30},{60,-25},{60,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(hEXOneRealGasOneFluidIdeal_L1_1.fluidPortIn, boundaryVLE_Txim_flow1.steam_a) annotation (Line(
      points={{60,-50},{60,-55},{60,-60}},
      color={175,0,0},
      thickness=0.5));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the different heat exchanger. This model provides the necessary gas and fluid boundaries for testing the heat exchanger and contains the sim center</p>
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
end TestHeatExchanger;
