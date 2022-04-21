within TransiEnt.Producer.Heat.Heat2Heat;
model Indirect_HEX_const_T_out_L1 "Constant T_return Heat Exchanger Model"


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

  import Modelica.Units.SI;
  import TIL = TILMedia.VLEFluidFunctions;
  outer TransiEnt.SimCenter simCenter;
  extends TransiEnt.Producer.Heat.Base.PartialHEX;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Temperature T_start = 90 + 273.15 "Temperature at start of simulation";
  parameter SI.HeatFlowRate Q_max = 90*1000 "Maximum Heat Supply";
  parameter SI.MassFlowRate m_flow_max = Q_max / (cp*(simCenter.T_supply - simCenter.T_return)) "Minimum mass flow rate";
  parameter SI.MassFlowRate m_flow_min = simCenter.m_flow_min "Minimum mass flow rate";
  final parameter SI.SpecificHeatCapacityAtConstantPressure cp=TIL.specificIsobaricHeatCapacity_pTxi(
        simCenter.fluid1,
        simCenter.p_nom[2],
        T_start,
        {1,0,0});
  parameter SI.Temperature T_out_const=simCenter.T_return "Desired constant outlet temperature";
  parameter SI.Efficiency overflow_rate=1 "Used to introduce inefficiencies in heat transfer by scaling the calculated mass flow";
  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  SI.MassFlowRate m_flow_calc;
  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput Q_demand annotation (Placement(transformation(extent={{-120,-20},{-80,20}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-72,80})));
  Modelica.Blocks.Interfaces.RealOutput T_out_calc annotation (Placement(transformation(extent={{100,-60},{120,-40}}), iconTransformation(extent={{92,-20},{132,20}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow annotation (Placement(transformation(extent={{100,30},{140,70}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,-114})));

  //  Modelica.Blocks.Sources.RealExpression realExpression(y=1) annotation (Placement(transformation(extent={{-12,40},{8,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=m_flow_calc) annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Interfaces.RealInput T_in annotation (Placement(transformation(extent={{-120,60},{-80,100}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={68,80})));
  Modelica.Blocks.Continuous.FirstOrder T_in_delayed(
    k=1,
    T=1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=simCenter.T_supply) annotation (Placement(transformation(extent={{-59,71},{-41,89}})));
  Modelica.Blocks.Math.Gain usedT(k=1) annotation (Placement(transformation(extent={{-14,75},{-4,85}})));
equation

  m_flow_calc = overflow_rate * max(Q_demand/(cp*(max(15, usedT.y - T_out_const))), m_flow_min);
  T_out_calc = T_in - Q_demand/(m_flow_calc*cp);

  connect(realExpression.y, m_flow) annotation (Line(points={{61,50},{120,50}}, color={0,0,127}));
  connect(T_in_delayed.u, T_in) annotation (Line(points={{-60.8,80},{-100,80}}, color={0,0,127}));
  connect(T_in_delayed.y, usedT.u) annotation (Line(points={{-40.1,80},{-15,80}},          color={0,0,127}));
  annotation (
    Line(points={{120,50},{11,50},{11,50},{120,50}}, color={0,0,127}),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Simple heat exchanger model specifically modeled to be used in district heating networks.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Calculates the necessary mass flow for a constant dT between supply and return:</span></p>
<p><img src=\"modelica://IntegraNet/Resources/Images/equations/equation-W7rTOKK8.png\" alt=\"Q = m * cp * dT\"/></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>Due to the simple nature of the model it is important to have a realistic supply temperature such that the return temperature doesn&apos;t fall below possible values. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de) on 10.10.2018</span></p>
</html>"));
end Indirect_HEX_const_T_out_L1;
