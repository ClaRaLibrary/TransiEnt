within TransiEnt.Examples.Electric;
model ElectricGrid_SecondaryBalancing "Example for secondary balancing simulation of a two area grid"

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

extends TransiEnt.Basics.Icons.Example;

  inner TransiEnt.SimCenter simCenter(                generationPark(
      index={"Plant_1","Plant_2"},
      nPlants=2,
      nDispPlants=2,
      nMODPlants=2,
      P_max={150e9 - Gen_2.P_el_n,Gen_2.P_el_n},
      P_min={0,0},
      P_grad_max_star={Gen_1.P_grad_max_star,Gen_2.P_grad_max_star},
      C_var={0,0}), useThresh=false)
                    annotation (Placement(transformation(extent={{-140,119},{-120,139}})));
  inner TransiEnt.ModelStatistics                    modelStatistics
    annotation (Placement(transformation(extent={{-120,119},{-100,139}})));

  TransiEnt.Producer.Electrical.Conventional.Components.NonlinearThreeStatePlant Gen_1(
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.WindOnshore,
    J=10*Gen_1.P_el_n/(100*Modelica.Constants.pi)^2,
    primaryBalancingController(providedDroop=0.2/50/(3/150 - 0.2*0.01)),
    isSecondaryControlActive=true,
    fixedStartValue_w=true,
    P_el_n=200e9,
    P_init=Load_1_set.k,
    nSubgrid=1) annotation (Placement(transformation(extent={{-142,-36},{-94,12}})));

  Modelica.Blocks.Sources.Constant Gen_1_set(k=-Load_1_set.k) annotation (Placement(transformation(extent={{-78,16},{-98,36}})));
  Modelica.Blocks.Sources.Constant Load_1_set(k=100e9)        annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-20,34})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer Dem_1(kpf=0.5) annotation (Placement(transformation(
        extent={{-16,-17},{16,17}},
        rotation=0,
        origin={-42,2})));
  TransiEnt.Producer.Electrical.Conventional.Components.NonlinearThreeStatePlant Gen_2(
    J=10*Gen_2.P_el_n/(100*Modelica.Constants.pi)^2,
    primaryBalancingController(providedDroop=0.2/50/(3/150 - 0.2*0.01)),
    P_grad_max_star=1/60,
    isSecondaryControlActive=true,
    fixedStartValue_w=false,
    P_el_n=100e9,
    P_init=-Gen_2_set.k,
    nSubgrid=2) annotation (Placement(transformation(extent={{28,-60},{76,-12}})));

  Modelica.Blocks.Sources.Constant
                               Gen_2_set(k=-Load_2_set.k - P_Z.k)
                   annotation (Placement(transformation(extent={{84,-4},{64,16}})));
  Modelica.Blocks.Sources.Constant Load_2_set(k=50e9)         annotation (Placement(transformation(
        extent={{12,-12},{-12,12}},
        rotation=0,
        origin={144,22})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer Dem_2(kpf=0.5) annotation (Placement(transformation(
        extent={{-16,-17},{16,17}},
        rotation=0,
        origin={122,-22})));
  Modelica.Blocks.Sources.Constant P_Z(k=-1e9)  annotation (Placement(transformation(extent={{-132,-110},{-112,-90}})));
  Modelica.Blocks.Sources.Constant SC_T(k=150)  annotation (Placement(transformation(extent={{-62,-112},{-42,-92}})));
  Modelica.Blocks.Sources.Constant SC_K(k=0.5)  annotation (Placement(transformation(extent={{-28,-112},{-8,-92}})));
  Modelica.Blocks.Sources.Constant P_tie_set_2(k=0)   annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={72,58})));
  TransiEnt.Components.Sensors.ElectricFrequency gridFrequency1(isDeltaMeasurement=true) annotation (Placement(transformation(extent={{-64,48},{-84,68}})));
  TransiEnt.Components.Sensors.ElectricActivePower tielinePower12 annotation (Placement(transformation(extent={{-18,66},{2,86}})));
  TransiEnt.Grid.Electrical.SecondaryControl.SecondaryBalancingController aGC1(
    K_r=(Gen_1.P_el_n/(Gen_1.P_el_n + Gen_2.P_el_n))*3e9/0.2,
    is_singleton=false,
    T_r=SC_T.k,
    beta=SC_K.k) annotation (Placement(transformation(extent={{-98,44},{-132,74}})));
  TransiEnt.Grid.Electrical.SecondaryControl.SecondaryBalancingController aGC(
    K_r=(Gen_2.P_el_n/(Gen_1.P_el_n + Gen_2.P_el_n))*3e9/0.2,
    is_singleton=false,
    T_r=SC_T.k,
    beta=SC_K.k) annotation (Placement(transformation(extent={{52,20},{18,50}})));
  Modelica.Blocks.Math.Gain tielinePower21(k=-1) annotation (Placement(transformation(extent={{16,94},{36,114}})));
  TransiEnt.Grid.Electrical.Base.TrumpetCurve trumpetCurve1(
    t_dist=100,
    d_margin=20e-3,
    delta_f_2=0.0393) annotation (Placement(transformation(extent={{-98,-112},{-78,-92}})));
  Modelica.Blocks.Sources.Constant P_tie_set_1(k=0)   annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-76,86})));
  TransiEnt.Components.Sensors.ElectricFrequency gridFrequency2(isDeltaMeasurement=true) annotation (Placement(transformation(extent={{90,24},{70,44}})));
  TransiEnt.Producer.Electrical.Conventional.Components.SimplePowerPlant Gen_A(P_el_n=3e9, nSubgrid=2) annotation (Placement(transformation(extent={{34,-122},{66,-90}})));
  Modelica.Blocks.Sources.Constant Psched(k=P_Z.k)
                                                  annotation (Placement(transformation(extent={{14,-90},{34,-70}})));
  TransiEnt.Components.Electrical.Grid.SeparableLine separableLine_L1_1 annotation (Placement(transformation(extent={{76,-107},{96,-87}})));
  Modelica.Blocks.Sources.BooleanStep Psched2(startValue=true, startTime=100) annotation (Placement(transformation(extent={{70,-82},{82,-70}})));
