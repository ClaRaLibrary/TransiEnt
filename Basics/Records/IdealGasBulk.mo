within TransiEnt.Basics.Records;
model IdealGasBulk "Model for generating a summary for an ideal gas bulk"
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

    extends TransiEnt.Basics.Icons.Record;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

    replaceable parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG6_var mediumModel "Used medium model";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

    input SI.Mass mass "Mass" annotation(Dialog);
    input SI.Temperature T "Temperature" annotation(Dialog);
    input SI.Pressure p "Pressure" annotation(Dialog);
    input SI.SpecificEnthalpy h "Specific enthalpy" annotation(Dialog);
    input SI.MassFraction xi[mediumModel.nc - 1] "Component mass fractions"  annotation(Dialog);
    input SI.MassFraction x[mediumModel.nc - 1] "Component molar fractions"  annotation(Dialog);
    input SI.Density rho "Density" annotation(Dialog);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model can be used to generate a summary of an ideal gas bulk</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>input for mass, temperature, specific enthalpy, pressure, component mass fraction, component molar fraction and density</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Apr 2017</p>
</html>"));
end IdealGasBulk;
