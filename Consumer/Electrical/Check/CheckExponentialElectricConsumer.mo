within TransiEnt.Consumer.Electrical.Check;
model CheckExponentialElectricConsumer

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
    redeclare Characteristics.Industry variability,
    P_el_set_const=100e6,
    v_n=110e3,
    P_n=100e6,
    Q_n=75e6)       annotation (Placement(transformation(extent={{46,-68},{80,-36}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage ElectricGrid(
    v_boundary=400,
    Use_input_connector_v=true,
    Use_input_connector_f=false) annotation (Placement(transformation(extent={{-8,-68},{-38,-36}})));
  inner TransiEnt.SimCenter simCenter(v_n=400) annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp GridVoltage(
    height=2*Consumer.v_n,
    duration=3600,
    offset=0,
    startTime=0)
               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-62,-42})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

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

createPlot(id=1, position={0, 0, 793, 817}, x="ElectricGrid.epp.v", y={"Consumer.epp.P", "Consumer.epp.Q", "Consumer.P_el_set_const", "Consumer.Q_el_nom.y"}, range={0.0, 220000.0, -5000000.0, 120000000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-80,-80},{100,80}})),
                                        Icon(graphics,
                                             coordinateSystem(extent={{-80,-80},
            {100,80}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for checking the exponential electric consumer</p>
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
end CheckExponentialElectricConsumer;
