within TransiEnt.Consumer.Heat.Check;
model TestIdealHeatingNetworkConsumer


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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




  extends TransiEnt.Basics.Icons.Checkmodel;
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-130,80},{-110,100}})));

  IdealHeatingNetworkConsumer ConsumerStation(T_return_const=50 + 273.15) annotation (Placement(transformation(extent={{12,-10},{-8,10}})));
  Modelica.Blocks.Sources.Constant Q_th_demand(k=250e6) annotation (Placement(transformation(extent={{36,18},{16,38}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi districtHeatingReturn(
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=100000,
    variable_p=false,
    h_const=400e3) annotation (Placement(transformation(
        extent={{13,-11},{-13,11}},
        rotation=180,
        origin={-47,-6})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow districtHeatingSupply(
    m_flow_const=0.1,
    m_flow_nom=0,
    p_nom=1000,
    variable_m_flow=false,
    variable_T=true)
                   annotation (Placement(transformation(extent={{-62,16},{-30,42}})));
  Modelica.Blocks.Sources.Step     T_feed(
    height=20,
    offset=373.15,
    startTime=100)                                      annotation (Placement(transformation(extent={{-106,20},{-86,40}})));
equation
  connect(Q_th_demand.y, ConsumerStation.Q_flow_demand) annotation (Line(points={{15,28},{2.4,28},{2.4,9.4}},
                                                                                                    color={0,0,127}));
  connect(districtHeatingSupply.T, T_feed.y) annotation (Line(points={{-65.2,29},{-72,29},{-72,30},{-85,30}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestIdealHeatingNetworkConsumer.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 817}, y={"districtHeatingSupply.eye.T"}, range={0.0, 200.0, 98.0, 122.0}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 406}, y={"districtHeatingReturn.steam_a.m_flow"}, range={0.0, 200.0, 750.0, 1150.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(ConsumerStation.fluidPortOut, districtHeatingReturn.steam_a) annotation (Line(
      points={{-8,-8},{-12,-8},{-12,-6},{-34,-6}},
      color={175,0,0},
      thickness=0.5));
  connect(ConsumerStation.fluidPortIn, districtHeatingSupply.steam_a) annotation (Line(
      points={{-8,-4},{-12,-4},{-12,-2},{-12,29},{-30,29}},
      color={175,0,0},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{100,100}})),
    experiment(StopTime=200),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(graphics,
         coordinateSystem(extent={{-160,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test enviroment for an ideal heating network consumer with a constant heat flow rate demand a variable temperature</p>
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
</html>"));
end TestIdealHeatingNetworkConsumer;
