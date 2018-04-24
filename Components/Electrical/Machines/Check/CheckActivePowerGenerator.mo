within TransiEnt.Components.Electrical.Machines.Check;
model CheckActivePowerGenerator
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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;

  // *** GRID ***

  // *** DEMAND ***

  // *** STORAGE ***

  // *** ELECTRIC GENERATORS ***

  // *** ENERGY SOURCE ***

  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  inner TransiEnt.SimCenter simCenter(f_n=50)
                                      annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=0.95) annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer Load(useInputConnectorP=true) annotation (Placement(transformation(extent={{74,-28},{94,-8}})));
  Modelica.Blocks.Sources.Cosine   P_load(
    amplitude=0.1e6,
    offset=0.4e6,
    startTime=0,
    freqHz=1/20)                                   annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Sources.Constant w_nom(k=2*3.14*50)
                                              "rad/sec" annotation (Placement(transformation(extent={{-88,-6},{-68,14}})));
  Modelica.Blocks.Sources.Constant H_gen(k=8) "Time constant" annotation (Placement(transformation(extent={{-14,40},{6,60}})));
  TransiEnt.Components.Boundaries.Mechanical.Power Turbine annotation (Placement(transformation(extent={{-24,-31},{-4,-9}})));
  Modelica.Mechanics.Rotational.Components.Inertia Inertia(J=H_gen.k*w_nom.k^2/P_nom.k,
    w(fixed=true, start=w_nom.k),
    a(fixed=false))                                               annotation(Placement(transformation(extent={{4,-30},{24,-10}})));
  Modelica.Blocks.Continuous.PI    speedCtrl(
    k=-1e3*0.5e6/Generator.eta,
    T=10,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.4e6)                                "W" annotation (Placement(transformation(extent={{-34,-4},{-18,12}})));
  Modelica.Blocks.Sources.Constant P_nom(k=1e6) annotation (Placement(transformation(extent={{-68,38},{-48,58}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,20})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-64,14},{-44,-6}})));
equation
  connect(Load.epp, Generator.epp) annotation (Line(
      points={{74.2,-18},{74.2,-20.1},{60.1,-20.1}},
      color={0,135,135},
      thickness=0.5));
  connect(Inertia.flange_b, Generator.mpp) annotation (Line(points={{24,-20},{40,-20},{40,-20.5},{39.5,-20.5}},   color={0,0,0}));
  connect(Turbine.mpp, Inertia.flange_a) annotation (Line(points={{-4,-20},{-4,-20},{4,-20}},               color={95,95,95}));
  connect(Load.P_el_set, P_load.y) annotation (Line(points={{84,-6.4},{84,50},{61,50}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckActivePowerGenerator.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={809, 0, 791, 817}, y={"Turbine.P_mech_is", "Generator.P_el_is", "Load.P_el_is"}, range={0.0, 20.0, 0, 535000.0}, autoscale=false, grid=true, colors={{28,108,200}, {194,194,194}, {0,140,72}}, thicknesses={0.25, 1.0, 0.25}, range2={0.88, 0.96}, filename=resultFile);
  createPlot(id=1, position={809, 0, 791, 406}, y={"Generator.epp.f"}, range={0.0, 20.0, 49.97448000000001, 49.97466000000001}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(Inertia.flange_b, speedSensor.flange) annotation (Line(points={{24,-20},{30,-20},{30,20},{10,20}},     color={0,0,0}));
  connect(speedCtrl.y, Turbine.P_mech_set) annotation (Line(points={{-17.2,4},{-14,4},{-14,-7.02}}, color={0,0,127}));
  connect(feedback.y, speedCtrl.u) annotation (Line(points={{-45,4},{-35.6,4}}, color={0,0,127}));
  connect(w_nom.y, feedback.u1) annotation (Line(points={{-67,4},{-62,4}}, color={0,0,127}));
  connect(speedSensor.w, feedback.u2) annotation (Line(points={{-11,20},{-54,20},{-54,12}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                               Icon(coordinateSystem(extent={{-100,
            -100},{100,100}})),
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
    experiment(StopTime=20));
end CheckActivePowerGenerator;
