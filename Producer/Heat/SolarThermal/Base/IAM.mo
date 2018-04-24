within TransiEnt.Producer.Heat.SolarThermal.Base;
model IAM "Calculates the incidence angle modifier"

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

  extends TransiEnt.Basics.Icons.Model;
  import Const = Modelica.Constants;
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Integer kind(min=1, max=3)=1 "IAM for direct Irradiance: 1: Constant IAM, 2: IAM as function of b0, 3: IAM by interpolation of record";
  parameter Real constant_iam_dir=1 "If a constant IAM is assumed";
  parameter Real constant_iam_diff=1 "If a constant IAM is assumed";
  parameter Real constant_iam_ground=1 "If a constant IAM is assumed";
  parameter Real b0=1 "assumption: constant b0-value for IAM=1-b0*(1/cos(theta)-1)";
  parameter Real[8] iam_SRCC={1,1,1,1,1,1,1,1} "IAM for theta = 0, 10, 20, ..., 70";
  parameter SI.Conversions.NonSIunits.Angle_deg[8] theta={0,10,20,30,40,50,60,70} "angles of incidence";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  Real iam_dir(min=0, unit="1");
  Real iam_diff(min=0, unit="1");
  Real iam_ground(min=0, unit="1");
  Real b0_interpolated;

  // _____________________________________________
  //
  //           Outer models
  // _____________________________________________

  outer IrradianceOnATiltedSurface irradiance;

equation
  // _____________________________________________
  //
  //            Characteristic Equations
  // _____________________________________________

   if kind == 1 then
     iam_dir=constant_iam_dir;
     iam_diff=constant_iam_diff;
     iam_ground=constant_iam_ground;
     b0_interpolated=0;

   elseif kind == 2 and noEvent(cos(irradiance.angle_direct_tilted)> 0 and (1-b0*(1/cos(irradiance.angle_direct_tilted)-1)) > 0) then
     iam_dir= 1-b0*(1/cos(irradiance.angle_direct_tilted)-1);
     iam_diff= 1-b0*(1/cos(irradiance.angle_diffuse_tilted)-1);
     iam_ground= 1-b0*(1/cos(irradiance.angle_ground_tilted)-1);
     b0_interpolated=0;

   elseif kind == 3 and abs(SI.Conversions.to_deg(irradiance.angle_direct_tilted))<=70 then
     iam_dir= iam_SRCC[integer(SI.Conversions.to_deg(irradiance.angle_direct_tilted)/10)+1]+(iam_SRCC[integer(SI.Conversions.to_deg(irradiance.angle_direct_tilted)/10)+2]-iam_SRCC[integer(SI.Conversions.to_deg(irradiance.angle_direct_tilted)/10)+1])*(SI.Conversions.to_deg(irradiance.angle_direct_tilted)-theta[integer(SI.Conversions.to_deg(irradiance.angle_direct_tilted)/10)+1])/10;
     iam_dir= 1-b0_interpolated*(1/cos(irradiance.angle_direct_tilted)-1);
     iam_diff= 1-b0_interpolated*(1/cos(irradiance.angle_diffuse_tilted)-1);
     iam_ground= 1-b0_interpolated*(1/cos(irradiance.angle_ground_tilted)-1);

   elseif kind == 3 and abs(SI.Conversions.to_deg(irradiance.angle_direct_tilted))>70 then
     iam_dir=0;
     iam_diff=0;
     iam_ground=0;
     b0_interpolated=0;

   else
     iam_dir=0;
     iam_diff=0;
     iam_ground=0;
     b0_interpolated=0;
   end if;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Calculates the incidence angle modifier as suggested by references. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>1. value = const</p>
<p>2. <img src=\"modelica://TransiEnt/Images/equations/equation-J3qxYr8m.png\" alt=\"value= 1-b0*(1/cos(theta)-1)\"/></p>
<p>3. value=linear interpolation</p>
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Peter Kovacs: A guide to the standard EN 12975 (2012)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Toerber (tobias.toerber@tuhh.de), Jul 2015</p>
<p>Edited by Sascha Guddusch (sascha.guddusch@tuhh.de), May 2016</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Mar 2017</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de), Apr. 2017</p>
</html>"),
         Icon(graphics={Line(
          points={{-76,54},{4,-94},{82,92}},
          color={255,170,85},
          thickness=0.5), Line(
          points={{-46,-2},{0,10},{44,0}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.Bezier)}));
end IAM;
