within TransiEnt.Consumer.Systems.FridgePoolControl.Components;
model ExplicitFridge "Model of a hysteresis controlled fridge as explicit declaration"

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
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  // parameters:
  parameter Real a = 50 "Gain of the histeresis function";
  parameter Real b = 20 "Slope of the saturation function at the origin";

  parameter Base.ExplicitFridgeParameters params;

  parameter SI.TemperatureDifference Delta_T_internal = 5;
  final parameter SI.Efficiency eta = params.COP/((273.15+20)/(20+12));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // variables:
  input SI.Temperature T_amb;

  SI.Temperature T(start=params.T0) "Temperature / Energy level"
                                                                annotation (Dialog(group="Initialization", showStartAttribute=true));
  Real x(start = params.x0, fixed = true) "State of on/off controller"
                                                                      annotation (Dialog(group="Initialization", showStartAttribute=true));
  Real y "On/Off control status (boolean)";
  SI.Power P_el = params.P_el_n * y;

  Real COP_Carnot =  (T_amb + Delta_T_internal)/max(2*Delta_T_internal, 2*Delta_T_internal + T_amb - params.Tset);
  Real COP_eff = max(COP_Carnot * eta,0);

  Real SOC = 1-(T-(params.Tset-params.DTdb/2))./params.DTdb;
  SI.Energy E_stor_total = params.m * params.cp * params.DTdb;
  SI.Time t_pos_max = E_stor_total*SOC/(params.k*(T_amb-T));
  SI.Time t_neg_max = E_stor_total*(1-SOC) / (params.P_el_n*COP_eff);

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  // hysteresis state
  der(x) =a*TransiEnt.Basics.Functions.hist(
    x,
    T - params.Tset,
    params.DTdb/2);

  // controller output
  y =TransiEnt.Basics.Functions.sat(
    b*x,
    -0.5,
    0.5) + 0.5;

  // energy equation
  der(T) = 1/params.tau * (params.Tamb-T) - params.k1/params.COP*COP_eff*y;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-48,58},{44,-58}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}), Rectangle(
          extent={{26,18},{32,-16}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a hysteresis controlled fridge as explicit declaration.</span></p>
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
<p>(no remarks)</p>
</html>"));
end ExplicitFridge;
