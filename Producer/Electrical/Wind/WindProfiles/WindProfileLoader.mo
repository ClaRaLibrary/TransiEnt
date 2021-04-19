within TransiEnt.Producer.Electrical.Wind.WindProfiles;
model WindProfileLoader "Loads wind profiles from csv files for 2011-2015, scaled by installed power.
  
  Data for 2011-2014 is scaled by total installed power at end of the year.
  Data for 2015 is scaled monthly by total installed power at end of corresponding month.
  
  'Power curve' refers to simulation data based on wind measurements from Deutscher Wetterdienst, 
  'Measured Data' refers to wind power generation measured by the TSOs"

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
  import TransiEnt;
  extends TransiEnt.Basics.Tables.GenericDataTable(
                                                 final relativepath="electricity/REProfiles/" + String(REProfile) + ".txt",
      final datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
                                                                  final tableName="default", final multiple_outputs = false, final columns=2:2, final use_absolute_path = false, final absolute_path="", constantfactor = P_el_n);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData REProfile=TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData.Wind2015_Gesamt_900s "Profile used as datasource";

  parameter SI.Power P_el_n=1 "Scales to power production measured every 15min";
  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Upload various wind profiles. Energy generation can be simulated by entering the installed wind power as a parameter.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Adjusted from SLPLoader Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on 06.04.2016</span></p>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{44,-12},{62,-22},{52,-42},{32,-36},{38,-26},{44,-12}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,8},{24,0},{12,-28},{-6,-22},{0,-12},{8,8}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{24,0},{44,-12},{32,-36},{12,-28},{14,-22},{24,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{44,-20},{66,-42}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Ellipse(
          extent={{22,-10},{50,-36}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-2,2},{32,-28}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Polygon(
          points={{-16,22},{8,8},{-6,-22},{-26,-16},{-22,-10},{-16,22}},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-18,10},{16,-22}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-38,24},{-10,-16}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Polygon(
          points={{-38,34},{-16,22},{-26,-16},{-52,-8},{-52,20},{-38,34}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-68,38},{-30,-8}},
          lineColor={184,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Sphere),
        Ellipse(
          extent={{-68,38},{-30,-8}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Polygon(
          points={{44,-12},{62,-22},{52,-42},{32,-36},{38,-26},{44,-12}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,8},{24,0},{12,-28},{-6,-22},{0,-12},{8,8}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{24,0},{44,-12},{32,-36},{12,-28},{14,-22},{24,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{44,-20},{66,-42}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Ellipse(
          extent={{22,-10},{50,-36}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-2,2},{32,-28}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Polygon(
          points={{-16,22},{8,8},{-6,-22},{-26,-16},{-22,-10},{-16,22}},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-18,10},{16,-22}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-38,24},{-10,-16}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Polygon(
          points={{-38,34},{-16,22},{-26,-16},{-52,-8},{-52,20},{-38,34}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-70,40},{-28,-10}},
          lineColor={184,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Sphere)}),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end WindProfileLoader;
