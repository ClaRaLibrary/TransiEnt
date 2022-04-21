within TransiEnt.Components.Sensors;
model FrequencyStandardDeviation "Computes the standard deviation of frequency deviations"



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

  extends TransiEnt.Basics.Icons.Sensor;

  // _____________________________________________
  //
  //        Parameters
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  parameter Modelica.Units.SI.Time t_eps(min=0.0) = 15*60 "Start calculation after first 15-Minute value";
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

  Modelica.Units.SI.Frequency delta_f=epp.f - simCenter.f_n;
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
                               Diagram(graphics,
                                       coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Measure freuqency on electric line using TransiEnt interfaces with L1E (single phase active power and frequency lines)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: active power port</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">y: RealOutput</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The algorithm for standard deviation computation was heaviliy inspired by the Model &quot;Variance&quot; from the Modelica_Noise Library.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end FrequencyStandardDeviation;
