within TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConductivityModels;
model PEMconductivity3
  "PEM conductivity as modeled by Abdin 2015"

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

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
public
  parameter Real humidity_const=14 "constant humidity";

  // _____________________________________________
  //
  //              Variables
  // _____________________________________________

  //Humidity
  Real mem_humidity "lambda, 14 typical, 22 for fully hydrated membrane"; //humidity factor should be 14-16 for vapor, 22 for liquid water. See Abdin 2015 paper

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  mem_humidity = humidity_const;

  //Ohmic Overpotential
  mem_conductivity = (0.005139*mem_humidity - 0.00326)*exp(1268*(1/303 - 1/T_op))*100; //Uses S/m and thickness in m; verified in Abdin 2015 (conversion factor missing), found in Springer 1991

  annotation (
    defaultConnectionStructurallyInconsistent=true,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>PEM Conductivity as per Abdin 2015</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>PEM Conductivity as modeled by Abdin et al, 2015. (Originally from Springer et al. 1991, conversion factor (*100) found from there)</p>
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
<p>Z. Abdin, C.J. Webb, and E. MacA. Gray. Modelling and simulation of a proton exchange membrane (PEM) electrolyzer cell. <i>International Journal of Hydrogen Energy</i>, 40(39):13243-13257, 2015. doi:<a href=\"https://www.sciencedirect.com/science/article/pii/S0360319915019321\">10.1016/j.ijhydene.2015.07.129</a>. </p>
<p>T. E. Springer, T. A. Zawodzinski, and S. Gottesfeld, &ldquo;Polymer Electrolyte Fuel Cell Model,&rdquo; <i>J. Electrochem. Soc.</i>, vol. 138, no. 8, pp. 2334&ndash;2342, 1991.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by John Webster (jcwebste@edu.uwaterloo.ca) October 2018.</p>
<p>Fixed by Carsten Bode (c.bode@tuhh.de) January 2019</p>
</html>"));
end PEMconductivity3;
