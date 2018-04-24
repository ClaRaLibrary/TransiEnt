within TransiEnt.Producer.Combined.LargeScaleCHP.Base;
model PQBoundaries
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  extends TransiEnt.Basics.Icons.PQDiagramIcon;
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput Q_flow annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput P_max annotation (Placement(transformation(extent={{100,34},{120,54}})));
  Modelica.Blocks.Interfaces.RealOutput P_min annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  // _____________________________________________
  //
  //             Parameters
  // _____________________________________________

  parameter TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.Generic_PQ_Characteristics PQCharacteristics=Characteristics.PQ_Characteristics_WW1() annotation (choicesAllMatching);

  // _____________________________________________
  //
  //             Components
  // _____________________________________________

  Modelica.Blocks.Tables.CombiTable1Ds PQTableCalculation(
    table=PQCharacteristics.PQboundaries,
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
                   annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Modelica.Blocks.Math.Gain gain_Q_flow(k=PQCharacteristics.k_Q_flow)
                                                    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  Modelica.Blocks.Math.Gain gain_P_max(k=PQCharacteristics.k_P_el)
                                                 annotation (Placement(transformation(extent={{54,34},{74,54}})));
  Modelica.Blocks.Math.Gain gain_P_min(k=PQCharacteristics.k_P_el)
                                                 annotation (Placement(transformation(extent={{56,-42},{76,-22}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Q_flow, gain_Q_flow.u) annotation (Line(points={{-120,0},{-95,0},{-70,0}}, color={0,0,127}));
  connect(gain_Q_flow.y, PQTableCalculation.u) annotation (Line(points={{-47,0},{-31.5,0},{-16,0}}, color={0,0,127}));
  connect(PQTableCalculation.y[1], gain_P_max.u) annotation (Line(points={{7,0},{18,0},{18,44},{52,44}},       color={0,0,127}));
  connect(gain_P_max.y, P_max) annotation (Line(points={{75,44},{110,44}}, color={0,0,127}));
  connect(gain_P_min.y, P_min) annotation (Line(points={{77,-32},{110,-32},{110,-30}}, color={0,0,127}));
  connect(PQTableCalculation.y[2], gain_P_min.u) annotation (Line(points={{7,0},{18,0},{18,-32},{54,-32}},     color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The operation limits (maximum and minimum) of condensation-extraction CHP plants can be defined with this model. It displays the heat output at the x-axis and the power output at the y-axis. </span></p>
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
</html>"));
end PQBoundaries;
