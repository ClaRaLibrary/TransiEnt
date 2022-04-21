within TransiEnt.Consumer.Systems.PVBatteryPoolControl.Controller.Check;
model CheckBatteryConditioningController "Tester for BatteryConditioningController"


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

  inner Base.PoolParameter param(nSystems=1, SOC_min=0.2) annotation (Placement(transformation(extent={{-30,42},{0,72}})));
  BatteryConditioningController ctrl(index=1) annotation (Placement(transformation(extent={{28,-16},{58,14}})));
  Modelica.Blocks.Sources.RealExpression SOC(y=0.5+0.5*cos(2*3.14*time/3600));

function plotResult

  constant String resultFileName = "CheckBatteryConditioiningController.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=2, position={809, 0, 791, 864}, y={"unit.value", "ctrl.Orderblock.y", "param.SOC_min"}, range={0.0, 7500.0, -0.2, 1.2000000000000002}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFile);
  createPlot(id=2, position={809, 0, 791, 284}, y={"ctrl.lessEqualThreshold.y"}, range={0.0, 7500.0, -0.2, 1.2000000000000002}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
  createPlot(id=2, position={809, 0, 791, 285}, y={"ctrl.P_el_cond_set", "param.P_el_cond"}, range={0.0, 7500.0, -500.0, 2500.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}}, patterns={LinePattern.Solid, LinePattern.Dot},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

    annotation (experiment(StopTime=7200, __Dymola_Algorithm="Dassl"), __Dymola_experimentSetupOutput(events=false));
end plotResult;
equation

  connect(SOC.y, ctrl.SOC_is[1]) annotation (Line(
      points={{-40.85,1.15},{8,1.15},{8,-1.3},{28.3,-1.3}},
      color={255,204,51},
      thickness=0.5));
annotation (Diagram(graphics,
                    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                       Icon(graphics,
                                            coordinateSystem(extent={{-100,-100},{100,100}})),
  experiment(StopTime=7200, __Dymola_Algorithm="Dassl"),
  __Dymola_experimentSetupOutput(
      derivatives=false,
      events=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for BatteryConditioningController</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
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
end CheckBatteryConditioningController;