equation

  connect(Gen_1_set.y, Gen_1.P_el_set) annotation (Line(
      points={{-99,26},{-121.6,26},{-121.6,11.76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Gen_2.epp, Dem_2.epp) annotation (Line(
      points={{74.8,-22.56},{91.4,-22.56},{91.4,-22},{106.32,-22}},
      color={0,135,135},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Gen_2_set.y, Gen_2.P_el_set) annotation (Line(
      points={{63,6},{48.4,6},{48.4,-12.24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Load_1_set.y, Dem_1.P_el_set) annotation (Line(points={{-31,34},{-31,34},{-42,34},{-42,21.72}},                     color={0,0,127}));
  connect(Load_2_set.y, Dem_2.P_el_set) annotation (Line(points={{130.8,22},{130.8,22},{122,22},{122,-2.28}},                 color={0,0,127}));
  connect(Gen_1.epp,tielinePower12. epp_IN) annotation (Line(
      points={{-95.2,1.44},{-66,1.44},{-66,2},{-64,2},{-64,76},{-17.2,76}},
      color={0,135,135},
      thickness=0.5));
  connect(tielinePower12.epp_IN,gridFrequency1. epp) annotation (Line(
      points={{-17.2,76},{-17.2,76},{-64,76},{-64,58}},
      color={0,135,135},
      thickness=0.5));
  connect(tielinePower12.epp_OUT, Gen_2.epp) annotation (Line(
      points={{1.4,76},{1.4,76},{100,76},{100,-22},{88,-22},{74.8,-22},{74.8,-22.56}},
      color={0,135,135},
      thickness=0.5));
  connect(aGC1.P_tie_is, tielinePower12.P) annotation (Line(points={{-107.86,72.65},{-107.86,104},{-11.8,104},{-11.8,83.8}}, color={0,0,127}));
  connect(tielinePower12.P, tielinePower21.u) annotation (Line(points={{-11.8,83.8},{-11.8,104},{14,104}},
                                                                                                         color={0,0,127}));
  connect(aGC1.y, Gen_1.P_SB_set) annotation (Line(points={{-133.7,59},{-139.36,59},{-139.36,9.36}},   color={0,0,127}));
  connect(gridFrequency1.f, aGC1.u) annotation (Line(points={{-84.4,58},{-94.6,58},{-94.6,59}}, color={0,0,127}));
  connect(aGC.y, Gen_2.P_SB_set) annotation (Line(points={{16.3,35},{12,35},{12,-6},{30,-6},{30,-14.64},{30.64,-14.64}},     color={0,0,127}));
  connect(tielinePower21.y, aGC.P_tie_is) annotation (Line(points={{37,104},{42.14,104},{42.14,48.65}},
                                                                                                      color={0,0,127}));
  connect(aGC.P_tie_set, P_tie_set_2.y) annotation (Line(points={{50.3,48.65},{50.3,58},{61,58}},
                                                                                                color={0,0,127}));
  connect(P_tie_set_1.y, aGC1.P_tie_set) annotation (Line(points={{-87,86},{-99.7,86},{-99.7,72.65}},    color={0,0,127}));
  connect(Gen_1.epp, Dem_1.epp) annotation (Line(
      points={{-95.2,1.44},{-57.68,1.44},{-57.68,2}},
      color={0,135,135},
      thickness=0.5));
  connect(gridFrequency2.f, aGC.u) annotation (Line(points={{69.6,34},{55.4,34},{55.4,35}},    color={0,0,127}));
  connect(Gen_2.epp, gridFrequency2.epp) annotation (Line(
      points={{74.8,-22.56},{100,-22.56},{100,34},{90,34}},
      color={0,135,135},
      thickness=0.5));
  connect(Gen_A.epp, separableLine_L1_1.epp_1) annotation (Line(
      points={{65.2,-97.04},{70.6,-97.04},{70.6,-97.1},{76.1,-97.1}},
      color={0,135,135},
      thickness=0.5));
  connect(separableLine_L1_1.epp_2, Dem_2.epp) annotation (Line(
      points={{95.9,-97},{100,-97},{100,-22},{106.32,-22}},
      color={0,135,135},
      thickness=0.5));
  connect(Psched2.y, separableLine_L1_1.isConnected) annotation (Line(points={{82.6,-76},{86,-76},{86,-87}},    color={255,0,255}));
  connect(Psched.y, Gen_A.P_el_set) annotation (Line(points={{35,-80},{47.6,-80},{47.6,-90.16}},    color={0,0,127}));
public
function plotResult

  constant String resultFileName = "ElectricGrid_SecondaryBalancing.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=2, position={809, 0, 791, 817}, y={"aGC1.y", "aGC.y"}, range={0.0, 3600.0, -1200000000.0, 400000000.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  createPlot(id=2, position={809, 0, 791, 269}, y={"Gen_1.P_el_is", "Dem_1.P_el_is"}, range={0.0, 3600.0, 99800000000.0, 100800000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {217,67,180}},filename=resultFile);
  createPlot(id=2, position={809, 0, 791, 269}, y=fill("", 0), range={0.0, 3600.0, 48800000000.0, 50200000000.0}, grid=true, subPlot=3,filename=resultFile);
  plotExpression(apply(ElectricGrid_SecondaryBalancing[end].Gen_2.P_el_is), false, "ElectricGrid_SecondaryBalancing[end].Gen_2.P_el_is", 2);
  createPlot(id=3, position={0, 0, 793, 817}, y={"Gen_1.epp.f", "trumpetCurve1.y"}, range={0.0, 3600.0, 49.9, 50.059999999999995}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  createPlot(id=3, position={0, 0, 793, 269}, y={"tielinePower21.y"}, range={0.0, 3600.0, -600000000.0, 1000000000.0}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
  createPlot(id=3, position={0, 0, 793, 269}, y={"separableLine_L1_1.epp_2.P"}, range={0.0, 3600.0, -1500000000.0, 500000000.0}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,140}})),
    experiment(
      StopTime=3600,
      Tolerance=1e-009,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-160,-140},{160,140}})),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This validation model produces results that correspond to Page A1-7 of the entso-e operational handbook appendix 1: Load-frequency control. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Pascal Dubucq (dubucq@tuhh.de), Apr 2017</p></html>"));
end ElectricGrid_SecondaryBalancing;
