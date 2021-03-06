within TransiEnt.Basics.Interfaces.Gas;
connector IdealGasTempPort "A connector for ideal gas featuring T,p,xi,m_flow"
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
  //           Instances of other Classes
  // _____________________________________________

  TILMedia.GasTypes.BaseGas                 Medium "Medium model";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  flow Modelica.SIunits.MassFlowRate m_flow "Mass flow rate from the connection point into the component";
  Modelica.SIunits.AbsolutePressure p "Thermodynamic pressure in the connection point";
  stream Modelica.SIunits.Temperature  T_outflow "Temperature close to the connection point if m_flow < 0";
  stream Modelica.SIunits.MassFraction xi_outflow[Medium.nc-1] "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Ideal gas flow connector with m_flow, T, p, xi as variables. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>p is the pressure</p>
<p>m_flow is the mass flow rate</p>
<p>xi is the mass fraction</p>
<p>T_outflow is the temperature</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>This connector should only be used for ideal gases (type consistency).</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Aug 2013</p>
</html>"));
end IdealGasTempPort;
