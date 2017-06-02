within TransiEnt.Basics.Blocks;
model PD
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
  extends TransiEnt.Basics.Icons.Block;

  Modelica.Blocks.Continuous.Derivative derivative(k=Td, T=Td) annotation (Placement(transformation(extent={{-8,12},{12,32}})));
  Modelica.Blocks.Math.Add PD(k2=wp)
                                    annotation (Placement(transformation(extent={{32,-4},{54,18}}, rotation=0)));
  Modelica.Blocks.Math.Gain P1(k=1 - wp)
                                        annotation (Placement(transformation(extent={{-38,12},{-18,32}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(rotation=0, extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-138,-20},{-100,18}})));
  parameter SI.Time Td=0.01 "Time constant of derivative block";
  parameter Real k=0.6 "Gain of proportional block";
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(rotation=0, extent={{100,-12},{120,8}}), iconTransformation(extent={{100,-12},{120,8}})));
  Modelica.Blocks.Math.Gain P2(k=k)     annotation (Placement(transformation(extent={{70,-12},{90,8}},   rotation=0)));
  parameter Real wp=0.6 "Weight of proportional block";
equation
  connect(P1.y, derivative.u) annotation (Line(points={{-17,22},{-14,22},{-10,22}}, color={0,0,127}));
  connect(derivative.y, PD.u1) annotation (Line(points={{13,22},{18,22},{18,13.6},{29.8,13.6}}, color={0,0,127}));
  connect(u, P1.u) annotation (Line(points={{-100,0},{-70,0},{-70,22},{-40,22}}, color={0,0,127}));
  connect(u, PD.u2) annotation (Line(points={{-100,0},{-40,0},{-40,0.4},{29.8,0.4}}, color={0,0,127}));
  connect(PD.y, P2.u) annotation (Line(points={{55.1,7},{62,7},{62,-6},{68,-6},{68,-2}}, color={0,0,127}));
  connect(P2.y, y) annotation (Line(points={{91,-2},{110,-2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
  Polygon(visible=true,
      lineColor={192,192,192},
    fillColor={192,192,192},
    fillPattern=FillPattern.Solid,
    points={{-78,90},{-86,68},{-70,68},{-78,90}}),
    Line(visible=true,
        points={{-78,78},{-78,-90}},
      color={192,192,192}),
  Line(visible = true,
    origin={-22.667,-27.333},
    points={{-55.333,93.333},{-25.333,9.333},{82.667,9.333}},
    color = {0,0,127},
    smooth = Smooth.Bezier),
  Line(visible=true,
      points={{-88,-80},{84,-80}},
    color={192,192,192}),
  Polygon(visible=true,
      lineColor={192,192,192},
    fillColor={192,192,192},
    fillPattern=FillPattern.Solid,
    points={{92,-80},{70,-72},{70,-88},{92,-80}}),
  Text(
      lineColor={192,192,192},
    extent={{-28,14},{88,60}},
          textString="PD")}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Proportional differential block without saturation or anti-windup</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised (code conventinos) by Pascal Dubucq (dubucq@tuhh.de) on 21.04.2017</span></p>
</html>"));
end PD;
