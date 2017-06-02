within TransiEnt.Producer.Electrical.Wind.Base.Check;
model Test_RoughnessFilter
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

public
function plotResult

  constant String resultFileName = "Test_RoughnessFilter.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 695}, y={"v_wind_20m.y", "hubHeight[10].v_wind_hub", "hubHeight[9].v_wind_hub",
"hubHeight[6].v_wind_hub", "hubHeight[3].v_wind_hub", "hubHeight[4].v_wind_hub",
 "hubHeight[5].v_wind_hub", "hubHeight[7].v_wind_hub", "hubHeight[8].v_wind_hub"}, range={0.0, 4000.0, -5.0, 70.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}, {162,29,33},
{244,125,35}, {102,44,145}, {28,108,200}}, patterns={LinePattern.Solid, LinePattern.Solid, LinePattern.Solid, LinePattern.Solid,
LinePattern.Solid, LinePattern.Solid, LinePattern.Solid, LinePattern.Solid,
LinePattern.Dash}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  parameter Integer n = 10;
  RoughnessFilter hubHeight[n](
    each typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.WindOnshore,
    each use_v_wind_input=true,
    each height_data=5,
    each Roughness(RoughnessLength=0.5),
    height_hub=5:10:100) annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Ramp v_wind_20m(
    duration=3000,
    height=30,
    offset=0) annotation (Placement(transformation(extent={{-54,0},{-34,20}})));
  inner TransiEnt.SimCenter simCenter(ambientConditions(redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_3600s_TMY wind)) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation
  for i in 1:n loop
    connect(v_wind_20m.y, hubHeight[i].v_wind_m) annotation (Line(points={{-33,10},{21.1,10},{21.1,9.9}}, color={0,0,127}));
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=4000));
end Test_RoughnessFilter;
