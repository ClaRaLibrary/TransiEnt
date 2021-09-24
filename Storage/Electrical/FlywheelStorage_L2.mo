within TransiEnt.Storage.Electrical;
model FlywheelStorage_L2 "Physical model of a flywheel storage where configurations can be chosen"


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

  extends TransiEnt.Storage.Electrical.Base.PartialElectricStorage;
  extends TransiEnt.Basics.Icons.Flywheel;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________
  parameter TransiEnt.Storage.Electrical.Specifications.DetailedFlywheel.GenericFlywheelRecord params "Model to use" annotation (choicesAllMatching);

  parameter Modelica.Units.NonSI.Energy_kWh E_start=E_max "Initial Energy";
  parameter SI.Energy K=2e6 "Power response per Hz deviation";
  final parameter Modelica.Units.NonSI.AngularVelocity_rpm n_max=params.n_max "Maximum revolution speed in rpm";
  final parameter Modelica.Units.NonSI.AngularVelocity_rpm n_min=params.n_min "Minimum revolution speed in rpm";
  final parameter Modelica.Units.NonSI.Energy_kWh E_max=params.E_max "Maximum storable energy in kWh";
  final parameter SI.Power P_el_max=params.P_el_max "Absolute maximum power";
  final parameter SI.Power P_loss_support=params.P_loss_support "Power needed to uphold operation";
  final parameter Real eta=params.eta_max "Maximum efficiency of a cycle";
  final parameter SI.Time tau=params.tau "Time constant for self discharge";
  final parameter Real eta_conv=params.eta_conv "Efficiency of conversion";
  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  //parameter SI.Time tau_test(fixed=false);
  Modelica.Units.SI.Energy E_rot(start=E_rot_min + Modelica.Units.Conversions.from_kWh(E_start)) "Rotational energy";

  // diagnostic variables
  SI.Frequency f(start=simCenter.f_n) "actual grid frequency"
                                                             annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.ActivePower P(start=0) "Power on epp"
                                          annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Energy E_stor "Available energy in Storage";
  SI.AngularFrequency omega "Angular velocity of flywheel";
  SI.Power P_omega_max "Maximum power output at current omega";
  SI.Power P_loss_conversion "Energy loss due to standbylosses";
  SI.Power P_loss_bear "Losses due to the bearing";
  SI.Power P_loss_aero "Aerodynamic losses";
  SI.Power P_loss "Summed losses";
  SI.Power P_demand;
  SI.Energy E_pos(start=0,stateSelect=StateSelect.never) "Positive (delivered) energy"
                                                                                      annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Energy E_neg(start=0,stateSelect=StateSelect.never) "Negative (stored) energy"
                                                                                   annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Energy eta_is=E_pos/max(E_stor_max,E_neg) "Actual efficiency";

  // _____________________________________________
  //
  //             Calculated Parameters
  // _____________________________________________

  final parameter SI.Energy E_stor_max=Modelica.Units.Conversions.from_kWh(  E_max);
  final parameter SI.AngularFrequency omega_max=Modelica.Units.Conversions.from_rpm(  n_max);
  final parameter SI.AngularFrequency omega_min=Modelica.Units.Conversions.from_rpm(  n_min);
  final parameter Real  lossFactor_bear=params.lossFactor_bear;
  final parameter Real  lossFactor_aero=params.lossFactor_aero;
  final parameter SI.Energy E_rot_max=E_stor_max + E_rot_min;
  final parameter SI.Energy  E_rot_min=1/2*omega_min^2*J "Rotational kinetic energy at omega_min";
  final parameter SI.MomentOfInertia  J=2*(E_rot_max)/omega_max^2 "Moment of inertia of flywheel";
  final parameter SI.MomentOfForce  M_max=P_el_max/omega_max "Maximum allowed momentum on flywheel";

//   final parameter SI.Time tau_min(fixed=false)
//     "Shortest possible discharge time";
  // _____________________________________________
  //
  //             Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealOutput SOC=E_stor/E_stor_max "State of Charge" annotation (Placement(transformation(extent={{94,30},{114,50}}),
        iconTransformation(extent={{-80,-10},{-100,10}})));

initial equation
  omega=(2*E_rot/J)^(1/2);
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  //Stored usable energy
  E_stor = E_rot - E_rot_min;
  //Power dependend on current angular velocity
  P_omega_max = omega*M_max;
  //Simple droop controller
  P_demand=K*(f - simCenter.f_n);

  //stop charging or discharging when omega_min or omega_max is reached
  if (omega > omega_max and (f - simCenter.f_n) > 0) or (
      omega < omega_min and (f - simCenter.f_n) < 0) then
    der(E_rot) = 0;
  else
    //limit power output. Maximum power output has to be reached though!
    der(E_rot) = smooth(1, if P_demand > P_omega_max then
      P_omega_max+P_loss_support else if P_demand < -(P_omega_max) then -(P_omega_max+P_loss) else P_demand);
  end if;

  //For analytic purposes:
  if
    (noEvent(epp.P>0)) then
    der(E_neg)=0;
    der(E_pos)=epp.P;
  else
    der(E_neg)=-epp.P;
    der(E_pos)=0;
  end if;
  //der(E_rot) does not completely go into epp.P
  //Also there are still losses when epp.P=0
  epp.P = -der(E_rot)-P_loss;

  //These can be exchanged. No difference in non-linear equations
  E_rot = 1/2*J*omega^2;
  //omega=sqrt(2*E_rot/J);

  //Bearing losses
  P_loss_bear = lossFactor_bear*omega;
  //Aerodynamic losses
  P_loss_aero = lossFactor_aero*omega^3;
  //Conversion losses
  P_loss_conversion = abs(epp.P*(1-eta_conv));
  P_loss=P_loss_bear + P_loss_aero + P_loss_support/eta_conv + P_loss_conversion;

  // diagnostic variables
  f = epp.f;
  P = epp.P;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of an electric storage device based on flywheel technology.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Physical representation of losses due to bearing and aerodynamic friction. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Wear-out of component is not taken into account. This model has ideal reaction speeds. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>There is only one electric port. Power input/output is regulated by grid frequency.</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>E=1/2*J*w^2</p>
<p>P_max = w*M_max</p>
<p>P=(f-f_n)*k</p>
<p>w_min&lt;w&lt;w_max</p>
<p>Losses:</p>
<p>Bearing losses proportional to w:</p>
<p>P_loss_bearing=a*w</p>
<p>Aerodynamic losses proportional to w^3:</p>
<p>P_loss_aerodynamic = b *w^3</p>
<p>Losses due to support system constant:</p>
<p>P_loss_support=const</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The flywheel will need the power to sustain its rotational speed when empty. Otherwise the simulation will fail.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Values for eta_max and self discharge rate compared to specification sheets. Thus, the loss factors a and b can be assumed to be in the right order of magnitude for the referenced system.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1]Beacon power, LLS, URL: http://beaconpower.com/ </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Arne Koeppen (arne.koeppen@tuhh.de), Jul 2013</p>
<p>Edited by Lisa Andresen (andresen@tuhh.de) Aug 2013</p>
</html>"));
end FlywheelStorage_L2;
