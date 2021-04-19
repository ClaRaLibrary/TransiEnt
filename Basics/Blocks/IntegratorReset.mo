within TransiEnt.Basics.Blocks;
block IntegratorReset "Output the integral of the input signal, boolean input allows reset of integral value"

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

  import Modelica.Blocks.Types.Init;
  extends Modelica.Blocks.Interfaces.SISO(y(start=y_start));

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

  parameter Real k(unit="1")=1 "Integrator gain";

  /* InitialState is the default, because it was the default in Modelica 2.2
     and therefore this setting is backward compatible
  */
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState "Type of initialization (1: no init, 2: steady state, 3,4: initial output)"
                                                                                    annotation(Evaluate=true,
      Dialog(group="Initialization"));
  parameter Real y_start=0 "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.BooleanInput trigger annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,68})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

initial equation
  if initType == Init.SteadyState then
     der(y) = 0;
  elseif initType == Init.InitialState or
         initType == Init.InitialOutput then
    y = y_start;
  end if;
equation
  when trigger then
    reinit(y,0);
  end when;
      der(y) = k*u;

  annotation (
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This block extends the functionality of the MSL <a href=\"Modelica.Blocks.Continuous.Integrator\">Integrator</a> block by a boolean input that can trigger the integrator state to zero. Thereby alternative anti-windup measures can be implemented.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica BooleanInput</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de), Aug 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de), Apr 2017 : code conventions</span></p>
</html>"), Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100.0,-100.0},{100.0,100.0}},
          initialScale=0.1),
        graphics={
          Line(
            visible=true,
            points={{-80.0,78.0},{-80.0,-90.0}},
            color={192,192,192}),
          Polygon(
            visible=true,
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
          Line(
            visible=true,
            points={{-90.0,-80.0},{82.0,-80.0}},
            color={192,192,192}),
          Polygon(
            visible=true,
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
          Text(
            visible=true,
            lineColor={192,192,192},
            extent={{0.0,-70.0},{60.0,-10.0}},
            textString="I"),
          Text(
            visible=true,
            extent={{-150.0,-150.0},{150.0,-110.0}},
            textString="k=%k"),
          Line(
            visible=true,
            points={{-80.0,-80.0},{80.0,80.0}},
            color={0,0,127})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255}),
        Text(
          extent={{-36,60},{32,2}},
          lineColor={0,0,0},
          textString="k"),
        Text(
          extent={{-32,0},{36,-58}},
          lineColor={0,0,0},
          textString="s"),
        Line(points={{-46,0},{46,0}}, color={0,0,0})}));
end IntegratorReset;
