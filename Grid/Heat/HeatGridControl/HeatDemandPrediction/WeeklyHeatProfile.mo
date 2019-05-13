within TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction;
model WeeklyHeatProfile "Normalized typical daily load profile is applied to input heat demand"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
    extends Basics.Icons.Block;
//   type Season = enumeration(
//       Winter "Typical winter profile",
//       Summer "Typical summer profile");
//   parameter Season season = Season.Winter "Choose season to load typical profile";

//   final parameter String name = if season==Season.Summer then "Summer" else "Winter";
//   final parameter String profilepath2 = "/heat/DistrictHeatingWeeklyHeatProfile" + String(season) +"_900s.txt";
//   final parameter String profilepath = "heat/DistrictHeatingWeeklyHeatProfileSummer_900s.txt";

  parameter SI.Time t_start_week = 6*86400 "Time between simulation start and first monday (e.g. first day is a sunday)";
  parameter SI.Time t_hp_end = 12441600 "End of heating period in Hamburg in 2012 according to http://ecowetter.de/ort/heizgradtage/hamburg/2012.html";
  parameter SI.Time t_hp_start = 22982400 "End of heating period in Hamburg in 2012 according to http://ecowetter.de/ort/heizgradtage/hamburg/2012.html";

  // _____________________________________________
  //
  //                  Components
  // _____________________________________________

  Basics.Tables.GenericCombiTable1Ds weeklyProfile_Winter(
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
    tablename="default",
    columns={2},
    relativepath="heat/DistrictHeatingWeeklyHeatProfileWinter_900s.txt") "H. Gadd and S. Werner, “Heat load patterns in district heating substations,” Appl. Energy, vol. 108, pp. 176–183, 2013." annotation (Placement(transformation(extent={{-38,-46},{-18,-26}})));
  Basics.Blocks.Sources.SawTooth second_in_week(
    period=604800,
    amplitude=604800,
    startTime=t_start_week) annotation (Placement(transformation(extent={{-76,-46},{-56,-26}})));
  Modelica.Blocks.Math.Product product annotation (Placement(transformation(extent={{46,-10},{66,10}})));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_raw "Heat flow rate input" annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow "Heat flow rate output" annotation (Placement(transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-20},{140,20}})));
//  parameter SI.Time Ts_in=2*24*3600 "Sample period of input signal (2*24*3600 = 2-days average)";
  Basics.Tables.GenericCombiTable1Ds weeklyProfile_Summer(
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
    tablename="default",
    columns={2},
    relativepath="heat/DistrictHeatingWeeklyHeatProfileSummer_900s.txt") "H. Gadd and S. Werner, “Heat load patterns in district heating substations,” Appl. Energy, vol. 108, pp. 176–183, 2013." annotation (Placement(transformation(extent={{-38,-74},{-18,-54}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(extent={{18,-30},{38,-10}})));
  Modelica.Blocks.Sources.BooleanExpression isHeatingPeriod(y=time < t_hp_end or time >= t_hp_start)
                                                                                                    annotation (Placement(transformation(extent={{-40,22},{-20,42}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(second_in_week.y, weeklyProfile_Winter.u) annotation (Line(points={{-55,-36},{-55,-36},{-40,-36}}, color={0,0,127}));
  connect(Q_flow_raw, product.u1) annotation (Line(points={{-120,0},{-80,0},{-80,6},{44,6}},   color={0,0,127}));
  connect(second_in_week.y, weeklyProfile_Summer.u) annotation (Line(points={{-55,-36},{-50,-36},{-50,-64},{-40,-64}}, color={0,0,127}));
  connect(weeklyProfile_Winter.y[1], switch1.u1) annotation (Line(points={{-17,-36},{-8,-36},{-8,-12},{16,-12}}, color={0,0,127}));
  connect(weeklyProfile_Summer.y[1], switch1.u3) annotation (Line(points={{-17,-64},{0,-64},{0,-28},{16,-28}}, color={0,0,127}));
  connect(isHeatingPeriod.y, switch1.u2) annotation (Line(points={{-19,32},{-14,32},{-14,-20},{16,-20}}, color={255,0,255}));
  connect(switch1.y, product.u2) annotation (Line(points={{39,-20},{40,-20},{40,-6},{44,-6}}, color={0,0,127}));
  connect(product.y, Q_flow) annotation (Line(points={{67,0},{120,0},{120,0}}, color={0,0,127}));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-78,78},{-74.2,77.8},{-68.6,74.6},{-62.9,67.7},{-57.3,57.4},{-50.9,42.1},{-42.83,19.2},{-25.9,-32.8},{-18.7,-52.2},{-12.3,-66.2},{-6.7,-75.1},{-1,-80.4},{4.6,-82},{10.2,-79.6},{15.9,-73.5},{21.5,-63.9},{27.9,-49.2},{36,-26.8},{44,-2}},
                                                            color={255,0,0},
                                                                           smooth=Smooth.Bezier),
        Line(points={{44,-1},{55.3,33.2},{62.5,52.1},{68.9,65.4},{74.6,73.6},{80.2,78.1},{85.8,78.8}},
                                       color={255,0,0}),
        Line(points={{-88,-2},{70,-2}},
                                      color={192,192,192}),
        Polygon(
          points={{92,-2},{70,6},{70,-10},{92,-2}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-78,66},{-78,-82}}, color={192,192,192}),
        Polygon(
          points={{-78,88},{-86,66},{-70,66},{-78,88}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">DailyHeatProfile</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. General Description</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The profile ist taken from </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] H. Gadd and S. Werner, &ldquo;Heat load patterns in district heating substations,&rdquo; Appl. Energy, vol. 108, pp. 176&ndash;183, 2013.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">... scaled to its mean value and multiplied to the input profile such that the energy consumption (in MWh) is conserved. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See: TransiEnt.Distribution.Heat.HeatGridControl.Check.<b>TestDailyHeatProfile </b>for how this work</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Only the profile for December - February has been taken. TODO: Digitize all others from Figure 1 and apply accordingly</span></p>
</html>"));
end WeeklyHeatProfile;
