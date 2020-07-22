within TransiEnt.Producer.Electrical.Wind.Controller;
model TorqueController
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

//  parameter Modelica.Blocks.Types.SimpleController controllerType_T=.Modelica.Blocks.Types.SimpleController.PI
//    "Type of controller"                                                                                                     annotation (Dialog(tab="Controller", group="Torque"),choicesAllMatching=true);
//  parameter Real k_T=1e6 "Gain of controller" annotation (Dialog(tab="Controller", group="Torque"));
//  parameter Real Ti_T=1 "Time constant of controller" annotation (Dialog(tab="Controller", group="Torque"));
//  parameter Real yMax_T=2*T_nom "Upper limit of PI controlled beta setpoint" annotation (Dialog(tab="Controller", group="Torque"));
//  parameter Real yMin_T=-2*T_nom "Lower limit of output" annotation (Dialog(tab="Controller", group="Torque"));
//  parameter SI.Torque T_nom = 1.92 "Nominal torque of turbine";
  parameter Real k_turbine "Turbine control constant";
  parameter SI.Torque tau_n;
  parameter SI.Torque tau_start=K_start*tau_n "Start value of torque";
  parameter Real K_start=-0.05 "Factor of torque at startup in pu";
  parameter SI.Time T_torqueControl=1 "Time Constant";

  parameter Real J "Wind turbine moment of inertia";
  parameter Real lambdaOpt "Optimal tip speed ratio";
  parameter Modelica.SIunits.Density rho "Density";
  parameter Modelica.SIunits.Length radius "Rotor Radius";
  parameter Real cp_opt "Optimal capacity factor";
    parameter Boolean limitsAtInit = true "= false, if limits are ignored during initialization";
  parameter Boolean strict=false "= true, if strict limits with noEvent(..)";

  parameter SI.Velocity v_cutIn;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input SI.Velocity v_wind "Wind velocity" annotation(Dialog);

  Modelica.Blocks.Logical.Hysteresis torqueControllerDisabled(uLow=0.98,
      uHigh=1.02)                                             annotation (Placement(transformation(extent={{-56,-8},{-42,6}})));
  Modelica.Blocks.Logical.Switch tau_set
    annotation (Placement(transformation(extent={{-26,-12},{-6,8}})));

  TransiEnt.Basics.Interfaces.General.AngularVelocityIn omega_is "Input for angular velocity" annotation (Placement(
        transformation(rotation=0, extent={{-110,-70},{-90,-50}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(rotation=0, extent={{106,-10},{126,10}})));
  Modelica.Blocks.Sources.RealExpression v_wind_is(y=v_wind/wind_fullload)
                                                             annotation (Placement(transformation(extent={{-84,-10},{-68,10}})));
  Modelica.Blocks.Sources.RealExpression tau_set_partload(y=omega_is^2*k_turbine)
    annotation (Placement(transformation(extent={{-98,-48},{-46,-16}})));

  TransiEnt.Basics.Interfaces.Ambient.VelocityIn wind_fullload "Input for wind velocity at full load" annotation (Placement(
        transformation(rotation=0, extent={{-110,50},{-90,70}})));
  Modelica.Blocks.Nonlinear.Limiter
                           limiter1(
    uMax=1e8,
    strict=true,
    limitsAtInit=true,
    uMin=0)
    annotation (Placement(transformation(extent={{28,-16},{48,4}},  rotation=
            0)));
  Modelica.Blocks.Logical.Switch tau_set1
    annotation (Placement(transformation(extent={{62,6},{74,-6}})));
  Modelica.Blocks.Sources.RealExpression v_wind_is1(y=v_wind/v_cutIn)
                                                             annotation (Placement(transformation(extent={{4,8},{20,28}})));
  Modelica.Blocks.Logical.Hysteresis torqueControllerDisabled1(
                                                              uLow=0.98,
      uHigh=1.02)                                             annotation (Placement(transformation(extent={{30,10},{44,24}})));
  Modelica.Blocks.Math.Gain tau_friction(k=K_start)          annotation (Placement(transformation(extent={{38,34},{50,46}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    k=1,
    T=T_torqueControl,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=tau_start) annotation (Placement(transformation(extent={{82,-7},{96,7}})));

  Modelica.Blocks.Sources.RealExpression tau_n_set(y=tau_n) annotation (Placement(transformation(extent={{-66,26},{-36,52}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(torqueControllerDisabled.y, tau_set.u2) annotation (Line(points={{-41.3,-1},{-36,-1},{-36,-2},{-28,-2}}, color={255,0,255}));
  connect(v_wind_is.y, torqueControllerDisabled.u) annotation (Line(points={{-67.2,0},{-57.4,0},{-57.4,-1}}, color={0,0,127}));
  connect(tau_set_partload.y, tau_set.u3) annotation (Line(points={{-43.4,-32},{-34,-32},{-34,-10},{-28,-10}}, color={0,0,127}));
  connect(v_wind_is1.y, torqueControllerDisabled1.u) annotation (Line(points={{20.8,18},{28.6,18},{28.6,17}}, color={0,0,127}));
  connect(torqueControllerDisabled1.y, tau_set1.u2) annotation (Line(points={{44.7,17},{54,17},{54,0},{60.8,0}}, color={255,0,255}));
  connect(tau_set1.u1, limiter1.y) annotation (Line(points={{60.8,-4.8},{56,-4.8},{56,-6},{49,-6}}, color={0,0,127}));
  connect(tau_set1.u3, tau_friction.y) annotation (Line(points={{60.8,4.8},{58,4.8},{58,40},{50.6,40}}, color={0,0,127}));
  connect(tau_set.y, limiter1.u) annotation (Line(points={{-5,-2},{26,-2},{26,-6}}, color={0,0,127}));
  connect(tau_set1.y, firstOrder.u) annotation (Line(points={{74.6,0},{80.6,0}}, color={0,0,127}));
  connect(firstOrder.y, y) annotation (Line(points={{96.7,0},{116,0}}, color={0,0,127}));
  connect(tau_n_set.y, tau_set.u1) annotation (Line(points={{-34.5,39},{-32,39},{-32,6},{-28,6}}, color={0,0,127}));
  connect(tau_n_set.y, tau_friction.u) annotation (Line(points={{-34.5,39},{36.8,39},{36.8,40}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), experiment(StopTime=250000,
        __Dymola_NumberOfIntervals=100000),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
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
end TorqueController;
