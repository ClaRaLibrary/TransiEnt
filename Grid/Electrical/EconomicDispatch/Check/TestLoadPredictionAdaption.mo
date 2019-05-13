within TransiEnt.Grid.Electrical.EconomicDispatch.Check;
model TestLoadPredictionAdaption
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  TransiEnt.Basics.Tables.ElectricGrid.ElectricityDemand_HH_900s_2012 Demand_HH_2012 annotation (Placement(transformation(extent={{-56,-40},{-36,-20}})));
  TransiEnt.Basics.Tables.ElectricGrid.ElectricityDemand_HH_900s_2012 IdealPrediction_HH_2012_1h_ahead(startTime=-3600) annotation (Placement(transformation(extent={{-56,-6},{-36,14}})));
  Modelica.Blocks.Math.Product Prediction_HH_2012 annotation (Placement(transformation(extent={{-12,20},{8,40}})));
  Modelica.Blocks.Noise.NormalNoise PredictionError(
    mu=1,
    samplePeriod=900,
    sigma=1/100)
    annotation (Placement(transformation(extent={{-56,26},{-36,46}})));
  LoadPredictionAdaption lpa_real annotation (Placement(transformation(extent={{8,-40},{28,-20}})));
equation
  connect(IdealPrediction_HH_2012_1h_ahead.y1, Prediction_HH_2012.u2) annotation (Line(points={{-35,4},{-26,4},{-26,24},{-14,24}},   color={0,0,127}));
  connect(PredictionError.y, Prediction_HH_2012.u1) annotation (Line(points={{-35,36},{-35,36},{-14,36}},          color={0,0,127}));
  connect(Demand_HH_2012.y1, lpa_real.P_load_is) annotation (Line(points={{-35,-30},{-35,-30},{6,-30}},                   color={0,0,127}));
  connect(lpa_real.P_load_pred, Prediction_HH_2012.y) annotation (Line(points={{18,-18},{18,-6},{18,30},{9,30}},                color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestLoadPredictionAdaption.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={0, 0, 1524, 682}, y={"Demand_HH_2012.y1", "IdealPrediction_HH_2012_1h_ahead.y1", "Prediction_HH_2012.y",
 "lpa_real.y"}, range={0.0, 88000.0, 900000000.0, 1450000000.0}, grid=true, colors={{178,179,179}, {178,179,179}, {28,108,200}, {238,46,47}}, patterns={LinePattern.Solid, LinePattern.Solid, LinePattern.Dash, LinePattern.Solid}, markers={MarkerStyle.None, MarkerStyle.None, MarkerStyle.None, MarkerStyle.Cross}, thicknesses={1.0, 0.25, 0.5, 0.5}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})),
    experiment(StopTime=86400, Interval=60),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-120,-100},{120,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test enviroment for LoadPredictionAdaption</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
</html>"));
end TestLoadPredictionAdaption;
