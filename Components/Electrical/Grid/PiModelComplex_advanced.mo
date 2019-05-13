within TransiEnt.Components.Electrical.Grid;
model PiModelComplex_advanced "pi-Modell of a cable for ComplexPowerPort, better numerics"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

 // extends TransiEnt.Basics.Icons.Model;

 extends PiModelComplex;

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________



  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________



  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________




  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________



  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________




     Boolean overload(start=false);
     SI.Current I_1_mag;
     SI.Current I_2_mag;
     SI.Current I_g_mag;
     Real usage;
     Modelica.SIunits.Voltage U_1_abs=Modelica.ComplexMath.'abs'(v_p);
     Modelica.SIunits.Voltage U_2_abs=Modelica.ComplexMath.'abs'(v_n);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________



      I_1_mag=Modelica.ComplexMath.'abs'(i_p);
      I_2_mag=Modelica.ComplexMath.'abs'(i_n);

if I_1_mag > I_2_mag then
  I_g_mag=I_1_mag;
else
  I_g_mag=I_2_mag;
end if;

if I_g_mag>(i_r*p*sqrt(3)) then
  overload=true;
else
  overload=false;
end if;

usage=I_g_mag/(i_r*p*sqrt(3));

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

 annotation (defaultComponentName = "transmissionLine",
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Advanced line model using two-port equation. Computes losses and voltage drop dependent of typical cable types and specified length. Model includes capacity of utilization.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L3E (defined in the CodingConventions), Quasi-Stationary model of transmission line with concentrated elements. Active- and reactive power (losses) are regarded. Electrical Pi-network.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quasi-stationary model, model of line with concentrated elements, limited by the wavelength of the 50 Hz oscillation </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two ComplexPowerPort for each terminal of the transmission line</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>I is used for currents</p>
<p>U is used for voltages</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two-Port Equations</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Use these model when capacity of utilization is needed. But this needs some computation time.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Parameters for the type of line are divided in the three voltage levels</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] M. Schaefer, KIT, URL: https://www.zml.kit.edu/downloads/Elektrische_Energieuebertragung_Leseprobe_Kapitel_2.pdf, 2018</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in March 2018</span></p>
</html>"));
end PiModelComplex_advanced;
