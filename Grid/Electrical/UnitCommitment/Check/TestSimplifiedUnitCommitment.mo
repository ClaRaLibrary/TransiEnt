within TransiEnt.Grid.Electrical.UnitCommitment.Check;
model TestSimplifiedUnitCommitment
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  inner SimCenter            simCenter(         thres=1e-9,
    Td=450,
    useThresh=true,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    redeclare Examples.Hamburg.ExampleGenerationPark2035 generationPark)
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  BinaryScheduleDataTable UC(
    P_init=P_init_set.k,
    unit_mustrun=fill(false, simCenter.generationPark.nDispPlants),
    unit_blocked=cat(
        1,
        fill(false, simCenter.generationPark.nDispPlants - 2),
        {true,true}),
    reserveAllocation(
      relativepath="electricity/UnitCommitmentSchedules/ReservePowerCommitmentSchedule_3600s_REF35.txt",
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      use_absolute_path=false),
    schedule(
      BC=5,
      CCP=6,
      GT1=7,
      GT2=8,
      GT3=9,
      OIL=10,
      GAR=11,
      BM=12,
      PS=13,
      PS_Pump=14,
      ROH=17,
      PV=18,
      WindOn=19,
      WindOff=20,
      Curt=15,
      Import=16,
      relativepath="electricity/UnitCommitmentSchedules/UnitCommitmentSchedule_3600s_smoothed_REF35.txt",
      use_absolute_path=false,
      smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1,
      columns=(2:simCenter.generationPark.nPlants + 1)),
    t_start=0)                                           annotation (Placement(transformation(extent={{-20,14},{0,34}})));
  Modelica.Blocks.Sources.RealExpression P_load(y=-sum(UC.schedule.y[simCenter.generationPark.isMOD])) annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Basics.Blocks.Sources.ConstantVectorSource P_init_set(nout=simCenter.generationPark.nPlants, k={0.00,184844600.00,0.00,264596300.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,65349610.00,67121080.00,-0.00,-0.00,0.00,45750000.00,0.00,436034500.00,176187200.00}) annotation (Placement(transformation(extent={{-88,-32},{-68,-12}})));
  EconomicDispatch.MeritOrderDispatcher meritOrderDispatcher_externalUC(P_init=P_init_set.k[simCenter.generationPark.isMOD], ntime=discretizePrediction.ntime) annotation (Placement(transformation(extent={{18,34},{38,54}})));
  EconomicDispatch.DiscretizePrediction
                       discretizePrediction(t_shift=0, samplePeriod=900)
                                                       annotation (Placement(transformation(extent={{-52,34},{-36,50}})));
  Modelica.Blocks.Math.Sum               P_gen_externalUC(nin=simCenter.generationPark.nMODPlants)
                                                     annotation (Placement(transformation(extent={{50,36},{68,54}})));
  SimplifiedUnitCommitment simplifiedUnitCommitment(P_init=P_init_set.k[simCenter.generationPark.isMOD])
                                                    annotation (Placement(transformation(extent={{-16,-84},{4,-64}})));
  Modelica.Blocks.Math.Sum               P_gen_simpleUC(nin=simCenter.generationPark.nMODPlants)
                                                        annotation (Placement(transformation(extent={{42,-55},{60,-37}})));
  EconomicDispatch.MeritOrderDispatcher meritOrderDispatcher_simpleUC(P_init=P_init_set.k[simCenter.generationPark.isMOD], ntime=discretizePrediction.ntime) annotation (Placement(transformation(extent={{10,-56},{30,-36}})));
  Basics.Blocks.Sources.ConstantVectorSource P_R(nout=simCenter.generationPark.nMODPlants, k=cat(
        1,
        {0,0,0,11e6},
        fill(0, simCenter.generationPark.nMODPlants - 4))) "Reserve constraints are set constant" annotation (Placement(transformation(extent={{-26,-32},{-12,-18}})));
