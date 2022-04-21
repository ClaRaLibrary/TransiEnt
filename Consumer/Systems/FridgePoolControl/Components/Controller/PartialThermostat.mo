within TransiEnt.Consumer.Systems.FridgePoolControl.Components.Controller;
partial model PartialThermostat "Blueprint for thermostat models"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  extends TransiEnt.Basics.Icons.Controller;
  import      Modelica.Units.SI;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

 parameter SI.Temperature T_set = 279.15 "Setpoint temperature";
 parameter SI.TemperatureDifference delta = 2 "Hysteresis deadband in K";
 parameter Boolean q0=false "Thermostat state at startup";

 SI.Temperature T_set_new(start=T_set) "New setpoint";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.TemperatureIn T_is "Measured value of controlled temperature" annotation (Placement(transformation(extent={{-108,-12},{-84,12}}), iconTransformation(extent={{-108,-12},{-84,12}})));

  Modelica.Blocks.Interfaces.BooleanOutput q "Boolean, true=Compressor on" annotation (Placement(transformation(extent={{92,-10},{112,10}}), iconTransformation(extent={{92,-10},{112,10}})));
                                                                                                                //Signal an Wrmepumpe

initial equation
  // _____________________________________________
  //
  //           Initial Equations
  // _____________________________________________
//   if T_is >= (T_set_new+delta/2) then
//     pre(q)=true;
//   elseif T_is <= (T_set_new-delta/2) then
//     pre(q)=false;
//   else
    pre(q)=q0;
//   end if;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  q = not pre(q) and T_is > (T_set_new+delta/2) or pre(q) and T_is >= (T_set_new-delta/2);

//   when {T_is >= (T_set_new+delta/2)} then
//     q=true;
//   elsewhen {T_is <= (T_set_new-delta/2)} then
//     q=false;
//   end when;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),              Diagram(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a partial model of a simple thermostat. Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>T_is - measured value of controlled Temperature</p>
<p>q - boolean (on/off) signal</p>
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
end PartialThermostat;
