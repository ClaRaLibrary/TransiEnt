within TransiEnt.Components.Electrical.Grid.Base;
partial model PartialTwoPortAdmittanceComplex "Base Class of two port models with admittance parameters for lines and transformers"
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

extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Boolean activateSwitch=false annotation(Dialog(group="Fundamental Definitions"));
protected
  parameter SI.ComplexAdmittance Y_11(re=1,im=1);
  parameter SI.ComplexAdmittance Y_12(re=1,im=1);
  parameter SI.ComplexAdmittance Y_21=Y_12;
  parameter SI.ComplexAdmittance Y_22=Y_11;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
public
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________


  SI.ComplexPower S_p;
  SI.ComplexPower S_n;
  SI.ComplexVoltage v_p;
  SI.ComplexVoltage v_n;
  SI.ComplexCurrent i_p;
  SI.ComplexCurrent i_n;
  SI.ActivePower P(start=0);
  SI.ReactivePower Q(start=0);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_p annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_n annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.BooleanInput switched_input if activateSwitch annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));

protected
  Modelica.Blocks.Interfaces.BooleanInput switched_internal annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  epp_p.f = epp_n.f;

  Connections.branch(epp_p.f,epp_n.f);

  if not activateSwitch then
     switched_internal=true;
  end if;

  if not switched_internal then

    i_p.re=0;
    i_p.im=0;
    i_n.re=0;
    i_n.im=0;

  else

    i_p=Y_11*v_p+Y_12*v_n;
    i_n=Y_21*v_p+Y_22*v_n;

  end if;

  S_p=v_p* Modelica.ComplexMath.conj(i_p);
  S_n=v_n* Modelica.ComplexMath.conj(i_n);

  P =S_p.re;
  Q =S_p.im;

  S_p.re     = epp_p.P;
  S_p.im     = epp_p.Q;
  v_p.re     = epp_p.v*cos(epp_p.delta);
  v_p.im     = epp_p.v*sin(epp_p.delta);

  S_n.re     = epp_n.P;
  S_n.im     = epp_n.Q;

  v_n.re     = epp_n.v*cos(epp_n.delta);
  v_n.im     = epp_n.v*sin(epp_n.delta);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(switched_internal, switched_input);

  annotation (Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100,-100},{100,100}}), graphics),
          Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Base model of two port circuit models</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L3E (defined in the CodingConventions), Quasi-Stationary model of two port with concentrated elements. Active- and reactive power (losses) are regarded. Electrical Pi-network.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quasi-stationary model, model of pi model with concentrated elements, limited by the wavelength of the 50 Hz oscillation </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two ComplexPowerPort for each terminal of the two port model</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Boolean input for switching</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>U is uses for voltages</p>
<p>P is used for active powers</p>
<p>S is used for apparent powers</p>
<p>I is used for electric currents</p>
<p>Q is used for reactive powers</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two-Port Equations</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Use as partial model</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] A. F. Jacob, TUHH, Circuit Theory , 2013</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in May 2019</span></p>
</html>"));
end PartialTwoPortAdmittanceComplex;
