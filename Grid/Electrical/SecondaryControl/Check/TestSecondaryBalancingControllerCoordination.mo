within TransiEnt.Grid.Electrical.SecondaryControl.Check;
model TestSecondaryBalancingControllerCoordination "Example how to calculate the demand of primary balancing power"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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



  extends TransiEnt.Basics.Icons.Checkmodel;
  inner TransiEnt.SimCenter simCenter(
    n_consumers=1,
    P_consumer={300e9},
    T_grid=7.5) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics                    modelStatistics
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Sources.Step P_tie_is1(
    offset=0,
    startTime=10,
    height=-1e9) annotation (Placement(transformation(extent={{-74,32},{-54,52}})));
  Modelica.Blocks.Sources.Constant P_tie_set1(k=0) annotation (Placement(transformation(extent={{-86,0},{-66,20}})));
  Modelica.Blocks.Sources.Step delta_f1(
    offset=0,
    startTime=10,
    height=-0.2) annotation (Placement(transformation(extent={{-94,-36},{-74,-16}})));
  TransiEnt.Grid.Electrical.SecondaryControl.SecondaryBalancingController SecondaryBalancingController1(
    is_singleton=false,
    K_r=1e9/0.2,
    T_r=150,
    beta=0.5) annotation (Placement(transformation(extent={{-54,-46},{-18,-10}})));
  Modelica.Blocks.Sources.Step P_tie_is2(
    offset=0,
    startTime=10,
    height=1e9) annotation (Placement(transformation(extent={{28,24},{48,44}})));
  Modelica.Blocks.Sources.Constant P_tie_set2(k=0) annotation (Placement(transformation(extent={{16,-8},{36,12}})));
  Modelica.Blocks.Sources.Step delta_f2(
    offset=0,
    startTime=10,
    height=-0.2) annotation (Placement(transformation(extent={{8,-46},{28,-26}})));
  TransiEnt.Grid.Electrical.SecondaryControl.SecondaryBalancingController SecondaryBalancingController2(
    is_singleton=false,
    K_r=2e9/0.2,
    beta=0.5,
    T_r=150) annotation (Placement(transformation(extent={{48,-54},{84,-18}})));
equation
  connect(P_tie_is1.y, SecondaryBalancingController1.P_tie_is) annotation (Line(points={{-53,42},{-43.56,42},{-43.56,-11.62}}, color={0,0,127}));
  connect(P_tie_set1.y, SecondaryBalancingController1.P_tie_set) annotation (Line(points={{-65,10},{-56,10},{-56,6},{-50,6},{-50,-11.62},{-52.2,-11.62}}, color={0,0,127}));
  connect(delta_f1.y, SecondaryBalancingController1.u) annotation (Line(points={{-73,-26},{-73,-28},{-57.6,-28}}, color={0,0,127}));
  connect(P_tie_is2.y, SecondaryBalancingController2.P_tie_is) annotation (Line(points={{49,34},{58.44,34},{58.44,-19.62}}, color={0,0,127}));
  connect(P_tie_set2.y, SecondaryBalancingController2.P_tie_set) annotation (Line(points={{37,2},{46,2},{46,-2},{52,-2},{52,-19.62},{49.8,-19.62}}, color={0,0,127}));
  connect(delta_f2.y, SecondaryBalancingController2.u) annotation (Line(points={{29,-36},{29,-36},{44.4,-36}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestSecondaryBalancingControllerCoordination.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={0, 0, 1616, 851}, y={"delta_f1.y", "delta_f2.y"}, range={0.0, 20.0, -0.25, 0.050000000000000044}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  createPlot(id=1, position={0, 0, 1616, 281}, y={"P_tie_is1.y", "P_tie_is2.y"}, range={0.0, 20.0, -1500000000.0, 1500000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  createPlot(id=1, position={0, 0, 1616, 280}, y={"SecondaryBalancingController1.y", "SecondaryBalancingController2.y"}, range={0.0, 20.0, -2000000000.0, 500000000.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestSecondaryBalancingControllerCoordination;
