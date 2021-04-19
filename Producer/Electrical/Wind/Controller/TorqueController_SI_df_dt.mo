within TransiEnt.Producer.Electrical.Wind.Controller;
model TorqueController_SI_df_dt "Torque controller for WTG with df/dt Synthetic Inertia"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
  //             Parameters
  // _____________________________________________
  parameter Boolean limitsAtInit = true "= false, if limits are ignored during initialization";
  parameter Boolean strict=false "= true, if strict limits with noEvent(..)"
    annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="Advanced"));
  parameter Modelica.Blocks.Types.SimpleController controllerType_T=.Modelica.Blocks.Types.SimpleController.PI "Type of controller"
                                                                                                    annotation (Dialog(tab="Controller", group="Torque"),choicesAllMatching=true);
 // parameter Real k_T=1e6 "Gain of controller" annotation (Dialog(tab="Controller", group="Torque"));
 // parameter Real Ti_T=1 "Time constant of controller" annotation (Dialog(tab="Controller", group="Torque"));
 // parameter Real yMax_T=2*T_nom "Upper limit of PI controlled beta setpoint" annotation (Dialog(tab="Controller", group="Torque"));
 // parameter Real yMin_T=-2*T_nom "Lower limit of output" annotation (Dialog(tab="Controller", group="Torque"));
 // parameter SI.Torque T_nom = 1.92 "Nominal torque of turbine";
  parameter Real k_turbine "Turbine control constant";
  parameter Real J "Wind turbine moment of inertia";
  parameter Real lambdaOpt "Optimal tip speed ratio";
  parameter Modelica.SIunits.Density rho "Density";
  parameter Modelica.SIunits.Length radius "Rotor Radius";
  parameter Real cp_opt "Optimal capacity factor";
  parameter SI.Torque tau_n;
  parameter SI.Torque tau_start=K_start*tau_n "Start value of torque";
  parameter Real K_start=-0.05 "Factor of torque at startup in pu";
  parameter SI.Time T_torqueControl=1 "Time Constant";
  parameter SI.Velocity v_cutIn "Cutin wind speed";
  parameter SI.Velocity v_fullLoad "Nominal wind speed";

  // _____________________________________________
  //
  //             Variables
  // _____________________________________________

  input SI.Velocity v_wind "Wind velocity" annotation(Dialog);
  Real tau_set_pu;

  Modelica.Blocks.Logical.Hysteresis torqueControllerDisabled annotation (Placement(transformation(extent={{-22,6},{-8,20}})));
  Modelica.Blocks.Logical.Switch tau_set
    annotation (Placement(transformation(extent={{40,-22},{60,-2}})));

  TransiEnt.Basics.Interfaces.General.AngularVelocityIn omega_is "Input for angular velocity" annotation (Placement(
        transformation(rotation=0, extent={{-104,-82},{-84,-62}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(rotation=0, extent={{94,-10},{114,10}})));
  Modelica.Blocks.Sources.RealExpression tau_set_partload(y=omega_is^2*k_turbine)
    annotation (Placement(transformation(extent={{-84,-24},{-32,8}})));
  Modelica.Blocks.Math.MultiSum tau_modulated(nu=2)
    annotation (Placement(transformation(extent={{2,-30},{22,-10}})));
  Modelica.Blocks.Sources.RealExpression tau_inertia(y=-2*H_e*der_f_grid*0.1*tau_n) annotation (Placement(transformation(extent={{-94,-68},{-42,-36}})));
  Modelica.Blocks.Interfaces.RealInput der_f_grid annotation (Placement(
        transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-40,102})));
  Real H_e "Effective inertia";

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_pu annotation (Placement(
        transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={40,102})));
  Modelica.Blocks.Sources.RealExpression v_wind_is1(y=v_wind/v_fullLoad)
                                                             annotation (Placement(transformation(extent={{-70,14},{-54,34}})));

  Modelica.Blocks.Math.Min tau_inertia_set
    annotation (Placement(transformation(extent={{-22,-68},{-2,-48}})));
  Modelica.Blocks.Sources.RealExpression tau_inertia_max(y=0.1*tau_n) annotation (Placement(transformation(extent={{-86,-98},{-34,-66}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(
    strict=strict,
    limitsAtInit=limitsAtInit,
    uMin=0,
    uMax=1e8) annotation (Placement(transformation(extent={{8,-68},{28,-48}},
          rotation=0)));
  Modelica.Blocks.Sources.RealExpression v_wind_is2(y=v_wind/v_cutIn)
                                                             annotation (Placement(transformation(extent={{-10,46},{6,66}})));
  Modelica.Blocks.Logical.Hysteresis torqueControllerDisabled1(
                                                              uLow=0.98,
      uHigh=1.02)                                             annotation (Placement(transformation(extent={{16,48},{30,62}})));
  Modelica.Blocks.Math.Gain tau_friction(k=K_start)          annotation (Placement(transformation(extent={{24,72},{36,84}})));
  Modelica.Blocks.Sources.RealExpression tau_n_set(y=tau_n) annotation (Placement(transformation(extent={{-80,64},{-50,90}})));
  Modelica.Blocks.Logical.Switch tau_set2
    annotation (Placement(transformation(extent={{74,6},{86,-6}})));
equation
  // _____________________________________________
  //
  //             Equations
  // _____________________________________________

  H_e=J*lambdaOpt^3/(rho*Modelica.Constants.pi*radius^5*cp_opt*omega_is);
  tau_set_pu =tau_set.y/tau_n;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(torqueControllerDisabled.y, tau_set.u2) annotation (Line(points={{-7.3,13},{27.35,13},{27.35,-12},{38,-12}}, color={255,0,255}));
  connect(tau_set_partload.y, tau_modulated.u[1]) annotation (Line(points={{-29.4,-8},{-20,-8},{-20,-16},{-10,-16},{-10,-16},{2,-16},{2,-16.5}}, color={0,0,127}));
  connect(v_wind_is1.y, torqueControllerDisabled.u) annotation (Line(points={{-53.2,24},{-44,24},{-44,13},{-23.4,13}},
                                           color={0,0,127}));
  connect(tau_inertia.y, tau_inertia_set.u1) annotation (Line(points={{-39.4,-52},{-24,-52}}, color={0,0,127}));
  connect(tau_modulated.y, tau_set.u3) annotation (Line(points={{23.7,-20},{38,-20}}, color={0,0,127}));
  connect(tau_inertia_max.y, tau_inertia_set.u2) annotation (Line(points={{-31.4,-82},{-26,-82},{-26,-64},{-24,-64}}, color={0,0,127}));
  connect(tau_inertia_set.y, limiter.u) annotation (Line(points={{-1,-58},{6,-58}}, color={0,0,127}));
  connect(limiter.y, tau_modulated.u[2]) annotation (Line(points={{29,-58},{40,-58},{40,-36},{-6,-36},{-6,-23.5},{2,-23.5}}, color={0,0,127}));
  connect(v_wind_is2.y,torqueControllerDisabled1. u) annotation (Line(points={{6.8,56},{14.6,56},{14.6,55}},  color={0,0,127}));
  connect(torqueControllerDisabled1.y, tau_set2.u2) annotation (Line(points={{30.7,55},{68,55},{68,0},{72.8,0}}, color={255,0,255}));
  connect(tau_set2.u3, tau_friction.y) annotation (Line(points={{72.8,4.8},{74,4.8},{74,78},{36.6,78}}, color={0,0,127}));
  connect(tau_n_set.y, tau_friction.u) annotation (Line(points={{-48.5,77},{22.8,77},{22.8,78}}, color={0,0,127}));
  connect(tau_set2.y, y) annotation (Line(points={{86.6,0},{104,0},{104,0}}, color={0,0,127}));
  connect(tau_set.y, tau_set2.u1) annotation (Line(points={{61,-12},{66,-12},{66,-4.8},{72.8,-4.8}}, color={0,0,127}));
  connect(tau_set.u1, tau_n_set.y) annotation (Line(points={{38,-4},{32,-4},{32,42},{-36,42},{-36,77},{-48.5,77}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), experiment(StopTime=250000,
        __Dymola_NumberOfIntervals=100000),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Torque Controller with synthetic Inertia control depending on the rate of change of frequency (df/dt).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quasistationary model for real power simulation only.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">y: Modelica RealOutput</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">omega_is: input for angular velocity in rad/s</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">der_f_grid: input for the derivation of the frequency </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_pu: input for electric power in W</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">H_e is the effective inertia</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Validated according to reference stated below.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Wu, Lei: &quot;Towards an Assessment of Power System Frequency Support From Wind Pland - Modeling Aggregate Inertial Response&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on June 21 2016</span></p>
</html>"));
end TorqueController_SI_df_dt;
