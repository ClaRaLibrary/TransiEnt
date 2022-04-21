within TransiEnt.Components.Heat.ThermalInsulation.Basics;
model Convection_L4 "Lumped thermal element for heat convection (Q_flow = Gc*dT)"



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





  parameter ClaRa.Basics.Units.Length length=1 "Length of plate"     annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length width= 1 "Width of plate"     annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.CoefficientOfHeatTransfer alpha = 10 "Signal representing the convective thermal conductance in [W/K]"    annotation (Placement(transformation(
        origin={0,100},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  parameter Integer N_ax = 1;

protected
  final parameter ClaRa.Basics.Units.Length Delta_x[N_ax]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length,
      N_ax) "Discretisation scheme" annotation (Dialog(group="Discretisation"));

   final parameter ClaRa.Basics.Units.Area A_heat[N_ax]={Delta_x[i]*width for i in 1:N_ax} "Area for heat transfer";

public
  ClaRa.Basics.Interfaces.HeatPort_a[N_ax] solid annotation (Placement(transformation(extent={{
            -110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.HeatPort_b[N_ax] fluid annotation (Placement(transformation(extent={{
            90,-10},{110,10}})));

equation

  solid.Q_flow + fluid.Q_flow = zeros(N_ax);

  solid.Q_flow = alpha.*A_heat.*(solid.T - fluid.T);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-62,80},{98,-80}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,80},{-60,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{-150,-90},{150,-130}},
          textString="%name",
          lineColor={0,0,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{-60,20},{76,20}}, color={191,0,0}),
        Line(points={{-60,-20},{76,-20}}, color={191,0,0}),
        Line(points={{-34,80},{-34,-80}}, color={0,127,255}),
        Line(points={{6,80},{6,-80}}, color={0,127,255}),
        Line(points={{40,80},{40,-80}}, color={0,127,255}),
        Line(points={{76,80},{76,-80}}, color={0,127,255}),
        Line(points={{-34,-80},{-44,-60}}, color={0,127,255}),
        Line(points={{-34,-80},{-24,-60}}, color={0,127,255}),
        Line(points={{6,-80},{-4,-60}}, color={0,127,255}),
        Line(points={{6,-80},{16,-60}}, color={0,127,255}),
        Line(points={{40,-80},{30,-60}}, color={0,127,255}),
        Line(points={{40,-80},{50,-60}}, color={0,127,255}),
        Line(points={{76,-80},{66,-60}}, color={0,127,255}),
        Line(points={{76,-80},{86,-60}}, color={0,127,255}),
        Line(points={{56,-30},{76,-20}}, color={191,0,0}),
        Line(points={{56,-10},{76,-20}}, color={191,0,0}),
        Line(points={{56,10},{76,20}}, color={191,0,0}),
        Line(points={{56,30},{76,20}}, color={191,0,0}),
        Text(
          extent={{22,124},{92,98}},
          lineColor={0,0,0},
          textString="Gc")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model of linear heat convection, e.g., the heat transfer between a plate and the surrounding air; see also: ConvectiveResistor. It may be used for complicated solid geometries and fluid flow over the solid by determining the convective thermal conductance Gc by measurements. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The basic constitutive equation for convection is </p>
<p><span style=\"font-family: Courier New;\">Q_flow = Gc*(solid.T - fluid.T);</span></p>
<p><span style=\"font-family: Courier New;\">Q_flow: Heat flow rate from connector &apos;solid&apos; (e.g., a plate)</span></p>
<p><span style=\"font-family: Courier New;\">to connector &apos;fluid&apos; (e.g., the surrounding air)</span></p>
<p>Gc = G.signal[1] is an input signal to the component, since Gc is nearly never constant in practice. For example, Gc may be a function of the speed of a cooling fan. For simple situations, Gc may be <i>calculated</i> according to </p>
<p><span style=\"font-family: Courier New;\">Gc = A*h</span></p>
<p><span style=\"font-family: Courier New;\">A: Convection area (e.g., perimeter*length of a box)</span></p>
<p><span style=\"font-family: Courier New;\">h: Heat transfer coefficient</span></p>
<p>where the heat transfer coefficient h is calculated from properties of the fluid flowing over the solid. Examples: </p>
<p><b>Machines cooled by air</b> (empirical, very rough approximation according to R. Fischer: Elektrische Maschinen, 10th edition, Hanser-Verlag 1999, p. 378): </p>
<p><span style=\"font-family: Courier New;\">h = 7.8*v^0.78 [W/(m2.K)] (forced convection)</span></p>
<p><span style=\"font-family: Courier New;\">= 12 [W/(m2.K)] (free convection)</span></p>
<p><span style=\"font-family: Courier New;\">where</span></p>
<p><span style=\"font-family: Courier New;\">v: Air velocity in [m/s]</span></p>
<p><b>Laminar</b> flow with constant velocity of a fluid along a <b>flat plate</b> where the heat flow rate from the plate to the fluid (= solid.Q_flow) is kept constant (according to J.P.Holman: Heat Transfer, 8th edition, McGraw-Hill, 1997, p.270): </p>
<p><span style=\"font-family: Courier New;\">h = Nu*k/x;</span></p>
<p><span style=\"font-family: Courier New;\">Nu = 0.453*Re^(1/2)*Pr^(1/3);</span></p>
<p><span style=\"font-family: Courier New;\">where</span></p>
<p><span style=\"font-family: Courier New;\">h : Heat transfer coefficient</span></p>
<p><span style=\"font-family: Courier New;\">Nu : = h*x/k (Nusselt number)</span></p>
<p><span style=\"font-family: Courier New;\">Re : = v*x*rho/mue (Reynolds number)</span></p>
<p><span style=\"font-family: Courier New;\">Pr : = cp*mue/k (Prandtl number)</span></p>
<p><span style=\"font-family: Courier New;\">v : Absolute velocity of fluid</span></p>
<p><span style=\"font-family: Courier New;\">x : distance from leading edge of flat plate</span></p>
<p><span style=\"font-family: Courier New;\">rho: density of fluid (material constant</span></p>
<p><span style=\"font-family: Courier New;\">mue: dynamic viscosity of fluid (material constant)</span></p>
<p><span style=\"font-family: Courier New;\">cp : specific heat capacity of fluid (material constant)</span></p>
<p><span style=\"font-family: Courier New;\">k : thermal conductivity of fluid (material constant)</span></p>
<p><span style=\"font-family: Courier New;\">and the equation for h holds, provided</span></p>
<p><span style=\"font-family: Courier New;\">Re &lt; 5e5 and 0.6 &lt; Pr &lt; 50</span> </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the Research Project &quot;Future Energy Solution&quot; (FES), 2020 </p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-90,80},{-60,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Text(
          extent={{-40,40},{80,20}},
          lineColor={255,0,0},
          textString="Q_flow"),
        Line(points={{-60,20},{76,20}}, color={191,0,0}),
        Line(points={{-60,-20},{76,-20}}, color={191,0,0}),
        Line(points={{-34,80},{-34,-80}}, color={0,127,255}),
        Line(points={{6,80},{6,-80}}, color={0,127,255}),
        Line(points={{40,80},{40,-80}}, color={0,127,255}),
        Line(points={{76,80},{76,-80}}, color={0,127,255}),
        Line(points={{-34,-80},{-44,-60}}, color={0,127,255}),
        Line(points={{-34,-80},{-24,-60}}, color={0,127,255}),
        Line(points={{6,-80},{-4,-60}}, color={0,127,255}),
        Line(points={{6,-80},{16,-60}}, color={0,127,255}),
        Line(points={{40,-80},{30,-60}}, color={0,127,255}),
        Line(points={{40,-80},{50,-60}}, color={0,127,255}),
        Line(points={{76,-80},{66,-60}}, color={0,127,255}),
        Line(points={{76,-80},{86,-60}}, color={0,127,255}),
        Line(points={{56,-30},{76,-20}}, color={191,0,0}),
        Line(points={{56,-10},{76,-20}}, color={191,0,0}),
        Line(points={{56,10},{76,20}}, color={191,0,0}),
        Line(points={{56,30},{76,20}}, color={191,0,0})}));
end Convection_L4;
