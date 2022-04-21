within TransiEnt.Producer.Gas.BiogasPlant.Base;
model GeometryCSTR "Geometry of CSTR"




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

  import Modelica.Constants.pi;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Diameter D_i=1 "Inner Diameter of CSTR";
  parameter Modelica.Units.SI.Diameter D_o=1.1 "Outer Diameter of CSTR";
  parameter Modelica.Units.SI.Height Height_tankWall=1 "Height of tank wall";
  parameter Modelica.Units.SI.Height Height_tankCenter=1 "Height of tank in center";
  parameter Modelica.Units.SI.Height Height_fluid=0.9 "Height of fluid in CSTR";

  parameter Real impellerRatio(
    min=0,
    max=1) = 1/3 "Ratio of impeller diameter to inner diameter of CSTR";

  parameter Real relativeImpellerHeight=1/5 "Ratio of height of impeller blade to impeller diameter";

  parameter Modelica.Units.SI.Diameter d=0.1016 "outer diameter of a tube of a coil";
  parameter Modelica.Units.SI.Diameter d_i=0.1016 - 2*0.0030480 "inner diameter of a tube of a coil";

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Modelica.Units.SI.Diameter d_r=impellerRatio*D_i "Diameter of impeller";
  final parameter Modelica.Units.SI.Height height_r=relativeImpellerHeight*d_r "Height of impeller blade";
  final parameter Modelica.Units.SI.Volume V_fluid=pi/4*D_i^2*Height_fluid "Volume of fluid in CSTR";
  final parameter Modelica.Units.SI.Volume V_gas=pi/4*D_i^2*((Height_tankWall - Height_fluid) + 1/3*(Height_tankCenter - Height_tankWall)) "Volume of gas in CSTR assuming cone shaped roof";
  final parameter Modelica.Units.SI.Area A_wallFluid=pi*D_i*Height_fluid "Area of wall in contact with fluid";
  final parameter Modelica.Units.SI.Area A_wallGas=pi*D_i*(Height_tankWall - Height_fluid) "Area of wall in contact with gas";
  final parameter Modelica.Units.SI.Area A_wallTank=pi*D_o*Height_tankWall "Area of external tank Wall";
  final parameter Modelica.Units.SI.Area A_roof=pi*D_i/2*sqrt(D_i^2/4 + (Height_tankCenter - Height_tankWall)^2) "Area of roof assuming cone shape";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  assert(D_o > D_i, "Outer Diameter musst be greater than inner Diameter");
  assert(Height_tankCenter - Height_tankWall >= 0, "Height in center of CSTR must be greater or equal height of its wall");
  assert(impellerRatio > 0 and impellerRatio < 1, "Diameter Ratio d_r/D_i out of bounds");
  assert(Height_tankWall - Height_fluid > 0, "Height of fluid must not be higher than wall height");

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-90,90},{90,-90}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          closure=EllipseClosure.Radial)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model containing all geometrical parameters of the CSTR to be used by other models </p>
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
<p>Model created by Philipp Jahneke         (philipp.koziol@tuhh.de), August 2018</p>
</html>"));
end GeometryCSTR;
