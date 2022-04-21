within TransiEnt.Basics.Tables.Combined.CombinedTables;
model Demand_3Tables "Three seperate tables for load profile data: electricity demand, heat demand for heating, heat demand for hot water"



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

  extends TransiEnt.Basics.Tables.Combined.CombinedTables.Base.Demand_combined;


  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //              Parameters
  // _____________________________________________

  parameter Real heatDemand=1 "scaling factor for space heating demand of the consumer" annotation (Dialog(group="Scaling"));

  parameter Real waterDemand=1 "scaling factor for warm water demand of the consumer" annotation (Dialog(group="Scaling"));

  parameter Real electricityDemand=1 "scaling factor for electricity demand of the consumer" annotation (Dialog(group="Scaling"));

  parameter DataPrivacy datasource_el=DataPrivacy.isPublic "Source of electricity table data"   annotation (
    Evaluate=true,
    HideResult=true,
    Dialog(enable=not use_absolute_path_el, group="Data location"));

  parameter DataPrivacy datasource_heating=DataPrivacy.isPublic "Source of heating table data"   annotation (
    Evaluate=true,
    HideResult=true,
    Dialog(enable=not use_absolute_path_heating, group="Data location"));

  parameter DataPrivacy datasource_dhw=DataPrivacy.isPublic "Source of domestic hot water table data"   annotation (
    Evaluate=true,
    HideResult=true,
    Dialog(enable=not use_absolute_path_dhw, group="Data location"));

  final parameter String environment_variable_name_el=if datasource_el ==DataPrivacy.isPublic then Types.PUBLIC_DATA else Types.PRIVATE_DATA  annotation(Evaluate=true, HideResult=true, Dialog(enable=not use_absolute_path, group="Data location"));
  final parameter String environment_variable_name_heating=if datasource_dhw ==DataPrivacy.isPublic then Types.PUBLIC_DATA else Types.PRIVATE_DATA  annotation(Evaluate=true, HideResult=true, Dialog(enable=not use_absolute_path, group="Data location"));
  final parameter String environment_variable_name_dhw=if datasource_heating ==DataPrivacy.isPublic then Types.PUBLIC_DATA else Types.PRIVATE_DATA  annotation(Evaluate=true, HideResult=true, Dialog(enable=not use_absolute_path, group="Data location"));

  parameter String relativepath_el="electricity/Household/ElectricityDemand_20Households_measured_3-4MWh_3600s.csv"
                                    annotation(Evaluate=true, HideResult=true, Dialog(enable=not use_absolute_path_el,
                                                                                                                    group="Data location"),choices(choice="electricity/Household/ElectricityDemand_20Households_measured_3-4MWh_3600s.csv"
                                                                                                                                                                                           "Measured electric load profiles from HTW Berlin with 3-4MWh/a",
                                                       choice="electricity/Household/ElectricityDemand_20Households_measured_4-5MWh_3600s.csv"                                             "Measured electric load profiles from HTW Berlin with 4-5MWh/a",
                                                       choice="electricity/Household/ElectricityDemand_20Households_measured_5-6MWh_3600s.csv" "Measured electric load profiles from HTW Berlin with 4-6 MWh/a"));

  parameter String relativepath_heating="heat/Household/Heating_20Households_simulated_6MWh_3600s.csv" annotation(Evaluate=true, HideResult=true, Dialog(enable=not use_absolute_path_heating, group="Data location"),choices(
                                               choice="heat/Household/Heating_SLP_TMY-Hamburg_HEF_10MWh_3600s.txt" "SLP with TMY Hamburg weather data and 10 MWh yearly heating demand",
                                               choice="heat/Household/Heating_SLP_TMY-Hamburg_HMF_35MWh_3600s.txt" "SLP with TMY Hamburg weather data and 35 MWh yearly heating demand",
                                               choice="heat/Household/Heating_20Households_simulated_6MWh_3600s.csv" "Simulated heating demand with 6MWh yearly demand"));

  parameter String relativepath_dhw="heat/Household/HotWater_VDI4655_60s.txt" annotation(Evaluate=true, HideResult=true, Dialog(enable=not use_absolute_path_dhw, group="Data location"),choices(
                                               choice="heat/Household/HotWater_VDI4655_60s.txt" "Hot water profile from VDI 4655",
                                               choice="heat/Household/HotWater_20Households_VEDIS_1.5MWh_60s.txt" "Stochastic profile from VEDIS tool, 1.5 MWh yearly demand",
                                               choice="heat/Household/HotWater_20Households_VEDIS_3MWh_60s.txt" "Stochastic profile from VEDIS tool, 3 MWh yearly demand"));

  parameter Boolean use_absolute_path_el = false "Should only be used for testing purposes" annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true), Dialog(group="Data location"));
  parameter Boolean use_absolute_path_heating = false "Should only be used for testing purposes" annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true), Dialog(group="Data location"));
  parameter Boolean use_absolute_path_dhw = false "Should only be used for testing purposes" annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true), Dialog(group="Data location"));

  parameter String absolute_path_el = ""  annotation(Evaluate=true, HideResult=true, Dialog(enable=use_absolute_path_el, group="Data location"));
  parameter String absolute_path_heating = ""  annotation(Evaluate=true, HideResult=true, Dialog(enable=use_absolute_path_heating, group="Data location"));
  parameter String absolute_path_dhw = ""  annotation(Evaluate=true, HideResult=true, Dialog(enable=use_absolute_path_dhw, group="Data location"));

  parameter String tableName_el="default" annotation (Dialog(group="Basics"));
  parameter String tableName_heating="default" annotation (Dialog(group="Basics"));
  parameter String tableName_dhw="default" annotation (Dialog(group="Basics"));

  parameter Integer consumer_count=1 "Starting number of the table columns";

  final parameter Integer columns_el[:]={consumer_count+1} "Columns of electricity table to be interpolated";
  final parameter Integer columns_heating[:]={consumer_count+1} "Columns of heating table to be interpolated";
  final parameter Integer columns_dhw[:]={consumer_count+1} "Columns of domestic hot water table to be interpolated";

  parameter Modelica.Blocks.Types.Smoothness smoothness=simCenter.tableInterpolationSmoothness "Smoothness of table interpolation" annotation (Dialog(group="Table data interpretation"));

  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints "Extrapolation of data outside the definition range" annotation (Dialog(group="Table data interpretation"));

  final parameter String complete_relative_path_el = Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(environment_variable_name_el) + relativepath_el);
  final parameter String complete_relative_path_heating = Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(environment_variable_name_heating) + relativepath_heating);
  final parameter String complete_relative_path_dhw = Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(environment_variable_name_dhw) + relativepath_dhw);

  final parameter String genericFileName_el = if use_absolute_path_el then absolute_path_el else complete_relative_path_el;
  final parameter String genericFileName_heating = if use_absolute_path_heating then absolute_path_heating else complete_relative_path_heating;
  final parameter String genericFileName_dhw = if use_absolute_path_dhw then absolute_path_dhw else complete_relative_path_dhw;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable_el(
    tableOnFile=true,
    smoothness=smoothness,
    offset={0},
    startTime=0,
    tableName=tableName_el,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName=complete_relative_path_el,
    columns=columns_el) annotation (Placement(transformation(extent={{-92,44},{-48,88}})));

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable_heating(
    tableOnFile=true,
    smoothness=smoothness,
    offset={0},
    startTime=0,
    tableName=tableName_heating,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName=complete_relative_path_heating,
    columns=columns_heating) annotation (Placement(transformation(extent={{-92,-20},{-48,24}})));

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable_dhw(
    tableOnFile=true,
    smoothness=smoothness,
    offset={0},
    startTime=0,
    tableName=tableName_dhw,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    fileName=complete_relative_path_dhw,
    columns=columns_dhw) annotation (Placement(transformation(extent={{-92,-82},{-48,-38}})));

  Modelica.Blocks.Math.Gain gain(k=waterDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-24,-60})));
  Modelica.Blocks.Math.Gain gain1(k=heatDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-22,2})));
  Modelica.Blocks.Math.Gain gain2(k=electricityDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-20,66})));

equation
 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  connect(combiTimeTable_el.y[1], gain2.u) annotation (Line(points={{-45.8,66},{-32,66}}, color={0,0,127}));
  connect(combiTimeTable_heating.y[1], gain1.u) annotation (Line(points={{-45.8,2},{-34,2}}, color={0,0,127}));
  connect(combiTimeTable_dhw.y[1], gain.u) annotation (Line(points={{-45.8,-60},{-36,-60}}, color={0,0,127}));
  connect(gain.y, demand.hotWaterPowerDemand) annotation (Line(points={{-13,-60},{0,-60},{0,-100},{-4,-100},{-4,-103.6}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(gain1.y, demand.heatingPowerDemand) annotation (Line(points={{-11,2},{0,2},{0,-103.6}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(gain2.y, demand.electricPowerDemand) annotation (Line(points={{-9,66},{0,66},{0,-104},{3.9,-104},{3.9,-103.6}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Contains three different tables for load profile data for electricity, space heating and drinking hot water demand. Load profiles can be scaled using the scaling factors. The model can be used in the Basic_Grid_Element.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Michael Djukow, GWI, in 2018</span></p>
</html>"));
end Demand_3Tables;
