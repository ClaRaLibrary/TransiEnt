within TransiEnt.Components.Electrical.Machines;
model SynchronousMachineComplex "ComplexPowerPort: SM model with electric circuit, excitation voltage input"


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
  //        Constants and  Hidden Parameters
  // _____________________________________________

protected
constant Complex j_comp(re=0,im=1) annotation(Dialog(enable=false));

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
public
  extends TransiEnt.Components.Electrical.Machines.Base.PartialQuasiStationaryGeneratorComplex;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________


  parameter Modelica.Units.SI.Reactance X_d=1.1 "Synchronous inductance of machine" annotation (Dialog(group="Physical constraints"));
  parameter Modelica.Units.SI.Resistance R_a=0.3 "Resistance for losses" annotation (Dialog(group="Physical constraints"));





  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________


  SI.ComplexCurrent i(re(start=0), im(start=0))             annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.ComplexVoltage v(re(start=v_n), im(start=0))               annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.ComplexVoltage e;
  Modelica.Units.SI.ComplexPower S_c;
  Modelica.Units.SI.ComplexImpedance Z "Complex impedance modeled by just an inductance (no ohmic resistance)";


  Modelica.Units.SI.ComplexPower S_rotor;


  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________


equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //mechanical equation

if OwnFrequency==true then
  S_rotor.re + D_cage * der(theta) = (mpp.tau * omega);
else
  S_rotor.re = (mpp.tau * omega);
end if;


  //voltage connection to epp

  epp.v =Modelica.ComplexMath.abs(v);
  Modelica.ComplexMath.arg(v)=delta_lsm;




  //electric equation

  e=i*Z+v;

  //Link to E_input

  Modelica.ComplexMath.abs(e) = E_input "Induced voltage depending on excitation";

  //electric power in and out

  S_c=-v*Modelica.ComplexMath.conj(i);

  S_rotor=e*Modelica.ComplexMath.conj(i);

  //Link to Power of epp

  S_c.re=epp.P;
  S_c.im=epp.Q;

  //calculation of theta

  theta=Modelica.ComplexMath.arg(e);

  //calculation of Z

    Z = j_comp*X_d+R_a "Stator impedance";







   annotation (Diagram(graphics,
                       coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a synchronous machine with losses. Mechanical connection is stiff.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>L4E - model with circuit description. Voltage, active and reactive power are linked together by equations. Model of excitation system with voltage control</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Mechanical connection is stiff</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">only one reactance, no dq0-system</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp (ComplexPowerPort) </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Mechanical power port mpp</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: electric potential in [V]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Only use machines of the class together in one simulation</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model only for small signal consideration and cylindrical rotor machine</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Set IsSlack to true for slack-bus version</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Tested in the check model &quot;TransiEnt.Components.Electrical.Machines.Check.CheckSynchronousMachineComplex&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in March 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model made more modular (extension of partial class and one version for Slack and PU-Bus) in June/July 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised (own Frequency) in October/November 2018</span></p>
</html>"));
end SynchronousMachineComplex;
