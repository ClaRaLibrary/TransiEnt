within TransiEnt.Components.Sensors;
model FrequencyStandardDeviation "Computes the standard deviation of frequency deviations"

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

  extends TransiEnt.Basics.Icons.Sensor;

  // _____________________________________________
  //
  //        Parameters
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  parameter Modelica.SIunits.Time t_eps(min=0.0)=15*60 "Start calculation after first 15-Minute value";
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{-10,-108},{10,-88}}), iconTransformation(extent={{-10,-108},{10,-88}})));
  Modelica.Blocks.Interfaces.RealOutput y "Frequency standard deviation" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,90}),   iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,90})));

  Modelica.SIunits.Frequency delta_f = epp.f - simCenter.f_n;
  // This algorithm has been inspired byModelica Noise library!
protected
  Real mean "Mean";
  Real var "Variance";
  parameter Real t_0(fixed=false);

initial equation
  t_0 = time;
  mean = delta_f;
  var = 0;
equation
  der(mean) = noEvent(if time >= t_0 + t_eps then (delta_f - mean)/(time-t_0) else 0);
  der(var) = noEvent(if time >= t_0 + t_eps then ((delta_f-mean)^2 - var)/(time - t_0) else 0);
  y        = sqrt(noEvent(if time >= t_0 + t_eps then max(var,0)                    else 0));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  epp.P = 0;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Text(
            extent={{-34,104},{-6,82}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="f"), Text(
          extent={{-88,162},{100,90}},
          lineColor={0,0,255},
          textString="%name")}),
                               Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Measure freuqency on electric line using TransiEnt interfaces with LoD 1 (single phase active power and frequency lines)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The algorithm for standard deviation computation was heaviliy inspired by the Model &QUOT;Variance&QUOT; from the Modelica_Noise Library.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end FrequencyStandardDeviation;