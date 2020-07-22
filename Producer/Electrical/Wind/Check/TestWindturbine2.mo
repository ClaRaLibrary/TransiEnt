within TransiEnt.Producer.Electrical.Wind.Check;
model TestWindturbine2
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
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency Grid annotation (Placement(transformation(extent={{64,-10},{84,10}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  Windturbine_SI_dfdt windTurbinePitchControlled(
    operationRanges=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.WindSpeedOperationRanges(),
    v_wind_start=0,
    beta_start=85,
    pitchController(PitchControllerTimeConstant(T=5)),
    P_el_n=3500000000000,
    turbineCharacteristics=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.MOD2()) annotation (Placement(transformation(extent={{2,-16},{24,10}})));

  Modelica.Blocks.Sources.Ramp Wind(
    height=30,
    offset=0,
    startTime=0,
    duration=2000)
    annotation (Placement(transformation(extent={{-74,-4},{-54,16}})));
  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.Ramp Wind1(
    offset=0,
    height=0,
    duration=500,
    startTime=600)
    annotation (Placement(transformation(extent={{-74,-50},{-54,-30}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));
equation
  connect(windTurbinePitchControlled.epp, Grid.epp) annotation (Line(
      points={{22.9,4.09091},{44,4.09091},{44,0},{64,0}},
      color={0,135,135},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "TestWindturbine2.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={955, -10, 584, 658}, x="windTurbinePitchControlled.v_wind", y={"windTurbinePitchControlled.Rotor.P_turbine_pu"}, range={4.0, 32.0, -0.5, 1.5}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={955, -10, 584, 216}, x="windTurbinePitchControlled.v_wind", y={"windTurbinePitchControlled.Rotor.omega"}, range={4.0, 32.0, 0.0, 2.5}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={955, -10, 584, 216}, x="windTurbinePitchControlled.v_wind", y={"windTurbinePitchControlled.Rotor.beta_set"}, range={4.0, 32.0, -20.0, 100.0}, grid=true, subPlot=3, colors={{28,108,200}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(Wind.y, add.u1) annotation (Line(points={{-53,6},{-34,6}}, color={0,0,127}));
  connect(Wind1.y, add.u2) annotation (Line(points={{-53,-40},{-46,-40},{-46,-6},{-34,-6}}, color={0,0,127}));
  connect(add.y, windTurbinePitchControlled.v_wind) annotation (Line(points={{-11,0},{3.21,0},{3.21,3.02727}},
                                                                                                         color={0,0,127}));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=5000, __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for wind turbines</p>
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
end TestWindturbine2;
