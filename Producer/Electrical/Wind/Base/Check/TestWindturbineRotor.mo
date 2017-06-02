within TransiEnt.Producer.Electrical.Wind.Base.Check;
model TestWindturbineRotor
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

  constant String resultFileName = "TestDrydenTurbulence.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={0, 0, 1616, 731}, y={"v_noturb.y1", "v_turb_high.y", "v_turb_low.y"}, range={0.0, 500.0, 1.9000000000000001, 2.9000000000000004}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFileName);
createPlot(id=1, position={0, 0, 1616, 363}, y={"turb_high.delta_v_turb", "turb_low.delta_v_turb"}, range={0.0, 500.0, -0.5, 0.5}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  WindturbineRotor windturbineRotor(P_el_n=P_nom.k) annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation (Placement(transformation(extent={{64,-10},{44,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=85,
    duration=400,
    offset=0,
    startTime=3600) annotation (Placement(transformation(extent={{-40,28},{-20,48}})));
  Modelica.Blocks.Sources.Ramp v_wind(
    height=12,
    duration=3600,
    offset=0) annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
  Modelica.Blocks.Sources.Constant P_nom(k=3e6) annotation (Placement(transformation(extent={{-92,60},{-72,80}})));
  Modelica.Blocks.Sources.Constant w_nom(k=8*2*12/windturbineRotor.D) annotation (Placement(transformation(extent={{-64,60},{-44,80}})));
  Modelica.Mechanics.Rotational.Components.Inertia Inertia(J=10*w_nom.k^2/P_nom.k, w(fixed=true, start=0))
                                                                  annotation(Placement(transformation(extent={{32,-10},{12,10}})));
  Modelica.Blocks.Sources.RealExpression f_is(y=Inertia.w/2/Modelica.Constants.pi)
                                                             "Hz" annotation (Placement(transformation(extent={{40,16},{60,36}})));
  Modelica.Blocks.Continuous.LimPID T_set(
    wp=1,
    k=P_nom.k/w_nom.k/w_nom.k*10,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=2*P_nom.k/w_nom.k)       "Time constant"                           annotation (Placement(transformation(extent={{54,46},{74,66}})));
  Modelica.Blocks.Sources.Constant f_set(k=w_nom.k/2/Modelica.Constants.pi) "Hz" annotation (Placement(transformation(extent={{20,46},{40,66}})));
  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-20,80},{0,100}})));
equation
  connect(v_wind.y, windturbineRotor.v_wind) annotation (Line(points={{-33,0},{-17.4,0},{-17.4,-0.2}}, color={0,0,127}));
  connect(ramp.y, windturbineRotor.beta_set) annotation (Line(points={{-19,38},{-8,38},{-8,9.6}}, color={0,0,127}));
  connect(f_is.y,T_set. u_m) annotation (Line(points={{61,26},{64,26},{64,44}},      color={0,0,127}));
  connect(f_set.y,T_set. u_s) annotation (Line(points={{41,56},{41,56},{52,56}}, color={0,0,127}));
  connect(windturbineRotor.flange, Inertia.flange_b) annotation (Line(points={{2.2,0},{12,0}}, color={0,0,0}));
  connect(Inertia.flange_a, torque.flange) annotation (Line(points={{32,0},{32,0},{44,0}}, color={0,0,0}));
  connect(T_set.y, torque.tau) annotation (Line(points={{75,56},{82,56},{82,54},{82,0},{66,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=4000));
end TestWindturbineRotor;
