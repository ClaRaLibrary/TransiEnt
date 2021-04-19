within TransiEnt.Components.Electrical.Machines;
model TwoAxisSynchronousMachineComplexSubtransient "ComplexPowerPort: Subtransient Two-Axis SM model with excitation voltage input"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Components.Electrical.Machines.Base.PartialQuasiStationaryGeneratorComplex;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Reactance X_d=2 "Synchronous reactance d-component"               annotation(Dialog(group="Physical constraints"));
  parameter SI.Reactance X_q=1.95 "Synchronous reactance q-component"               annotation(Dialog(group="Physical constraints"));
  parameter SI.Resistance R_a=0.3 "Resistance for losses"               annotation(Dialog(group="Physical constraints"));
  parameter SI.Reactance X_d_trans=0.25 "Transient reactance d-component"               annotation(Dialog(group="Physical constraints"));
  parameter SI.Reactance X_q_trans=0.3 "Transient reactance q-component"               annotation(Dialog(group="Physical constraints"));
  parameter Modelica.SIunits.Time T_d0_trans=0.2 "Time constant d-component" annotation(Dialog(group="Physical constraints"));
  parameter Modelica.SIunits.Time T_q0_trans=0.2 "Time constant q=component" annotation(Dialog(group="Physical constraints"));

  parameter SI.Reactance X_d_subtrans=0.5 "Subtransient reactance d-component"               annotation(Dialog(group="Physical constraints"));
  parameter SI.Reactance X_q_subtrans=0.25 "Subtransient reactance q-component"               annotation(Dialog(group="Physical constraints"));
  parameter Modelica.SIunits.Time T_d0_subtrans=0.11 "Time constant d-component, subtransient part" annotation(Dialog(group="Physical constraints"));
  parameter Modelica.SIunits.Time T_q0_subtrans=0.08 "Time constant q-component, subtransient part" annotation(Dialog(group="Physical constraints"));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  Modelica.SIunits.ComplexPower S_c;

  Modelica.SIunits.Voltage v_d( start=0) annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.SIunits.Voltage v_q(start=v_n) annotation (Dialog(group="Initialization", showStartAttribute=true));

  Modelica.SIunits.Current i_d(start=0)
                                       annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.SIunits.Current i_q(start=0)
                                       annotation (Dialog(group="Initialization", showStartAttribute=true));

  Modelica.SIunits.Voltage e_FD;

  Modelica.SIunits.Voltage e_d_trans(start=0)
                                             annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.SIunits.Voltage e_q_trans(start=v_n) annotation (Dialog(group="Initialization", showStartAttribute=true));

  Modelica.SIunits.Voltage e_d_subtrans(start=0)
                                                annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.SIunits.Voltage e_q_subtrans(start=v_n) annotation (Dialog(group="Initialization", showStartAttribute=true));

Modelica.SIunits.Angle theta_absolut(start=0.17453292519943295) annotation (Dialog(group="Initialization", showStartAttribute=true));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

initial equation

  der(e_d_trans)=0;
  der(e_q_trans)=0;

  der(e_d_subtrans)=0;
  der(e_q_subtrans)=0;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

if OwnFrequency==true then
  v_d*i_d+v_q*i_q + D_cage*der(theta) = (mpp.tau * omega);
else
  v_d*i_d+v_q*i_q = (mpp.tau * omega);
end if;

  S_c.re=epp.P;
  S_c.im=epp.Q;

  //differential equations

  //transient part

  T_d0_trans*der(e_q_trans)=-e_q_trans-(X_d-X_d_trans)*i_d+e_FD;

  T_q0_trans*der(e_d_trans)=-e_d_trans+(X_q-X_q_trans)*i_q;

  //subtransient part

  T_d0_subtrans*der(e_q_subtrans)=e_q_trans-(X_d_trans-X_d_subtrans)*i_d-e_q_subtrans;

  T_q0_subtrans*der(e_d_subtrans)=e_d_trans+(X_q_trans-X_q_subtrans)*i_q-e_d_subtrans;

  //electric equations

  v_d=X_q_subtrans*i_q-R_a*i_d+e_d_subtrans;

  v_q=-X_d_subtrans*i_d-R_a*i_q+e_q_subtrans;

  v_d^2+v_q^2=v_grid^2;

  cos(theta_absolut)=if v_q < v_grid then v_q/v_grid else 1;

  S_c.re=-((v_d+R_a*i_d)*i_d+(v_q+R_a*i_q)*i_q);
  S_c.im=-(v_q*i_d-v_d*i_q);

  e_FD=E_input;

  theta=theta_absolut+delta_lsm;

  annotation(defaultConnectionStructurallyInconsistent=true, Diagram(graphics,
                                                                     coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Subransient model of a synchronous machine with two-Axis description and losses. Mechanical connection is stiff.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>L4E - model with circuit description. Voltage, active and reactive power are linked together by equations.</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Mechanical connection is stiff</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">magnetical behaviour simplified</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp (ComplexPowerPort)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Mechanical power port mpp</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: electric potential in [V]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Only use machines of the class together in one simulation</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model for short time characteristics 100 ms - 1 s</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Set IsSlack to true for slack-bus version</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Tested in the check model &quot;TransiEnt.Components.Electrical.Machines.Check.CheckTwoAxisSynchronousMachineComplexSubtransient&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] F. Milano, &ldquo;Power System Modelling and Scripting&rdquo;, Springer London, 2010, p. 223</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[2] J. Arrillaga, C.P. Arnold, &ldquo;Computer Analysis of Power Systems&rdquo;, John Wiley & Sons Ltd Chihcester, 1990</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in March 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model made more modular (extension of partial class and one version for Slack and PU-Bus) in June/July 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised (own Frequency) in October/November 2018</span></p>
</html>"));
end TwoAxisSynchronousMachineComplexSubtransient;
