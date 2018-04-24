within TransiEnt.Producer.Electrical.Wind.Controller;
model TorqueController_SI_deltaF "Torque controller for WTG with delta_f Synthetic Inertia"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  //             Parameters
  // _____________________________________________
  parameter Boolean limitsAtInit = true "= false, if limits are ignored during initialization";
  parameter Boolean strict=false "= true, if strict limits with noEvent(..)"
    annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="Advanced"));
  parameter Modelica.Blocks.Types.SimpleController controllerType_T=.Modelica.Blocks.Types.SimpleController.PI "Type of controller"
                                                                                                    annotation (Dialog(tab="Controller", group="Torque"),choicesAllMatching=true);
  parameter Real k_T=1e6 "Gain of controller" annotation (Dialog(tab="Controller", group="Torque"));
  parameter Real Ti_T=1 "Time constant of controller" annotation (Dialog(tab="Controller", group="Torque"));
 // parameter Real yMax_T=2*T_nom "Upper limit of PI controlled beta setpoint" annotation (Dialog(tab="Controller", group="Torque"));
 // parameter Real yMin_T=-2*T_nom "Lower limit of output" annotation (Dialog(tab="Controller", group="Torque"));
 // parameter SI.Torque T_nom "Nominal torque of turbine";
  parameter Real k_turbine "Turbine control constant";
  parameter Real J "Wind turbine moment of inertia";
  parameter Real lambdaOpt "Optimal tip speed ratio";
  parameter Modelica.SIunits.Density rho "Density";
  parameter Modelica.SIunits.Length radius "Rotor Radius";
  parameter Real cp_opt "Optimal capacity factor";
  parameter SI.Torque T_nom;
  parameter SI.Torque T_start=K_start*T_nom "Start value of torque";
  parameter Real K_start=-0.05 "Factor of torque at startup in pu";
  parameter SI.Time T_torqueControl=1 "Time Constant";
  parameter SI.Velocity v_cutIn "Cutin wind speed";
  parameter SI.Velocity v_fullLoad "Nominal wind speed";

  // _____________________________________________
  //
  //             Variables
  // _____________________________________________

  Real T_set_pu;
  Real H_e "Effective inertia";
  input SI.Velocity v_wind "Wind velocity" annotation(Dialog);

  Modelica.Blocks.Logical.Hysteresis torqueControllerDisabled(                       uLow=
        0.98, uHigh=1.02)                                     annotation (Placement(transformation(extent={{-10,16},{4,30}})));
  Modelica.Blocks.Logical.Switch T_set
    annotation (Placement(transformation(extent={{18,10},{38,30}})));

  Modelica.Blocks.Interfaces.RealInput omega_is annotation (Placement(
        transformation(rotation=0, extent={{-114,76},{-94,96}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(rotation=0, extent={{90,-10},{110,10}})));
  Modelica.Blocks.Sources.RealExpression v_wind_is(y=v_wind/v_fullLoad)
                                                             annotation (Placement(transformation(extent={{-40,14},{-24,34}})));
  Modelica.Blocks.Sources.RealExpression T_set_partload(y=omega_is^2*
        k_turbine)
    annotation (Placement(transformation(extent={{-100,-6},{-48,26}})));
  Modelica.Blocks.Math.MultiSum T_modulated(nu=2)
    annotation (Placement(transformation(extent={{-18,-4},{-4,10}})));
  Modelica.Blocks.Sources.RealExpression T_inertia(y=add_Inertia.y*0.1*T_nom)
    annotation (Placement(transformation(extent={{-100,-46},{-48,-14}})));
  Modelica.Blocks.Interfaces.RealInput freq_is annotation (Placement(
        transformation(
        rotation=90,
        extent={{-10,-10},{10,10}},
        origin={18,-102})));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=1, k=10)
    annotation (Placement(transformation(extent={{34,-84},{54,-64}})));
  Modelica.Blocks.Continuous.TransferFunction add_Inertia(b={5.5,0}, a={5.5,
        1})
    annotation (Placement(transformation(extent={{64,-84},{84,-64}})));

  Modelica.Blocks.Math.Min T_inertia_set
    annotation (Placement(transformation(extent={{-30,-46},{-10,-26}})));
  Modelica.Blocks.Sources.RealExpression T_inertia_max(y=0.125*T_nom)
    annotation (Placement(transformation(extent={{-100,-80},{-48,-48}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{-40,-18},{-30,-8}})));
  Modelica.Blocks.Logical.Switch T_set1
    annotation (Placement(transformation(extent={{32,-54},{52,-34}})));
  Modelica.Blocks.Sources.Constant no_inertia(k=0)
    annotation (Placement(transformation(extent={{-38,-90},{-18,-70}})));
  Modelica.Blocks.Nonlinear.Limiter
                           limiter1(                     strict=strict, limitsAtInit=limitsAtInit,
    uMin=0,
    uMax=2*T_nom)
    annotation (Placement(transformation(extent={{46,10},{66,30}},  rotation=
            0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(
    strict=strict,
    limitsAtInit=limitsAtInit,
    uMin=0,
    uMax=1e8) annotation (Placement(transformation(extent={{-2,-46},{18,-26}},
          rotation=0)));
  Modelica.Blocks.Sources.RealExpression v_wind_is1(y=v_wind/v_cutIn)
                                                             annotation (Placement(transformation(extent={{-8,56},{8,76}})));
  Modelica.Blocks.Logical.Hysteresis torqueControllerDisabled1(
                                                              uLow=0.98,
      uHigh=1.02)                                             annotation (Placement(transformation(extent={{18,58},{32,72}})));
  Modelica.Blocks.Logical.Switch T_set2
    annotation (Placement(transformation(extent={{80,30},{92,18}})));
  Modelica.Blocks.Math.Gain              T_friction(k=K_start)
                                                             annotation (Placement(transformation(extent={{26,82},{38,94}})));
  Modelica.Blocks.Sources.RealExpression T_nom_set(y=T_nom) annotation (Placement(transformation(extent={{-78,74},{-48,100}})));
equation
  // _____________________________________________
  //
  //             Equations
  // _____________________________________________

  H_e=J*lambdaOpt^3/(rho*Modelica.Constants.pi*radius^5*cp_opt*omega_is);
  T_set_pu=T_set.y/3.3e6*1.92;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(torqueControllerDisabled.y, T_set.u2) annotation (Line(points={{4.7,23},{10,23},{10,20},{16,20}},
                                            color={255,0,255}));
  connect(T_set_partload.y, T_modulated.u[1]) annotation (Line(points={{-45.4,10},{-18,10},{-18,5.45}},
                                color={0,0,127}));
  connect(T_modulated.y, T_set.u3) annotation (Line(points={{-2.81,3},{8,3},{8,12},{16,12}},
                                              color={0,0,127}));
  connect(firstOrder.y, add_Inertia.u)
    annotation (Line(points={{55,-74},{55,-74},{62,-74}}, color={0,0,127}));
  connect(freq_is, firstOrder.u) annotation (Line(points={{18,-102},{18,-74},
          {32,-74}},  color={0,0,127}));
  connect(v_wind_is.y, torqueControllerDisabled.u) annotation (Line(points={{-23.2,24},{-22,24},{-22,23},{-11.4,23}},
                                           color={0,0,127}));
  connect(T_inertia.y, T_inertia_set.u1) annotation (Line(points={{-45.4,-30},
          {-42,-30},{-32,-30}},           color={0,0,127}));
  connect(T_inertia_max.y, T_inertia_set.u2) annotation (Line(points={{-45.4,
          -64},{-42,-64},{-42,-42},{-32,-42}}, color={0,0,127}));
  connect(T_inertia.y, greaterThreshold.u) annotation (Line(points={{-45.4,-30},{-46,-30},{-46,-12},{-46,-13},{-41,-13}},
                                                      color={0,0,127}));
  connect(greaterThreshold.y, T_set1.u2) annotation (Line(points={{-29.5,-13},{24,-13},{24,-44},{30,-44}},
                                    color={255,0,255}));
  connect(no_inertia.y, T_set1.u3) annotation (Line(points={{-17,-80},{-12,
          -80},{-8,-80},{-8,-52},{30,-52}},          color={0,0,127}));
  connect(T_set.y, limiter1.u)
    annotation (Line(points={{39,20},{39,20},{44,20}},   color={0,0,127}));
  connect(T_set1.y, T_modulated.u[2]) annotation (Line(points={{53,-44},{60,-44},{60,-10},{-24,-10},{-24,0.55},{-18,0.55}},
                                                    color={0,0,127}));
  connect(T_inertia_set.y, limiter.u)
    annotation (Line(points={{-9,-36},{-4,-36}}, color={0,0,127}));
  connect(limiter.y, T_set1.u1) annotation (Line(points={{19,-36},{24.5,-36},
          {30,-36}}, color={0,0,127}));
  connect(v_wind_is1.y,torqueControllerDisabled1. u) annotation (Line(points={{8.8,66},{16.6,66},{16.6,65}},  color={0,0,127}));
  connect(torqueControllerDisabled1.y,T_set2. u2) annotation (Line(points={{32.7,65},{70,65},{70,24},{78.8,24}},
                                                                                                               color={255,0,255}));
  connect(T_set2.u3,T_friction. y) annotation (Line(points={{78.8,28.8},{76,28.8},{76,88},{38.6,88}},
                                                                                                    color={0,0,127}));
  connect(T_nom_set.y, T_friction.u) annotation (Line(points={{-46.5,87},{24.8,87},{24.8,88}}, color={0,0,127}));
  connect(limiter1.y, T_set2.u1) annotation (Line(points={{67,20},{74,20},{74,19.2},{78.8,19.2}}, color={0,0,127}));
  connect(T_set2.y, y) annotation (Line(points={{92.6,24},{100,24},{100,0}}, color={0,0,127}));
  connect(T_set.u1, T_nom_set.y) annotation (Line(points={{16,28},{8,28},{8,54},{-26,54},{-26,87},{-46.5,87}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), experiment(StopTime=250000,
        __Dymola_NumberOfIntervals=100000),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Torque Controller with synthetic Inertia control depending on frequency deviation (delta f).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quasistationary model for real power simulation only.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Validated according to reference stated below.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Miller, N. et al: &QUOT;GE Wind Plant Dynamic Performance for Grid and Wind Events&QUOT;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on June 21 2016</span></p>
</html>"));
end TorqueController_SI_deltaF;
