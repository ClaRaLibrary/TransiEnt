within TransiEnt.Consumer.Electrical.Check;
model CheckTableBasedElectricConsumer


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

  TableBasedElectricConsumer Consumer(redeclare TransiEnt.Basics.Tables.ElectricGrid.PowerData.ElectricityDemand_HH_900s_2012 consumerDataTable) annotation (Placement(transformation(extent={{16,-16},{50,16}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid(useInputConnector=false) annotation (Placement(transformation(extent={{-10,-16},{-40,16}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(ElectricGrid.epp, Consumer.epp) annotation (Line(
      points={{-10,0},{17.075,0},{17.075,0},{16.34,0}},
      color={0,0,0},
      smooth=Smooth.None));

public
function plotResult

  constant String resultFileName = "CheckTableBasedElectricConsumer.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 695}, y={"Consumer.epp.P"}, range={0.0, 650000.0, 900000000.0, 1900000000.0}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 345}, y={"modelStatistics.electricPower.P_demand"}, range={0.0, 650000.0, 900000000.0, 1900000000.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-80,-80},{100,80}})),
                                        Icon(graphics,
                                             coordinateSystem(extent={{-80,-80},
            {100,80}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for checking a table based electric cosumer</p>
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
    experiment(StopTime=604800),
    __Dymola_experimentSetupOutput);
end CheckTableBasedElectricConsumer;
