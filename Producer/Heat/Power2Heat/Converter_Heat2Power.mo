within TransiEnt.Producer.Heat.Power2Heat;
model Converter_Heat2Power "Model of a very simple night storage heating unit - takes in a heat demand and converts it into an electrical energy demand"


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
 //          Outer models
 // _____________________________________________
  extends Basics.Icons.Model;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real eff = 1 "Efficiency of the night storage heater";

 // _____________________________________________
 //
 //          Interfaces
 // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput Q_demand_sh "Space heating demand" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,104}), iconTransformation(
        extent={{-15,-15},{15,15}},
        rotation=-90,
        origin={1,95})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp   annotation (Placement(transformation(extent={{-130,-40},{-102,-12}}), iconTransformation(extent={{-152,-12},{-120,20}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower Electric_Consumer(useInputConnectorQ=false,
                                                                                           useCosPhi=false) annotation (Placement(transformation(extent={{-6,-40},{24,-12}})));

  Modelica.Blocks.Math.Division division annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-6,54})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=eff) annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Electric_Consumer.epp, epp) annotation (Line(
      points={{-6,-26},{-16,-26},{-16,-26},{-116,-26}},
      color={0,127,0},
      thickness=0.5));

  connect(division.y, Electric_Consumer.P_el_set) annotation (Line(points={{-6,43},{-6,18},{0,18},{0,-9.2}}, color={0,0,127}));
  connect(Q_demand_sh, division.u1) annotation (Line(points={{0,104},{0,66},{1.77636e-15,66}}, color={0,0,127}));
  connect(realExpression.y, division.u2) annotation (Line(points={{-59,80},{-12,80},{-12,66}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}}), graphics={
        Rectangle(
          extent={{-66,66},{66,-62}},
          fillColor={241,240,229},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-58,-30},{-22,-34}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-30},{18,-34}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-30},{58,-34}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,-38},{-22,-42}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-38},{18,-42}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-38},{58,-42}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,-46},{-22,-50}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-46},{18,-50}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-46},{58,-50}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,-54},{-22,-58}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-54},{18,-58}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-54},{58,-58}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid)}),                      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Represents a simple Night Storage Heating model with constant efficiency converting a heat demand to an electrical demand</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Constant efficiency, LoD 1</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de), 2020</span></p>
</html>"));
end Converter_Heat2Power;
