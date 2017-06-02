within TransiEnt.Components.Electrical.PowerTransformation.Check;
model CheckIdealTriac "Example how to use the power transformator model"

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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Components.Boundaries.Electrical.Frequency Grid(useInputConnector=false) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={57,0})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  TransiEnt.Components.Electrical.PowerTransformation.IdealTriac Triac(isValveMode=false) annotation (Placement(transformation(extent={{-16,-12},{8,12}})));
  TransiEnt.Components.Boundaries.Electrical.Power TurboGen(useInputConnectorP=true) annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-47,0})));
  Modelica.Blocks.Sources.Cosine P_gen_total(
    freqHz=2e-3,
    offset=-1e6,
    amplitude=1e6)
                 annotation (Placement(transformation(extent={{-96,18},{-76,38}})));
  Modelica.Blocks.Sources.Step Curtailement(
    offset=0,
    startTime=3600,
    height=-1e5) annotation (Placement(transformation(extent={{-38,48},{-18,68}})));
equation
  connect(P_gen_total.y, TurboGen.P_el_set) annotation (Line(points={{-75,28},{-50,28},{-42.2,28},{-42.2,9.6}}, color={0,0,127}));
  connect(Curtailement.y, Triac.u) annotation (Line(points={{-17,58},{-4,58},{-4,9.84}}, color={0,0,127}));
  connect(TurboGen.epp, Triac.epp_in) annotation (Line(
      points={{-38.92,-0.08},{-27.46,-0.08},{-27.46,0},{-16,0}},
      color={0,135,135},
      thickness=0.5));
  connect(Triac.epp_out, Grid.epp) annotation (Line(
      points={{7.76,0},{48.92,0},{48.92,-0.08}},
      color={0,135,135},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "CheckIdealTriac.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={809, 0, 791, 733}, y={"Triac.epp_in.P", "Grid.epp.P"}, range={0.0, 7500.0, -100000.0, 1900000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=7200,
      Interval=900,
      __Dymola_fixedstepsize=5,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end CheckIdealTriac;
