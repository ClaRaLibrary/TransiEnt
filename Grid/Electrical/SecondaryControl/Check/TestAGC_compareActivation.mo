within TransiEnt.Grid.Electrical.SecondaryControl.Check;
model TestAGC_compareActivation "Compares three variants of secondary balancing control activation"
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  extends TransiEnt.Basics.Icons.Checkmodel;

TransiEnt.Grid.Electrical.SecondaryControl.AGC aGC_ProRata(
    samplePeriod=60,
    startTime=60,
    isExternalTielineSetpoint=true,
    redeclare Activation.ProRataActivation SecondaryControlActivation "Pro Rata Activation") annotation (Placement(transformation(extent={{6,18},{26,38}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(extent={{66,-6},{86,14}})));
  Modelica.Blocks.Sources.Constant P_tie_set(k=0) annotation (Placement(transformation(extent={{-58,60},{-38,80}})));
  Modelica.Blocks.Sources.Step P_tie_is(
    height=10e6,
    offset=0,
    startTime=3600) annotation (Placement(transformation(extent={{-58,34},{-38,54}})));
  TransiEnt.Basics.Blocks.Sources.ConstantVectorSource P_res_const(nout=simCenter.generationPark.nDispPlants, k=fill(100e6, P_res_const.nout)) annotation (Placement(transformation(extent={{-58,-2},{-38,18}})));
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
    redeclare Activation.MeritOrderActivation_Var1 SecondaryControlActivation(C_var_pos=simCenter.generationPark.C_var, C_var_neg=simCenter.generationPark.C_var) "Merit Order Activation Var1") annotation (Placement(transformation(extent={{6,-38},{26,-18}})));
TransiEnt.Grid.Electrical.SecondaryControl.AGC aGC_MeritOrder_var2(
    samplePeriod=60,
    startTime=60,
    isExternalTielineSetpoint=true,
    redeclare Activation.MeritOrderActivation_Var2 SecondaryControlActivation(C_var_pos=simCenter.generationPark.C_var, C_var_neg=simCenter.generationPark.C_var) "Merit Order Activation Var2") "Merit order activation with maximum possible gradient" annotation (Placement(transformation(extent={{8,-80},{28,-60}})));
equation
  connect(ElectricGrid.epp, aGC_ProRata.epp) annotation (Line(
      points={{65.9,3.9},{16,3.9},{16,18}},
      color={0,135,135},
      thickness=0.5));
  connect(aGC_ProRata.P_tie_set, P_tie_set.y) annotation (Line(points={{20.2,38},{20,38},{20,44},{20,70},{-37,70}},  color={0,0,127}));
  connect(P_tie_is.y, aGC_ProRata.P_tie_is) annotation (Line(points={{-37,44},{-30,44},{12,44},{12,38}},     color={0,0,127}));
  connect(P_res_const.y, aGC_ProRata.P_SB_max_pos) annotation (Line(points={{-37,8},{-8,8},{-8,24},{6.4,24}}, color={0,0,127}));
  connect(P_res_const.y, aGC_ProRata.P_SB_max_neg) annotation (Line(points={{-37,8},{-8,8},{-8,32},{6.4,32}}, color={0,0,127}));
  connect(P_tie_set.y, aGC_MeritOrder_var1.P_tie_set) annotation (Line(points={{-37,70},{-24,70},{-24,-10},{20.2,-10},{20.2,-18}}, color={0,0,127}));
  connect(P_tie_is.y, aGC_MeritOrder_var1.P_tie_is) annotation (Line(points={{-37,44},{-28,44},{-28,-14},{12,-14},{12,-18}}, color={0,0,127}));
  connect(P_res_const.y, aGC_MeritOrder_var1.P_SB_max_neg) annotation (Line(points={{-37,8},{-32,8},{-32,-24},{6.4,-24}}, color={0,0,127}));
  connect(P_res_const.y, aGC_MeritOrder_var1.P_SB_max_pos) annotation (Line(points={{-37,8},{-32,8},{-32,-32},{6.4,-32}}, color={0,0,127}));
  connect(aGC_MeritOrder_var1.epp, ElectricGrid.epp) annotation (Line(
      points={{16,-38},{16,-52},{48,-52},{48,3.9},{65.9,3.9}},
      color={0,135,135},
      thickness=0.5));
  connect(aGC_MeritOrder_var2.epp, ElectricGrid.epp) annotation (Line(
      points={{18,-80},{18,-80},{18,-88},{48,-88},{48,3.9},{65.9,3.9}},
      color={0,135,135},
      thickness=0.5));
  connect(P_tie_set.y, aGC_MeritOrder_var2.P_tie_set) annotation (Line(points={{-37,70},{-24,70},{-24,-56},{22.2,-56},{22.2,-60}}, color={0,0,127}));
  connect(P_tie_is.y, aGC_MeritOrder_var2.P_tie_is) annotation (Line(points={{-37,44},{-28,44},{-28,-60},{14,-60}}, color={0,0,127}));
  connect(P_res_const.y, aGC_MeritOrder_var2.P_SB_max_neg) annotation (Line(points={{-37,8},{-32,8},{-32,-66},{8.4,-66}}, color={0,0,127}));
  connect(P_res_const.y, aGC_MeritOrder_var2.P_SB_max_pos) annotation (Line(points={{-37,8},{-32,8},{-32,-74},{8.4,-74}}, color={0,0,127}));
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestAGC_compareActivation;
