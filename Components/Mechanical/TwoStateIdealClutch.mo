within TransiEnt.Components.Mechanical;
model TwoStateIdealClutch "1D-rotational clutch"


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




  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp_a "Left flange of shaft" annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0), iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp_b "Right flange of shaft" annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0), iconTransformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.BooleanInput isRunning "Virtual disconnection (only for statistics component)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120}), iconTransformation(
        extent={{-13,-13},{13,13}},
        rotation=270,
        origin={-1,87})));

equation
  // _____________________________________________
  //
  //               Characteristic Equations
  // _____________________________________________

  0 = mpp_a.tau + mpp_b.tau;

  if noEvent(isRunning) then
    mpp_a.phi = mpp_b.phi;
  else
    mpp_a.tau = 0;
  end if;

  annotation (
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Ideal clutch which closes if is_running is true.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>mpp_a: mechanical power port</p>
<p>mpp_b: mechanical power port</p>
<p>isRunning: BooleanInput</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Carsten Bode (c.bode@tuhh.de) in Jan 21</span></p>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Line(points={{0,83},{90,63},{90,33},{30,33}}, color={0,0,0}),
        Polygon(
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid,
          points={{48,33},{78,43},{78,23},{48,33}},
          lineColor={0,0,0}),
        Line(points={{-6,82},{-96,62},{-96,32},{-36,32}}, color={0,0,0}),
        Rectangle(
          extent={{-100,10},{-50,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{50,10},{100,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Line(points={{-80,-25},{-60,-25}}, color={0,0,0}),
        Line(points={{60,-25},{80,-25}}, color={0,0,0}),
        Line(points={{-70,-25},{-70,-70}}, color={0,0,0}),
        Line(points={{70,-25},{70,-70}}, color={0,0,0}),
        Line(points={{-70,-70},{70,-70}}, color={0,0,0}),
        Rectangle(
          extent={{-50,50},{50,-50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Text(
          extent={{-151,-130},{149,-170}},
          lineColor={0,0,0},
          textString="J=%J"),
        Rectangle(
          extent={{20,50},{40,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid,
          points={{-49,32},{-79,42},{-79,22},{-49,32}},
          lineColor={0,0,0})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics));
end TwoStateIdealClutch;
