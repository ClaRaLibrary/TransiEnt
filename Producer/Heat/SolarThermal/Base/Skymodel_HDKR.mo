within TransiEnt.Producer.Heat.SolarThermal.Base;
model Skymodel_HDKR "HDKR model - Anisotropic calculation of the irradiance on a tilted surface"

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
  import Const = Modelica.Constants;
  import SI = Modelica.SIunits;
  extends SkymodelBase;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Real anisotropyIndex "Anisotropy index";
  Real eff "Correction factor by KLUCHER";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  anisotropyIndex= if irradiance_extraterrestrial<=25 then 0 else min(1,max(Const.small,irradiance_direct_horizontal/max(1.5,irradiance_extraterrestrial)));
  eff= sqrt(max(0,irradiance_direct_horizontal) / max(1,(irradiance_direct_horizontal + irradiance_diffuse_horizontal)));

  irradiance_direct_tilted= (irradiance_direct_horizontal)*ratio_beam;
  irradiance_diffuse_tilted= irradiance_diffuse_horizontal*(1-anisotropyIndex)*((1+cos(slope))/2)*(1+eff*(sin(slope/2))^3)+irradiance_diffuse_horizontal*anisotropyIndex*ratio_beam;
  irradiance_ground_tilted= (irradiance_direct_horizontal+irradiance_diffuse_horizontal)*reflectance_ground*(1-cos(slope))/2;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Anisotropic approach to calculate solar radiation on a tilted surface.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Hay and Davies (1980) estimate the fraction of the diffuse that is circumsolar and consider it to be all from the same direction as the beam radiation; they do not treat horizon brightening. Reindl et al. (1990b) add a horizon-brightening term to the Hay and Davies model, as proposed by Klucher (1979), giving a model to be</p>
<p>referred to as the HDKR model (see Duffie & Beckman, 2006).</p>
<p>Theoretical model based on the assumption that the diffuse irradiance has a peak next to the angle of the sun so that this circumsolar irradiance can be added to direct irradiance.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Usage for small values of angleOfSunIncidence.horizontal is not recommended because of refraction by atmosphere.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>direct_tilted, diffuse_tilted and ground_tilted are the calculated irradiances of tilted surface.</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-rB1AoQA1.png\" alt=\"     anisotropyIndex= min(1,max(Const.small,direct_horizontal/max(1,sun_horizontal)))\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-2rQGTpsH.png\" alt=\" eff= sqrt(direct_horizontal / max(1,(direct_horizontal + diffuse_horizontal)))
\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-q80QnxMB.png\" alt=\" direct_tilted= (direct_horizontal+diffuse_horizontal*anisotropy_index)*ratio_beam\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-Q6JTVUNw.png\" alt=\"diffuse_tilted= diffuse_horizontal*(1-anisotropy_index)*((1+cos(slope))/2)*(1+eff*(sin(slope/2))^3)\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-k3G0JHF6.png\" alt=\"
  ground_tilted= (direct_horizontal+diffuse_horizontal)*reflectance_ground*(1-cos(slope))/2\"/></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>None.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Purely theoretical model</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Duffie & Beckman (2006): Solar Engineering of Thermal Processes, p. 91 f.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Toerber (tobias.toerber@tuhh.de), Jul 2015</p>
<p>Edited by Sascha Guddusch (sascha.guddusch@tuhh.de), May 2016</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Mar 2017</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de), Apr. 2017</p>
<p>Model modified by Oliver Schülting (oliver.schuelting@tuhh.de), Jun 2018: no anisotropy if irradiance_extraterrestrial&lt;=25 since this lead to unrealistic high irradiation peaks at morning and/or evening</p>
</html>"));
end Skymodel_HDKR;
