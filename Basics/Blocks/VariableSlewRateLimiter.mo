within TransiEnt.Basics.Blocks;
block VariableSlewRateLimiter "Limits the signal with upper and lower boundary based on ClaRa VariableGradientLimiter"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Modelica.Blocks.Interfaces.SISO(y(start=y_start,fixed=true));
  import ClaRa.Basics.Functions.Stepsmoother;
  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Boolean useConstantLimits= true "True, if gradient limits are constant";
  parameter Real maxGrad_const(final unit="1/s")=1/60 annotation (Dialog(enable = useConstantLimits));
  parameter Real minGrad_const(final unit="1/s")=-maxGrad_const annotation (Dialog(enable = useConstantLimits));
  parameter Real Td(final unit="s")=0.1;
  parameter Real y_start=0;

  final parameter Real Nd(min=Modelica.Constants.small)=1/Td "|Expert Settings|Input - Output Coupling|The higher Nd, the closer y follows u";

  parameter Boolean useThresh=false "|Expert Settings|Numerical Noise Suppression|Use threshould for suppression of numerical noise";
  parameter Real thres(max=1e-6)=1e-7 "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000."
                           annotation (Dialog(enable = useThresh,tab="Expert Settings",group="Numerical Noise Suppression"));
  parameter Boolean strict=true "= true, if strict limits with noEvent(..)"
    annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="Expert Settings"));
  // _____________________________________________
  //
  //        Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput maxGrad(value=maxGrad_) if not useConstantLimits "Maximum Gradient allowd"
                              annotation (Placement(transformation(extent={{
            -140,60},{-100,100}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput minGrad(value=minGrad_) if not useConstantLimits "Minimum Gradient allowd"
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
equation

  if useConstantLimits then
    maxGrad_ = maxGrad_const;
    minGrad_ = minGrad_const;
  end if;
  der(y_aux) = smooth(1,noEvent(min(maxGrad_,max(minGrad_,(u-y_aux)*Nd))));

  if useThresh then
     y= homotopy(actual=Stepsmoother(1, 0.1, abs(der(y_aux))/thres)*y_aux + (1-Stepsmoother(1, 0.1, abs(der(y_aux))/thres))*u, simplified=y_start);
  else
    y=homotopy(actual=y_aux,simplified=y_start);
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
<p><i><span style=\"font-family: MS Shell Dlg 2;\">The model is based on </span></i><code></span><span style=\"color: #006400;\">ClaRa&nbsp;<a href=\"ClaRa.Components.Utilities.Blocks.VariableGradientLimiter\">VariableGradientLimiter</a></code></p>
<pre>It adds some diagnostic variables to provide more inside if numerical issues lead to odd behaviour. Furthermore the initialization is a little more robust by using the homotopy operator and
a start value with fixed=true. </pre>
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
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised (code conventions) by Pascal Dubucq (dubucq@tuhh.de) on 21.04.2017</span></p>
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
<td valign=\"top\">A. Haumer &amp; D. Winkler</td>
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
