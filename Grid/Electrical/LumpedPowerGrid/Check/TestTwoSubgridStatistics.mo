within TransiEnt.Grid.Electrical.LumpedPowerGrid.Check;
model TestTwoSubgridStatistics "Example of the component PowerPlant_PoutGrad_L1"
  import TransiEnt;

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

  inner TransiEnt.SimCenter simCenter(P_n_ref_1=700e6, P_n_ref_2=300e9 - 700e6) annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer load annotation (Placement(transformation(extent={{32,-30},{52,-10}})));
  Modelica.Blocks.Sources.Constant P_demand(k=600e6) annotation (Placement(transformation(extent={{12,40},{32,60}})));
  TransiEnt.Producer.Electrical.Conventional.Components.NonlinearThreeStatePlant gasTurbines(
    P_el_n=100e6,
    P_min_star=0.2,
    H=10,
    isSecondaryControlActive=false,
    P_init=0) annotation (Placement(transformation(extent={{-60,24},{-40,44}})));
  Modelica.Blocks.Sources.Step GTload(
    height=-100e6,
    offset=0,
    startTime=100)
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  TransiEnt.Grid.Electrical.LumpedPowerGrid.LumpedGrid uCTEModel(P_el_n=300e9 - 700e6) annotation (Placement(transformation(rotation=0, extent={{-28,-84},{-8,-64}})));
  TransiEnt.Producer.Electrical.Conventional.Components.NonlinearThreeStatePlant BrownCoal1(
    P_max_star=1,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BrownCoal,
    P_grad_max_star=simCenter.generationPark.P_grad_max_star_BCG,
    P_el_n=500e6,
    P_min_star=0.1,
    H=12,
    isSecondaryControlActive=false) annotation (Placement(transformation(extent={{-53,-21},{-30,4}})));

  TransiEnt.Producer.Electrical.Wind.PowerProfileWindPlant WindOnshorePlant(P_el_n=100e6) annotation (Placement(transformation(extent={{-56,-59},{-34,-38}})));
  Modelica.Blocks.Sources.Step BCload(
    startTime=200,
    offset=-500e6,
    height=455e6)
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Modelica.Blocks.Sources.Constant
                               WindLoad(k=-100e6)
    annotation (Placement(transformation(extent={{-82,-44},{-62,-24}})));
equation
  connect(load.epp,uCTEModel.epp)
    annotation (Line(
      points={{32.2,-20},{-0.05,-20},{-0.05,-74},{-8,-74}},
      color={0,135,135},
      thickness=0.5,
      smooth=Smooth.None));

  connect(gasTurbines.epp, load.epp) annotation (Line(
      points={{-41,41},{0,41},{0,-20},{16,-20},{16,-20},{32.2,-20}},
      color={0,135,135},
      thickness=0.5,
      smooth=Smooth.None));

  connect(GTload.y, gasTurbines.P_el_set) annotation (Line(
      points={{-69,50},{-51.5,50},{-51.5,43.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(WindOnshorePlant.epp, load.epp) annotation (Line(
      points={{-35.1,-41.15},{0,-41.15},{0,-20},{32.2,-20}},
      color={0,135,135},
      thickness=0.5,
      smooth=Smooth.None));

  connect(BrownCoal1.epp, load.epp) annotation (Line(
      points={{-31.15,0.25},{-30,0.25},{-30,-2},{0,-2},{0,-20},{24,-20},{24,-20},{32.2,-20}},
      color={0,135,135},
      thickness=0.5,
      smooth=Smooth.None));

  connect(BCload.y, BrownCoal1.P_el_set) annotation (Line(
      points={{-69,10},{-43.225,10},{-43.225,3.875}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(WindLoad.y, WindOnshorePlant.P_el_set) annotation (Line(
      points={{-61,-34},{-46.65,-34},{-46.65,-38.105}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_demand.y, load.P_el_set) annotation (Line(points={{33,50},{42,50},{42,-8.4}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestTwoSubgridStatistics.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={0, 0, 1616, 850}, y={"modelStatistics.electricPower.T_tc_2"}, range={0.0, 0.14, 11.98, 11.985000000000001}, grid=true, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 209}, y={"uCTEModel.epp.f"}, range={0.0, 0.14, 49.985, 50.005}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 208}, y={"modelStatistics.electricPower.T_tc_1"}, range={0.0, 0.14, 0.0, 15.0}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 209}, y={"BrownCoal1.MechanicalConnection.isRunning", "gasTurbines.MechanicalConnection.isRunning"}, range={0.0, 0.14, -0.5, 1.5}, grid=true, subPlot=4, colors={{28,108,200}, {28,108,200}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=500),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestTwoSubgridStatistics;
