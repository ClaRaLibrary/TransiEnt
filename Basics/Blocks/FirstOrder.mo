within TransiEnt.Basics.Blocks;
block FirstOrder "First order transfer function block (= 1 pole, allows Tau = 0 and a gain)"

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




  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real k(unit="1")=1 "Gain";
  parameter Modelica.Units.SI.Time Tau=0 "Time Constant, set Tau=0 for no signal smoothing";
  parameter Integer initOption = 1 "Initialisation option" annotation(choices(choice=1 "y = u", choice=2 "y = y_start", choice=3 "der(y) = 0",
                                                                                            choice=4 "no init"));
  parameter Real y_start=1 "Start value at output" annotation(Dialog(enable = Tau>0 and initOption==2),Evaluate=evaluate_y_start);
  parameter Boolean evaluate_y_start = false "true for Evaluate=true for y_start";
protected
  Real y_aux(stateSelect=if Tau==0 then StateSelect.never else StateSelect.always);
initial equation
  if Tau < Modelica.Constants.eps then
    // do nothing because no initialization is necessary
  elseif initOption == 1 then // y= u
    y_aux = u;
  elseif initOption == 2 then // y = y_start
    y_aux=y_start;
  elseif initOption == 3 and Tau>0 then // der(y) = 0
    der(y_aux)=0;
  elseif initOption == 4 then // no init
    y_aux=0;
  else
    assert(false, "Unknown init option in component " + getInstanceName());
   end if;
equation
  if Tau < Modelica.Constants.eps then
    y=k*u;
    y_aux=0;
  else
    der(y_aux) = (k*u - y_aux)/Tau;
    y=y_aux;
  end if;
  annotation (
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>First order block that allows Tau=0 and has a gain implemented.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model was copied from ClaRa.Components.Utilities.Blocks.FirstOrderClaRa of ClaRa version 1.3.0 and y_aux was eliminated as a state for the case Tau=0. Also a gain was added, as done in Modelica.Blocks.Continuous.FirstOrder.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>u: input</p>
<p>y: output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p><span style=\"font-family: Courier New;\">evaluate_y_start = true </span>might help avoiding circular equalities.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
<p>Model modified by Carsten Bode (c.bode@tuhh.de), Feb 2021 (added parameter <span style=\"font-family: Courier New;\">evaluate_y_start</span>)</p>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,78},{-80,-90}}, color={221,222,223}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,88},{-80,90}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={221,222,223}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-70,-45.11},{-60,-19.58},{-50,-0.9087},{-40,
              12.75},{-30,22.75},{-20,30.06},{-10,35.41},{0,39.33},{10,42.19},
              {20,44.29},{30,45.82},{40,46.94},{50,47.76},{60,48.36},{70,48.8},
              {80,49.12}}, color={27,36,42}),
        Text(
          extent={{0,0},{60,-60}},
          lineColor={221,222,223},
          textString="PT1"),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="T=%T")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
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
end FirstOrder;
