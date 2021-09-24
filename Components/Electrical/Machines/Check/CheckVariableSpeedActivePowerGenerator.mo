within TransiEnt.Components.Electrical.Machines.Check;
model CheckVariableSpeedActivePowerGenerator

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
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
  TransiEnt.Components.Electrical.Machines.VariableSpeedActivePowerGenerator Generator annotation (Placement(transformation(extent={{2,-62},{22,-42}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer Power(useInputConnectorP=true) annotation (Placement(transformation(extent={{64,-62},{84,-42}})));
  Modelica.Blocks.Sources.Constant P_n(k=1e6)   annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant P_load(k=0.5e6) annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Sources.Constant omega_n(k=2*3.14*1/5) "rad/sec"
                                                        annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Constant H_gen(k=8) "Time constant" annotation (Placement(transformation(extent={{-14,40},{6,60}})));
  Modelica.Blocks.Continuous.LimPID T_set(
    yMax=2*P_n.k/omega_n.k,
    wp=1,
    k=P_n.k/omega_n.k/omega_n.k*10,
    controllerType=Modelica.Blocks.Types.SimpleController.PI) "Time constant" annotation (Placement(transformation(extent={{-28,-4},{-8,16}})));
  TransiEnt.Components.Boundaries.Mechanical.Power Turbine annotation (Placement(transformation(extent={{-78,-63},{-58,-41}})));
  Modelica.Mechanics.Rotational.Components.Inertia Inertia(J=H_gen.k*omega_n.k^2/P_n.k, w(fixed=true, start=omega_n.k)) annotation (Placement(transformation(extent={{-48,-63},{-28,-43}})));
  Modelica.Blocks.Sources.Constant f_set(k=omega_n.k/2/Modelica.Constants.pi) "Hz" annotation (Placement(transformation(extent={{-72,-4},{-52,16}})));
  Modelica.Blocks.Sources.RealExpression f_is(y=Inertia.w/2/Modelica.Constants.pi)
                                                             "Hz" annotation (Placement(transformation(extent={{-42,-34},{-22,-14}})));
  Modelica.Blocks.Sources.Constant P_is(k=-0.5e6) "W" annotation (Placement(transformation(extent={{-100,-34},{-80,-14}})));
  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem dummyExcitationSystem annotation (Placement(transformation(extent={{48,-44},{28,-24}})));
equation
  connect(Power.epp, Generator.epp) annotation (Line(
      points={{64.2,-52},{64.2,-52.1},{22.1,-52.1}},
      color={0,135,135},
      thickness=0.5));
  connect(T_set.y, Generator.tau_set) annotation (Line(points={{-7,6},{-4,6},{-4,-58},{2,-58},{2,-58.5},{2.7,-58.5}}, color={0,0,127}));
  connect(Inertia.flange_b, Generator.mpp) annotation (Line(points={{-28,-53},{-14,-53},{-14,-52},{2,-52}},       color={0,0,0}));
  connect(Turbine.mpp, Inertia.flange_a) annotation (Line(points={{-58,-52},{-58,-52},{-58,-53},{-48,-53}}, color={95,95,95}));
  connect(P_is.y, Turbine.P_mech_set) annotation (Line(points={{-79,-24},{-74,-24},{-68,-24},{-68,-39.02}}, color={0,0,127}));
  connect(Power.P_el_set, P_load.y) annotation (Line(points={{74,-40.4},{74,50},{61,50}},     color={0,0,127}));
  connect(f_set.y, T_set.u_s) annotation (Line(points={{-51,6},{-46,6},{-30,6}}, color={0,0,127}));
  connect(f_is.y, T_set.u_m) annotation (Line(points={{-21,-24},{-18,-24},{-18,-6}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckVariableSpeedActivePowerGenerator.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"Generator.epp.P"}, range={0.0, 100.0, 244400.0, 245400.0}, grid=true, colors={{28,108,200}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 179}, y={"Turbine.mpp.tau"}, range={0.0, 100.0, -300000.0, 100000.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 180}, y={"Generator.mpp.der(phi)", "Turbine.mpp.der(phi)"}, range={0.0, 100.0, -1000000.0, 3000000.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 179}, y={"f_set.y", "f_is.y"}, range={0.0, 100.0, 0.3, 0.38}, grid=true, subPlot=4, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(dummyExcitationSystem.y, Generator.E_input) annotation (Line(points={{27.4,-34},{11.7,-34},{11.7,-42.1}}, color={0,0,127}));
  connect(dummyExcitationSystem.epp1, Generator.epp) annotation (Line(
      points={{48,-34},{54,-34},{54,-52},{60,-52},{22.1,-52.1}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                               Icon(graphics,
                                                    coordinateSystem(extent={{-100,
            -100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for VariableSpeedActivePowerGenerator</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end CheckVariableSpeedActivePowerGenerator;
