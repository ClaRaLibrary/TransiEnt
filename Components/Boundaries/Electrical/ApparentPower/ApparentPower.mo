within TransiEnt.Components.Boundaries.Electrical.ApparentPower;
model ApparentPower "L2 Active and reactive power by parameter or inputs"


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

  extends TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary(
      redeclare TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp);
  extends TransiEnt.Basics.Icons.ElectricSink;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Boolean useInputConnectorP=true
    "Gets parameter from input connector" annotation (
    Evaluate=true,
    HideResult=true,
    choices(__Dymola_checkBox=true),
    Dialog(group="Boundary"));

  parameter SI.Power P_el_set_const=0 "Constant boundary"
    annotation (Dialog(group="Boundary", enable=not useInputConnectorP));

  parameter Boolean useInputConnectorQ=true
    "Gets parameter from input connector" annotation (
    Evaluate=true,
    HideResult=true,
    choices(__Dymola_checkBox=true),
    Dialog(group="Boundary"));

  parameter SI.ReactivePower Q_el_set_const=0 annotation (Dialog(group="Boundary",
        enable=not useInputConnectorQ and not useCosPhi));

  parameter Boolean useCosPhi=true annotation (
    Evaluate=true,
    HideResult=true,
    choices(__Dymola_checkBox=true),
    Dialog(group="Boundary", enable=not useInputConnectorQ));

  parameter SI.PowerFactor cosphi_boundary=1 annotation (Dialog(group="Boundary",
        enable=useCosPhi and not useInputConnectorQ));

  parameter Integer behavior=1 annotation (
    Evaluate=true,
    HideResult=true,
    choices(
      __Dymola_radioButtons=true,
      choice=1 "inductive",
      choice=-1 "capacitive"),
    Dialog(group="Boundary", enable=useCosPhi and not useInputConnectorQ));
  // 1 if inductive, -1 if capacitive

  parameter Boolean change_sign=false "Change sign on input value";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set if              useInputConnectorP
    "Active power input" annotation (Placement(transformation(extent={{-140,60},
            {-100,100}}, rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,120})));

  TransiEnt.Basics.Interfaces.Electrical.ReactivePowerIn Q_el_set if              useInputConnectorQ
    "Reactive power input" annotation (Placement(transformation(extent={{-140,22},
            {-100,62}}, rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,120})));
  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  SI.ReactivePower Q=epp.Q;
  SI.ApparentPower S;

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________
protected
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_internal
    "Needed to connect to conditional connector for active power";
  TransiEnt.Basics.Interfaces.Electrical.ReactivePowerIn Q_internal
    "Needed to connect to conditional connector for reactive power";

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if not useInputConnectorP then
    P_internal = if change_sign == false then P_el_set_const else -
      P_el_set_const;
  end if;

  if not useInputConnectorQ then
    if not useCosPhi then
      Q_internal = if change_sign == false then Q_el_set_const else -
        Q_el_set_const;
    else
      if not change_sign then
        Q_internal = abs(P_internal/cosphi_boundary)*sin(behavior*acos(
          cosphi_boundary));
      else
        Q_internal = -(abs(P_internal/cosphi_boundary)*sin(behavior*acos(
          cosphi_boundary)));
      end if;
    end if;
  end if;

  epp.P = if change_sign == false then P_internal else -P_internal;
  epp.Q = if change_sign == false then Q_internal else -Q_internal;
  S = sqrt(P_internal^2 + Q_internal^2);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_internal, P_el_set);
  connect(Q_internal, Q_el_set);

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          visible=useInputConnectorP,
          extent={{-96,128},{-74,108}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="P"), Text(
          visible=useInputConnectorQ,
          extent={{24,130},{46,110}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect("Q", if useInputConnectorQ then "Q" else ""))}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Electric boundary condition with interface type L2 (real and apparent power, voltage and frequency).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: electric power in W</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: reactive power in var</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Apparent power port</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>P_el is the active power</p>
<p>Q_el is the reactive power</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Lennard Wilkening (lennard.wilkening@tuhh.de) and Jan-Peter Heckel (jan.heckel@tuhh.de) in February 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Julian Urbansky, Fraunhofer UMSICHT, in August 2021 </span></p>
</html>"));
end ApparentPower;
