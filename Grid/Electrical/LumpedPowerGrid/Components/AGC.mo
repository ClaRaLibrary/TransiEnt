within TransiEnt.Grid.Electrical.LumpedPowerGrid.Components;
model AGC "Automatic generation control model for just one secondary balancing provider (used in lumped grid models)"

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
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Boolean changeSignOfTieLinePower = false "Allows to change the sign of the tie line power input";

  parameter Real K_r = 0.8*3e9/0.2 "Sub grid participation factor"
                                    annotation(Dialog(group="Static"));
  parameter Real T_r=10 "Time constant of secondary balancing power" annotation(Dialog(group="Dynamic"));

  parameter Real beta=6e9 "Gain of secondary balancing power" annotation(Dialog(group="Dynamic"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(rotation=0, extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_tie_is annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,100})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_sec_set annotation (Placement(transformation(rotation=0, extent={{96,-10},{116,10}}), iconTransformation(extent={{96,-10},{116,10}})));
  TransiEnt.Grid.Electrical.SecondaryControl.SecondaryBalancingController SecondaryController(
    is_singleton=false,
    K_r=K_r,
    T_r=T_r,
    beta=beta) annotation (Placement(transformation(extent={{-6,-11},{16,11}})));
  TransiEnt.Components.Sensors.ElectricFrequency Delta_f_is(isDeltaMeasurement=true) annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Modelica.Blocks.Sources.Constant P_tie_set(k=0) annotation (Placement(transformation(extent={{-54,16},{-34,36}})));

  Modelica.Blocks.Math.Gain changeSign(k=if changeSignOfTieLinePower then -1 else 1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,62})));
equation
  connect(Delta_f_is.f, SecondaryController.u) annotation (Line(points={{10.4,-70},
          {10.4,-40},{-32,-40},{-32,0},{-8.2,0}},                                                                    color={0,0,127}));
  connect(SecondaryController.P_tie_set, P_tie_set.y) annotation (Line(points={{-4.9,10.01},{-4.9,26},{-33,26}}, color={0,0,127}));
  connect(P_sec_set, SecondaryController.y) annotation (Line(points={{106,0},{106,0},{17.1,0}}, color={0,0,127}));
  connect(epp, Delta_f_is.epp) annotation (Line(
      points={{0,-100},{0,-86},{-26,-86},{-26,-70},{-10,-70}},
      color={0,135,135},
      thickness=0.5));
  connect(P_tie_is, changeSign.u) annotation (Line(points={{0,100},{0,74},{0,74}}, color={0,0,127}));
  connect(changeSign.y, SecondaryController.P_tie_is) annotation (Line(points={{0,51},{0.38,51},{0.38,10.01}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(extent={{-100,-100},{100,100}},
                                                                     preserveAspectRatio=false)),
                                                                       Icon(graphics,
                                                                            coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Automatic generation control model for just one secondary balancing provider (used in lumped grid models), no power dispatch</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>technical component for use with physical models</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>only for one secondary balancing provider</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp: electric power port</p>
<p>P_tie_is: input for electric power in [W]</p>
<p>P_sec_set: output for electric power in [W]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>model without usage yet</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end AGC;
