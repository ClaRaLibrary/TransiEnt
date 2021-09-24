within TransiEnt.Basics.Blocks;
block VariableSlewRateLimiter "Limits the signal with upper and lower boundary based on ClaRa VariableGradientLimiter"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  extends Modelica.Blocks.Interfaces.SISO(y(start=y_start,fixed=true));
  import ClaRa.Basics.Functions.Stepsmoother;
  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Real Nd(min=Modelica.Constants.small)=1/Td "|Expert Settings|Input - Output Coupling|The higher Nd, the closer y follows u";

  parameter Boolean useThresh=false "|Expert Settings|Numerical Noise Suppression|Use threshould for suppression of numerical noise";
  parameter Real thres(max=1e-6)=1e-7 "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000."
                           annotation (Dialog(enable = useThresh,tab="Expert Settings",group="Numerical Noise Suppression"));
  parameter Boolean strict=true "= true, if strict limits with noEvent(..)"
    annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="Expert Settings"));

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

  parameter Boolean useConstantLimits= true "True, if gradient limits are constant";
  parameter Real maxGrad_const(final unit="1/s")=1/60 annotation (Dialog(enable = useConstantLimits));
  parameter Real minGrad_const(final unit="1/s")=-maxGrad_const annotation (Dialog(enable = useConstantLimits));
  parameter Real Td(final unit="s")=0.1 "The lower Td, the closer y follows u";
  parameter Real y_start=0;
  parameter Boolean useHomotopy=simCenter.useHomotopy;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput maxGrad=maxGrad_ if not useConstantLimits "Maximum gradient allowed"
                              annotation (Placement(transformation(extent={{
            -140,60},{-100,100}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput minGrad=minGrad_ if not useConstantLimits "Minimum gradient allowed"
                              annotation (Placement(transformation(extent={{
            -140,-100},{-100,-60}}, rotation=0)));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Real maxGrad_;
  Real minGrad_;
  Real y_aux;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
equation

  if useConstantLimits then
    maxGrad_ = maxGrad_const;
    minGrad_ = minGrad_const;
  end if;
  der(y_aux) = smooth(1,noEvent(min(maxGrad_,max(minGrad_,(u-y_aux)*Nd))));


     if useThresh then
      y= if useHomotopy then homotopy(actual=Stepsmoother(1, 0.1, abs(der(y_aux))/thres)*y_aux + (1-Stepsmoother(1, 0.1, abs(der(y_aux))/thres))*u, simplified=y_start) else homotopy(actual=y_aux,simplified=y_start);
     else  y= if useHomotopy then homotopy(actual=y_aux, simplified= 0) else y_aux;
     end if;




  annotation (Icon(graphics={
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{90,0},{68,-8},{68,8},{90,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(
      points={{-50,-70},{50,70}},
      color={0,0,0},
      smooth=Smooth.None),
    Line(
      visible=strict,
      points={{32,78},{-50,-70}},
      color={255,0,0},
      smooth=Smooth.None)}),
Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><i><span style=\"font-family: MS Shell Dlg 2;\">The model is based on </i><span style=\"font-family: Courier New; color: #006400;\">ClaRa <a href=\"ClaRa.Components.Utilities.Blocks.VariableGradientLimiter\">VariableGradientLimiter</a></span></p>
<p><span style=\"font-family: Courier New;\">It adds some diagnostic variables to provide more inside if numerical issues lead to odd behaviour. Furthermore the initialization is a little more robust by using the homotopy operator and</span></p>
<p><span style=\"font-family: Courier New;\">a start value with fixed=true. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: minimum gradient allowed</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: maximum gradient allowed</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">u: connector of real input signal</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Basics.Blocks.Check.TestSlewRateLimiter&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de), Aug 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de), Apr 2017 : code conventions</span></p>
</html>",
revisions="<html>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<th>Revision</th>
<th>Date</th>
<th>Author</th>
<th>Comment</th>
</tr>
<tr>
<td valign=\"top\">4954</td>
<td valign=\"top\">2012-03-02</td>
<td valign=\"top\">A. Haumer & D. Winkler</td>
<td valign=\"top\"><p>Initial version based on discussion in <a href=\"https://trac.modelica.org/Modelica/ticket/529/Modelica\">#529</a></p></td>
</tr>
</table>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
    Line(
      visible=strict,
      points={{32,78},{-50,-70}},
      color={255,0,0},
      smooth=Smooth.None),
    Line(
      points={{-50,-70},{50,70}},
      color={0,0,0},
      smooth=Smooth.None),
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{90,0},{68,-8},{68,8},{90,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid)}));
end VariableSlewRateLimiter;
