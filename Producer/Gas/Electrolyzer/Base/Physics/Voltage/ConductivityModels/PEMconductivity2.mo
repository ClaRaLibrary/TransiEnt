within TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConductivityModels;
model PEMconductivity2
  "PEM conductivity as modeled by N.V.Dale 2008"

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

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConductivityModels.PartialPEMConductivity;

  import SI = Modelica.SIunits;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Ohmic Overpotential
  mem_conductivity = (0.0480257 + 8.15178e-4*(T_op-273.15) + 5.11692e-7*(T_op-273.15)^2)*100; // Units S/m; Linear regression from experimental data; N.V.Dale 2008, 6kW Nafion PEM

  annotation (
    defaultConnectionStructurallyInconsistent=true,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>PEM Conductivity model N.V.Dale 2008 for a Nafion 117 membrane. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>PEM Conductivity as modeled by N.V.Dale et al, 2008.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Original model developed and validated in the range of 20-60 &deg;C with operating pressure of 15-35 bar. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>N.V. Dale et al. Semiempirical model based on thermodynamic principles for determining 6&nbsp;kW proton exchange membrane electrolyzer stack characteristics. <i>Journal of Power Sources</i>, 185(2):1348-1353, 2008. DOI: <span style=\"font-family: Arial,Helvetica,Lucida Sans Unicode,Microsoft Sans Serif,Segoe UI Symbol,STIXGeneral,Cambria Math,Arial Unicode MS,sans-serif;\"><a href=\"https://doi.org/10.1016/j.jpowsour.2008.08.054\">https://doi.org/10.1016/j.jpowsour.2008.08.054</a></span> </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by John Webster (jcwebste@edu.uwaterloo.ca) October 2018.</p>
<p>Fixed by Carsten Bode (c.bode@tuhh.de) January 2019</p>
</html>"));
end PEMconductivity2;
