within TransiEnt.Grid.Electrical.EconomicDispatch.Check;
model TestMeritOrderDispatcherStatePrediction

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

  MeritOrderDispatcherStatePrediction
                       mod(
    startTime=60,
    ntime=discretizePrediction.ntime,
    samplePeriod=discretizePrediction.samplePeriod,
    P_init(displayUnit="W") = simCenter.generationPark.P_max) annotation (Placement(transformation(extent={{4,-12},{28,14}})));
  DiscretizePrediction discretizePrediction(t_shift=0, samplePeriod=900)
                                                       annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));
  inner SimCenter simCenter(redeclare Base.EmptyGenerationPark generationPark(
      nPlants=2,
      nDispPlants=2,
      nMODPlants=2,
      P_grad_max_star={0.1/60,0.05/60},
      C_var={10,5},
      index={"Small expensive unit","Large cheap unit"},
      P_max={0.5e9,2.3e9},
      P_min=0.2 .* {0.5e9,2.3e9}))
                            annotation (Placement(transformation(extent={{-110,80},{-90,100}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-90,100},{-70,80}})));
  Modelica.Blocks.Sources.Cosine P_load_is(
    f=1/86400,
    amplitude=2e8,
    offset=2.3e9,
    phase(displayUnit="rad") = 3.14) annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
  Modelica.Blocks.Sources.Cosine P_load_pred_1h(
    f=1/86400,
    amplitude=2e8,
    offset=2.3e9,
    phase=3.14 + 1/24*2*3.14) annotation (Placement(transformation(extent={{-74,20},{-54,40}})));
  Basics.Blocks.Sources.ConstantVectorSource P_sec_pos(nout=simCenter.generationPark.nDispPlants, k=fill(0, P_sec_pos.nout)) annotation (Placement(transformation(extent={{-18,34},{2,54}})));
  Modelica.Blocks.Sources.Constant P_min_total(k=sum(simCenter.generationPark.P_min)) annotation (Placement(transformation(extent={{68,54},{88,74}})));
  Modelica.Blocks.Sources.Constant P_max_total(k=sum(simCenter.generationPark.P_max)) annotation (Placement(transformation(extent={{66,18},{86,38}})));
  Basics.Blocks.DelayedBooleanReplicator opstatus_4x15min_pred(
    t_pred=discretizePrediction.t_pred,
    samplePeriod=discretizePrediction.samplePeriod,
    nout=simCenter.generationPark.nDispPlants) annotation (Placement(transformation(extent={{-32,-62},{-4,-34}})));
  Basics.Blocks.Sources.BooleanVectorExpression opstatus_1h_pred(nout=simCenter.generationPark.nDispPlants, y_set=cat(
        1,
        {time >= 2e4 - 3600},
        fill(true, simCenter.generationPark.nDispPlants - 1))) annotation (Placement(transformation(extent={{-78,-58},{-58,-38}})));
  Basics.Blocks.Sources.BooleanVectorExpression opstatus_now(nout=simCenter.generationPark.nDispPlants, y_set=cat(
        1,
        {time >= 2e4},
        fill(true, simCenter.generationPark.nDispPlants - 1))) annotation (Placement(transformation(extent={{-78,-80},{-58,-60}})));
equation
  connect(discretizePrediction.P_predictions,mod. u) annotation (Line(points={{-11,0},{1.6,0},{1.6,1}},
                                                                                                    color={0,0,127}));
  connect(P_load_is.y, discretizePrediction.P_is) annotation (Line(points={{-55,0},{-46,0},{-34,0}}, color={0,0,127}));
  connect(P_load_pred_1h.y, discretizePrediction.P_prediction) annotation (Line(points={{-53,30},{-22,30},{-22,12}}, color={0,0,127}));
  connect(P_sec_pos.y, mod.P_R_pos) annotation (Line(points={{3,44},{10,44},{10,16.6},{10.24,16.6}},color={0,0,127}));
  connect(P_sec_pos.y, mod.P_R_neg) annotation (Line(points={{3,44},{22,44},{22,16.6}},     color={0,0,127}));
  connect(opstatus_1h_pred.y,opstatus_4x15min_pred. u) annotation (Line(points={{-57,-48},{-34.8,-48}},
                                                                                                     color={255,0,255}));
  connect(opstatus_4x15min_pred.y, mod.z) annotation (Line(points={{-2.6,-48},{16,-48},{16,-14.6}}, color={255,0,255}));
public
function plotResult

  constant String resultFileName = "TestMeritOrderDispatcherStatePrediction.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={0, 0, 1524, 682}, y={"P_load_is.y", "P_load_pred_1h.y", "mod.P_set_total", "mod.y[2]"}, range={0.0, 88000.0, 1500000000.0, 3000000000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}}, filename=resultFile);
  createPlot(id=1, position={0, 0, 1524, 166}, y={"opstatus_now.y[1]", "opstatus_4x15min_pred.y[1, 5]"}, range={0.0, 90000.0, -0.5, 1.5}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
  createPlot(id=1, position={0, 0, 1524, 166}, y={"mod.y[1]"}, range={0.0, 88000.0, -200000000.0, 600000000.0}, grid=true, subPlot=3, colors={{28,108,200}}, filename=resultFile);
  createPlot(id=1, position={0, 0, 1524, 166}, y={"mod.der(C_var_total)"}, range={0.0, 88000.0, 10000000000.0, 18000000000.0}, grid=true, subPlot=4, colors={{28,108,200}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})),
    experiment(StopTime=86400, Interval=60),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-120,-100},{120,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test enviroment for MeritOrderDispatcherStatePrediction</p>
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
end TestMeritOrderDispatcherStatePrediction;
