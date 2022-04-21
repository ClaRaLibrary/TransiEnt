within TransiEnt.Basics.Tables.Combined.CombinedTables;
model Demand_Table_combined "Table with combined load profile data for consumer: y[1]=electricity demand, y[2]=heat demand for heating, y[3] = heat demand for hot water"



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

  parameter Integer consumer_count=1 "Starting number of the table column group";

  parameter Real heatDemand=1 "scaling factor for space heating demand of the consumer";

  parameter Real waterDemand=1 "scaling factor for warm water demand of the consumer";

  parameter Real electricityDemand=1 "scaling factor for electricity demand of the consumer";

  parameter DataPrivacy datasource=DataPrivacy.isPublic "Source of electricity table data"   annotation (
    Evaluate=true,
    HideResult=true,
    Dialog(enable=not use_absolute_path, group="Data location"));

  final parameter String environment_variable_name=if datasource ==DataPrivacy.isPublic then Types.PUBLIC_DATA else Types.PRIVATE_DATA  annotation(Evaluate=true, HideResult=true, Dialog(enable=not use_absolute_path, group="Data location"));

  parameter String relativepath="combined/DemandCombined_3Consumers_60s.csv"
                                    annotation(Evaluate=true, HideResult=true, Dialog(enable=not use_absolute_path_el,
                                                                                                                    group="Data location"),choices(choice="combined/DemandCombined_3Consumers_60s.csv"
                                                                                                                                                                                           "Combined Table for 3 Households"));


  parameter Boolean use_absolute_path = false "Should only be used for testing purposes" annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true), Dialog(group="Data location"));
  parameter String absolute_path = ""  annotation(Evaluate=true, HideResult=true, Dialog(enable=use_absolute_path, group="Data location"));

  parameter String tableName="default" annotation (Dialog(group="Basics"));

  parameter Integer columns[:]={3*consumer_count - 1,3*consumer_count,3*consumer_count + 1} "Columns of table to be interpolated" annotation (Dialog(group="Basics"));

  parameter Modelica.Blocks.Types.Smoothness smoothness=simCenter.tableInterpolationSmoothness "Smoothness of table interpolation" annotation (Dialog(group="Table data interpretation"));

  parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints "Extrapolation of data outside the definition range" annotation (Dialog(group="Table data interpretation"));

  final parameter String complete_relative_path = Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(environment_variable_name) + relativepath);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    fileName=complete_relative_path,
    smoothness=smoothness,
    columns= columns,
    offset={0},
    startTime=0,
    tableName=tableName,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-84,16},{-40,60}})));

  Modelica.Blocks.Math.Gain gain(k=waterDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={48,-42})));
  Modelica.Blocks.Math.Gain gain1(k=heatDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={2,-44})));
  Modelica.Blocks.Math.Gain gain2(k=electricityDemand) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-36,-44})));

equation

 // _____________________________________________
 //
 //            Connect statements
 // _____________________________________________

  connect(combiTimeTable.y[1], gain2.u) annotation (Line(points={{-37.8,38},{-32,38},{-32,-32},{-36,-32}}, color={0,0,127}));
  connect(combiTimeTable.y[2], gain1.u) annotation (Line(points={{-37.8,38},{2,38},{2,-32}}, color={0,0,127}));
  connect(combiTimeTable.y[3], gain.u) annotation (Line(points={{-37.8,38},{48,38},{48,-30}}, color={0,0,127}));
  connect(gain2.y, demand.electricPowerDemand) annotation (Line(points={{-36,-55},{-36,-90},{3.9,-90},{3.9,-103.6}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(gain1.y, demand.heatingPowerDemand) annotation (Line(points={{2,-55},{0,-55},{0,-103.6}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(gain.y, demand.hotWaterPowerDemand) annotation (Line(points={{48,-53},{48,-86},{-4,-86},{-4,-103.6}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Contains one combined table for load profile data for electricity, space heating and drinking hot water demand. Load profiles can be scaled using the three scaling factors. The model can be used in the Basic_Grid_Element.</p>
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
<p>The data in the given data-file has to have the following structure:</p>
<p>First coulumn contains the time vector. This vector is followed by groups of three columns. First column of these groups has to contain the electricity demand, second column the space heating demand and third column the drinking hot water demand, all of the same household.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end Demand_Table_combined;
