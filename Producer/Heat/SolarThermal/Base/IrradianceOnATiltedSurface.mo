within TransiEnt.Producer.Heat.SolarThermal.Base;
model IrradianceOnATiltedSurface "Combines the calculation of incidence angle of solar irradiance and different models for calculating the solar irradiance on a tilted surface"
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

  extends TransiEnt.Basics.Icons.Model;
  import Const = Modelica.Constants;
  import SI = Modelica.SIunits;
  outer TransiEnt.SimCenter simCenter;


  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
  parameter Boolean use_input_data=false "choose if input data is given by inputs - if not, simCenter data is used";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Ambient.IrradianceIn irradiance_direct_measured_input(value=irradiance_direct_measured) annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  TransiEnt.Basics.Interfaces.Ambient.IrradianceIn irradiance_diffuse_horizontal_input(value=irradiance_diffuse_horizontal) annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Angle angle_direct_tilted;            //angle of direct irradiance on a tilted surface
  SI.Irradiance irradiance_direct_tilted;  // direct irradiance on a tilted surface
  SI.Angle angle_diffuse_tilted;           // angle of diffuse irradiance on a tilted surface
  SI.Irradiance irradiance_diffuse_tilted;  // diffuse irradiance on a tilted surface
  SI.Angle angle_ground_tilted;            // angle of ground-reflected irradiance on a tilted surface
  SI.Irradiance irradiance_ground_tilted;      // ground-reflected irradiance on a tilted surface
  inner SI.Irradiance irradiance_direct_measured "Measured direct irradiance";
  inner SI.Irradiance irradiance_diffuse_horizontal "Measured diffuse irradiance";
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  replaceable model Skymodel=SkymodelBase constrainedby SkymodelBase annotation(choicesAllMatching=true);
  Skymodel skymodel annotation (Placement(transformation(extent={{-22,2},{-2,22}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if (not use_input_data) then
    irradiance_direct_measured=simCenter.i_direct;
    irradiance_diffuse_horizontal=simCenter.i_diffuse;
  end if;

  irradiance_direct_tilted=skymodel.irradiance_direct_tilted;
  angle_direct_tilted=skymodel.angle_tilted;

  irradiance_diffuse_tilted=skymodel.irradiance_diffuse_tilted;
  angle_diffuse_tilted=SI.Conversions.from_deg(59.7-0.1388*SI.Conversions.to_deg(skymodel.slope)+0.001497*SI.Conversions.to_deg(skymodel.slope)^2);

  irradiance_ground_tilted=skymodel.irradiance_ground_tilted;
  angle_ground_tilted= SI.Conversions.from_deg(90 - 0.5788*SI.Conversions.to_deg(skymodel.slope) + 0.002693*SI.Conversions.to_deg(skymodel.slope)^2);

    annotation(choicesAllMatching,
              Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Combines the calculation of incidence angle of solar irradiance and different models for calculating the solar irradiance on a tilted surface.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Calculation of angle of incidence for ground reflected and diffuse irradiance gives the effective angle of incidence for flate plate solar collectors. Product of thickness of glazing and extinction coefficient must be lower than 5.4mm.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>s. 2.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>irradiance_direct_measured_input: input for irradiance in W/m2</p>
<p>irradiance_diffuse_horizontal_input: input for irradiance in W/m2</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>Calculated output is Basics.Records.Irradiance direct_tilted, diffuse_tilted, ground_tilted;</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-pYeG5mvk.png\" alt=\"  diffuse_tilted.angle=SI.Conversions.from_deg(59.7-0.1388*slope+0.001497*slope^2)\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-2n2aAkd8.png\" alt=\" ground_tilted.angle= SI.Conversions.from_deg(90 - 0.5788*slope + 0.002693*slope^2)\"/></p>
<p>Alle other values are calculated by instances of other models.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Choose via parameter use_input_data which solar data input data is used for calculation:</p>
<p>use_input_data=true: solar input data is given directly via two inputs (irradiance_direct_measured_input, irradiance_diffuse_horizontal_input)</p>
<p>use_input_data=false: solar input data from simCenter is used for calculation</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Duffie/Beckman (2006): Solar Engineering of Thermal Processes</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Toerber (tobias.toerber@tuhh.de), Jul 2015</p>
<p>Model modified by Sascha Guddusch (sascha.guddusch@tuhh.de), May 2016</p>
<p>Model modified by Anne Senkel (anne.senkel@tuhh.de), Mar 2017</p>
<p>Model modified by Lisa Andresen (andresen@tuhh.de), Apr. 2017</p>
<p>Model modified by Oliver Schülting (oliver.schuelting@tuhh.de), May 2018: added possibility to use inputs for solar irradiation</p>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-86,-84},{24,-84},{94,72},{-8,72},{-86,-84}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-90,64},{-4,16}},
          color={255,255,0},
          thickness=1,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-82,44},{4,-4}},
          color={255,255,0},
          thickness=1,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-60,64},{26,16}},
          color={255,255,0},
          thickness=1,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-86,-42},{-46,-30}},
          color={255,255,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{62,-78},{26,-40}},
          color={255,255,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-14,84},{26,32}},
          color={255,255,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open})}));
end IrradianceOnATiltedSurface;
