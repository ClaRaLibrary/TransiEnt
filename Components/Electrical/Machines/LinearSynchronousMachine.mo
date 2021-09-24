within TransiEnt.Components.Electrical.Machines;
model LinearSynchronousMachine "ApparentPowerPort: Linear generator model with constant efficiency"


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

  import TransiEnt;
  extends TransiEnt.Components.Electrical.Machines.Base.PartialQuasiStationaryGenerator;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Efficiency eta=1 "Total efficiency";
  //parameter Modelica.SIunits.Voltage v_n=110e3 "Nominal voltage";
  parameter Modelica.Units.SI.Frequency f_n=simCenter.f_n "Nominal frequency";
  parameter Modelica.Units.SI.ActivePower P_el_n=180e3 "Nominal active power";
  parameter Modelica.Units.SI.ApparentPower S_n=225e3 "Nominal apparent power";
  final parameter Modelica.Units.SI.PowerFactor cosphi_n=P_el_n/S_n;
  final parameter Modelica.Units.SI.ReactivePower Q_n=sqrt(S_n^2 - P_el_n^2);

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput K_q "Control input" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={78,106}),
                        iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={-81,-63})));

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

  epp.f =Modelica.Units.Conversions.to_Hz(der(mpp.phi));
  epp.P = - (mpp.tau * omega * eta);
  Delta_Q_star = K_q * Delta_v_star;

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a synchronous machine with constant efficiency. Mechanical connection is stiff.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>L1E (defined in the CodingConventions)</p>
<p>- only active power flow and frequency</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Constant efficiency </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Mechanical connection is stiff</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Mechanical power port mpp</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: electric potential in [V]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Active power port epp</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Do not use!</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Tested in the check model &quot;TransiEnt.Components.Electrical.Machines.Check.CheckLinearSynchronousMachine&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end LinearSynchronousMachine;
