within TransiEnt.Basics.Interfaces.Thermal;
connector FluidPort "Basic fluid port in TransiEnt library consisting of massflow, pressure, enthalpy and composition"


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
  //           Instances of other Classes
  // _____________________________________________

  TILMedia.VLEFluidTypes.BaseVLEFluid  Medium "Medium model";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  flow Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate from the connection point into the component";
  Modelica.Units.SI.AbsolutePressure p "Thermodynamic pressure in the connection point";
  stream Modelica.Units.SI.SpecificEnthalpy h_outflow "Specific thermodynamic enthalpy close to the connection point if m_flow < 0";
  stream Modelica.Units.SI.MassFraction xi_outflow[Medium.nc - 1] "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";

  annotation (Icon(graphics), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This connector is used for fluid flow between components. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>m_flow Mass flow rate in [kg/s]</p>
<p>p Absolute pressure in the connection point in [Pa]</p>
<p>h_outflow Specific thermodynamic enthalpy close to the connection point if m_flow &lt; 0 [J/kg]</p>
<p>xi_outflow Independent mixture mass fractions m_i/m close to the connection point if m_flow &lt; 0 [1]</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Oct 2014</p>
</html>"));
end FluidPort;
