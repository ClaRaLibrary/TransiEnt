within TransiEnt.Producer.Electrical.Photovoltaics;
model OneDiodeModel


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

  extends TransiEnt.Basics.Icons.SolarElectricalModel;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Current I_sc = 3.99 "Short-circuit current";
  parameter SI.Current I_mpp = 3.69 "Current at MPP";
  parameter SI.Voltage V_mpp = 17.6 "Voltage at maximum power point (MPP)";
  parameter SI.Power P_max=65 "Maximum power";

  parameter Real k_V_oc = -80e-3 "Temperature coefficient of I_SC in V/C";
  parameter Real k_P = -0.5 "Temperature coefficient of power  in %/C";

  parameter Integer n_s = 36 "number of cells";

  // from data sheet but not yet used
  parameter SI.Voltage V_OC = 22.1 "Open-circuit voltage";
  parameter Real k_I_SC = 0.065 "Temperature coefficient of I_SC in %/C";

  // can be calculated from parameters but for now constant (taken from sera, 2007)
  parameter SI.Resistance R_s = 0.47 "Serial resistance";
  parameter SI.Resistance R_sh = 1365 "Shunt resistance";
  parameter Real A = 1.397 "diode ideality factor";

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  Modelica.Electrical.Analog.Ideal.IdealDiode     idealDiode(useHeatPort=false, Vknee=V_mpp)
                                                                               annotation (Placement(transformation(
        extent={{-13,-13},{13,13}},
        rotation=270,
        origin={-10,3})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-46,0})));
  Modelica.Electrical.Analog.Basic.Resistor R_SH(R=R_sh)
                                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,2})));
  Modelica.Electrical.Analog.Basic.Resistor R_S(R=R_s)
                                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={38,50})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (Placement(transformation(extent={{42,-92},{62,-72}})));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (Placement(transformation(extent={{90,-56},{110,-36}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (Placement(transformation(extent={{90,40},{110,60}})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(signalCurrent.n, idealDiode.p) annotation (Line(
      points={{-46,10},{-46,50},{-10,50},{-10,16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(signalCurrent.p, idealDiode.n) annotation (Line(
      points={{-46,-10},{-46,-46},{-10,-46},{-10,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(R_S.p, signalCurrent.n)
    annotation (Line(
      points={{28,50},{-46,50},{-46,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(R_SH.p, R_S.p)
    annotation (Line(
      points={{20,12},{20,50},{28,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(R_SH.n, idealDiode.n) annotation (Line(
      points={{20,-8},{20,-46},{-10,-46},{-10,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ground.p, signalCurrent.p) annotation (Line(
      points={{52,-72},{52,-46},{-46,-46},{-46,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(R_S.n, pin_p) annotation (Line(
      points={{48,50},{100,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pin_n, ground.p) annotation (Line(
      points={{100,-46},{52,-46},{52,-72}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(u, signalCurrent.i) annotation (Line(
      points={{-100,0},{-53,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Photovoltaic model based on the one diode model.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">pin_n: negative pin</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">pin_p: positiv pin</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">u: RealInput</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Producer.Electrical.Photovoltaics.Check.Check_OneDiodeModel&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end OneDiodeModel;
