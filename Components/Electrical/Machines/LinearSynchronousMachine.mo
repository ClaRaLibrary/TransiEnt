within TransiEnt.Components.Electrical.Machines;
model LinearSynchronousMachine "Linear generator model with constant efficiency of power transformation and linear relation between voltage and reactive power"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import TransiEnt;
  extends TransiEnt.Components.Electrical.Machines.Base.PartialQuasiStationaryGenerator;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Efficiency eta=1 "Total efficiency";
  parameter Modelica.SIunits.Voltage v_n=110e3 "Nominal voltage";
  parameter Modelica.SIunits.Frequency f_n=simCenter.f_n "Nominal frequency";
  parameter Modelica.SIunits.ActivePower P_el_n = 180e3 "Nominal active power";
  parameter Modelica.SIunits.ApparentPower S_n = 225e3 "Nominal apparent power";
  final parameter Modelica.SIunits.PowerFactor cosphi_n = P_el_n/S_n;
  final parameter Modelica.SIunits.ReactivePower Q_n= sqrt(S_n^2-P_el_n^2);

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput K_q "Control input" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,104}),iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={-3,99})));

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  SI.Voltage v_star = epp.v / v_n;
  SI.Voltage Delta_v_star = v_star-1;
  SI.Frequency f_star = epp.f/f_n;
  SI.Frequency Delta_f_star = f_star-1;
  SI.ActivePower P_el_is = -epp.P;
  SI.ReactivePower Q_star = -epp.Q/Q_n;
  SI.ReactivePower Q_is = -epp.Q;
  SI.ReactivePower Delta_Q_star = Q_star - 1;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  epp.f = Modelica.SIunits.Conversions.to_Hz(der(mpp.phi));
  epp.P = - (mpp.tau * omega * eta);
  Delta_Q_star = K_q * Delta_v_star;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a synchronous machine with constant efficiency. Mechanical connection is stiff.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>LoD1 - only active power flow and frequency</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Constant efficiency </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Mechanical connection is stiff</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Do not use!</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end LinearSynchronousMachine;
