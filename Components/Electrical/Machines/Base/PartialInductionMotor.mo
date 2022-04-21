within TransiEnt.Components.Electrical.Machines.Base;
partial model PartialInductionMotor "Partial Model for the induction machines"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

constant Complex j_comp(re=0,im=1);

  // _____________________________________________
  //
  //                  Outer
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Frequency f_n=simCenter.f_n;
  parameter Modelica.Units.SI.Frequency f_rot_n=591.3/60;
  parameter SI.Voltage v_n=simCenter.v_n;
  parameter Real N_pp=5;

  parameter Modelica.Units.SI.Torque tau_bd=20000;
  parameter Real slip_bd=0.0445;
  parameter Real slip_n=0.0145;

  parameter SI.Power P_n=738113;

  parameter Boolean useCharLine=false "True if characteristic line shall be used (else formula of Kloss)";

  parameter TransiEnt.Components.Electrical.Machines.Base.CharLineInductionMachine.CharLineInductionMachine_empty choose_CL_asy=TransiEnt.Components.Electrical.Machines.Base.CharLineInductionMachine.CharLineInductionMachine_ieet() annotation (choicesAllMatching=true, Dialog(enable=useCharLine));

  parameter Boolean useConverter=true;

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  //Modelica.SIunits.Frequency f_internal=switch1.y "frequency of rotor";
  Real slip(start=slip_n) "slip of asynchronous machine";
  Modelica.Units.SI.AngularFrequency omega_rot(start=2*Modelica.Constants.pi*f_rot_n) annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.Frequency f_rotor(start=f_rot_n) annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.Torque tau_m "mechanical torque";
  Modelica.Units.SI.Angle delta_asy(start=-0.08726646259971647) = epp.delta annotation (Dialog(group="Initialization", showStartAttribute=true));

  Modelica.Units.SI.PowerFactor cosphi=abs(S.re)/Modelica.ComplexMath.abs(S);
  Modelica.Units.SI.ComplexPower S(re(start=P_n), im(start=0)) annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.Voltage v_grid(start=v_n) = epp.v annotation (Dialog(group="Initialization", showStartAttribute=true));

  Modelica.Units.SI.Power P_mech=-(mpp.tau*omega_rot);

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

  CharLineInductionMachine.CharLineInductionMachineBlock charLineAsychronousMachineBlock(CharLineAsychronousMachine_parameter=choose_CL_asy) annotation (Placement(transformation(extent={{-12,54},{8,74}})));

protected
  TransiEnt.Basics.Interfaces.General.FrequencyIn f_internal  "Needed to connect to conditional connector for converterfrequency";

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Mechanical Equations

  slip= (f_internal-max(0,f_rotor)*N_pp)/(f_internal);

   tau_m=-mpp.tau;

  f_rotor=Modelica.Units.Conversions.to_Hz(omega_rot);

  omega_rot=der(mpp.phi);

  charLineAsychronousMachineBlock.slip_in=slip/slip_bd;

  if useCharLine then

  tau_m/(tau_bd)=charLineAsychronousMachineBlock.tau_out;

  else

    tau_m/(tau_bd) = 2/((slip/slip_bd) + (slip_bd/slip)) "Formula of Kloss";

  end if;

  if not useConverter then
    f_internal = epp.f;
  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(f_internal,f_converter);

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Partial model of an induction machine using TransiEnt electrical interfaces.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">depends on the used class</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Mechanical power port mpp</p>
<p>Complex power port epp</p>
<p>Modelica RealInput: frequency in Hz</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>omega_rot is the angular velocity of the rotor</p>
<p>f_rot is the frequency of the rotor</p>
<p>slip is the slip of the asynchronous machine</p>
<p>tau_m is the mechanical torque</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in August 2018</span></p>
</html>"));
end PartialInductionMotor;
