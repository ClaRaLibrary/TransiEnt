within TransiEnt.Grid.Electrical.SecondaryControl.Check;
model TestAGC_compareActivation "Compares three variants of secondary balancing control activation"
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
  extends TransiEnt.Basics.Icons.Checkmodel;

TransiEnt.Grid.Electrical.SecondaryControl.AGC aGC_ProRata(
    samplePeriod=60,
    startTime=60,
    isExternalTielineSetpoint=true,
    redeclare Activation.ProRataActivation SecondaryControlActivation "Pro Rata Activation") annotation (Placement(transformation(extent={{6,10},{26,30}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{66,-14},{86,6}})));
  Modelica.Blocks.Sources.Constant P_tie_set(k=0) annotation (Placement(transformation(extent={{-58,52},{-38,72}})));
  Modelica.Blocks.Sources.Step P_tie_is(
    height=10e6,
    offset=0,
    startTime=3600) annotation (Placement(transformation(extent={{-58,26},{-38,46}})));
  TransiEnt.Basics.Blocks.Sources.ConstantVectorSource P_res_const(nout=simCenter.generationPark.nDispPlants, k=fill(100e6, P_res_const.nout)) annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  inner TransiEnt.SimCenter  simCenter(         thres=1e-9,
    Td=450,
    useThresh=true,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    redeclare Base.EmptyGenerationPark generationPark(
      index={"Expensive","Even more expensive","Cheap unit"},
      nPlants=3,
      nDispPlants=3,
      P_max={1e9,1e9,1e9},
      P_min={100e6,100e6,100e6},
      P_grad_max_star={10/60,10/60,10/60},
      C_var={20,10,5}))
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
TransiEnt.Grid.Electrical.SecondaryControl.AGC aGC_MeritOrder_var1(
    samplePeriod=60,
    startTime=60,
    isExternalTielineSetpoint=true,
    redeclare Activation.MeritOrderActivation_Var1 SecondaryControlActivation(C_var_pos=simCenter.generationPark.C_var, C_var_neg=simCenter.generationPark.C_var) "Merit Order Activation Var1") annotation (Placement(transformation(extent={{6,-46},{26,-26}})));
TransiEnt.Grid.Electrical.SecondaryControl.AGC aGC_MeritOrder_var2(
    samplePeriod=60,
    startTime=60,
    isExternalTielineSetpoint=true,
    redeclare Activation.MeritOrderActivation_Var2 SecondaryControlActivation(C_var_pos=simCenter.generationPark.C_var, C_var_neg=simCenter.generationPark.C_var) "Merit Order Activation Var2") "Merit order activation with maximum possible gradient" annotation (Placement(transformation(extent={{8,-88},{28,-68}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
equation
  connect(ElectricGrid.epp, aGC_ProRata.epp) annotation (Line(
      points={{66,-4},{16,-4},{16,10}},
      color={0,135,135},
      thickness=0.5));
  connect(aGC_ProRata.P_tie_set, P_tie_set.y) annotation (Line(points={{20.2,30},{20,30},{20,62},{-37,62}},          color={0,0,127}));
  connect(P_tie_is.y, aGC_ProRata.P_tie_is) annotation (Line(points={{-37,36},{12,36},{12,30}},              color={0,0,127}));
  connect(P_res_const.y, aGC_ProRata.P_SB_max_pos) annotation (Line(points={{-37,0},{-8,0},{-8,16},{6.4,16}}, color={0,0,127}));
  connect(P_res_const.y, aGC_ProRata.P_SB_max_neg) annotation (Line(points={{-37,0},{-8,0},{-8,24},{6.4,24}}, color={0,0,127}));
  connect(P_tie_set.y, aGC_MeritOrder_var1.P_tie_set) annotation (Line(points={{-37,62},{-24,62},{-24,-18},{20.2,-18},{20.2,-26}}, color={0,0,127}));
  connect(P_tie_is.y, aGC_MeritOrder_var1.P_tie_is) annotation (Line(points={{-37,36},{-28,36},{-28,-22},{12,-22},{12,-26}}, color={0,0,127}));
  connect(P_res_const.y, aGC_MeritOrder_var1.P_SB_max_neg) annotation (Line(points={{-37,0},{-32,0},{-32,-32},{6.4,-32}}, color={0,0,127}));
  connect(P_res_const.y, aGC_MeritOrder_var1.P_SB_max_pos) annotation (Line(points={{-37,0},{-32,0},{-32,-40},{6.4,-40}}, color={0,0,127}));
  connect(aGC_MeritOrder_var1.epp, ElectricGrid.epp) annotation (Line(
      points={{16,-46},{16,-60},{48,-60},{48,-4},{66,-4}},
      color={0,135,135},
      thickness=0.5));
  connect(aGC_MeritOrder_var2.epp, ElectricGrid.epp) annotation (Line(
      points={{18,-88},{18,-96},{48,-96},{48,-4},{66,-4}},
      color={0,135,135},
      thickness=0.5));
  connect(P_tie_set.y, aGC_MeritOrder_var2.P_tie_set) annotation (Line(points={{-37,62},{-24,62},{-24,-64},{22.2,-64},{22.2,-68}}, color={0,0,127}));
  connect(P_tie_is.y, aGC_MeritOrder_var2.P_tie_is) annotation (Line(points={{-37,36},{-28,36},{-28,-68},{14,-68}}, color={0,0,127}));
  connect(P_res_const.y, aGC_MeritOrder_var2.P_SB_max_neg) annotation (Line(points={{-37,0},{-32,0},{-32,-74},{8.4,-74}}, color={0,0,127}));
  connect(P_res_const.y, aGC_MeritOrder_var2.P_SB_max_pos) annotation (Line(points={{-37,0},{-32,0},{-32,-82},{8.4,-82}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestAGC_compareActivation.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=1, position={0, 0, 793, 817}, y={"P_tie_is.y"}, range={0.0, 7500.0, -1000000.0, 11000000.0}, grid=true, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={0, 0, 793, 406}, y={"simCenter.generationPark.C_var[1]", "simCenter.generationPark.C_var[2]",
"simCenter.generationPark.C_var[3]"}, range={0.0, 7500.0, 4.0, 22.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFile);
createPlot(id=2, position={809, 0, 791, 817}, y={"aGC_ProRata.P_sec_set[1]", "aGC_ProRata.P_sec_set[2]", "aGC_ProRata.P_sec_set[3]",
 "aGC_ProRata.P_sec_set_total"}, range={0.0, 7500.0, -60000000.0, 10000000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}},filename=resultFile);
createPlot(id=2, position={809, 0, 791, 269}, y={"aGC_MeritOrder_var1.P_sec_set[1]", "aGC_MeritOrder_var1.P_sec_set[2]",
"aGC_MeritOrder_var1.P_sec_set[3]", "aGC_MeritOrder_var1.P_sec_set_total"}, range={0.0, 7500.0, -60000000.0, 10000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}},filename=resultFile);
createPlot(id=2, position={809, 0, 791, 269}, y={"aGC_MeritOrder_var2.P_sec_set[1]", "aGC_MeritOrder_var2.P_sec_set[2]",
"aGC_MeritOrder_var2.P_sec_set[3]", "aGC_MeritOrder_var2.P_sec_set_total"}, range={0.0, 7500.0, -60000000.0, 10000000.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
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
end TestAGC_compareActivation;
