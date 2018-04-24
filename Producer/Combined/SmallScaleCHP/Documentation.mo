within TransiEnt.Producer.Combined.SmallScaleCHP;
model Documentation "Documentation of a Combined Heat and Power Unit"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
extends ModelicaReference.Icons.Information;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a (block) Combined Heat and Power (CHP) plant based on an internal combustion engine.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>heat exchangers with prescribed heat flow, engine and generator model replaceable, thereby deciding on the level of detail</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>model is validated against a small CHP unit by the german maker senertec. In general the model should be scalable if additional validation data is available.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>controlBus: Connector for a CHP contoller, defining all necessary in- and outputs</p>
<p>epp: ActivePowerPort</p>
<p>waterPortIn, waterPortOut: fluidports for a distributed heating system</p>
<p>gasPortIn, gasPortOut: fuel and exhaust gas ports (ideal gas medium)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>Specification: Contains records of CHP parameters. All records must extend Base.BaseCHPSpecification.</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>For static engine:</p>
<p>calculation of heat and fuel consumption based on efficiencies and P_set</p>
<p>For dynamic engine:</p>
<p>calculation of heat and fuel consumption based on efficiencies and P_set and a state depending mean frictional pressure. Power output governed by second order transfer function.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>None.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>&QUOT;DachsHKA&QUOT; parameter set is validated</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>equation for frictional pressure according to Reulein (Simulation des instation&auml;ren Warmlaufverhaltens von Verbrennungsmotoren,1998)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Original model created by Arne Koeppen (arne.koeppen@tuhh.de), Jul 2014</p>
<p>Edited by Jan Braune (jan.braune@tuhh.de), Feb 2015</p>
<p>Edited by Lisa Andresen (andresen@tuhh.de), Mar 2015</p>
</html>"));
end Documentation;
