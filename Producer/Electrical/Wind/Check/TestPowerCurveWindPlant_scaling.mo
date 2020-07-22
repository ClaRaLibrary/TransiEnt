within TransiEnt.Producer.Electrical.Wind.Check;
model TestPowerCurveWindPlant_scaling
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency Grid(useInputConnector=false) annotation (Placement(transformation(extent={{62,-10},{82,10}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  PowerCurveWindPlant
              windturbine                                                                                     annotation (Placement(transformation(extent={{2,-16},{22,4}})));

  Modelica.Blocks.Sources.Ramp Wind(
    startTime=10,
    duration=500,
    height=25,
  offset=0)
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  PowerCurveWindPlant
              windturbineScaled(P_el_n=9e6)                                                                   annotation (Placement(transformation(extent={{2,-48},{22,-28}})));
  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation
  connect(windturbine.epp, Grid.epp) annotation (Line(
      points={{21,1},{44,1},{44,0},{62,0}},
      color={0,135,135},
      thickness=0.5));
  connect(Wind.y, windturbine.v_wind) annotation (Line(points={{-31,0},{-22,0},{-22,0.1},{3.1,0.1}},
                                                   color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestPowerCurveWindPlant_scaling.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 697}, x="Wind.y", y={"windturbine.P_el_is", "windturbineScaled.P_el_is"}, range={0.0, 26.0, -500000.0, 9500000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=3, position={0, 0, 793, 697}, y={"Wind.y"}, range={0.0, 550.0, -5.0, 30.0}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=3, position={0, 0, 793, 346}, y={"windturbine.P_el_is", "windturbineScaled.P_el_is"}, range={0.0, 550.0, -1000000.0, 10000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(windturbineScaled.epp, Grid.epp) annotation (Line(
      points={{21,-31},{44,-31},{44,0},{62,0}},
      color={0,135,135},
      thickness=0.5));
  connect(windturbineScaled.v_wind, Wind.y) annotation (Line(points={{3.1,-31.9},{-10,-31.9},{-10,0},{-31,0}}, color={0,0,127}));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=550, Interval=10),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for plotting the power curve of wind plants</p>
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
end TestPowerCurveWindPlant_scaling;
