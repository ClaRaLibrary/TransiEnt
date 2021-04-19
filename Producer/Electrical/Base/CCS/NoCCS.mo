within TransiEnt.Producer.Electrical.Base.CCS;
record NoCCS "No efficiency losses due to CCS"
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
  Real CCS_Absolute_Efficiency_Loss[:,:]=[0,0;1,0];
  Real Deviation_CO2_Absolute_Efficiency_Loss[:,:]=[0,1;1,1];

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Records for efficiency losses with CCS for power plants.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p><span style=\"font-family: Courier New;\">CCS_Absolute_Efficiency_Loss </span>contains the absolute efficiency load of the power plant over the original relative load of power plant without CCS for one specific value of the deposited CO2 fraction.</p>
<p><span style=\"font-family: Courier New;\">Deviation_CO2_Absolute_Efficiency_Loss </span>contains the deviation of the efficiency losses if the CO2 deposition fraction deviates from the original fraction.</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Schülting (oliver.schuelting@tuhh.de), Dec 2018</p>
</html>"));
end NoCCS;
