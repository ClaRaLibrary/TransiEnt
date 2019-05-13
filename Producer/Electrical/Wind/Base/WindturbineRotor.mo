within TransiEnt.Producer.Electrical.Wind.Base;
model WindturbineRotor
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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.BetzCoefficientApproximation turbineCharacteristics=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.MOD2() "Characteristic behaviour of betz factor" annotation (choicesAllMatching=true);
  parameter SI.Velocity v_fullLoad=12 "nominal wind speed";
  parameter Modelica.SIunits.Length D=(8*P_el_n/(Modelica.Constants.pi*rho*v_fullLoad^3*cp_opt))^0.5 "Rotor diameter";

  parameter Real beta_start = 0 "Setpoint for pitch angle";

  parameter Modelica.SIunits.Power P_el_n=3.5e6 "Rated (maximum) power";

  parameter Real lambda_small = 1e-6 "Minimum tip speed ratio";

  parameter SI.Velocity v_wind_small = simCenter.v_wind_small "Small wind velocity with neglectable power";

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

      //final parameter Modelica.SIunits.Density rho = simCenter.ambientConditions.rho_amb;
  final parameter Modelica.SIunits.Density rho = 1.225;

  final parameter Real k_turbine = cp_opt * rho * Modelica.Constants.pi * (D/2)^5 / (2 * lambda_opt^3) "machine constant";

  final parameter Real cp_opt=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.betzCoefficient(
      turbineCharacteristics,
      lambda_opt,
      0);

  final parameter Real lambda_opt = turbineCharacteristics.lambdaOpt[1,2];

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Ambient.VelocityIn v_wind  "Wind velocity"   annotation (Placement(transformation(origin={-110,0}, extent={{-10,-10},{10,10}}), iconTransformation(origin={-94,-2}, extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput beta_set(start=beta_start, final quantity= "Angle", final unit="rad", displayUnit="deg")    "Setpoint Pitch angle"                                    annotation (Placement(transformation(origin={-110,36}, extent={{-10,-10},{10,10}}), iconTransformation(
        origin={0,96},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange annotation (Placement(transformation(origin={102,0}, extent={{-10,-10},{10,10}}), iconTransformation(origin={102,0}, extent={{-10,-10},{10,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  Modelica.SIunits.Power P_wind;
  Modelica.SIunits.Power P_turbine;
    Real P_turbine_pu "Power plant per unit";
  Real cp "Power Coefficient";
  Real lambda = omega * D /2 / max(v_wind,v_wind_small);
  SI.AngularVelocity omega = der(flange.phi);
  SI.Conversions.NonSIunits.AngularVelocity_rpm n_rpm = 30/Modelica.Constants.pi*omega;

  Modelica.Blocks.Tables.CombiTable1D lambdaOpt(table=turbineCharacteristics.lambdaOpt,
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)                   annotation (Placement(transformation(extent={{-6,-10},{14,10}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  P_wind =Modelica.Constants.pi*D^2/4*rho*0.5*v_wind^3;

  P_turbine = max(P_wind * cp, 0);
  P_turbine_pu=P_turbine/P_el_n;

  cp =max(0.001, min(1, TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.betzCoefficient(
    turbineCharacteristics,
    if noEvent(lambda < lambda_small) then lambda_small else lambda,
    max(0, beta_set))));

  flange.tau * omega = -P_turbine;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(beta_set, lambdaOpt.u[1]) annotation (Line(points={{-110,36},{-88,36},{-46,36},{-46,0},{-8,0}},  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                   graphics={
        Polygon(
          points={{-6,2},{-12,-4},{-42,-22},{-46,-22},{-8,2},{-6,2}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-5,4},{-3,4},{0,10},{-3,52},{-5,48},{-5,4}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,2},{4,-4},{34,-22},{36,-22},{36,-20},{0,2},{-2,2}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-53,50},{44,-47}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot),
        Ellipse(
          extent={{-7,4},{-1,-2}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Sphere)}), Diagram(graphics,
                                                     coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
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
end WindturbineRotor;
