within TransiEnt.Basics.Blocks;
block RealToVector "Takes single input signal and puts it in a specific location in a vector (all other elements are zero)"
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

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

  parameter Integer nout=1 "Number of outputs";
  parameter Integer index;

  // _____________________________________________
  //
  //                 Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput u "Connector of Real input signals" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nout] "Connector of Real output signals" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  for i in 1:nout loop
    if i == index then
      y[i] = u;
    else
      y[i]=0;
    end if;
  end for;

  annotation (
    Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{38,50},{78,-50}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-84,2},{-72.139,12.907},{-61.139,12.907}},   color={0,0,
                255}),
          Line(points={{-124,0},{-87.037,-0.018}},      color={0,0,255}),
          Ellipse(
            extent={{-92.044,4.5925},{-82.044,-4.9075}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-58,13},{-47,13},{23,-30},{33,-30}}, color={0,0,255}),
          Line(points={{-57,40},{-47,40},{23,0},{32,0}}, color={0,0,255}),
          Line(points={{-57,-40},{-46,-40},{23,30},{32,30}}, color={0,0,255}),
          Polygon(
            points={{-60.998,14.8801},{-60.998,10.8801},{-56.998,12.8801},{-60.998,14.8801}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{58.305,4.1274},{68.305,-5.3726}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Line(points={{68,0},{93,0}},  color={0,0,255}),
          Polygon(
            points={{32.162,32.3085},{32.162,28.3085},{36.162,30.3085},{32.162,32.3085}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{32.257,1.8044},{32.257,-2.1956},{36.257,-0.1956},{32.257,1.8044}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{32.881,-28.1745},{32.881,-32.1745},{36.881,-30.1745},{32.881,-28.1745}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Line(points={{36,0},{58,0}}, color={0,0,255}),
          Line(points={{35,30},{48,30},{61,3}}, color={0,0,255}),
          Line(points={{37,-30},{48,-30},{62,-4}}, color={0,0,255}),
        Ellipse(extent={{-66,44},{-60,34}}, lineColor={28,108,200}),
        Ellipse(extent={{-66,-34},{-60,-44}}, lineColor={28,108,200})}),
    Diagram(graphics,
            coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Takes a real input and puts it in a specified location in a vector. All other elements of the vector are set to zero.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: connector of real input signal</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealOutput: connector of real output signal </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de), Aug 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de), Apr 2017 : code conventions</span></p>
</html>"));
end RealToVector;
