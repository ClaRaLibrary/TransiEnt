within TransiEnt.Producer.Heat.Power2Heat.Heatpump.Check;
model TestHeatpump
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

  TransiEnt.Producer.Heat.Power2Heat.Heatpump.Heatpump                 heatpump(
    usePowerPort=true,
    useFluidPorts=true,
    p_drop=0,
    useHeatPort=false,
    T_set=323.15)                                                                             annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source1(
    variable_m_flow=false,
    T_const=30 + 273,
    m_flow_const=0.1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={64,-32})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency electricGrid1(useInputConnector=false)
                                                                                                         annotation (Placement(transformation(extent={{20,-46},{40,-26}})));
  Modelica.Blocks.Sources.Sine Q_flow_set(
    amplitude=500,
    offset=1000,
    phase=3.1415926535898,
    f=1/4000) annotation (Placement(transformation(extent={{-56,-14},{-39,4}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi sink1(medium=simCenter.fluid1, p_const=17e5)
                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={62,21})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperature1
                                                      annotation (Placement(transformation(extent={{26,12},{46,32}})));
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
  connect(heatpump.epp, electricGrid1.epp) annotation (Line(
      points={{3.6,-10},{3.6,-36},{20,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(heatpump.inlet, source1.steam_a) annotation (Line(
      points={{6,-3.8},{64,-3.8},{64,-22}},
      color={175,0,0},
      thickness=0.5));
  connect(heatpump.outlet, sink1.steam_a) annotation (Line(
      points={{6.2,3},{16,3},{16,4},{62,4},{62,11}},
      color={175,0,0},
      thickness=0.5));
  connect(temperature1.port, sink1.steam_a) annotation (Line(
      points={{36,12},{36,4},{62,4},{62,11}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Q_flow_set.y, heatpump.Q_flow_set) annotation (Line(points={{-38.15,-5},{-38.15,-5.4},{-14.6,-5.4}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-82,76},{84,52}},
          textColor={28,108,200},
          textString="Look at: heatPump.Q_flow and heatPump.epp.P")}),
                             experiment(StopTime=7200),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for Heatpump</p>
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
end TestHeatpump;
