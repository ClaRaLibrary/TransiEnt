within TransiEnt.Producer.Electrical.Wind.Check;
model TestPowerProfileWindPlant
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
  TransiEnt.Components.Boundaries.Electrical.Frequency Grid(useInputConnector=false) annotation (Placement(transformation(extent={{62,-10},{82,10}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  PowerProfileWindPlant
              windturbine                                                                                     annotation (Placement(transformation(extent={{2,-16},{22,4}})));

  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  WindProfiles.WindProfileLoader windProfileLoader(
    REProfile=TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData.Wind2011_TenneT_900s,
    P_el_n=1e9,
    change_of_sign=true) annotation (Placement(transformation(extent={{-42,8},{-22,28}})));
equation
  connect(windturbine.epp, Grid.epp) annotation (Line(
      points={{21.5,-0.4},{44,-0.4},{44,-0.1},{61.9,-0.1}},
      color={0,135,135},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "TestPowerProfileWindPlant.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=3, position={0, 0, 1616, 731}, y={"windturbine.P_el_is", "modelStatistics.electricPower.P_renewable_gen"}, range={0.0, 620000.0, 0.0, 600000000.0}, grid=true, colors={{175,175,175}, {0,0,0}}, thicknesses={1.0, 0.25},filename=resultFile);
createPlot(id=3, position={0, 0, 1616, 241}, y={"windProfileLoader.y1"}, range={0.0, 620000.0, -600000000.0, 0.0}, grid=true, subPlot=2, colors={{0,0,0}},filename=resultFile);
createPlot(id=3, position={0, 0, 1616, 240}, y={"modelStatistics.electricPower.E_renewable_gen"}, range={0.0, 620000.0, -10.0, 40.0}, grid=true, subPlot=3, colors={{0,0,0}},filename=resultFile);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(windProfileLoader.y1, windturbine.P_el_set) annotation (Line(points={{-21,18},{10.5,18},{10.5,3.9}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=604800, Interval=900),
    __Dymola_experimentSetupOutput);
end TestPowerProfileWindPlant;
