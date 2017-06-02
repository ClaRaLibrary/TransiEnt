within TransiEnt.Grid.Electrical.EconomicDispatch.Check;
model TestMeritOrderDispatcher
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

  MeritOrderDispatcher mod(
    startTime=60,
    ntime=discretizePrediction.ntime,
    samplePeriod=discretizePrediction.samplePeriod,
    P_init(displayUnit="W") = {0.2e9,2.3e9})                  annotation (Placement(transformation(extent={{4,-12},{28,14}})));
  DiscretizePrediction discretizePrediction(t_shift=0) annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));
  Basics.Blocks.Sources.BooleanArrayConstant operatingStatus(nout=mod.nout) annotation (Placement(transformation(extent={{-22,-48},{-2,-28}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-78,100},{-58,80}})));
  Modelica.Blocks.Sources.Cosine P_load_is(
    freqHz=1/86400,
    amplitude=2e8,
    offset=2.3e9) annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
  Modelica.Blocks.Sources.Cosine P_load_pred_1h(
    freqHz=1/86400,
    phase=1/24*2*3.14,
    amplitude=2e8,
    offset=2.3e9) annotation (Placement(transformation(extent={{-76,26},{-56,46}})));
  Basics.Blocks.Sources.ConstantVectorSource P_sec_pos(nout=simCenter.generationPark.nDispPlants, k=fill(0, P_sec_pos.nout)) annotation (Placement(transformation(extent={{-18,34},{2,54}})));
  Modelica.Blocks.Sources.Constant P_min_total(k=sum(simCenter.generationPark.P_min)) annotation (Placement(transformation(extent={{68,54},{88,74}})));
  Modelica.Blocks.Sources.Constant P_max_total(k=sum(simCenter.generationPark.P_max)) annotation (Placement(transformation(extent={{66,18},{86,38}})));
  inner SimCenter simCenter(redeclare Base.EmptyGenerationPark generationPark(
      nPlants=2,
      nDispPlants=2,
      nMODPlants=2,
      C_var={10,5},
      index={"Small expensive unit","Large cheap unit"},
      P_max={0.5e9,2.3e9},
      P_min=0.2 .* {0.5e9,2.3e9},
      P_grad_max_star={0.1/60,1e-6}))
                            annotation (Placement(transformation(extent={{-108,80},{-88,100}})));
equation
  connect(discretizePrediction.P_predictions,mod. u) annotation (Line(points={{-11,0},{1.6,0},{1.6,1}},
                                                                                                    color={0,0,127}));
  connect(operatingStatus.y, mod.z) annotation (Line(points={{-1,-38},{16,-38},{16,-14.6}}, color={255,0,255}));
  connect(P_load_is.y, discretizePrediction.P_is) annotation (Line(points={{-55,0},{-55,0},{-34,0}}, color={0,0,127}));
  connect(P_load_pred_1h.y, discretizePrediction.P_prediction) annotation (Line(points={{-55,36},{-22,36},{-22,12}}, color={0,0,127}));
  connect(P_sec_pos.y, mod.P_R_pos) annotation (Line(points={{3,44},{10,44},{10,16.6},{11.2,16.6}}, color={0,0,127}));
  connect(P_sec_pos.y, mod.P_R_neg) annotation (Line(points={{3,44},{20.8,44},{20.8,16.6}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestMeritOrderDispatcher.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=1, position={0, 0, 1524, 682}, y={"mod.P_set_total", "P_load_is.y", "mod.y[2]", "mod.P_max[2]"}, range={0.0, 88000.0, 1900000000.0, 2600000000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}}, patterns={LinePattern.Solid, LinePattern.Solid, LinePattern.Solid, LinePattern.Dash}, filename=resultFile);
  createPlot(id=1, position={0, 0, 1524, 224}, y={"mod.y[1]", "mod.P_min[1]"}, range={0.0, 88000.0, 80000000.0, 220000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, patterns={LinePattern.Solid, LinePattern.Dash}, filename=resultFile);
  createPlot(id=1, position={0, 0, 1524, 223}, y={"mod.der(C_var_total)"}, range={0.0, 88000.0, 10000000000.0, 14000000000.0}, grid=true, subPlot=3, colors={{28,108,200}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})),
    experiment(StopTime=86400, Interval=60),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-120,-100},{120,100}})),
    Documentation(info="<html>
<p>Note that the more expensive unit 1 is used above minimum level around t= 7e4s because the unit 2 has such a slow maximum slewrate that otherwise the load could not be followed.</p>
</html>"));
end TestMeritOrderDispatcher;
