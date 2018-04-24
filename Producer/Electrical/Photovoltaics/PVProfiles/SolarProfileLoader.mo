within TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles;
model SolarProfileLoader "Loads PV profiles from csv files for 2011, 2012, 2014 and 2015
 'Meassured Data' refers to wind power generation meassured by the TSOs"

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
  import TransiEnt;
  extends TransiEnt.Basics.Tables.GenericDataTable(
                                                 final relativepath="electricity/REProfiles/" + String(REProfile) + ".txt",
      final datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
                                                                  final tableName="default", final multiple_outputs = false, final columns=2:2, final use_absolute_path = false, final absolute_path="", constantfactor = P_el_n);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarData REProfile=TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarData.Solar2012_TenneT_900s "Profile used as datasource";

  parameter SI.Power P_el_n=1 "Scales to power production measured every 15min";

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Upload various PV profiles. Energy generation can be simulated by entering the installed PV power as a parameter.</span></p>
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
          points={{0,48},{82,48},{26,-60},{-60,-60},{0,48}},
          smooth=Smooth.None,
          fillColor={0,96,141},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{14,48},{-42,-60}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{32,48},{-24,-60}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{48,48},{-8,-60}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{64,48},{8,-60}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{-4,36},{78,36}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-16,18},{66,18}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-28,-2},{54,-2}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-36,-22},{46,-22}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-50,-44},{32,-44}},
          color={255,255,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{-30,58},{-76,12}},
          lineColor={255,128,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end SolarProfileLoader;
