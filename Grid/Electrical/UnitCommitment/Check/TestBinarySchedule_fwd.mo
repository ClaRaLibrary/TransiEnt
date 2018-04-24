within TransiEnt.Grid.Electrical.UnitCommitment.Check;
model TestBinarySchedule_fwd
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

  Basics.Blocks.Sources.ConstantVectorSource P_init_set(nout=simCenter.generationPark.nPlants, k={0.00,184844600.00,0.00,264596300.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,65349610.00,67121080.00,-0.00,-0.00,0.00,45750000.00,0.00,436034500.00,176187200.00}) annotation (Placement(transformation(extent={{-70,-6},{-50,14}})));
  Modelica.Blocks.Sources.Constant t_start_set(k=0) annotation (Placement(transformation(extent={{-70,34},{-50,54}})));
  BinaryScheduleDataTable_fwd UC(
    t_start=t_start_set.k,
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
      columns=(2:simCenter.generationPark.nPlants + 1))) annotation (Placement(transformation(extent={{-8,-4},{12,16}})));
  inner SimCenter            simCenter(         thres=1e-9,
    Td=450,
    useThresh=true,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    redeclare Examples.Hamburg.ExampleGenerationPark2035 generationPark)
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=604800, Interval=450),
    __Dymola_experimentSetupOutput);
end TestBinarySchedule_fwd;
