within TransiEnt.Components.Electrical.Machines;
model InductionMotorComplex_L3E "Model of Induction Motor for ComplexPowerPort"
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

  extends TransiEnt.Components.Electrical.Machines.Base.PartialInductionMotor(
    f_rot_n=591.3/60,
    N_pp=5,
    tau_bd=20000,
    slip_bd=0.0445,
    slip_n=0.0145,
    P_n=738113);

  // _____________________________________________
  //
  //        Constants and  Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //                  Outer
  // _____________________________________________

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

   parameter Modelica.SIunits.Resistance r_R1=0.599 "1st cage rotor resistance";

   parameter Modelica.SIunits.Resistance r_s=0.7 "stator resistance";
   parameter Modelica.SIunits.Reactance x_R1=5.99 "1st cage rotor reactance";

    parameter Modelica.SIunits.Reactance x_s=5.4 "Stator reactance";
  parameter Modelica.SIunits.Reactance x_my=140 "Magnetization reactance";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

     Modelica.SIunits.ComplexVoltage U;
     Modelica.SIunits.ComplexVoltage E;
     Modelica.SIunits.ComplexVoltage U_S;
     Modelica.SIunits.ComplexCurrent I;
     Modelica.SIunits.ComplexCurrent I_R;
     Modelica.SIunits.ComplexCurrent I_my;

     Modelica.SIunits.ComplexPower S_rot;

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

//Electrical equations new

     epp.v=Modelica.ComplexMath.'abs'(U);
     delta_asy=Modelica.ComplexMath.arg(U);

     U=U_S+E;

     U_S=sqrt(3)*I*(r_s+j_comp*x_s);

     I_R+I_my=I;

     E=sqrt(3)*I_my*j_comp*x_my;

     E=sqrt(3)*I_R*(j_comp*x_R1+r_R1/slip);

     S_rot=sqrt(3)*E*Modelica.ComplexMath.conj(I);

     S=sqrt(3)*U*Modelica.ComplexMath.conj(I);

     epp.P=S.re;

     epp.Q=S.im;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model for asynchronous, induction motor for use with the ComplexPowerPort with network</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>L3E (defined in the CodingConventions): Models are based on electrical networks in quasi-stationary form</p>
<p>No dynamics</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Mechanical connection is stiff</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Only one axis, do not use for fast changes</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp (ComplexPowerPort) and mpp</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Formula of Kloss(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">use this model for auxillary </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Components.Electrical.Machines.Check.CheckAsynchronousMotor_L3E&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no references)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in April 2018 </span></p>
</html>"));
end InductionMotorComplex_L3E;
