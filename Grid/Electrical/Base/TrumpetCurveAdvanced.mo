within TransiEnt.Grid.Electrical.Base;
block TrumpetCurveAdvanced
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
//European Network of Transmission System Operators for Electricity (ENTSO-E). (2015). Appendix 1: Load-Frequency Control and Performance. In Continental Europe Operation Handbook.page 21... ENTSO-E. Retrieved from https://www.entsoe.eu/publications/system-operations-reports/operation-handbook/Pages/default.aspx

  extends Modelica.Blocks.Interfaces.SO;
  extends Basics.Icons.Block;
  parameter Boolean is_loss = true;
  parameter Modelica.SIunits.Power P_Z = 3e9;
  parameter Modelica.SIunits.Time t_dist=0 "Time of disturbance";
  parameter Modelica.SIunits.Frequency f_0= 50 "Nominal frequency";
  parameter Real lambda_u = 16.5e9 "Grid power frequency behaviour in W/Hz";
  parameter Modelica.SIunits.Frequency delta_f_margin = 20e-3;

  final parameter Real A = 1.2 * (1/lambda_u * abs(P_Z) + 30e-3);
  final parameter Real T = 900 / log(A/delta_f_margin);

equation
  if is_loss then
    y=if time < t_dist then f_0 else f_0 - A * exp(-(time-t_dist)/T);
  else
    y=if time < t_dist then f_0 else f_0 + A * exp(-(time-t_dist)/T);
  end if;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model generates an output according to the trumpet curve defined by </p>
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
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TrumpetCurveAdvanced;
