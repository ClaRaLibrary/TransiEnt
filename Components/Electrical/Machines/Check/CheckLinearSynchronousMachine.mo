within TransiEnt.Components.Electrical.Machines.Check;
model CheckLinearSynchronousMachine
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  // *** GRID ***

  // *** DEMAND ***

  // *** STORAGE ***

  // *** ELECTRIC GENERATORS ***

  // *** ENERGY SOURCE ***

  inner TransiEnt.SimCenter simCenter(f_n=50)
                                      annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  TransiEnt.Components.Electrical.Machines.LinearSynchronousMachine Generator(eta=0.95) annotation (Placement(transformation(extent={{10,-52},{30,-32}})));
  Modelica.Blocks.Sources.Cosine   P_load(
    startTime=0,
    freqHz=1/20,
    amplitude=0.08e6,
    offset=0.1e6)                                  annotation (Placement(transformation(extent={{40,14},{60,34}})));
  Modelica.Blocks.Sources.Constant v_n(k=110e3)         annotation (Placement(transformation(extent={{-68,8},{-48,28}})));
  TransiEnt.Components.Boundaries.Mechanical.Power Turbine(tau_is(start=20))
                                                           annotation (Placement(transformation(extent={{-48,-53},{-28,-31}})));
  Modelica.Blocks.Math.Gain        voltageCtrl(k=1e5)
                                                  "W" annotation (Placement(transformation(extent={{-12,10},{4,26}})));
  Modelica.Blocks.Math.Gain P_n(k=-1/Generator.eta)
                                                annotation (Placement(transformation(extent={{-72,-24},{-52,-4}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-40,28},{-20,8}})));
public
function plotResult

  constant String resultFileName = "CheckLinearSynchronousMachine.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={809, 0, 791, 817}, x="ElectricGrid.epp.v", y={"Generator.epp.f", "Generator.f_n"}, range={0.0, 20.0, 49.99999000000001, 50.00003000000001}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
  createPlot(id=1, position={809, 0, 791, 200}, x="ElectricGrid.epp.v", y={"Generator.P_el_n", "Generator.P_el_is", "load.P_el_nom.y"}, range={0.0, 20.0, 0.0, 200000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFile);
  createPlot(id=1, position={809, 0, 791, 201}, x="ElectricGrid.epp.v", y={"Generator.epp.v", "Generator.v_n"}, range={0.0, 20.0, 109998.5, 110000.5}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
  createPlot(id=1, position={809, 0, 791, 200}, x="ElectricGrid.epp.v", y={"Generator.Q_n", "Generator.Q_is"}, range={0.0, 20.0, 0.0, 150000.0}, grid=true, subPlot=4, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumer load(
    cosphi_set=0.8,
    useCosPhi=true,
    useInputConnectorP=true,
    f_n=50,
    v_n=v_n.k,
    redeclare TransiEnt.Consumer.Electrical.Characteristics.Industry variability) annotation (Placement(transformation(extent={{64,-52},{84,-32}})));
  TransiEnt.Components.Sensors.ElectricFrequencyVoltage electricFrequencyVoltage annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={42,2})));

  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem_ApparentPowerPort dummyExcitationSystem_ApparentPowerPort annotation (Placement(transformation(extent={{48,-32},{28,-12}})));
equation
  connect(feedback.y, voltageCtrl.u) annotation (Line(points={{-21,18},{-13.6,18}},
                                                                                  color={0,0,127}));
  connect(P_n.y, Turbine.P_mech_set) annotation (Line(points={{-51,-14},{-38,-14},{-38,-29.02}}, color={0,0,127}));
  connect(Generator.epp, load.epp) annotation (Line(
      points={{30.1,-42.1},{58.05,-42.1},{58.05,-42},{64.2,-42}},
      color={0,127,0},
      thickness=0.5));
  connect(P_load.y, load.P_el_set) annotation (Line(points={{61,24},{74,24},{74,-30.4}}, color={0,0,127}));
  connect(electricFrequencyVoltage.epp, load.epp) annotation (Line(
      points={{52,2.2},{52,2},{56,2},{56,-42},{64.2,-42}},
      color={0,127,0},
      thickness=0.5));
  connect(v_n.y, feedback.u1) annotation (Line(points={{-47,18},{-38,18},{-38,18}}, color={0,0,127}));
  connect(electricFrequencyVoltage.v, feedback.u2) annotation (Line(points={{32,8},{26,8},{26,36},{-30,36},{-30,26}},   color={0,0,127}));
  connect(P_load.y, P_n.u) annotation (Line(points={{61,24},{78,24},{78,46},{-36,46},{-36,46},{-82,46},{-82,-14},{-74,-14}}, color={0,0,127}));
  connect(voltageCtrl.y, Generator.K_q) annotation (Line(points={{4.8,18},{6,18},{6,-48},{11.9,-48},{11.9,-48.3}},
                                                                                                   color={0,0,127}));
  connect(Turbine.mpp, Generator.mpp) annotation (Line(points={{-28,-42},{-12,-42},{-12,-42},{10,-42}},      color={95,95,95}));
  connect(dummyExcitationSystem_ApparentPowerPort.epp1, load.epp) annotation (Line(
      points={{48,-22},{56,-22},{56,-42},{64.2,-42}},
      color={0,127,0},
      thickness=0.5));
  connect(dummyExcitationSystem_ApparentPowerPort.y, Generator.E_input) annotation (Line(points={{27.4,-22},{20,-22},{20,-32.1},{19.7,-32.1}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                               Icon(graphics,
                                                    coordinateSystem(extent={{-100,
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
end CheckLinearSynchronousMachine;
