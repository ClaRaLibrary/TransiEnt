within TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConcentrationVoltageModels;
partial model PartialConcentrationModel

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

 extends TransiEnt.Basics.Icons.Voltage;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-150,-105},{150,-145}},
          lineColor={0,134,134},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008300\">1. Purpose of model</span></h4>
<p>partial model containing the essential variables for concentration overvoltage.</p>
<h4><span style=\"color: #008300\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008300\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">5. Nomenclature</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008300\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">10. Version History</span></h4>
<p>Created by John Webster (jcwebste@edu.uwaterloo.ca) October 2018.</p>
</html>"));
end PartialConcentrationModel;
