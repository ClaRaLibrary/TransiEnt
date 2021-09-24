within TransiEnt.Grid.Electrical.SecondaryControl;
model SecondaryBalancingController "Secondary balancing control model as proposed by ENTSO-E operational handbook"


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

  extends Modelica.Blocks.Interfaces.SISO;
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Real K_r = 1 "Sub grid participation factor"
                                    annotation(Dialog(group="Static"));
  parameter Real T_r=10 "Time constant of secondary balancing power" annotation(Dialog(group="Dynamic"));

  parameter Real beta=6e9 "Gain of secondary balancing power" annotation(Dialog(group="Dynamic"));

  parameter Boolean is_singleton = true "Select true, if this is the only 2ndary ctrl in total grid model"
                                                                       annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  parameter SI.Power P_n=simCenter.P_n_low;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

   TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_tie_is if             not is_singleton "Requested power for exchange between multiple control areas" annotation (Placement(transformation(extent={{-111,80},{-91,100}}, rotation=0), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-42,91})));
   TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_tie_set if            not is_singleton "Requested power for exchange between multiple control areas" annotation (Placement(transformation(extent={{-111,50},{-91,70}}, rotation=0), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-90,91})));
  Modelica.Blocks.Interfaces.RealInput u "Frequency deviation" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Secondary balancing setpoint" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  Modelica.Blocks.Math.Gain ProportionalGain(k=-K_r)
    annotation (Placement(transformation(extent={{-54,-7},{-40,7}})));
  Modelica.Blocks.Continuous.PI PI(k=beta, T=T_r,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    x_start=0,
    y_start=0)
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  SI.Energy E_total_sec_bal_pos(start=0, fixed=true);
  SI.Energy E_total_sec_bal_neg(start=0, fixed=true);

  Modelica.Blocks.Math.Feedback delta_P_tie annotation (Placement(transformation(extent={{-84,80},{-64,100}})));
  Modelica.Blocks.Math.Sum G(nin=2, k=-ones(G.nin)) annotation (Placement(transformation(extent={{-26,-9},{-6,11}})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if is_singleton then
    delta_P_tie.u1 = 0;
    delta_P_tie.u2 = 0;
  end if;

  der(E_total_sec_bal_pos) = min(0,y) "only add up negative power = additional power output";
  der(E_total_sec_bal_neg) = max(0,y) "only add up positive power = reduced power output";

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_tie_is, delta_P_tie.u1) annotation (Line(points={{-101,90},{-82,90}}, color={0,0,127}));
  connect(P_tie_set, delta_P_tie.u2) annotation (Line(points={{-101,60},{-74,60},{-74,82}}, color={0,0,127}));
  connect(u, ProportionalGain.u) annotation (Line(points={{-120,0},{-55.4,0}}, color={0,0,127}));
  connect(G.y, PI.u) annotation (Line(points={{-5,1},{4,1},{4,0},{14,0}},
                                                              color={0,0,127}));
  connect(ProportionalGain.y, G.u[1]) annotation (Line(points={{-39.3,0},{-34,0},{-28,0}},           color={0,0,127}));
  connect(delta_P_tie.y, G.u[2]) annotation (Line(points={{-65,90},{-48,90},{-48,32},{-34,32},{-34,2},{-28,2}}, color={0,0,127}));
  connect(PI.y, y) annotation (Line(points={{37,0},{74,0},{110,0}},        color={0,0,127}));
  annotation (defaultComponentName="SecondaryBalancingController",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                    graphics={Text(
          extent={{-86,8},{-66,2}},
          lineColor={0,0,0},
          textString="Delta f"),              Text(
          extent={{46,8},{66,2}},
          lineColor={0,0,0},
          textString="Delta P_sec"),
        Text(
          extent={{-40,104},{100,46}},
          lineColor={28,108,200},
          textString="G=P_tie_is - P_tie_set + K_r * Delta f

delta P_sec = - beta * G - 1/T_r * Int G dt"),
        Text(
          extent={{-6,10},{8,0}},
          lineColor={28,108,200},
          textString="-G")}),      Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-38,26},{38,-30}},
          lineColor={0,0,0},
          textString="Sec")}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Secondary balancing controller modeled according to ENTSO-E requirements with</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- PI behaviour</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- input of frequency value and exchange power request</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Grid.Electrical.SecondaryControl.Check.TestSecondaryBalancingController&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end SecondaryBalancingController;
