within TransiEnt.Basics.Icons;
partial class PtG "Icon for power to gas plant including electrolyser and compressor"
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
  extends TransiEnt.Basics.Icons.Model;

  annotation(Documentation(info = "<html><p>This is an icon for electrolysers. Electrolysers convert energy <i>E</i> to hydrogen <i>H2</i>.</p><p>The yellow ball represents the energy which is converted into the blue balls of hydrogen</p></html>", revisions = "<html><ul><il>V1.0 Patrick Gttsch<br>first design</il></ul></html>"), Icon(coordinateSystem(extent={{-100,
            -100},{100,100}},                                                                                                    preserveAspectRatio=false,   initialScale = 0.1, grid = {2,2}), graphics={
        Rectangle(
          extent={{-76,64},{76,-64}},
          lineColor={0,134,134},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{76,64},{-76,-64}},
          color={0,134,134},
          smooth=Smooth.None),
        Text(
          extent={{-70,62},{-22,-6}},
          lineColor={0,134,134},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="P"),
        Text(
          extent={{4,4},{52,-64}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="H"),
        Text(
          extent={{38,-36},{74,-64}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="2")}));

end PtG;
