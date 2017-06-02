within TransiEnt.Basics.Records.GasProperties;
record NormalDensities "Record containing densities at STP (T=273.15 K, p=1.01325 bar) for components of natural gas in kg/m3"
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  extends TransiEnt.Basics.Icons.Record;

  parameter String[:] names = {"Methane", "CH4", "Ethane", "C2H6", "Propane", "C3H8", "Butane", "C4H10", "Nitrogen", "N2", "carbon_dioxide", "CO2", "Hydrogen", "H2"};
  parameter Modelica.SIunits.Density[:] rho_n = {0.7175, 0.7175, 1.3551, 1.3551, 2.010, 2.010, 2.709, 2.709, 1.2504, 1.2504, 1.9767, 1.9767, 0.08989, 0.08989};

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This record contains densities at STP for some gas components used in the TransiEnt library.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The names vector contains the component names</p>
<p><img src=\"modelica://TransiEnt/Images/MolarMasses_Names.png\"/>.</p>
<p>In the normal densities vector the densities for each component is defined in kg/m3</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Be sure to store the densities for each component in rho_n vector in the same column in which the name is stored in the names vector.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Jul 2016</p>
</html>"));
end NormalDensities;