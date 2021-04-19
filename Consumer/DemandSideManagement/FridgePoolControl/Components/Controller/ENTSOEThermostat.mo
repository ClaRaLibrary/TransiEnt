within TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Components.Controller;
model ENTSOEThermostat "Frequency dependent thermostat as proposed by ENTSO-E"
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
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Controller.PartialThermostat;
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //         Outer models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants
  // _____________________________________________

 parameter SI.Frequency f_n = simCenter.f_n "Nominal grid frequency";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

 parameter SI.Frequency delta_f_db = 0.4 "Frequency isWithinDeadband of primary control";
 parameter Real alpha = -10 "Gain of frequency dependency";

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

protected
 Boolean isWithinDeadband( start=true, fixed=true) "True = within frequency isWithinDeadband";
 Boolean isTransition( start=false, fixed=true) "True = is transition state after frequency induced control action";
 SI.Time starttime( start=0); //Zeitpunkt des Wiedererreichens der Totzone
 discrete SI.Time t_delay( start = 300) "Time delay before normal operation after frequency induced control action";
 SI.Temp_K T_set_transition;

  // _____________________________________________
  //
  //           Interfaces
  // _____________________________________________

public
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp "Electric power port for frequency measurement" annotation (Placement(transformation(extent={{-11,85},{16,111}}), iconTransformation(extent={{-11,85},{16,111}})));

initial equation
  // _____________________________________________
  //
  //           Initial Equations
  // _____________________________________________
  T_set_transition=T_set;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
 isWithinDeadband =  (abs(epp.f-f_n) <= (delta_f_db/2));

  when edge(isWithinDeadband) then
    t_delay=300*Design.Experimentation.RandomNumber.Functions.random(); // random delay time between 0 und 300s
    starttime=time;
    T_set_transition=pre(T_set_new);
  end when;

  when edge(isWithinDeadband) and t_delay>0 then
    isTransition=true;
  elsewhen time>=(starttime+t_delay) then
    isTransition=false;
  end when;

  T_set_new = if (isWithinDeadband and not isTransition) then T_set elseif noEvent(isTransition) then T_set_transition else (T_set + alpha*(epp.f - f_n));
  epp.P=0;

           annotation (Diagram(graphics,
                               coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-28,21},{28,9}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="ENTSO-E")}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model of a frequency dependant Thermostat which was proposed by ENTSO-E (European Network of Transmission System Operators for Electricity). Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>T_is - measured value of controlled Temperature</p>
<p>q - boolean (on/off) signal</p>
<p>epp - Electric Power Port for frequency measurement</p>
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
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end ENTSOEThermostat;
