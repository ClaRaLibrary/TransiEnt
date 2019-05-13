within TransiEnt.Components.Mechanical;
model TwoStateInertiaWithIdealClutch "1D-rotational component with inertia. Sends zero inertia to statistics if shut down signal is true"

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

  extends TransiEnt.Components.Mechanical.Base.PartialMechanicalConnection;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________


  SI.AngularAcceleration alpha(start=0) "Absolute angular acceleration of component (= der(omega))"
    annotation (Dialog(group="Initialization", showStartAttribute=true));

  SI.Power P_rot "Power from changes in rotational energy";

 // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
   Modelica.Blocks.Interfaces.BooleanInput isRunning "Virtual disconnection (only for statistics component)"
                                                            annotation (
      Placement(transformation(
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

  alpha = der(omega);

  if noEvent(isRunning) then
  P_rot =omega*alpha*J;
    J*alpha = mpp_a.tau + mpp_b.tau;
  E_kin=J*omega^2/2;
  else
    mpp_b.tau=0;
    P_rot=0;
    E_kin=0;
  end if;

  annotation (
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Rigid mechanical shaft that can be used for simulation of grid inertia and can be disconnected by input value &apos;isRunning&apos;. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model contains moment of inertia statistics. It sends the moment of inertia specified by parameter J to the statistics component if it is connected, i.e. if isRunning=true</span></p>
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
<p>Tested in check model &quot;CheckTwoStateInertiaWithClutch&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
      Line(  points={{0,83},{90,63},{90,33},{30,33}}, color={0,0,0}),
      Polygon(
        fillColor={255,0,255},
        fillPattern=FillPattern.Solid,
        points={{48,33},{78,43},{78,23},{48,33}},
          lineColor={0,0,0}),
      Line(  points={{-6,82},{-96,62},{-96,32},{-36,32}}, color={0,0,0}),
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
end TwoStateInertiaWithIdealClutch;
