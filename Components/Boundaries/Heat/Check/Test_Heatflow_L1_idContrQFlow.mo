within TransiEnt.Components.Boundaries.Heat.Check;
model Test_Heatflow_L1_idContrQFlow "Model for testing Heatflow_L1_idContrQFlow_temp"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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
  // ____________________________________________

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                       sourceConst(                                     T_const(displayUnit="degC") = 333.15, m_flow_const=1)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,20})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sinkConst(
    m_flow_nom=0, p_const(displayUnit="bar") = 100000)
                   annotation (Placement(transformation(extent={{100,10},{80,30}})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1_idContrQFlow_temp heatflow_L1_idContrQFlow_tempConst(use_varTemp=false, T_out_set_const=293.15)
                                                                                                        annotation (Placement(transformation(extent={{-10,20},{10,40}})));

    ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                         sourceVar(
    T_const(displayUnit="degC") = 293.15, m_flow_const=1)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-40})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi      sinkVar(m_flow_nom=0, p_const(displayUnit="bar") = 100000)
                   annotation (Placement(transformation(extent={{100,-50},{80,-30}})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1_idContrQFlow_temp heatflow_L1_idContrQFlow_tempVar(use_varTemp=true, typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional)
                                                                                                      annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=100,
    offset=46 + 273.15,
    height=24) annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(heatflow_L1_idContrQFlow_tempConst.fluidPortIn, sourceConst.steam_a) annotation (Line(
      points={{-4,20},{-80,20}},
      color={175,0,0},
      thickness=0.5));
  connect(heatflow_L1_idContrQFlow_tempConst.fluidPortOut, sinkConst.steam_a) annotation (Line(
      points={{4,20},{80,20}},
      color={175,0,0},
      thickness=0.5));
  connect(heatflow_L1_idContrQFlow_tempVar.fluidPortIn, sourceVar.steam_a) annotation (Line(
      points={{-4,-40},{-80,-40}},
      color={175,0,0},
      thickness=0.5));
  connect(heatflow_L1_idContrQFlow_tempVar.fluidPortOut, sinkVar.steam_a) annotation (Line(
      points={{4,-40},{80,-40}},
      color={175,0,0},
      thickness=0.5));
  connect(ramp.y, heatflow_L1_idContrQFlow_tempVar.T_out_set) annotation (Line(points={{-19,-10},{0,-10},{0,-20}}, color={0,0,127}));
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
<p>Test environment for Heatflow_L1_idContrQFlow_temp.</p>
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
end Test_Heatflow_L1_idContrQFlow;
