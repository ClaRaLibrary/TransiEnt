within TransiEnt.Producer.Gas.BiogasPlant.Base;
model PitchedBladeImpeller "stirrer model of a pitched blade Impeller"




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

  import TransiEnt;
  import      Modelica.Units.SI;
  import Const = Modelica.Constants;
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //        Constants and  Hidden Parameters
  // _____________________________________________

  final parameter Real k_s=11 "proportionality constant of shear Rate to speed of rotation";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Diameter d "diameter of agitator/impeller";
  parameter SI.Diameter D "diameter of StirredTankReactor";
  parameter SI.Frequency n "stirring speed as revelutions per second";
  parameter SI.Height h "height of impeller blade";
  parameter Integer Z "number of blades";
  parameter SI.Angle alpha=Const.pi/4 "pitch angle of blades";
  parameter Boolean useBaffles=false "true if baffles are used to redirect flow";

  parameter SI.Length b_S if      useBaffles "baffle width" annotation (Dialog(enable=(useBaffles)));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  input SI.Density rho "input for density of the medium" annotation (Dialog(group="Variables"));
  input SI.DynamicViscosity eta "input for efficiency of impeller" annotation (Dialog(group="Variables"));
  SI.ReynoldsNumber Re "Reynolds number in a Stirred Tank";
  Real Ne "Newton or Power number";
  SI.FroudeNumber Fr "Froude number";
  SI.Power P "Power demand of stirring";
  SI.Frequency gamma "shear rate";

  Real C1 "geometrical coefficient in Nusselt-Equation";
  Real C2 "geometrical coefficient in Nusselt-Equation";

  // _____________________________________________
  //
  //               Functions
  // _____________________________________________

  function PitchedBladeImpeller_Ne
    extends TransiEnt.Basics.Icons.Function;
    input Modelica.Units.SI.ReynoldsNumber Re;
    input Boolean useBaffles;
    output Real Ne;

  algorithm
    if useBaffles then
      if 1 < Re and Re < 24 then
        Ne := 80/Re;
      elseif 24 < Re and Re < 10^5 then
        Ne := 10/3;
      elseif Re > 10^5 then
        Ne := 10/3 "this is outside validity range";
      end if;
    else
      if 1 < Re and Re < 3.1 then
        Ne := 50/Re;
      elseif 3.1 < Re and Re < 553 then
        Ne := 4/(log(Re))^2;
      elseif 553 < Re and Re < 10^5 then
        Ne := 1/Re^0.1;
      elseif Re > 10^5 then
        Ne := 1/(10^0.5) "this is outside validity range";
      end if;
    end if;

    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"));
  end PitchedBladeImpeller_Ne;

  function PitchedBladeImpeller_C1
    extends TransiEnt.Basics.Icons.Function;
    input Modelica.Units.SI.Diameter D "Inner Diameter of CSTR";
    input Modelica.Units.SI.Diameter d "Diameter of stirrer";
    input Modelica.Units.SI.Height h "Height of stirrer blades";
    input Modelica.Units.SI.Angle alpha "Blade pitch angle";
    input Integer Z "Number of blades";
    output Real C1 "geometrical coefficient in Nusselt-Equation";
  protected
    constant Real relPos=1/3 "relative vertical position height over bottom/height of vessel";

  algorithm
    C1 := 0.54*(d/D)^(-0.25)*(h/D)^0.15*relPos^0.15*sin(alpha)^0.5*Z^0.15;
    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"));
  end PitchedBladeImpeller_C1;

  function PitchedBladeImpeller_C2
    extends TransiEnt.Basics.Icons.Function;
    input Modelica.Units.SI.Diameter D "Inner Diameter of CSTR";
    input Modelica.Units.SI.Diameter d "Diameter of stirrer";
    input Modelica.Units.SI.Height h "Height of stirrer blades";
    input Integer Z "Number of blades";
    output Real C2 "geometrical coefficient in Nusselt-Equation";
  protected
    constant Real relPos=1/3 "relative vertical position height over bottom/height of vessel";

  algorithm
    C2 := 0.825*(d/D)^(-0.25)*(h/D)^0.15*Z^0.15;
    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"));
  end PitchedBladeImpeller_C2;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
equation
  Ne = PitchedBladeImpeller_Ne(Re, useBaffles);
  C1 = PitchedBladeImpeller_C1(
    D,
    d,
    h,
    alpha,
    Z);
  C2 = PitchedBladeImpeller_C2(
    D,
    d,
    h,
    Z);
  assert(
    Re > 1 and Re < 10^5,
    "Reynolds Number outside validity range",
    AssertionLevel.warning);

  gamma = k_s*n;
  Ne = P/(rho*n^3*d^5);
  Re = n*d^2*rho/eta;
  Fr = n^2*d/Const.g_n;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a pitched blade impeller for the CSTR</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] L. Andresen, P. Dubucq, R. Peniche, G. Ackermann, A. Kather, and G. Schmitz, &ldquo;Status of the TransiEnt Library: Transient simulation of coupled energy networks with high share of renewable energy,&rdquo; in <i>Proceedings of the 11th International Modelica Conference</i>, 2015, pp. 695&ndash;705.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"), Icon(graphics={
        Ellipse(
          extent={{-50,-24},{0,-44}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,-44},{50,-24}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-3,56},{3,-37}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}));
end PitchedBladeImpeller;
