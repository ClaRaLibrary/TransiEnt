within TransiEnt.Producer.Electrical.Wind.Base.Check;
model TestDrydenTurbulence
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

  DrydenTurbulence turb_low(t=0.1, sigma=0.05*2.4)
                               annotation (Placement(transformation(extent={{-44,-72},{-24,-52}})));

  DrydenTurbulence turb_high(       sigma=0.1*2.4, t=0.1)
                               annotation (Placement(transformation(extent={{-48,50},{-28,70}})));

  TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 v_noturb annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
  Modelica.Blocks.Math.Add          v_turb_low       annotation (Placement(transformation(extent={{4,-54},{24,-34}})));
  Modelica.Blocks.Math.Add          v_turb_high       annotation (Placement(transformation(extent={{4,44},{24,64}})));

equation
  connect(turb_high.delta_v_turb, v_turb_high.u1) annotation (Line(points={{-27.6,60},{-27.6,60},{2,60}}, color={0,0,127}));
  connect(turb_low.delta_v_turb, v_turb_low.u2) annotation (Line(points={{-23.6,-62},{-12,-62},{-12,-50},{2,-50}}, color={0,0,127}));
  connect(v_noturb.y1, v_turb_low.u1) annotation (Line(points={{-53,0},{-18,0},{-18,-38},{2,-38}}, color={0,0,127}));
  connect(v_noturb.y1, v_turb_high.u2) annotation (Line(points={{-53,0},{-16,0},{-16,48},{2,48}}, color={0,0,127}));
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=60));

end TestDrydenTurbulence;
