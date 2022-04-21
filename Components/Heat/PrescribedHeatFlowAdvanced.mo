within TransiEnt.Components.Heat;
model PrescribedHeatFlowAdvanced "Prescribed heat flow boundary condition, includes exergy and variable discretization"



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

    import SI = ClaRa.Basics.Units;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Integer N_axial = 3 "Number of axial elements" annotation(Dialog(group="Discretisation"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

    outer ClaRa.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

    Modelica.Blocks.Interfaces.RealInput Q_flow
        annotation (Placement(transformation(
        origin={-100,0},
        extent={{20,-20},{-20,20}},
        rotation=180)));
  ClaRa.Basics.Interfaces.HeatPort_b port[N_axial]
                             annotation (Placement(transformation(extent={{90,
            -10},{110,10}}, rotation=0)));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real x[N_axial]= ones(N_axial) "Discretisation scheme"
                             annotation(Dialog(group="Discretisation"));

  SI.HeatFlowRate[N_axial] Q_Ex_flow "Exergy Part of Heat Flux";

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  port.Q_flow = -Q_flow.*(x/max(sum(x),1));
  Q_Ex_flow = port.Q_flow.*(ones(N_axial)-simCenter.T_amb./port.T);

     annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Line(
          points={{-60,-20},{40,-20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-60,20},{40,20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-80,0},{-60,-20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-80,0},{-60,20}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{40,0},{40,40},{70,20},{40,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-40},{40,0},{70,-20},{40,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,40},{90,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Heat flow boundary including calculation of exergy content and a non-constant discretization sheme for the heat flows. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(no remarks)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">First Version in 04.2020 for the research project Future Energy Solution (FES) by Michael von der Heyde (heyde@tuhh.de)</span> </p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),      graphics={
        Line(
          points={{-60,-20},{68,-20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-60,20},{68,20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-80,0},{-60,-20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-80,0},{-60,20}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{60,0},{60,40},{90,20},{60,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,-40},{60,0},{90,-20},{60,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}));
end PrescribedHeatFlowAdvanced;
