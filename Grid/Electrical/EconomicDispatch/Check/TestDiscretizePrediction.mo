within TransiEnt.Grid.Electrical.EconomicDispatch.Check;
model TestDiscretizePrediction

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

  TransiEnt.Basics.Tables.ElectricGrid.PowerData.ElectricityDemand_HH_900s_2012 Demand_HH_2012 annotation (Placement(transformation(extent={{-84,12},{-64,32}})));
public
function plotResult

  constant String resultFileName = "TestDiscretizePrediction.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
 createPlot(id=1, position={809, 0, 791, 817}, y={"Demand_Prediction1h.y1", "Demand_HH_2012.y1", "discretizePrediction.P_predictions[1]",
 "discretizePrediction.P_predictions[2]", "discretizePrediction.P_predictions[3]"}, range={0.0, 90000.0, 950000000.0, 1450000000.0}, grid=true, colors={{186,186,186}, {97,97,97}, {0,140,72}, {217,67,180}, {238,46,47}}, patterns={LinePattern.Dash, LinePattern.Dash, LinePattern.Solid, LinePattern.Solid,
LinePattern.Solid}, thicknesses={1.0, 1.0, 0.25, 0.25, 0.25}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 406}, y={"Demand_Prediction1h.y1", "Demand_HH_2012.y1", "discretizePrediction_shift.P_predictions[1]",
 "discretizePrediction_shift.P_predictions[2]", "discretizePrediction_shift.P_predictions[3]"}, range={0.0, 90000.0, 950000000.0, 1450000000.0}, grid=true, subPlot=2, colors={{162,162,162}, {104,104,104}, {0,140,72}, {217,67,180}, {0,0,0}}, patterns={LinePattern.Dash, LinePattern.Dash, LinePattern.Solid, LinePattern.Solid,
LinePattern.Solid}, thicknesses={1.0, 1.0, 0.25, 0.25, 0.25}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  DiscretizePrediction discretizePrediction(
    t_pred=3600,
    t_shift=0,
    samplePeriod=1800)                      annotation (Placement(transformation(extent={{-10,20},{22,52}})));
  DiscretizePrediction discretizePrediction_shift(
    t_pred=3600,
    t_shift=900,
    samplePeriod=1800)                            annotation (Placement(transformation(extent={{-10,-54},{22,-22}})));
  TransiEnt.Basics.Tables.ElectricGrid.PowerData.ElectricityDemand_HH_900s_2012 Demand_Prediction1h(startTime=-3600)
                                                                                             annotation (Placement(transformation(extent={{-80,62},{-60,82}})));
equation
  connect(Demand_Prediction1h.y1, discretizePrediction.P_prediction) annotation (Line(points={{-59,72},{-48,72},{6,72},{6,55.2}}, color={0,0,127}));
  connect(Demand_Prediction1h.y1, discretizePrediction_shift.P_prediction) annotation (Line(points={{-59,72},{-50,72},{-50,0},{6,0},{6,-18.8}}, color={0,0,127}));
  connect(Demand_HH_2012.y1, discretizePrediction.P_is) annotation (Line(points={{-63,22},{-58,22},{-58,24},{-58,38},{-58,36},{-13.2,36}}, color={0,0,127}));
  connect(Demand_HH_2012.y1, discretizePrediction_shift.P_is) annotation (Line(points={{-63,22},{-58,22},{-58,-38},{-13.2,-38}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})),
    experiment(StopTime=86400, Interval=60),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-120,-100},{120,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test enviroment for DiscretizePrediction</p>
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
end TestDiscretizePrediction;
