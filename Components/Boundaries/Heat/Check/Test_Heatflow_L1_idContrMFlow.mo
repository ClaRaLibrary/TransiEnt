within TransiEnt.Components.Boundaries.Heat.Check;
model Test_Heatflow_L1_idContrMFlow "Model for testing Heatflow_L1_idContrMFlow_temp"

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
  // ____________________________________________

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sourceConst(p_const(displayUnit="bar") = 100000, T_const(displayUnit="degC") = 333.15,
    variable_T=true)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,20})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sinkConst(
    m_flow_nom=0, p_const(displayUnit="bar") = 100000)
                   annotation (Placement(transformation(extent={{100,10},{80,30}})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1_idContrMFlow_temp heatflow_L1_idContrMFlow_tempConst(use_varTemp=false, T_out_set_const=293.15)
                                                                                                        annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=100e3)  annotation (Placement(transformation(extent={{40,20},{20,40}})));
    ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sourceVar(
    variable_p=false,
    p_const(displayUnit="bar") = 100000,
    T_const(displayUnit="degC") = 293.15,
    variable_T=true)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-40})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi      sinkVar(m_flow_nom=0, p_const(displayUnit="bar") = 100000)
                   annotation (Placement(transformation(extent={{100,-50},{80,-30}})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1_idContrMFlow_temp heatflow_L1_idContrMFlow_tempVar(use_varTemp=true, typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional)
                                                                                                      annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=-100e3)
                                                                  annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    offset=46 + 273.15,
    height=24,
    duration=50)
               annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=100,
    offset=46 + 273.15,
    height=-30)
               annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=50,
    startTime=50,
    height=40,
    offset=40 + 273.15)
               annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(heatflow_L1_idContrMFlow_tempConst.fluidPortIn, sourceConst.steam_a) annotation (Line(
      points={{-4,20},{-50,20}},
      color={175,0,0},
      thickness=0.5));
  connect(heatflow_L1_idContrMFlow_tempConst.fluidPortOut, sinkConst.steam_a) annotation (Line(
      points={{4,20},{80,20}},
      color={175,0,0},
      thickness=0.5));
  connect(heatflow_L1_idContrMFlow_tempVar.fluidPortIn, sourceVar.steam_a) annotation (Line(
      points={{-4,-40},{-50,-40}},
      color={175,0,0},
      thickness=0.5));
  connect(heatflow_L1_idContrMFlow_tempVar.fluidPortOut, sinkVar.steam_a) annotation (Line(
      points={{4,-40},{80,-40}},
      color={175,0,0},
      thickness=0.5));
  connect(realExpression.y, heatflow_L1_idContrMFlow_tempConst.Q_flow_set) annotation (Line(points={{19,30},{14,30},{14,30},{10,30}}, color={0,0,127}));
  connect(realExpression1.y, heatflow_L1_idContrMFlow_tempVar.Q_flow_set) annotation (Line(points={{19,-30},{10,-30}}, color={0,0,127}));
  connect(ramp.y, heatflow_L1_idContrMFlow_tempVar.T_out_set) annotation (Line(points={{-19,-10},{0,-10},{0,-20}}, color={0,0,127}));
  connect(ramp1.y, sourceConst.T) annotation (Line(points={{-79,20},{-70,20}}, color={0,0,127}));
  connect(ramp2.y, sourceVar.T) annotation (Line(points={{-79,-40},{-70,-40}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-8,54},{10,46}},
          lineColor={28,108,200},
          textString="Consumer"), Text(
          extent={{-8,0},{10,-8}},
          lineColor={28,108,200},
          textString="Producer")}),
                                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for Heatflow_L1_idContrMFlow_temp. It is visible that the consumer/producer heat flows are set to zero as soon as the inlet temperature is smaller/greater than the set outlet temperature.</p>
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
<p>Model created by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"),
    experiment(StopTime=100));
end Test_Heatflow_L1_idContrMFlow;
