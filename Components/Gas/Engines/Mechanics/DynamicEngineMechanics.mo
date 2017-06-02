within TransiEnt.Components.Gas.Engines.Mechanics;
model DynamicEngineMechanics
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
  extends TransiEnt.Components.Gas.Engines.Mechanics.BasicEngineMechanics;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Modelica.SIunits.Pressure p_me_n=Specification.P_el_max/Specification.omega_n/Specification.engineDisplacement*4*Modelica.Constants.pi/Specification.n_cylinder "Nominal mean effective pressure at P_max";
  final parameter Modelica.SIunits.Pressure p_mf_n=(1/Specification.eta_m - 1)*p_me_n "Nominal friction mean effective pressure at P_max";
  final parameter Modelica.SIunits.Velocity c_m=Specification.n_n*Specification.pistonStroke/30;

  // _____________________________________________
  //
  //            Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Temp_C theta_cylinder_opt=145 "Optimal temperature of cylinder";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_iron=490 "TILMedia steel";
  parameter Modelica.SIunits.Temperature T_site=290 "Average outside temperature at plant site"
    annotation (Dialog(group="Stanby losses"));

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  Modelica.SIunits.Temperature T_cylinderWall "Temperature of cylinder wall";
  Modelica.SIunits.Temperature T_innerEngine = TemperaturesIn[2];
  Modelica.SIunits.Temperature T_outerEngine = TemperaturesIn[1];
  Real eta_start;
  // Boolean use_eta_start(start=true);
  Modelica.SIunits.Pressure p_me "Mean effective pressure";
  Modelica.SIunits.Pressure p_mf "Friction mean effective pressure";

  Modelica.Blocks.Logical.Switch ignition
    annotation (Placement(transformation(extent={{-58,43},{-46,55}})));
  Modelica.Blocks.Continuous.SecondOrder secondOrder(w=Specification.reactionTime, D=
        Specification.damping)
    annotation (Placement(transformation(extent={{-34,37},{-10,62}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(
    uMax=Specification.P_el_max,
    limitsAtInit=true,
    uMin=0)
    annotation (Placement(transformation(extent={{-10,-10.5},{10,10.5}},
        rotation=0,
        origin={12,49.5})));
  Modelica.Blocks.Logical.Switch clutch
    annotation (Placement(transformation(extent={{34,11},{46,23}})));
  Modelica.Blocks.MathBoolean.OnDelay onDelay(delayTime=Specification.syncTime)
      annotation (Placement(transformation(extent={{-50,10},{-36,24}})));
  Modelica.Blocks.Sources.Constant zero(k=0)
    annotation (Placement(transformation(extent={{-5,-5},{5,5}},
          rotation=90,
          origin={-29,-21})));
  TransiEnt.Components.Boundaries.Mechanical.Power mechanicalPower(change_sign=true) annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=0,
        origin={64,0})));

  Modelica.Blocks.Continuous.SecondOrder secondOrder1(w=1, D=1)
    annotation (Placement(transformation(extent={{54,49},{78,74}})));
equation
if switch then
  //Engine State
    p_me = clutch.u1/Specification.omega_n/Specification.engineDisplacement*4*Modelica.Constants.pi/Specification.n_cylinder;
    //Calculate cylinder wall temperature according to Fischer.
    //T_cylinderWall = max(T_innerEngine + (0.01575 - 0.00013*(T_outerEngine -273.15))*Specification.n_n + 1e-5*p_me*4.6, T_site);
    //According to Schwarzmeier:
    T_cylinderWall=max(theta_cylinder_opt + 1.5*(p_me-p_me_n)/10^5 + 0.8*(T_innerEngine-Specification.T_opt) + 273.15, 290);
    p_mf = p_mf_n
    + (44/Specification.n_cylinder*(c_m/(T_cylinderWall - 273.15)^1.66-c_m/(theta_cylinder_opt)^1.66)
    + 31/10^5*(p_me/10^5/(T_cylinderWall- 273.15)^1.66 - p_me_n/10^5/(theta_cylinder_opt)^1.66)
    + 22e-3/Specification.n_cylinder*(Specification.pistonDiameter*Specification.n_n)^2*(1/(T_innerEngine - 273.15)^1.49-1/(Specification.T_opt-273.15)^1.49)
    + 6e-3*(1+0.0012*c_m)*((p_me/10^5)^1.35-(p_me_n/10^5)^1.35)
    + 1.9*(p_me/10^5/(T_innerEngine - 273.15)^1.49 - p_me_n/10^5/(Specification.T_opt-273.15)^1.49))*10^5;

    //Efficiencies
    eta_start =min(1,(clutch.u1/P_el_set)*p_mf_n/p_mf);
    eta_h = (1 + (1 - Specification.eta_m)*(1-eta_start))*efficiencyFunction(
      P_el_set,
      {Specification.P_el_max,Specification.P_el_min},
      {Specification.eta_h_min,Specification.eta_h_max});
    eta_el = (Specification.eta_m + (1 - Specification.eta_m)*eta_start)*efficiencyFunction(
      P_el_set,
      {Specification.P_el_max,Specification.P_el_min},
      {Specification.eta_el_max,Specification.eta_el_min});

else
  //efficiencies set to 1e-10 > 0 for numerical reasons

    p_me = 1e-10;
    T_cylinderWall = T_innerEngine;
    p_mf = 1e-10;

    //Efficiencies
    eta_h = 1e-10;
    eta_el = 1e-10;
    eta_start = 1e-10;
end if;

  connect(ignition.y, secondOrder.u) annotation (Line(
      points={{-45.4,49},{-41.7,49},{-41.7,49.5},{-36.4,49.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(secondOrder.y, limiter.u) annotation (Line(
      points={{-8.8,49.5},{0,49.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limiter.y, clutch.u1) annotation (Line(
      points={{23,49.5},{28,49.5},{28,21.8},{32.8,21.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(clutch.u2, onDelay.y) annotation (Line(
      points={{32.8,17},{-34.6,17}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(switch, onDelay.u) annotation (Line(
      points={{-108,-60},{-86,-60},{-86,17},{-52.8,17}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(ignition.u2, onDelay.u) annotation (Line(
      points={{-59.2,49},{-70,49},{-70,17},{-52.8,17}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(clutch.u3, zero.y) annotation (Line(
      points={{32.8,12.2},{20,12.2},{20,-12},{-30,-12},{-30,-16},{-30,
          -16},{-30,-15.5},{-29,-15.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ignition.u3, zero.y) annotation (Line(
      points={{-59.2,44.2},{-62,44.2},{-62,-10},{-28,-10},{-28,-15.5},{
          -29,-15.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mpp, mechanicalPower.mpp) annotation (Line(
      points={{100,-2},{88,-2},{88,0},{76,0}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(P_el_set, ignition.u1) annotation (Line(
      points={{-108,-10},{-83,-10},{-83,53.8},{-59.2,53.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(clutch.y, secondOrder1.u) annotation (Line(
      points={{46.6,17},{50,17},{50,61.5},{51.6,61.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mechanicalPower.P_mech_set, secondOrder1.y)
    annotation (Line(
      points={{64,14.16},{86,14.16},{86,61.5},{79.2,61.5}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple model for the mechanical behaviour of an engine to supply a targeted mechanical power output.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Based on the staticEngineMechanics model a 2nd-order transfer function has been added to take the dynamical behaviour of the engine into account.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>switch - boolean input to switch the engine on/off</p>
<p>P_el - target mechanical power input</p>
<p>efficienciesOut[2] - ouput connector for electrical [1] and overall [2] efficiency of the engine</p>
<p>temperaturesIn[2] - input connector for temperature levels in the engine (as the efficiencies in the more complex models are calculated based on temperature-dependent empirical equations)</p>
<p>mpp - port for mechanical power output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The electrical and overall efficiencies are calculated based on a linear interpolation approach between minimum and maximum power output, as can be seen in the following picture</p>
<p><img src=\"modelica://TransiEnt/Images/interpolation_eta.png\"/></p>
<p>The 2nd-order transfer function, describing the mechanical inertia of the engine can be adapted via the parameters damping and angular frequency.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>This model has been parametrised and validated as part of the overall CHP-model (DACHS HKA G5.5).</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Apr 2014</p>
<p>Edited by Jan Braune (jan.braune@tuhh.de), Mar 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2015</p>
</html>"));
end DynamicEngineMechanics;
