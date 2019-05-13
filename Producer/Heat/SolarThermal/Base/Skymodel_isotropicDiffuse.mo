within TransiEnt.Producer.Heat.SolarThermal.Base;
model Skymodel_isotropicDiffuse "Isotropic calculation of the irradiance on a tilted surface"

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

  import Const = Modelica.Constants;
  import SI = Modelica.SIunits;
  extends SkymodelBase;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  irradiance_direct_tilted = irradiance_direct_horizontal*ratio_beam;
  irradiance_diffuse_tilted= irradiance_diffuse_horizontal*(1 + cos(slope))/2;
  irradiance_ground_tilted= (irradiance_direct_horizontal + irradiance_diffuse_horizontal)*reflectance_ground*(1 - cos(slope))/2;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Isotropic approach to calculate solar radiation on a tilted surface.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Theoretical model based on the assumption that the diffuse irradiance is distributed uniformly throughout the sky.</p>
<p>The radiation on the tilted surface was considered to include three components: beam, isotropic diffuse, and solar radiation diffusely reﬂected from the ground.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Usage for small values of angleOfSunIncidence.horizontal is not recommended because of refraction by atmosphere</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>direct_tilted, diffuse_tilted and ground_tilted are the calculated irradiances of tilted surface.</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-SulDhPxL.png\" alt=\"direct_tilted = direct_horizontal*ratio_beam\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-2oro7BQ3.png\" alt=\"diffuse_tilted= diffuse_horizontal*(1 + cos(slope))/2\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-k3G0JHF6.png\"/></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>None.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Purely theoretical model</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Duffie &amp; Beckman&nbsp;(2006):&nbsp;Solar&nbsp;Engineering&nbsp;of&nbsp;Thermal&nbsp;Processes</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Toerber (tobias.toerber@tuhh.de), Jul 2015</p>
<p>Edited by Sascha Guddusch (sascha.guddusch@tuhh.de), May 2016</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Mar 2017</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de), Apr. 2017</p>
</html>"));
end Skymodel_isotropicDiffuse;
