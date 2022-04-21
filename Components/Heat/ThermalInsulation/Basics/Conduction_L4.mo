within TransiEnt.Components.Heat.ThermalInsulation.Basics;
model Conduction_L4 "Thermal element for static heat conduction"



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
  parameter ClaRa.Basics.Units.Length width=1 "Width of plate"     annotation(Dialog(group="Geometry"));

  parameter Integer N_ax = 1;

  replaceable model Material = TILMedia.SolidTypes.TILMedia_Aluminum constrainedby TILMedia.SolidTypes.BaseSolid "Material of the cylinder"
                                                                                              annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Length d = 1 "Thickness of plate"     annotation(Dialog(group="Geometry"));

protected
   TILMedia.Solid solid[N_ax](redeclare replaceable model SolidType = Material, T=(solid_1.T+solid_2.T)/2) annotation (Placement(transformation(extent={{48,8},{68,28}})));

protected
  final parameter ClaRa.Basics.Units.Length Delta_x[N_ax]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length,
      N_ax) "Discretisation scheme" annotation (Dialog(group="Discretisation"));

   final parameter ClaRa.Basics.Units.Area A_heat[N_ax]={Delta_x[i]*width for i in 1:N_ax} "Area for heat transfer";

  ClaRa.Basics.Units.CoefficientOfHeatTransfer k[N_ax] "solid heat transfer coefficient in [W/m2K] (=lambda/d)";

public
  ClaRa.Basics.Interfaces.HeatPort_a[N_ax] solid_1 annotation (Placement(transformation(extent={{
            -110,-10},{-90,10}})));
  ClaRa.Basics.Interfaces.HeatPort_b[N_ax] solid_2 annotation (Placement(transformation(extent={{
            90,-10},{110,10}})));

equation

  k = solid.lambda./d;

  solid_1.Q_flow + solid_2.Q_flow = zeros(N_ax);

  solid_1.Q_flow = k.*A_heat.*(solid_1.T - solid_2.T);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-90,70},{90,-70}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-90,70},{-90,-70}},
          thickness=0.5),
        Line(
          points={{90,70},{90,-70}},
          thickness=0.5),
        Text(
          extent={{-150,115},{150,75}},
          textString="%name",
          lineColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Line(
          points={{-80,0},{80,0}},
          color={255,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-100,-20},{100,-40}},
          lineColor={255,0,0},
          textString="Q_flow"),
        Text(
          extent={{-100,58},{100,38}},
          lineColor={0,0,0},
          textString="dT = port_a.T - port_b.T")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model for transport of heat without storing it; see also: ThermalResistor. It may be used for complicated geometries where the thermal conductance G (= inverse of thermal resistance) is determined by measurements and is assumed to be constant over the range of operations.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>If the component consists mainly of one type of material and a regular geometry, it may be calculated, e.g., with one of the following equations: </p>
<ul>
<li>Conductance for a <b>box</b> geometry under the assumption that heat flows along the box length: </li>
<p><span style=\"font-family: Courier New;\">G = k*A/L</span></p>
<p><span style=\"font-family: Courier New;\">k: Thermal conductivity (material constant)</span></p>
<p><span style=\"font-family: Courier New;\">A: Area of box</span></p>
<p><span style=\"font-family: Courier New;\">L: Length of box</span></p>
<li>Conductance for a <b>cylindrical</b> geometry under the assumption that heat flows from the inside to the outside radius of the cylinder: </li>
</ul>
<p><span style=\"font-family: Courier New;\">G = 2*pi*k*L/log(r_out/r_in)</span></p>
<p><span style=\"font-family: Courier New;\">pi : Modelica.Constants.pi</span></p>
<p><span style=\"font-family: Courier New;\">k : Thermal conductivity (material constant)</span></p>
<p><span style=\"font-family: Courier New;\">L : Length of cylinder</span></p>
<p><span style=\"font-family: Courier New;\">log : Modelica.Math.log;</span></p>
<p><span style=\"font-family: Courier New;\">r_out: Outer radius of cylinder</span></p>
<p><span style=\"font-family: Courier New;\">r_in : Inner radius of cylinder</span></p>
<p><span style=\"font-family: Courier New;\">Typical values for k at 20 degC in W/(m.K):</span></p>
<p><span style=\"font-family: Courier New;\">aluminium 220</span></p>
<p><span style=\"font-family: Courier New;\">concrete 1</span></p>
<p><span style=\"font-family: Courier New;\">copper 384</span></p>
<p><span style=\"font-family: Courier New;\">iron 74</span></p>
<p><span style=\"font-family: Courier New;\">silver 407</span></p>
<p><span style=\"font-family: Courier New;\">steel 45 .. 15 (V2A)</span></p>
<p><span style=\"font-family: Courier New;\">wood 0.1 ... 0.2</span></p>
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
</html>"));
end Conduction_L4;
