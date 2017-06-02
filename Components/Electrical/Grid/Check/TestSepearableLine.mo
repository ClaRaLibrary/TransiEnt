within TransiEnt.Components.Electrical.Grid.Check;
model TestSepearableLine
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
  extends Basics.Icons.Checkmodel;
  Producer.Electrical.Conventional.Components.SimplePowerPlant Gen_A(P_el_n=3e9) annotation (Placement(transformation(extent={{-92,-16},{-72,4}})));
  Modelica.Blocks.Interaction.Show.RealValue realValue(use_numberPort=false, number=1e-9*Load.epp.P) annotation (Placement(transformation(extent={{40,26},{70,54}})));
  Modelica.Blocks.Sources.Constant Psched(k=-3e9) annotation (Placement(transformation(extent={{-98,28},{-78,48}})));
  Producer.Electrical.Conventional.Components.NonlinearThreeStatePlant Gen_A1(
    P_init=147e9,
    J=10*150e9/(100*3.14)^2,
    P_el_n=300e9,
    primaryBalancingController(providedDroop=0.18/50/(3/150 - 0.18*0.01), maxValuePrCtrl=0.02)) annotation (Placement(transformation(extent={{-42,-86},{-22,-66}})));

  Modelica.Blocks.Sources.Constant Psched1(k=-147e9) annotation (Placement(transformation(extent={{-66,-66},{-46,-46}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  SeparableLine separableLine_L1_1 annotation (Placement(transformation(extent={{-46,-14},{-26,6}})));
  Modelica.Blocks.Sources.BooleanStep Psched2(startValue=true, startTime=100) annotation (Placement(transformation(extent={{-62,44},{-42,64}})));
  Consumer.Electrical.LinearElectricConsumer Load(kpf=0.5) annotation (Placement(transformation(
        extent={{-16,-17},{16,17}},
        rotation=0,
        origin={38,-18})));
  Modelica.Blocks.Sources.Constant Load_A(k=150e9) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={68,6})));
equation
  connect(Gen_A.epp, separableLine_L1_1.epp_1) annotation (Line(
      points={{-72.5,-0.4},{-59.25,-0.4},{-59.25,-4.1},{-45.9,-4.1}},
      color={0,135,135},
      thickness=0.5));
  connect(separableLine_L1_1.isConnected, Psched2.y) annotation (Line(points={{-36,6},{-36,6},{-36,54},{-41,54}}, color={255,0,255}));
  connect(Load.epp, separableLine_L1_1.epp_2) annotation (Line(
      points={{22.32,-18},{12,-18},{12,-10},{-26.1,-10},{-26.1,-4}},
      color={0,135,135},
      thickness=0.5));
  connect(Gen_A1.epp, Load.epp) annotation (Line(
      points={{-22.5,-70.4},{6,-70.4},{6,-18},{22.32,-18}},
      color={0,135,135},
      thickness=0.5));
  connect(Load_A.y, Load.P_el_set) annotation (Line(points={{57,6},{54,6},{54,8},{50,8},{50,16},{38,16},{38,1.72}},       color={0,0,127}));
  connect(Psched1.y, Gen_A1.P_el_set) annotation (Line(points={{-45,-56},{-33.5,-56},{-33.5,-66.1}}, color={0,0,127}));
  connect(Psched.y, Gen_A.P_el_set) annotation (Line(points={{-77,38},{-72,38},{-72,12},{-83.5,12},{-83.5,3.9}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestSepearableLine.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 733}, y={"separableLine_L1_1.epp_1.P"}, range={0.0, 300.0, 2950000000.0, 3200000000.0}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 179}, y={"separableLine_L1_1.epp_2.P"}, range={0.0, 300.0, -4000000000.0, 1000000000.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 180}, y={"separableLine_L1_1.epp_1.f"}, range={0.0, 300.0, 35.0, 55.0}, grid=true, subPlot=3, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 179}, y={"separableLine_L1_1.epp_2.f"}, range={0.0, 300.0, 20.0, 60.0}, grid=true, subPlot=4, colors={{28,108,200}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=300,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-006,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end TestSepearableLine;