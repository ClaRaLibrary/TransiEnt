within TransiEnt.Storage.Heat.HeatStorage_Stratified.Basics;
model ThermalConductor_Fluid "Thermal Conduction between two fluid layers (based on ThermalConductor from MSL)"
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
  extends Modelica.Thermal.HeatTransfer.Components.ThermalConductor(
    final G= A_heat*k/height_Seg);

  import SI = Modelica.SIunits;

  parameter Modelica.SIunits.Area A_heat = 1 "Area of heat transfer";
  parameter Modelica.SIunits.Length height_Seg = 1 "Height of one fluid layer";
  parameter Modelica.SIunits.ThermalConductivity k = 0.6 "Specific heat conductivity of fluid";
                                            //0,6 means the value of water

algorithm
    assert(A_heat > 0,
      "Area of heat transfer hast to be positive. Adjust!");
    assert(height_Seg > 0,
      "Height of cylinder of heat transfer hast to be positive. Adjust!");
    assert(k> 0,
      "Specific heat conductivity of insulation hast to be positive. Adjust!");

annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Modeling the thermal conduction between two fluid layers of same height. The model extends the models ThermalConductor from the Modelica Standard Library (MSL)</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Thermal conduction in fluid with constant specific heat condductivity considered.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Thermal conduction in fluid with constant specific heat conductivity considered.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>port_a: model gets temperature and gives the calculated heat flow back </p><p>port_b: model gets temperature and gives the calculated heat flow with changed sign back</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>A_heat: Area of heat transfer </p><p>height_Seg: height of one fluid layer </p><p>k: Specific heat conductivity of fluid (0.6 means water) </p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Ramm (tobias.ramm@tuhh.de) on Fri Mar 20 2015</p>
<p>Revised and edited by Lisa Andresen (andresen@tuhh.de), Jun 2015</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end ThermalConductor_Fluid;
