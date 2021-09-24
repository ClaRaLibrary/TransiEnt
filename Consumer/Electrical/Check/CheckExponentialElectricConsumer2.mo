within TransiEnt.Consumer.Electrical.Check;
model CheckExponentialElectricConsumer2


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ExponentialElectricConsumer Consumer(
    Q_el_set=500,
    cosphi_set=0.8,
    useCosPhi=true,
    v_n=simCenter.v_n,
    redeclare Characteristics.Industry variability,
    P_el_set_const=100e6,
    P_n=100e6,
    Q_n=75e6)       annotation (Placement(transformation(extent={{46,-68},{80,-36}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage ElectricGrid(
    v_boundary=400,
    Use_input_connector_f=true,
    Use_input_connector_v=true) annotation (Placement(transformation(extent={{-8,-68},{-38,-36}})));
  inner TransiEnt.SimCenter simCenter(v_n=400) annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Sine GridFrequency(
    offset=50,
    startTime=0,
    f=1/900,
    amplitude=0.05) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-10})));
  Modelica.Blocks.Sources.Step GridVoltage(
    offset=400,
    startTime=1800,
    height=40) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-62,-42})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(GridFrequency.y, ElectricGrid.f_set) annotation (Line(points={{-49,-10},{-14,-10},{-14,-32.8},{-14.9,-32.8}},
                                                                                                    color={0,0,127}));
  connect(GridVoltage.y, ElectricGrid.v_set) annotation (Line(points={{-51,-42},{-48,-42},{-44,-42},{-44,-20},{-32,-20},{-32,-32.8}},  color={0,0,127}));
  connect(ElectricGrid.epp, Consumer.epp) annotation (Line(points={{-8,-52},{-1.925,-52},{-1.925,-52},{46.34,-52}},         color={0,127,0}));
public
function plotResult

  constant String resultFileName = "CheckExponentialElectricConsumer.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 695}, y={"simCenter.f_n", "ElectricGrid.epp.f"}, range={0.0, 3600.0, 49.900000000000006, 50.10000000000001}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 135}, y={"ElectricGrid.epp.v", "simCenter.v_n"}, range={0.0, 3600.0, 380.0, 460.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 135}, y={"Consumer.epp.P", "Consumer.P_el_nom.y"}, range={0.0, 3600.0, 1980.0, 2040.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 135}, y={"Consumer.epp.Q", "Consumer.Q_el_nom.y"}, range={0.0, 3600.0, 0.0, 2000.0}, grid=true, subPlot=4, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 135}, y={"Consumer.cosphi_set"}, range={0.0, 3600.0, 0.7000000000000001, 0.9000000000000001}, grid=true, subPlot=5, colors={{28,108,200}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-80},{100,80}})),
                                        Icon(graphics,
                                             coordinateSystem(extent={{-80,-80},
            {100,80}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for an exponential electric consumer with a variable grid voltage and a variable grid frequency</p>
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
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput);
end CheckExponentialElectricConsumer2;
