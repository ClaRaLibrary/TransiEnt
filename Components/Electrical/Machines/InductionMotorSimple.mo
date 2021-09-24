within TransiEnt.Components.Electrical.Machines;
model InductionMotorSimple "Induction Motor Model with improved coupling and simple equations"

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

extends TransiEnt.Basics.Icons.MachineRL;

  // _____________________________________________
  //
  //        Constants and  Hidden Parameters
  // _____________________________________________

//constant Complex j_comp(re=0,im=1);

  // _____________________________________________
  //
  //                  Outer
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Frequency f_rot_n=591.3/60;
  parameter SI.Voltage v_n=simCenter.v_n;
  parameter Real N_pp=5;
  parameter Real slip_n=0.0145 "Nonminal Slip";

  parameter SI.Power P_n=738113 "Nominal Power";

  parameter Boolean useConverter=true "True for frequency input";

  parameter Modelica.Units.SI.Reactance x_my=140 "Magnetization reactance";
  parameter Modelica.Units.SI.Resistance r_s=0.7 "stator resistance";
  parameter Modelica.Units.SI.Reactance x_s=5.4 "Stator reactance";
  parameter Modelica.Units.SI.Reactance x_R1=5.99 "1st cage rotor reactance";
  parameter Modelica.Units.SI.Resistance r_R1=0.599 "1st cage rotor resistance";

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  Real slip(start=slip_n) "slip of asynchronous machine";
  Modelica.Units.SI.AngularFrequency omega_rot(start=2*Modelica.Constants.pi*f_rot_n) "Angular Frequency of rotation" annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.Frequency f_rotor(start=f_rot_n) annotation (Dialog(group="Initialization", showStartAttribute=true));

  Modelica.Units.SI.Angle delta_asy(start=-0.08726646259971647) = epp.delta annotation (Dialog(group="Initialization", showStartAttribute=true));

  Modelica.Units.SI.PowerFactor cosphi=abs(S.re)/Modelica.ComplexMath.abs(S);
  Modelica.Units.SI.ComplexPower S(re(start=P_n), im(start=0)) annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.Voltage v_grid(start=v_n) = epp.v annotation (Dialog(group="Initialization", showStartAttribute=true));

  Modelica.Units.SI.Power P_mech(start=P_n) = -mpp.tau*omega_rot annotation (Dialog(group="Initialization", showStartAttribute=true));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp annotation (Placement(transformation(extent={{-108,-8},{-88,12}}), iconTransformation(extent={{-112,-12},{-88,12}})));
  TransiEnt.Basics.Interfaces.General.FrequencyIn f_converter if  useConverter  "Frequency input from converter" annotation (Placement(transformation(extent={{-140,60},{-100,100}}, rotation=0), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,96})));
  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{94,-8},{108,6}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TransiEnt.Basics.Interfaces.General.FrequencyIn f_internal  "Needed to connect to conditional connector for converterfrequency";

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

 //Frequency from grid or converter
 if not useConverter then
    f_internal = epp.f;
  end if;

 //Mechanical equations
  slip= (f_internal-max(0,f_rotor)*N_pp)/(f_internal);

  omega_rot=der(mpp.phi);

  f_rotor=Modelica.Units.Conversions.to_Hz(omega_rot);

  //Important equation that links the submodels
  mpp.tau=-((r_R1/slip)*(v_grid)^2)/((r_s+r_R1/slip)^2+(x_s+x_R1)^2)/omega_rot;

  //Electrical equations

  S.re=((r_s+r_R1/slip)*(v_grid)^2)/((r_s+r_R1/slip)^2+(x_s+x_R1)^2);
  S.im=((v_grid)^2)/(x_my)+((x_s+x_R1)*(v_grid)^2)/((r_s+r_R1/slip)^2+(x_s+x_R1)^2);

  S.re=epp.P;
  S.im=epp.Q;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(f_internal,f_converter);

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple model of an induction machine using TransiEnt electrical interfaces.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">no mechanical modeling</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L3E - Models are based on electrical networks in quasi-stationary form.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Mechanical power port mpp</p>
<p>Complex power port epp</p>
<p>Modelica RealInput: frequency in Hz</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>omega_rot is the angular velocity of the rotor</p>
<p>f_rot is the frequency of the rotor</p>
<p>slip is the slip of the asynchronous machine</p>
<p>delta_asy is an angle </p>
<p>cosphi is the power factor</p>
<p>S is the apparent power</p>
<p>v_grid is the voltage of the grid</p>
<p>P_mech is the mechanical power</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">test mode is given</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">electrical submodel from [1] F. Milano, &ldquo;Power System Modelling and Scripting&rdquo;, Springer London, 2010, p. 349f</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2019</span></p>
</html>"));
end InductionMotorSimple;