equation
  connect(UC.P_sec_pos[simCenter.generationPark.isMOD], meritOrderDispatcher_externalUC.P_R_pos) annotation (Line(points={{1.3,21.4},{8,21.4},{8,62},{24,62},{24,56}}, color={0,0,127}));
  connect(UC.P_sec_neg[simCenter.generationPark.isMOD], meritOrderDispatcher_externalUC.P_R_neg) annotation (Line(points={{1.3,16.8},{6,16.8},{6,66},{32,66},{32,56}}, color={0,0,127}));
  connect(discretizePrediction.P_predictions, meritOrderDispatcher_externalUC.u) annotation (Line(points={{-35.2,42},{-35.2,44},{16,44}}, color={0,0,127}));
  connect(P_load.y, discretizePrediction.P_is) annotation (Line(points={{-67,0},{-60,0},{-60,42},{-53.6,42}}, color={0,0,127}));
  connect(P_load.y, discretizePrediction.P_prediction) annotation (Line(points={{-67,0},{-67,0},{-60,0},{-60,58},{-44,58},{-44,51.6}},
                                                                                                                                     color={0,0,127}));
  connect(UC.z[simCenter.generationPark.isMOD], meritOrderDispatcher_externalUC.z) annotation (Line(points={{1.3,28},{28,28},{28,32}}, color={255,0,255}));
  connect(meritOrderDispatcher_externalUC.y, P_gen_externalUC.u) annotation (Line(points={{39,44},{48.2,44},{48.2,45}}, color={0,0,127}));
  connect(simplifiedUnitCommitment.P_loadpred, P_load.y) annotation (Line(points={{-16,-74},{-28,-74},{-28,0},{-67,0}}, color={0,0,127}));
  connect(simplifiedUnitCommitment.z, meritOrderDispatcher_simpleUC.z) annotation (Line(points={{4.8,-74},{20,-74},{20,-58}}, color={255,0,255}));
  connect(discretizePrediction.P_predictions, meritOrderDispatcher_simpleUC.u) annotation (Line(points={{-35.2,42},{-28,42},{-28,-46},{8,-46}}, color={0,0,127}));
  connect(meritOrderDispatcher_simpleUC.y, P_gen_simpleUC.u) annotation (Line(points={{31,-46},{40.2,-46}}, color={0,0,127}));
  connect(P_R.y, meritOrderDispatcher_simpleUC.P_R_pos) annotation (Line(points={{-11.3,-25},{16,-25},{16,-34}}, color={0,0,127}));
  connect(P_R.y, meritOrderDispatcher_simpleUC.P_R_neg) annotation (Line(points={{-11.3,-25},{24,-25},{24,-34}}, color={0,0,127}));
  connect(P_R.y, simplifiedUnitCommitment.P_R_pos) annotation (Line(points={{-11.3,-25},{-10,-25},{-10,-44},{-10,-62}}, color={0,0,127}));
  connect(P_R.y, simplifiedUnitCommitment.P_R_neg) annotation (Line(points={{-11.3,-25},{-2,-25},{-2,-62}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestSimplifiedUnitCommitment.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=4, position={0, 0, 1615, 703}, y={"P_load.y","P_gen_externalUC.y", "P_gen_simpleUC.y"}, range={0.0, 88000.0, 200000000.0, 500000000.0}, grid=true, colors={{140,140,140},{28,108,200}, {238,46,47}}, thicknesses={1.0,0.5, 0.5}, filename=resultFileName);
  createPlot(id=4, position={0, 0, 1615, 172}, y={"meritOrderDispatcher_externalUC.C_var_total", "meritOrderDispatcher_simpleUC.C_var_total"}, range={0.0, 88000.0, -50.0, 100.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
  createPlot(id=4, position={0, 0, 1615, 171}, y={"meritOrderDispatcher_simpleUC.z[9]", "meritOrderDispatcher_simpleUC.z[5]",
  "meritOrderDispatcher_simpleUC.z[4]", "meritOrderDispatcher_simpleUC.z[2]",
  "meritOrderDispatcher_simpleUC.z[1]"}, range={0.0, 88000.0, -0.5, 1.5}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}}, filename=resultFileName);
  createPlot(id=4, position={0, 0, 1615, 171}, y={"meritOrderDispatcher_externalUC.z[2]", "meritOrderDispatcher_externalUC.z[4]"}, range={0.0, 88000.0, 0.8, 1.2000000000000002}, grid=true, subPlot=4, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Interval=450),
    __Dymola_experimentSetupOutput);
end TestSimplifiedUnitCommitment;
