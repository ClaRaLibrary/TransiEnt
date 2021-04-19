within TransiEnt.Producer.Heat.SolarThermal.Base;
partial model SkymodelBase "Base model for modeling the influence of orientation of a surface for calculation of irradiance"

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

  import Const = Modelica.Constants;
  import SI = Modelica.SIunits;
  extends ExtraTerrestrialIrradiance;
  extends TransiEnt.Basics.Icons.Model;



  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Real reflectance_ground=0.2 "Reflection coefficient of the ground";
  parameter Boolean direct_normal=true "=true, if the direct irradiance measured on a surface is normal to irradiance";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  outer SI.Irradiance irradiance_direct_measured "Measured direct irradiance";
  outer SI.Irradiance irradiance_diffuse_horizontal "Measured diffuse irradiance";
  SI.Irradiance irradiance_direct_horizontal "Direct horizontal irradiance";
  SI.Irradiance irradiance_direct_tilted, irradiance_diffuse_tilted, irradiance_ground_tilted;
  Real ratio_beam "Ratio between direct irradiance on a tilted surface and irradiance on a horizontal surface";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  ratio_beam=max(Const.small, cos(angle_tilted) / max(cos(angle_horizontal),0.01));

  if direct_normal then
    irradiance_direct_horizontal=irradiance_direct_measured*max(cos(angle_horizontal),0);
  else
    irradiance_direct_horizontal=irradiance_direct_measured;
  end if;

      annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base model for modeling the influence of orientation of a surface for calculation of irradiance.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>ratio_beam is invalid for small angles</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Usage for small values of angleOfSunIncidence.horizontal is not recommended because of refraction by atmosphere</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>direct_tilted, diffuse_tilted and ground_tilted are the calculated irradiances of tilted surface.</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-UnTavo0A.png\" alt=\" ratio_beam=max(Const.small, cos(angleOfSunIncidence.tilted) /max(cos(angleOfSunIncidence.horizontal),0.01))
\"/></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Model needs outer variables SI.Irradiance direct_measured, diffuse_horizontal, sun_horizontal.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>purely theoretical model</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Duffie/Beckman (2006): Solar Engineering of Thermal Processes</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Toerber (tobias.toerber@tuhh.de), Jul 2015</p>
<p>Edited by Sascha Guddusch (sascha.guddusch@tuhh.de), May 2016</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Mar 2017</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de), Apr. 2017</p>
<p>Model modified by Oliver Schülting (oliver.schuelting@tuhh.de), May 2018</p>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-94,30},{2,2}},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={135,135,135},
          lineColor={170,170,255}),
        Ellipse(
          extent={{46,14},{-50,-20}},
          lineColor={170,170,255},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={135,135,135}),
        Ellipse(
          extent={{94,26},{-30,4}},
          lineColor={170,170,255},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={135,135,135}),
        Line(
          points={{-72,74},{-48,34}},
          color={255,220,0},
          thickness=1,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-24,76},{0,36}},
          color={255,220,0},
          thickness=1,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{20,76},{44,36}},
          color={255,220,0},
          thickness=1,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{30,-26},{54,-66}},
          color={255,220,0},
          thickness=1,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{2,34},{24,40}},
          color={255,220,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-32,-18},{0,-46}},
          color={255,220,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-58,-4},{-64,-44}},
          color={255,220,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-34,34},{-42,56}},
          color={255,220,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{6,-28},{10,-56}},
          color={255,220,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{52,-10},{86,-26}},
          color={255,220,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{54,34},{78,58}},
          color={255,220,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-36,-26},{-12,-66}},
          color={255,220,0},
          thickness=1,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open})}),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end SkymodelBase;
