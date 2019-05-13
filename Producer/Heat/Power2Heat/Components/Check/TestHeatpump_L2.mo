within TransiEnt.Producer.Heat.Power2Heat.Components.Check;
model TestHeatpump_L2
  import TransiEnt;
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  Modelica.Blocks.Sources.Constant       T_room_set_K(  k=20+273.15)       annotation (Placement(transformation(extent={{-53,-10},{-33,10}})));
  TransiEnt.Producer.Heat.Power2Heat.Components.HeatpumpFluidPorts Heatpump(init_state=2) annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    variable_m_flow=false,
    T_const=30 + 273,
    m_flow_const=0.1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-28})));
  TransiEnt.Components.Boundaries.Electrical.Frequency electricGrid(useInputConnector=false) annotation (Placement(transformation(extent={{16,38},{36,58}})));
  Modelica.Blocks.Sources.Sine T_room_is_K(
    amplitude=2,
    offset=20 + 273.15,
    phase=3.1415926535898,
    freqHz=1/4000)      annotation (Placement(transformation(extent={{-43,-42},{-23,-22}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi sink(
    medium=simCenter.fluid1,
    p_const=17e5)         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={56,25})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperature annotation (Placement(transformation(extent={{16,4},{36,24}})));
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
  connect(T_room_set_K.y, Heatpump.u_set) annotation (Line(points={{-32,0},{-26,0},{-14.4,0}}, color={0,0,127}));
  connect(source.steam_a, Heatpump.waterIn) annotation (Line(
      points={{60,-18},{60,-5.9},{6.1,-5.9}},
      color={0,131,169},
      thickness=0.5));
  connect(Heatpump.epp, electricGrid.epp) annotation (Line(
      points={{6,8},{6,48},{16,48}},
      color={0,135,135},
      thickness=0.5));
  connect(T_room_is_K.y, Heatpump.u_meas) annotation (Line(points={{-22,-32},{-4,-32},{-4,-11.2}}, color={0,0,127}));
  connect(Heatpump.waterOut, sink.steam_a) annotation (Line(
      points={{6.2,4},{56,4},{56,15}},
      color={175,0,0},
      thickness=0.5));
  connect(Heatpump.waterOut, temperature.port) annotation (Line(
      points={{6.2,4},{16.1,4},{26,4}},
      color={175,0,0},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
                             experiment(StopTime=7200),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for Heatpump_L2</p>
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
end TestHeatpump_L2;
