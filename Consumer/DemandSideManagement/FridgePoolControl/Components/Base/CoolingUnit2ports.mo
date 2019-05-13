within TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Components.Base;
model CoolingUnit2ports "Simple cooling unit model with two ports for fridge and freezer heat flow"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Power P_el_n = 80 "Nominal electric power";
  parameter Real COP = 2 "Expected value of coefficient of performance";
  parameter Real x_fridge = 0.3862 "Fraction of total cooling power needed for fridge";

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  final parameter Real x_freezer = 1-x_fridge "Fraction of total cooling power needed for freezer";

protected
  SI.Power P(start=0);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-107,50},{-87,70}}), iconTransformation(extent={{-107,50},{-87,70}})));
  Modelica.Blocks.Interfaces.BooleanInput q
   annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,72}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,98})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{-109,-52},{-89,-32}}), iconTransformation(extent={{-109,-52},{-89,-32}})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{49,-10},{69,10}}), iconTransformation(extent={{86,-14},{113,14}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  if q then
    P=P_el_n;
  else
    P=0;
  end if;

  P*x_fridge*COP=port_a.Q_flow;
  P*x_freezer*COP=port_b.Q_flow;
  epp.P=P;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-42,44},{38,-44}},
          lineColor={0,0,0}),
        Polygon(
          points={{-52,12},{-48,12},{-34,12},{-42,0},{-34,-10},{-52,-10},{-42,0},{-52,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,52},{16,36}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-36},{18,-52}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{26,14},{52,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{30,-6},{38,14},{48,-6}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,26},{-24,-20},{24,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,-18},{-20,-10},{-8,8},{-6,10},{2,16},{12,20},{20,20}},
          color={0,0,255},
          smooth=Smooth.None)}),    Diagram(graphics,
                                            coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple&nbsp;cooling&nbsp;unit&nbsp;model&nbsp;with&nbsp;two&nbsp;ports&nbsp;for&nbsp;fridge&nbsp;and&nbsp;freezer&nbsp;heat&nbsp;flow. </span>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>port_a - Heat Port 1</p>
<p>port_b - Heat Port 2</p>
<p>q - boolean (on/off) signal</p>
<p>epp - Electric Power Port</p>
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
end CoolingUnit2ports;
