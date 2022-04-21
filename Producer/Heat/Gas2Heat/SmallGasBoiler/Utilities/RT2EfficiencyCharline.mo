within TransiEnt.Producer.Heat.Gas2Heat.SmallGasBoiler.Utilities;
model RT2EfficiencyCharline "Characteristic line for the boiler's heating efficiency in function of the heating grid return temperature"



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

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Boolean condensing = false "Condensing operation";
  parameter Boolean referenceNCV = true "true, if efficiencies shall be in respect to NCV, false will give GCV referenced efficiencies";
protected
  parameter String CharLineFileName=if condensing then "WGKennlinie-TR-BuderusLoganoGE434141-750BWmod.txt"
       else "WGKennlinie-TR-BuderusLoganoGE434141-750NTmod.txt" "Characteristic line data filename with extension";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

public
  Basics.Interfaces.General.TemperatureCelsiusIn T_return "Input for return temperature in Celsius"   annotation (Placement(transformation(extent={{-116,-12},{-92,12}}),
        iconTransformation(extent={{-116,-12},{-92,12}})));
  TransiEnt.Basics.Interfaces.General.EfficiencyOut eta "Output for efficiency"
    annotation (Placement(transformation(extent={{90,-12},{114,12}}),
        iconTransformation(extent={{90,-12},{114,12}})));

  // _____________________________________________
  //
  //                   Complex Components
  // _____________________________________________

  TransiEnt.Basics.Tables.GenericCombiTable1Ds charLine(relativepath="\\heat\\GasBoiler\\" + CharLineFileName, columns=if referenceNCV then {3} else {2}) annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
equation
  connect(T_return, charLine.u) annotation (Line(
      points={{-104,0},{-14,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(charLine.y[1], eta) annotation (Line(
      points={{9,0},{102,0}},
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
          extent={{34,-42},{70,-90}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="T_R"),
        Line(
          points={{-52,58},{-18,46},{12,-12},{64,-28}},
          color={255,0,0},
          smooth=Smooth.Bezier,
          thickness=0.5)}),      Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This block calculates a boiler&apos;s efficiency from the return temperature of the heating system (heat carrier).</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The efficiency of a boiler is both depending on the part load and the return temperature of the heat carrier. This block considers the latter with a representative characteristical line giving the efficiency for a certain return temperature range.</p>
<p>As condensing boilers have different characteristical lines than non-condensing have, so the block loads different lines for a given parameter <i>condensing</i>. Also the reference value of the efficiency can be chosen via <i>referenceNCV</i>.</p>
<p><img src=\"modelica://TransiEnt/Images/BoilerCharLineReturnTemp.png\"/></p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<ul>
<li>T_return: input value of the return temperature</li>
<li>eta: output value of the heating efficiency</li>
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
<p>Planungsunterlage Ecostream-Gasheizkessel Logano GE434 und Gas-Brennwertkessel Logano plus GB434 &ndash; 09/2005</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Paul Kernstock (paul.kernstock@tu-harburg.de) June 2015</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de) Nov 2016</p>
</html>"));
end RT2EfficiencyCharline;
