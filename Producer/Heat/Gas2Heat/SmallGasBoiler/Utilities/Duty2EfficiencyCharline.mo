within TransiEnt.Producer.Heat.Gas2Heat.SmallGasBoiler.Utilities;
model Duty2EfficiencyCharline "Characteristic line of a boiler's efficiency in function of the boiler's duty"

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
  //        Constants and Parameters
  // _____________________________________________

  parameter Boolean condensing "Condensing operation";
  parameter Boolean referenceNCV = true "true, if efficiencies shall be in respect to NCV, false will give GCV referenced efficiencies";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_n "Nominal heating power";
protected
  parameter String CharLineFileName=if condensing then "WGKennlinie-TL-Wolf450-5200BW4030.txt"
       else "WGKennlinie-TL-Wolf450-5200NT.txt" "Characteristic line data filename with extension";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

public
  Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set "Heat duty"    annotation (Placement(transformation(extent={{-116,-12},{-92,12}}),
        iconTransformation(extent={{-116,-12},{-92,12}})));
 TransiEnt.Basics.Interfaces.General.EfficiencyOut eta "Boiler's efficiency"
    annotation (Placement(transformation(extent={{94,-12},{118,12}}),
        iconTransformation(extent={{94,-12},{118,12}})));

  // _____________________________________________
  //
  //                   Complex Components
  // _____________________________________________

  TransiEnt.Basics.Tables.GenericCombiTable1Ds charLine(relativepath="\\heat\GasBoiler\\" + CharLineFileName, columns=if referenceNCV then {3} else {2}) annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Q_flow_n)
    annotation (Placement(transformation(extent={{-90,-42},{-70,-22}})));
  Modelica.Blocks.Math.Division division1
    annotation (Placement(transformation(extent={{-50,-6},{-38,6}})));
equation
  connect(realExpression.y, division1.u2) annotation (Line(
      points={{-69,-32},{-60,-32},{-60,-3.6},{-51.2,-3.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(division1.y,charLine. u) annotation (Line(
      points={{-37.4,0},{-14,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow_set, division1.u1) annotation (Line(
      points={{-104,0},{-78,0},{-78,3.6},{-51.2,3.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(charLine.y[1], eta) annotation (Line(
      points={{9,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,94},{-70,72},{-54,72},{-62,94}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-62,72},{-62,-66}}, color={192,192,192}),
        Text(
          extent={{-94,100},{-72,66}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="eta"),
        Polygon(
          points={{94,-44},{72,-36},{72,-52},{94,-44}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-86,-44},{86,-44}}, color={192,192,192}),
        Text(
          extent={{42,-44},{86,-90}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Q/Qn"),
        Line(
          points={{-52,58},{-18,46},{12,-12},{64,-28}},
          color={255,0,0},
          smooth=Smooth.Bezier,
          thickness=0.5)}),      Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-32,-6},{-20,-10}},
          lineColor={0,0,255},
          textString="Q/Qn")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This block calculates a boiler&apos;s efficiency from its part working load.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The efficiency of a boiler is both depending on the part working load and the return temperature of the heat carrier. This block considers the former with a representative characteristical line giving the efficiency for a certain part load range. To compute the part working load, the nominal heat load of the boiler has to be given with the parameter <i>Q_flow_n</i>.</p>
<p>As condensing boilers have different characteristical lines than non-condening have, so the block loads different lines for a given parameter <i>condesing</i>. Also the reference value of the efficiency can be chosen via <i>referenceNCV</i>.</p>
<p><img src=\"modelica://TransiEnt/Images/BoilerCharLinePartLoad.png\"/></p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<ul>
<li>Q_flow_set: input value of the heat duty</li>
<li>eta: output value of the boiler&apos;s efficiency</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Paul Kernstock (paul.kernstock@tu-harburg.de) June 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2015</p>
</html>"));
end Duty2EfficiencyCharline;
