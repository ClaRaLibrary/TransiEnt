within TransiEnt.Producer.Gas.Electrolyzer.Check;
model Test_400A_Espinosa_L2 "Test functionality of new electrolyzer model structure with Espinosa physics subcomponents"


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
  import      Modelica.Units.SI;

public
  parameter SI.Temperature T_op_start=273.15+25 "for 400A constant current";

  parameter SI.Pressure p_out=35e5 "Pressure of the produced hydrogen";

  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L2 EM(T_op_start=T_op_start, whichInput=1) annotation (Placement(transformation(extent={{0,20},{20,40}})));

/*redeclare model CostSpecsGeneral =
        TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Electrolyzer_2035,*/

  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid_0thOrder annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,30})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_0thOrder(p_const=p_out) annotation (Placement(transformation(extent={{60,20},{40,40}})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel1, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3)
                                                                       annotation (Placement(transformation(extent={{148,78},
            {168,98}})));
  //inner TransiEnt.ModelStatistics                                         modelStatisticsDetailed annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Ramp CurrentRamp(
    offset=0,
    startTime=0,
    duration=0,
    height=400)
    annotation (Placement(transformation(extent={{-52,62},{-32,82}})));

  Modelica.Blocks.Sources.RealExpression v_stackT1(y=EM.summary.outline.V_stack)
    annotation (Placement(transformation(extent={{76,16},{96,36}})));
  Modelica.Blocks.Sources.RealExpression temp1(y=EM.summary.outline.T_op - 273.15)
    annotation (Placement(transformation(extent={{76,-32},{96,-12}})));
  Modelica.Blocks.Sources.CombiTimeTable espExperimentalTemp(smoothness=
        Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1, table=[
        7.56,25.082; 41.65,26.937; 77.22,27.555; 112.8,29.41; 146.89,31.265;
        182.46,32.811; 219.52,32.811; 255.1,34.976; 290.67,36.831; 326.24,
        38.068; 361.82,37.758; 397.39,39.613; 432.97,41.469; 468.54,42.705;
        504.12,41.778; 539.69,43.324; 573.78,45.797; 609.36,46.725; 644.93,
        45.179; 679.02,48.271; 714.6,49.507; 750.17,49.507; 787.23,48.271;
        818.35,51.362; 853.93,52.908; 888.02,52.29; 923.6,51.981; 956.21,55.073;
        988.81,55.382; 996.23,56; 1030.32,53.527; 1065.89,53.527; 1099.98,56;
        1137.04,57.546; 1168.17,54.145; 1181.51,52.599; 1194.85,52.754])
    annotation (Placement(transformation(extent={{76,-10},{96,10}})));
  Modelica.Blocks.Sources.CombiTimeTable espExperimentalVoltage(smoothness=
        Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1, table=[
        1.63,113.817; 37.2,112.89; 72.78,112.581; 109.83,112.271; 146.89,
        111.653; 182.46,111.344; 219.52,111.344; 256.58,110.725; 292.15,110.107;
        329.21,109.798; 366.27,110.107; 401.84,109.489; 438.9,109.18; 475.95,
        108.87; 513.01,109.18; 548.58,108.561; 585.64,108.252; 622.7,108.252;
        659.75,108.252; 695.33,107.634; 732.38,107.324; 769.44,107.634; 805.01,
        107.324; 842.07,107.015; 879.13,106.706; 914.7,107.015; 951.76,106.397;
        988.81,106.397; 1025.87,106.706; 1061.45,106.706; 1098.5,106.397;
        1135.56,106.088; 1171.13,106.706])
    annotation (Placement(transformation(extent={{76,42},{96,62}})));
equation
  connect(ElectricGrid_0thOrder.epp, EM.epp) annotation (Line(
      points={{-20,30},{0,30},{0,30}},
      color={0,135,135},
      thickness=0.5));
  connect(sink_0thOrder.gasPort, EM.gasPortOut) annotation (Line(
      points={{40,30},{20,30}},
      color={255,255,0},
      thickness=1.5));
  connect(EM.i_el_stack_set, CurrentRamp.y) annotation (Line(points={{13.4,42},{
          14,42},{14,72},{-31,72}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -40},{180,100}})),                                   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -40},{180,100}})),
    experiment(StopTime=1200),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(executeCall=TransiEnt.Components.Convertor.Power2Gas.Check.TestPEMElectrolyzer_L1_1DDynamics.plotResult() "Plot example results"),
    Documentation(info="<html>
<h4><span style=\"color: #008300\">1. Purpose of model</span></h4>
<p>Runs on a constant 400A input current and contains an integrated squared deviation for comparison with (Espinosa-Lopez et al., 2018)&apos;s results.</p>
<h4><span style=\"color: #008300\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008300\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">5. Nomenclature</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008300\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">9. References</span></h4>
<p>[1] Manuel Espinosa-L&oacute;pez, Philippe Baucour, Serge Besse, Christophe Darras, Raynal Glises, Philippe Poggi, Andr&eacute; Rakotondrainibe, and Pierre Serre-Combe. Modelling and experimental validation of a 46 kW PEM high pressure water electrolyser. Renewable Energy, 119, pp. 160-173, 2018. doi: 10.1016/J.RENENE.2017.11.081. </p>
<h4><span style=\"color: #008300\">10. Version History</span></h4>
<p>Created by John Webster (jcwebste@edu.uwaterloo.ca) October 2018.</p>
</html>"));
end Test_400A_Espinosa_L2;
