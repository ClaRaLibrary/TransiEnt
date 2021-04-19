within TransiEnt.Producer.Heat.Gas2Heat.SmallGasBoiler.Utilities;
block FirstOrder_variableDamping "First order transfer function block (= 1 pole) with variable damping"

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

  extends Modelica.Blocks.Interfaces.MISO(nin=2,y(start=y_start));

  // _____________________________________________
  //
  //           Constants and Parameters
  // _____________________________________________

  parameter Real k(unit="1")=1 "Gain";
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit "Type of initialization (1: no init, 2: steady state, 3/4: initial output)"
    annotation (Evaluate=true, Dialog(group="Initialization"));
  parameter Real y_start=0 "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________

  Modelica.SIunits.Time T(start=1)=u[2] "Variable time Constant"
                                                                annotation (Dialog(group="Initialization", showStartAttribute=true));

initial equation
  if initType == Init.SteadyState then
    der(y) = 0;
  elseif initType == Init.InitialState or initType == Init.InitialOutput then
    y = y_start;
  end if;

equation
  der(y) = (k*u[1] - y)/T;
  annotation (
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This blocks defines the transfer function between the input u and the output y (element-wise) as <i>first order</i> system with variable damping: </p>
<pre>               k
     y = ------------ * u
            T * s + 1</pre>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>u[1]: signal input</p>
<p>u[2]: damping input</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Function created by Paul Kernstock (paul.kernstock@tuhh.de) August 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2015</p>
</html>"), Icon(
  coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}},
    initialScale=0.1),
    graphics={
  Line(visible=true,
      points={{-80.0,78.0},{-80.0,-90.0}},
    color={192,192,192}),
  Polygon(visible=true,
    lineColor={192,192,192},
    fillColor={192,192,192},
    fillPattern=FillPattern.Solid,
    points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
  Line(visible=true,
    points={{-90.0,-80.0},{82.0,-80.0}},
    color={192,192,192}),
  Polygon(visible=true,
    lineColor={192,192,192},
    fillColor={192,192,192},
    fillPattern=FillPattern.Solid,
    points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
  Line(visible = true,
      origin = {-26.667,6.667},
      points = {{106.667,43.333},{-13.333,29.333},{-53.333,-86.667}},
      color = {0,0,127},
      smooth = Smooth.Bezier),
  Text(visible=true,
    lineColor={192,192,192},
    extent={{0.0,-60.0},{60.0,0.0}},
    textString="PT1"),
  Text(visible=true,
    extent={{-150.0,-150.0},{150.0,-110.0}},
    textString="T=%T")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-48,52},{50,8}},
          lineColor={0,0,0},
          textString="k"),
        Text(
          extent={{-54,-6},{56,-56}},
          lineColor={0,0,0},
          textString="T s + 1"),
        Line(points={{-50,0},{50,0}}, color={0,0,0}),
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255})}));
end FirstOrder_variableDamping;
