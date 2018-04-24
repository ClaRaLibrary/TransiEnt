within TransiEnt.Components.Boundaries.Ambient;
model UndergroundTemperature "Gives the underground temperature at specified depth and time as a cosinal characteristic"

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

  import TransiEnt;
  import Const = Modelica.Constants;
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________
  replaceable model Material = TransiEnt.Basics.Media.Solids.GravelStonesSandDry constrainedby TILMedia.SolidTypes.BaseSolid "Material in the ground" annotation(choicesAllMatching);
  parameter SI.Temperature T_amb_avg = simCenter.T_amb_const "Annual average ambient temperature";
  parameter SI.TemperatureDifference dT_amb_month = 8.6025 "Ambient temperature amplitude of monthly averages";
  parameter SI.Height z = 1 "Depth below ground";
  parameter SI.Time t_0 = 366*24*3600 "Oscillation period in seconds (one year)";
  parameter SI.Time t_Tmax = 5557*3600 "Second of the year when maximal temperature occurs";
  final parameter SI.Angle phi_0 = 2*Const.pi*t_Tmax/t_0 "Phase displacement of maximal temperature";
protected
  parameter SI.ThermalDiffusivity a = solid.lambda_nominal/solid.cp_nominal/solid.d "Thermal diffusivity of the soil";
  parameter Real zeta=z*sqrt(Const.pi/a/t_0);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
public
  Modelica.Blocks.Interfaces.RealOutput T_underground(
    final quantity="Temperature",
    final unit="K",
    displayUnit="degC") "Temperature in the ground at given depth and simulated time" annotation (Placement(transformation(extent={{84,-10},{104,10}})));

  // _____________________________________________
  //
  //         Instances of other Classes
  // _____________________________________________
protected
   TILMedia.Solid solid(redeclare each replaceable model SolidType = Material, T=T_amb_avg)
     annotation (Placement(transformation(extent={{58,18},{78,38}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  T_underground=T_amb_avg+dT_amb_month*exp(-zeta)*cos(2*Const.pi*time/t_0-phi_0-zeta);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-20,-98},{20,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,40},{12,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,40},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,80},{12,40},{-12,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(points={{-40,60},{-12,60}}, color={0,0,0}),
        Line(points={{-40,20},{-12,20}}, color={0,0,0}),
        Line(points={{-40,-20},{-12,-20}}, color={0,0,0}),
        Line(points={{12,-10},{60,-10}},
                                     color={0,0,127}),
        Line(
          points={{-100,100},{100,100}},
          color={95,95,95},
          thickness=0.5),
        Line(
          points={{-70,100},{-70,60}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-52,58},{-70,72}},
          lineColor={0,0,0},
          textString="z")}),                                     Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Gives the underground temperature at the specified depth and simulated time as a sinusoidally oscillation with an oscillating period of one year.</span></p>
<p><img src=\"modelica://TransiEnt/Images/TestUndergroundTemperature.png\"/></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>As stated in [1] the underground temperature is not effected by hourly up to couple of days fluctuations of the ambient temperature. Therefore, the annual course of the ambient temperature can be approximated as a sinusoidally temperature oscillation, which describes the course of the monthly average temperatures very well (s. eq. (2)). The non disturbed underground temperature in the specified depth followes the ambient temperature with time delay. For the temperature boundary condition of 3rd kind Grigull and Sandner [2] derived eq. (2) with the help of the Laplace transformation.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>Equation (2) is only valid for heat transfer coefficients towards infinity at the earth&apos;s surface. The full equation with heat transfer coefficient can be found in [1] where it is also shown that the impact of the heat transfer coefficient is negligible.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Real output of underground temperature in K.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">T_amb_avg: Annual average temperature</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">dT_amb_month: Amplitude of annual monthly averaged temperature course</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">t_0: Oscillation period (one year in seconds)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">t_Tmax: Second of the year when maximal temperature occurs</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">z: Depth at which T_underground is calculated</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Sinusoidally ambient temperature of monthly means (z=0):</span></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-dCbiPhLv.png\" alt=\"T_ground = T_amb_avg + dT_amb_month*cos(2*pi*t/t_0-phi_0)\"/> (1)</p>
<p>with the phase displacement of the maximal temperature compared to the beginning of the year</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-x0MWXRo8.png\" alt=\"phi_0=2*pi*t_Tmax/t_0\"/>.</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Sinusoidally</span> underground temperature as function of z and t:</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-76FKWOfY.png\" alt=\"T_underground = T_amb_avg + dT_amb_month*exp(-zeta)*cos(2*pi*t/t_0-phi_0-zeta)\"/> (2)</p>
<p>with <img src=\"modelica://TransiEnt/Images/equations/equation-QJt2Bd2c.png\" alt=\"zeta\"/> taking into account the depth in the underground, the soil transport characteristics and the oscillation period:</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-Ue70Lr0l.png\" alt=\"zeta=z*sqrt(pi/(a_soil*t_0))\"/></p>
<p>with a as thermal diffusivity defined as</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-TVCmUKlI.png\" alt=\"a_soil=lambda_soil/(rho_soil*cp_soil)\"/>.</p>
<p>Find transport characteristica of different soil material in [3].</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>The oscillation period of the temperature is normally one year. Be sure to change the soil transport characteritica according to the depth.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>[1] Ramming, Klaus: <i>Bewertung und Optimierung oberfl&auml;chennaher Erdw&auml;rmekollektoren f&uuml;r verschiedene Lastf&auml;lle</i>, Technical University Dresden, 2007</p>
<p>[2] Grigull, Ulrich ; Sandner, Heinrich: <i>W&auml;rmeleitung</i>, <i>W&auml;rme- und Stoff&uuml;bertragung</i>. Berlin, Heidelberg&nbsp;: Springer Berlin Heidelberg, 1990 &mdash;&nbsp;ISBN&nbsp;978-3-540-52315-4</p>
<p>[3] VDI 4640 Blatt 1: Thermische Nutzung des Untergrunds - Grundlagen, Genehmigungen, Umweltaspekte. In: <i>Verein Deutscher Ingenieure e.V.</i> D&uuml;sseldorf (2010)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Lisa Andresen (andresen@tuhh.de), Dec 2016</span></p>
</html>"));
end UndergroundTemperature;
