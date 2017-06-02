within TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Components.Controller;
partial model PartialThermostat "Blueprint for thermostat models"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Controller;
  import SI = Modelica.SIunits;

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

  Modelica.Blocks.Interfaces.RealInput T_is "Measured value of controlled temperature" annotation (Placement(transformation(extent={{-108,-12},{-84,12}}), iconTransformation(extent={{-108,-12},{-84,12}})));

  Modelica.Blocks.Interfaces.BooleanOutput q "Boolean, true=Compressor on" annotation (Placement(transformation(extent={{92,-10},{112,10}}), iconTransformation(extent={{92,-10},{112,10}})));
                                                                                                                //Signal an Wrmepumpe

initial equation
  // _____________________________________________
  //
  //           Initial Equations
  // _____________________________________________
  if T_is >= (T_set_new+delta/2) then
    q=true;
  elseif T_is <= (T_set_new-delta/2) then
    q=false;
  else
    q=q0;
  end if;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  when {T_is >= (T_set_new+delta/2)} then
    q=true;
  elsewhen {T_is <= (T_set_new-delta/2)} then
    q=false;
  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),              Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
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
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
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