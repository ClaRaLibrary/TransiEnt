within TransiEnt.Components.Gas.VolumesValvesFittings.Check;
model Test_Mixing_H2NG
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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
  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Checkmodel;

  parameter SI.VolumeFraction phi_H2max=0.1 "Maximum admissible volume fraction of H2 in NGH2 at normal conditions";
  parameter Real f_gasDemand=simCenter.f_gasDemand "Gain value for gas demand";

  inner TransiEnt.SimCenter simCenter(
  tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
    p_eff_2=0,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1)
                   annotation (Placement(transformation(extent={{-210,120},{-190,140}})));

  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 mix_NGH2(
    p(
    start = simCenter.p_amb_const),
    volume=1,
    h(
    start = 19.8e3))
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-27,-88})));
protected
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source(
    m(fixed=true),
    variable_p=true,
    variable_T=true) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-170,-62})));

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink(
    m(fixed=true),
    m_flow_const=10,
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={120,-102})));

protected
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sourceH2(
    m(fixed=true),
    xi_const=zeros(sourceH2.medium.nc - 1),
    variable_m_flow=true,
    variable_T=true) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-26,100})));
public
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor(compositionDefinedBy=1) annotation (Placement(transformation(extent={{0,-6},{-20,14}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor vleTemperatureSensor annotation (Placement(transformation(extent={{0,44},{-20,64}})));
  TransiEnt.Components.Sensors.RealGas.PressureSensor vlePressureSensor annotation (Placement(transformation(extent={{-20,68},{0,88}})));
  TransiEnt.Components.Sensors.RealGas.PressureSensor vlePressureSensor2 annotation (Placement(transformation(extent={{-140,-62},{-120,-42}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor vleTemperatureSensor2 annotation (Placement(transformation(extent={{-112,-62},{-92,-42}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor1(compositionDefinedBy=1) annotation (Placement(transformation(extent={{-118,-102},{-98,-82}})));
  TransiEnt.Components.Sensors.RealGas.PressureSensor vlePressureSensor3 annotation (Placement(transformation(extent={{-6,-72},{14,-52}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor vleTemperatureSensor3 annotation (Placement(transformation(extent={{22,-72},{42,-52}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor2(compositionDefinedBy=1) annotation (Placement(transformation(extent={{52,-102},{72,-82}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensorH2(xiNumber=massflowSensorH2.medium.nc) annotation (Placement(transformation(extent={{-20,-32},{0,-12}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensorNG(xiNumber=massflowSensorNG.medium.nc) annotation (Placement(transformation(extent={{-76,-102},{-56,-82}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensorMix(xiNumber=massflowSensorMix.medium.nc) annotation (Placement(transformation(extent={{82,-102},{102,-82}})));
  TransiEnt.Components.Sensors.RealGas.SpecificEnthalpySensor vleSpecificEnthalpySensor1 annotation (Placement(transformation(extent={{-84,-62},{-64,-42}})));
  TransiEnt.Components.Sensors.RealGas.SpecificEnthalpySensor vleSpecificEnthalpySensor2 annotation (Placement(transformation(extent={{50,-72},{70,-52}})));
  TransiEnt.Components.Sensors.RealGas.SpecificEnthalpySensor vleSpecificEnthalpySensor3 annotation (Placement(transformation(extent={{-20,18},{0,38}})));
  Modelica.Blocks.Sources.Step T_NG(
    height=20,
    offset=simCenter.T_ground,
    startTime=40)
                 annotation (Placement(transformation(extent={{-214,-72},{-194,-52}})));
  Modelica.Blocks.Sources.Pulse p_NG(
    offset=simCenter.p_amb_const,
    width=100,
    nperiod=4,
    startTime=2,
    amplitude=45e5,
    period=11)    annotation (Placement(transformation(extent={{-214,-104},{-194,-82}})));
  Modelica.Blocks.Sources.Pulse mFlowH2(
    width=100,
    nperiod=2,
    amplitude=-10,
    offset=0,
    period=14,
    startTime=25)
                 annotation (Placement(transformation(extent={{-66,108},{-46,128}})));
  Modelica.Blocks.Sources.Pulse mFlowSink(
    width=100,
    nperiod=2,
    amplitude=5,
    offset=10,
    period=14,
    startTime=30) annotation (Placement(transformation(extent={{158,-118},{138,-98}})));
  Modelica.Blocks.Sources.Step T_H2(
    height=20,
    offset=simCenter.T_ground,
    startTime=35) annotation (Placement(transformation(extent={{12,108},{-8,128}})));

  // _____________________________________________
  //
  //             Private functions
  // _____________________________________________

  function plotResult

  constant String resultFileName = "Test_Mixing_H2NG.mat";

  output String resultFile;

  algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots(false);

  createPlot(id=1, position={0, 0, 722, 912}, y={"mix_NGH2.mass"}, range={0.0, 65.0, 0.0, 60.0}, grid=true, colors={{28,108,200}});
  createPlot(id=1, position={0, 0, 722, 225}, y={"T_NG.y", "T_H2.y", "mix_NGH2.summary.gas.T"}, range={0.0, 65.0, 270.0, 310.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}});
  createPlot(id=1, position={0, 0, 722, 224}, y={"mFlowH2.y", "mFlowSink.y"}, range={0.0, 65.0, -20.0, 20.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}});
  createPlot(id=1, position={0, 0, 722, 224}, y={"p_NG.y"}, range={0.0, 65.0, 0.0, 6000000.0}, grid=true, subPlot=4, colors={{28,108,200}});

  resultFile := "Successfully plotted results for file: " + resultFile;

  end plotResult;

equation
  connect(sourceH2.gasPort, vlePressureSensor.gasPortIn) annotation (Line(
      points={{-26,90},{-26,68},{-20,68}},
      color={255,255,0},
      thickness=1.5));
  connect(vlePressureSensor.gasPortOut, vleTemperatureSensor.gasPortIn) annotation (Line(
      points={{0,68},{8,68},{8,44},{0,44}},
      color={255,255,0},
      thickness=1.5));
  connect(vlePressureSensor2.gasPortOut, vleTemperatureSensor2.gasPortIn) annotation (Line(
      points={{-120,-62},{-120,-62},{-112,-62}},
      color={255,255,0},
      thickness=1.5));
  connect(mix_NGH2.gasPort3, vlePressureSensor3.gasPortIn) annotation (Line(
      points={{-17,-88},{-6,-88},{-6,-72}},
      color={255,255,0},
      thickness=1.5));
  connect(vlePressureSensor3.gasPortOut, vleTemperatureSensor3.gasPortIn) annotation (Line(
      points={{14,-72},{14,-72},{22,-72}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensorNG.gasPortOut, mix_NGH2.gasPort1) annotation (Line(
      points={{-56,-102},{-40,-102},{-40,-88},{-37,-88}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor1.gasPortOut, massflowSensorNG.gasPortIn) annotation (Line(
      points={{-98,-102},{-76,-102}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor2.gasPortOut, massflowSensorMix.gasPortIn) annotation (Line(
      points={{72,-102},{72,-102},{82,-102}},
      color={255,255,0},
      thickness=1.5));
  connect(vleTemperatureSensor2.gasPortOut, vleSpecificEnthalpySensor1.gasPortIn) annotation (Line(
      points={{-92,-62},{-88,-62},{-84,-62}},
      color={255,255,0},
      thickness=1.5));
  connect(vleSpecificEnthalpySensor1.gasPortOut, vleCompositionSensor1.gasPortIn) annotation (Line(
      points={{-64,-62},{-64,-72},{-130,-72},{-130,-102},{-118,-102}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensorH2.gasPortOut, mix_NGH2.gasPort2) annotation (Line(
      points={{0,-32},{4,-32},{4,-48},{-27,-48},{-27,-78}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensorMix.gasPortOut, sink.gasPort) annotation (Line(
      points={{102,-102},{110,-102}},
      color={255,255,0},
      thickness=1.5));
  connect(vlePressureSensor2.gasPortIn, source.gasPort) annotation (Line(
      points={{-140,-62},{-160,-62}},
      color={255,255,0},
      thickness=1.5));
  connect(p_NG.y, source.p) annotation (Line(points={{-193,-93},{-193,-81.5},{-182,-81.5},{-182,-68}}, color={0,0,127}));
  connect(T_NG.y, source.T) annotation (Line(points={{-193,-62},{-182,-62}}, color={0,0,127}));
  connect(mFlowH2.y, sourceH2.m_flow) annotation (Line(points={{-45,118},{-38,118},{-32,118},{-32,112}}, color={0,0,127}));
  connect(vleTemperatureSensor.gasPortOut, vleSpecificEnthalpySensor3.gasPortIn) annotation (Line(
      points={{-20,44},{-28,44},{-32,44},{-32,18},{-20,18}},
      color={255,255,0},
      thickness=1.5));
  connect(vleSpecificEnthalpySensor3.gasPortOut, vleCompositionSensor.gasPortIn) annotation (Line(
      points={{0,18},{8,18},{8,-6},{0,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor.gasPortOut, massflowSensorH2.gasPortIn) annotation (Line(
      points={{-20,-6},{-32,-6},{-32,-32},{-20,-32}},
      color={255,255,0},
      thickness=1.5));
  connect(vleTemperatureSensor3.gasPortOut, vleSpecificEnthalpySensor2.gasPortIn) annotation (Line(
      points={{42,-72},{50,-72}},
      color={255,255,0},
      thickness=1.5));
  connect(vleSpecificEnthalpySensor2.gasPortOut, vleCompositionSensor2.gasPortIn) annotation (Line(
      points={{70,-72},{76,-72},{76,-78},{26,-78},{26,-102},{52,-102}},
      color={255,255,0},
      thickness=1.5));
  connect(sink.m_flow, mFlowSink.y) annotation (Line(points={{132,-108},{137,-108}}, color={0,0,127}));
  connect(T_H2.y, sourceH2.T) annotation (Line(points={{-9,118},{-26,118},{-26,112}}, color={0,0,127}));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-140},{160,140}}), graphics={Text(
          extent={{-216,106},{-44,18}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="#LA, 16.02.2017
Temperature after mixing H2 and NG7 is lower than before
Deviation increases with increasing pressure and decreasing temperature
time: 32 s, 42 s, 47 s

Look at:
mix_NGH2.summary.gas.T
mix_NGH2.mass
p_NG.y
mFlowH2.y, mFlowSink.y
T_NG.y, T_H2.y

(Commands -> Plot example results)")}),
    experiment(StopTime=60, Tolerance=1e-006),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_Commands(executeCall=TransiEnt.Components.Gas.VolumesValvesFittings.Check.Test_Mixing_H2NG.plotResult() "Plot example results"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for mixing hydrogen and natural gas</p>
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
</html>"));
end Test_Mixing_H2NG;
