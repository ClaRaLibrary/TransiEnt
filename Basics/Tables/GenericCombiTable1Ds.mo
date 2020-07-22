within TransiEnt.Basics.Tables;
model GenericCombiTable1Ds "Parameterized version of MSL's CombiTimeTable."

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
  extends TransiEnt.Basics.Icons.TableIcon;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TransiEnt.Basics.Tables.DataPrivacy datasource=DataPrivacy.isPublic "Source of table data" annotation (
    Evaluate=true,
    HideResult=true,
    Dialog(group="Data location"));

  final parameter String environment_variable_name=if datasource ==DataPrivacy.isPublic              then Types.PUBLIC_DATA else Types.PRIVATE_DATA annotation(Evaluate=true, HideResult=true, Dialog(group="Data location"));

  parameter String relativepath = "" "Path relative to source directory"
                                                                        annotation(Evaluate=true, HideResult=true, Dialog(group="Data location"));

  final parameter String complete_relative_path = Modelica.Utilities.Files.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(environment_variable_name) + relativepath);

  final parameter String genericFileName = complete_relative_path;

  parameter String tablename = "default";

  parameter Integer columns[:]=2:size(combiTable1Ds.table, 2) "columns of table to be interpolated (has to be modified before usage!)";
    // this parameter has to be set manually to a correct value, e.g. {2,3,4} because dymola is not able to evaluate size(combiTable1DS.table) prior to simulation and therefore the check will fail!

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[size(columns,1)]
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(
    tableOnFile=true,
    tableName=tablename,
    fileName=genericFileName,
    columns=columns)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(u, combiTable1Ds.u) annotation (Line(
      points={{-120,0},{-12,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y, combiTable1Ds.y) annotation (Line(
      points={{110,0},{11,0}},
      color={0,0,127},
      smooth=Smooth.None));

   annotation (Icon(graphics), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Generates a table from 1D input data and gives an 1D output.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealInput: u</p>
<p>Modelica RealOutput: y</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end GenericCombiTable1Ds;
