within TransiEnt.Basics.Blocks;
model SplineLim "Spline smoothed limiter"
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

extends Modelica.Blocks.Interfaces.SISO;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Real lim=(uMax-uMin)*thres;

  final parameter Real xa=uMin - lim*sqrt(2);
  final parameter Real xb=uMin + lim;
  final parameter Real xc=uMax - lim;
  final parameter Real xd=uMax + lim*sqrt(2);
  final parameter Real ya=uMin;
  final parameter Real yb=uMin + lim;
  final parameter Real yc=uMax - lim;
  final parameter Real yd=uMax;

protected
  final parameter Real dya=0;
  final parameter Real dyb=1;
  parameter Real[4] coef1(fixed=false);
  parameter Real[4] coef2(fixed=false);

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

public
  parameter Real uMax = 1 "Maximum";
  parameter Real uMin = -uMax "Minimum";
  parameter Real thres(max=0.5, min=Modelica.Constants.eps) = 0.1 "Share of (uMax-uMin) from which on spline interpolation shall be used";


  // _____________________________________________
  //
  //     Private Functions (only for plotResult protected function)
  // _____________________________________________

  //   function plotResult
  //   constant String resultFileName = "InsertModelNameHere.mat";
  //   algorithm
  //     TransiEnt.Basics.Functions.plotResult(resultFileName);
  //     createPlot(...); // obtain content by calling function plotSetup() in the commands window
  //     //add ,filename=resultFileName at the end of first createPlot command
  //   end plotResult;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

initial equation
  assert(uMax >= uMin, "Limiter: Limits must be consistent. However, uMax (=" + String(uMax) +
                       ") < uMin (=" + String(uMin) + ")");
  assert(thres<=0.5, "For a continuous course the transition zones may not overlap!");

  ya = coef1[1] + xa*(coef1[2] + xa*(coef1[3] + xa*coef1[4]));
  yb = coef1[1] + xb*(coef1[2] + xb*(coef1[3] + xb*coef1[4]));
  dya = coef1[2] + xa*(2*coef1[3] + xa*3*coef1[4]);
  dyb = coef1[2] + xb*(2*coef1[3] + xb*3*coef1[4]);

  yc = coef2[1] + xc*(coef2[2] + xc*(coef2[3] + xc*coef2[4]));
  yd = coef2[1] + xd*(coef2[2] + xd*(coef2[3] + xd*coef2[4]));
  dyb = coef2[2] + xc*(2*coef2[3] + xc*3*coef2[4]);
  dya = coef2[2] + xd*(2*coef2[3] + xd*3*coef2[4]);

equation
  y = smooth(1, noEvent(
    if u <= xa then uMin
    elseif u >= xd then uMax
    elseif u > xa and u < xb then coef1[1] + u*coef1[2] + u^2*coef1[3] + u^3*coef1[4]
    elseif u > xc and u < xd then coef2[1] + u*coef2[2] + u^2*coef2[3] + u^3*coef2[4]
    else u));

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________


  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Polygon(
      points={{90,0},{68,-8},{68,8},{90,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
        Line(
          points={{75,60},{50,60},{40,58},{30,50},{-30,-50},{-40,-58},{-50,-60},
              {-75,-60}},
          color={0,0,0},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Smoothes the transition zones of the limiter by spline interpolation.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The parameter thres gives the transition zone as share of (uMax-uMin) and should be &LT;=0.5, else regions would overlap.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Christian Warnecke, Aug 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Lisa Andresen (andresen@tuhh.de), Dec 2016</span></p>
</html>"));
end SplineLim;
