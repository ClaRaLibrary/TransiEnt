within TransiEnt.Components.Heat;
model HeatFlowMultiplier "Heat Flow Multiplier"
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
  //              Visible Parameters
  // _____________________________________________

  parameter Real factor=1 "Factor with which the heat flow rate is supposed to be scaled";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
equation
  port_a.T=port_b.T;
  port_b.Q_flow=-factor*port_a.Q_flow;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Polygon(
          points={{-10,80},{10,80},{40,-80},{-40,-80},{-10,80}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>The model simply multiplies the heat flow at port_a with a given factor.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>see 7.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>port_a: input heat flow to be multiplied</p>
<p>port_b: output heat flow (multiplied)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>This model can lead to unphysical behavior since it contains an invalid energy balance.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Jun 2019</p>
</html>"));
end HeatFlowMultiplier;
