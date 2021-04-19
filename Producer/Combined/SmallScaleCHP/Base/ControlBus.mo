within TransiEnt.Producer.Combined.SmallScaleCHP.Base;
connector ControlBus "Controls a CHP model"

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

replaceable record Specification=BaseCHPSpecification;
Modelica.SIunits.Temperature T_return;
Modelica.SIunits.Temperature T_supply;
Boolean switch;
Modelica.SIunits.Power P_el_set;
Modelica.SIunits.Power P_el_meas;
Modelica.SIunits.EnthalpyFlowRate Q_flow_meas;
Modelica.SIunits.Power P_el_pump_set;
Modelica.SIunits.Frequency f_grid;
Modelica.SIunits.Pressure dp;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),   graphics={Rectangle(
        extent={{-40,40},{40,-40}},
        lineColor={255,0,0},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid), Ellipse(
          extent={{-64,66},{64,-60}},
          lineColor={255,240,19},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-84,52},{82,-48}},
          lineColor={0,0,0},
          textString="C")}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Partial model of a control bus.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Jun 2013</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2013</p>
</html>"));
end ControlBus;
