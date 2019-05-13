within TransiEnt.Producer.Heat.SolarThermal.Base;
model ExtraTerrestrialIrradiance "Calculates the extraterrestrial irradiance of the sun"

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
  extends SolarTime;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  constant SI.Irradiance solarConstant=1367;

  parameter SI.Angle latitude=SI.Conversions.from_deg(53.55) "latitude of the position, north posiive, 53,55 N for Hamburg";
  parameter SI.Angle slope=SI.Conversions.from_deg(30) "slope of the tilted surface, Assumption";
  parameter SI.Angle surfaceAzimuthAngle=0 "Angle between the local meridian and the projection of the normal of the surface on a horizontal surface, west positive";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Angle angle_horizontal;
  SI.Angle angle_tilted;
  SI.Irradiance irradiance_extraterrestrial;

  SI.Angle declination;
  SI.Angle hourAngle;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //angle of sun incidence
  declination=SI.Conversions.from_deg(0.3948 - 23.2559*cos(J + SI.Conversions.from_deg(9.1)) - 0.3915*cos(2*J + SI.Conversions.from_deg(5.4)) - 0.1764*cos(3*J + SI.Conversions.from_deg(26)));
  hourAngle= -Const.pi+solarTime/(60*60*24)*2*Const.pi; // = -pi at +midnight, = 0 at solar noon = pi at -midnight -> multiple of pi does not harm calculation

  angle_horizontal=acos(sin(declination)*sin(latitude)+cos(declination)*cos(latitude)*cos(hourAngle));
  angle_tilted=acos(sin(declination)*sin(latitude)*cos(slope)-sin(declination)*cos(latitude)*sin(slope)*cos(surfaceAzimuthAngle)+cos(declination)*cos(latitude)*cos(slope)*cos(hourAngle)+cos(declination)*sin(latitude)*sin(slope)*cos(surfaceAzimuthAngle)*cos(hourAngle)+cos(declination)*sin(slope)*sin(surfaceAzimuthAngle)*sin(hourAngle));

  //extraterrestrial irradiance
  irradiance_extraterrestrial = cos(angle_horizontal)*solarConstant*(1+0.033*cos(J));

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Calculates the extraterrestrial irradiance of the sun, equation is given by Duffie/Beckman (2006): Solar Engineering of Thermal Processes</p>
<p>Model&nbsp;provides&nbsp;the&nbsp;angle&nbsp;of&nbsp;incidence&nbsp;and&nbsp;the&nbsp;irradiance&nbsp;of&nbsp;the&nbsp;sun&nbsp;on&nbsp;a&nbsp;horizontal&nbsp;surface&nbsp;at&nbsp;a&nbsp;position&nbsp;with&nbsp;the&nbsp;parameter&nbsp;latitude&nbsp;in&nbsp;respect&nbsp;to&nbsp;local&nbsp;(=solar)&nbsp;time.&nbsp;Solar&nbsp;time&nbsp;and&nbsp;day&nbsp;have&nbsp;to&nbsp;be&nbsp;provided&nbsp;as&nbsp;outer&nbsp;variables.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model considers the differences of sun-earth distance during a year, neglects periodical differences of sun activity. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>until the next big change in sun&apos;s activity or if very accurate values are needed</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>outer variables:</p>
<p>day: day as floating point, means day=0 at 01.01. 00:00:00, day=0.5 at 01.01. 12:00:00 a.s.o.</p>
<p>solarTime: solarTime in seconds </p>
<p>output</p>
<p>sunIrradiance={Irradiance, Angle}: gives the irradiance on a horizontal surface with the incidence angle </p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b> </p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-LGhyLfIh.png\" alt=\"
  irradiance_extraterrestrial = cos(angle)*solarConstant*(1+0.033*cos(360*(day)/365.25))\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-j0cypZU6.png\" alt=\"  angle= angleOfSunIncidence.horizontal\"/></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Duffie/Beckman (2006): Solar Engineering of Thermal Processes</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Toerber (tobias.toerber@tuhh.de), Jul 2015</p>
<p>Edited by Sascha Guddusch (sascha.guddusch@tuhh.de), May 2016</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Mar 2017</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de), Apr. 2017</p>
</html>"));
end ExtraTerrestrialIrradiance;
