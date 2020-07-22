within TransiEnt.Components.Boundaries.Ambient;
model AmbientConditions "Contains the time varying ambient condition parameters used in simCenter block"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.OuterElement;

  parameter Modelica.SIunits.Density rho_amb = 1.2 "Ambient density";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable TransiEnt.Components.Boundaries.Ambient.Base.EmptySolarRadiation globalSolarRadiation constrainedby TransiEnt.Components.Boundaries.Ambient.Base.PartialGlobalSolarRadiation annotation (choicesAllMatching=true, Placement(transformation(extent={{-22,2},{-2,22}})));

  replaceable TransiEnt.Components.Boundaries.Ambient.Base.EmptySolarRadiation directSolarRadiation constrainedby TransiEnt.Components.Boundaries.Ambient.Base.PartialGlobalSolarRadiation annotation (choicesAllMatching=true, Placement(transformation(extent={{-22,38},{-2,58}})));

  replaceable TransiEnt.Components.Boundaries.Ambient.Base.EmptySolarRadiation diffuseSolarRadiation constrainedby TransiEnt.Components.Boundaries.Ambient.Base.PartialGlobalSolarRadiation annotation (choicesAllMatching=true, Placement(transformation(extent={{-22,72},{-2,92}})));

  replaceable TransiEnt.Components.Boundaries.Ambient.Base.EmptyTemperature temperature constrainedby TransiEnt.Components.Boundaries.Ambient.Base.PartialTemperature annotation (choicesAllMatching=true, Placement(transformation(extent={{-22,-38},{-2,-18}})));

  replaceable TransiEnt.Components.Boundaries.Ambient.Base.EmptyWindspeed wind constrainedby TransiEnt.Components.Boundaries.Ambient.Base.PartialWindspeed annotation (choicesAllMatching=true, Placement(transformation(extent={{-22,-76},{-2,-56}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  Modelica.SIunits.Temp_C summary_temperature = temperature.value;
  Modelica.SIunits.Velocity summary_windSpeed = wind.value;
  Modelica.SIunits.Irradiance summary_gSolarRadiation = globalSolarRadiation.value;
  Modelica.SIunits.Irradiance summary_directSolarRadiation = directSolarRadiation.value;
  Modelica.SIunits.Irradiance summary_diffuseSolarRadiation = diffuseSolarRadiation.value;

 annotation (
    defaultComponentName="ambientConditions",
    defaultComponentPrefixes="inner",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(
          extent={{40,24},{14,48}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,18},{-42,44}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{14,12},{12,12},{10,14},{10,18},{12,20},{16,22},{14,26},{18,32},{24,32},{24,34},{28,38},{32,38},{34,36},{38,40},{46,40},{50,36},{50,32},{54,32},{58,30},{58,26},{60,24},{62,22},{62,18},{60,16},{56,12},{14,12}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          pattern=LinePattern.None),
        Polygon(
          points={{12,-32},{10,-32},{8,-30},{8,-26},{10,-24},{14,-22},{12,-18},{16,-12},{22,-12},{22,-10},{26,-6},{30,-6},{32,-8},{36,-4},{44,-4},{48,-8},{48,-12},{52,-12},{56,-14},{56,-18},{58,-20},{60,-22},{60,-26},{58,-28},{54,-32},{12,-32}},
          lineColor={28,108,200},
          fillColor={0,0,216},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-46,-32},{-48,-32},{-50,-30},{-50,-26},{-48,-24},{-44,-22},{-46,-18},{-42,-12},{-36,-12},{-36,-10},{-32,-6},{-28,-6},{-26,-8},{-22,-4},{-14,-4},{-10,-8},{-10,-12},{-6,-12},{-2,-14},{-2,-18},{0,-20},{2,-22},{2,-26},{0,-28},{-4,-32},{-46,-32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{40,-16},{30,-22},{22,-26},{30,-26},{16,-46},{42,-24},{34,-24},{40,-16}},
          lineColor={255,210,74},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-14,-18},{-14,-22},{-14,-26},{-14,-28},{-14,-28},{-16,-30},{-18,-30},{-20,-28},{-20,-26},{-18,-24},{-16,-22},{-14,-18}},
          lineColor={0,0,255},
          fillColor={105,208,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          pattern=LinePattern.None),
        Polygon(
          points={{-26,-30},{-26,-34},{-26,-38},{-26,-40},{-26,-40},{-28,-42},{-30,-42},{-32,-40},{-32,-38},{-30,-36},{-28,-34},{-26,-30}},
          lineColor={0,0,255},
          fillColor={105,208,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          pattern=LinePattern.None),
        Polygon(
          points={{-30,-12},{-30,-16},{-30,-20},{-30,-22},{-30,-22},{-32,-24},{-34,-24},{-36,-22},{-36,-20},{-34,-18},{-32,-16},{-30,-12}},
          lineColor={0,0,255},
          fillColor={105,208,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          pattern=LinePattern.None)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Global parameters for all models depending only on TransiEnt core library.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</p>
</html>"));
end AmbientConditions;
