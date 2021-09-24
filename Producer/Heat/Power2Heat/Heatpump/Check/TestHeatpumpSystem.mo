within TransiEnt.Producer.Heat.Power2Heat.Heatpump.Check;
model TestHeatpumpSystem
  import TransiEnt;

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



  extends TransiEnt.Basics.Icons.Checkmodel;
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency electricGrid1(useInputConnector=false)
                                                                                                         annotation (Placement(transformation(extent={{42,-54},{62,-34}})));
  Modelica.Blocks.Sources.Sine Q_demand(
    amplitude=2,
    offset=500,
    phase=3.1415926535898,
    f=1/4000) annotation (Placement(transformation(extent={{-83,-10},{-63,10}})));
  TransiEnt.Producer.Heat.Power2Heat.Heatpump.HeatPumpSystem heatPumpSystem(V_Storage=0.2) annotation (Placement(transformation(extent={{-16,-18},{26,24}})));
equation

public
function plotResult

  constant String resultFileName = "TestHeatpump_L2.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 817}, y={"electricGrid.epp.P"}, range={0.0, 7500.0, -1000.0, 200.0}, grid=true, colors={{28,108,200}},filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 269}, y={"source.eye.T", "temperature.T_celsius"}, range={0.0, 7500.0, 28.0, 42.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}},filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 269}, y={"T_room_is_K.y"}, range={0.0, 7500.0, 291.0, 296.0}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(Q_demand.y, heatPumpSystem.Q_Demand) annotation (Line(points={{-62,0},{-20,0},{-20,2.79},{-14.95,2.79}}, color={0,0,127}));
  connect(heatPumpSystem.epp, electricGrid1.epp) annotation (Line(
      points={{20.96,-18},{20.96,-44},{42,-44}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-52,76},{62,50}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Look at: heatPumpSystem.Q_demand,
 heatpumpSystem.Storage.Q_loss,
 heatPumpSystem.heatPump.Q_flow and
 electricGrid.epp.P")}),     experiment(
      StopTime=864000,
      Interval=3600.00288,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for HeatpumpSystem</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4.Interfaces</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
</html>"));
end TestHeatpumpSystem;
