within TransiEnt.Grid.Electrical.UnitCommitment;
model BinaryScheduleDataTable "Adds constants for easy allocation of outputs"
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
  extends TransiEnt.Basics.Icons.Model;

  outer TransiEnt.SimCenter simCenter;

  replaceable TransiEnt.Grid.Electrical.UnitCommitment.ScheduleDataTable schedule(
    smoothness=simCenter.tableInterpolationSmoothness,
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
    constantfactor=1e6,
    WT=2,
    CCP=5,
    BCG=1,
    WW2=-1,
    GT1=6,
    columns=(2:nPlants + 1),
    relativepath="electricity/UnitCommitmentSchedules/UnitCommitmentSchedule_3600s_smoothed_REF35.txt",
    BM=9,
    PS=10,
    Curt=12,
    ROH=14,
    PV=15,
    WindOn=16,
    WindOff=17,
    OIL=7,
    GAR=8,
    Import=13,
    WW1=4,
    BC=3,
    startTime=t_start,
    GUDTS=3,
    GT2=7,
    GT3=8) constrainedby TransiEnt.Grid.Electrical.UnitCommitment.ScheduleDataTable "Tabled schedule from day ahead planning" annotation (
    __Dymola_editText=false,
    choicesAllMatching=true,
    Placement(transformation(extent={{-21,23},{19,61}})));

    final parameter Integer nPlants =  simCenter.generationPark.nPlants "Total number of plants in day ahead planning";
    final parameter Integer nDispPlants =  simCenter.generationPark.nDispPlants "Dispatchable number of plants in day ahead planning";
    final parameter SI.Power[nDispPlants] P_min = simCenter.generationPark.P_min;

    replaceable TransiEnt.Grid.Electrical.UnitCommitment.ReserveScheduleDataTable reserveAllocation(
    smoothness=schedule.smoothness,
    datasource=schedule.datasource,
    columns=(2:3*nPlants + 1),
    relativepath=schedule.relativepath,
    startTime=schedule.startTime,
    constantfactor=-schedule.constantfactor) constrainedby TransiEnt.Grid.Electrical.UnitCommitment.ReserveScheduleDataTable "Tabled control power allocation from day ahead planning" annotation (
    __Dymola_editText=false,
    choicesAllMatching=true,
    Placement(transformation(extent={{-21,-55},{19,-17}})));

    parameter Boolean[nDispPlants] unit_blocked = cat(1, fill(false, nDispPlants-1), {true}) "Can bes used to constantly shut down a plant";
    parameter Boolean[nDispPlants] unit_mustrun = fill(false, nDispPlants) "Can bes used to constantly run a plant";
    parameter SI.Power P_init[nPlants]= zeros(nPlants);
    parameter SI.Time t_start = 0 "Start time, e.g. -3600 starts simulation at second hour";
    parameter SI.Time t_prediction = -3600 "e.g. -3600 means 1h ahead";
    parameter SI.Time samplePeriod=60 "Period of one cycle (must be equal to period in MeritOrderDispatcher)";
    final parameter Integer ntime=integer(-t_prediction/samplePeriod+1);

    ScheduleDataTable prediction(
    smoothness=schedule.smoothness,
    datasource=schedule.datasource,
    constantfactor=schedule.constantfactor,
    WT=schedule.WT,
    CCP=schedule.CCP,
    BCG=schedule.BCG,
    WW2=schedule.WW2,
    GT2=schedule.GT2,
    GT1=schedule.GT1,
    columns=(2:nPlants+1),
    relativepath=schedule.relativepath,
    BM=schedule.BM,
    PS=schedule.PS,
    Curt=schedule.Curt,
    ROH=schedule.ROH,
    PV=schedule.PV,
    WindOn=schedule.WindOn,
    WindOff=schedule.WindOff,
    OIL=schedule.OIL,
    GAR=schedule.GAR,
    Import=schedule.Import,
    WW1=schedule.WW1,
    BC=schedule.BC,
    startTime=t_prediction + schedule.startTime) "Generated with matlab script: \\\\transientee-sources\\matlab\\pd\\fahrplanoptimierung\\tageseinsatzplanung\\main.m" annotation (Placement(transformation(extent={{-91,27},{-51,65}})));

    Modelica.Blocks.Interfaces.BooleanOutput[nDispPlants] z annotation (Placement(transformation(extent={{93,21},{133,59}})));

    Modelica.Blocks.Interfaces.RealOutput[nDispPlants] P_sec_pos annotation (Placement(transformation(extent={{93,-45},{133,-7}})));
    Modelica.Blocks.Interfaces.RealOutput[nDispPlants] P_sec_neg annotation (Placement(transformation(extent={{93,-91},{133,-53}})));
equation
  for i in 1:nDispPlants loop
    z[i] = (not unit_blocked[i] and -schedule.y[i] >= P_min[i]) or unit_mustrun[i];
  end for;

  for i in 1:nDispPlants loop
    P_sec_pos[i] = reserveAllocation.y[i];
    P_sec_neg[i] = reserveAllocation.y[i];
  end for;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-48,68},{2,-52}},
          lineColor={255,255,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-48,-52},{-48,68},{52,68},{52,-52},{-48,-52},{-48,-22},{52,-22},{52,8},{-48,8},{-48,38},{52,38},{52,68},{2,68},{2,-53}},
            color={0,0,0}),
        Polygon(
          points={{-80,88},{-88,66},{-72,66},{-80,88}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,66},{-80,-82}}, color={192,192,192}),
        Line(points={{-90,-72},{82,-72}}, color={192,192,192}),
        Polygon(
          points={{90,-72},{68,-64},{68,-80},{90,-72}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end BinaryScheduleDataTable;
