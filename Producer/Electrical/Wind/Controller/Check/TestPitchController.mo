within TransiEnt.Producer.Electrical.Wind.Controller.Check;
model TestPitchController
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
  TransiEnt.Producer.Electrical.Wind.Controller.PitchController pitchController(
    turbine=Characteristics.VariableSpeed.ExampleTurbineRanges(),
    yMax=25,
    yMin=0,
    v_wind=max(0.1, cosine.y)) annotation (Placement(transformation(extent={{-30,3},{24,49}})));
  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions(redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind) annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.Cosine cosine(
    freqHz=1/86400,
    amplitude=-26,
    offset=26) annotation (Placement(transformation(extent={{-30,74},{-10,94}})));
  Modelica.Blocks.Sources.Constant P_set(k=1.5e6) annotation (Placement(transformation(extent={{-57,4},{-43,18}})));
  Modelica.Blocks.Sources.RealExpression P_is(y=Rotor.P_turbine) annotation (Placement(transformation(extent={{-58,32},{-42,52}})));
  Base.WindturbineRotor Rotor(
    turbineCharacteristics=Characteristics.VariableSpeed.MOD2(),
    D=100,
    P_el_n=1.5e6) annotation (Placement(transformation(extent={{22,-28},{42,-8}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed=2*8*12/100)
                                                                               annotation (Placement(transformation(extent={{74,-28},{54,-8}})));
  Modelica.Blocks.Sources.RealExpression v_wind_internal(y=pitchController.v_wind) annotation (Placement(transformation(extent={{-8,-28},{8,-8}})));
equation
  connect(P_set.y, pitchController.u_s) annotation (Line(points={{-42.3,11},{-42,11},{-42,11.3636},{-30,11.3636}}, color={0,0,127}));
  connect(P_is.y, pitchController.u_m) annotation (Line(points={{-41.2,42},{-30,42},{-30,40.6364}},        color={0,0,127}));
  connect(constantSpeed.flange, Rotor.flange) annotation (Line(points={{54,-18},{50,-18},{48,-18},{42.2,-18}},
                                                                                             color={0,0,0}));
  connect(v_wind_internal.y, Rotor.v_wind) annotation (Line(points={{8.8,-18},{16,-18},{20,-18},{20,-18.2},{22.6,-18.2}},       color={0,0,127}));
  connect(pitchController.beta_set, Rotor.beta_set) annotation (Line(points={{18.6,11.7818},{32,11.7818},{32,12},{32,-8.4}},      color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestPitchController.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={0, 0, 793, 681}, y={"Rotor.P_turbine_pu"}, range={0.0, 90000.0, -1.0, 4.0}, grid=true, colors={{238,46,47}}, filename=resultFileName);
createPlot(id=1, position={0, 0, 793, 166}, y={"pitchController.partLoad.active", "pitchController.fullLoad.active"}, range={0.0, 90000.0, -0.5, 1.5}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={0, 0, 793, 167}, y={"Rotor.v_wind", "Rotor.beta_set"}, range={0.0, 90000.0, -50.0, 100.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={0, 0, 793, 166}, y={"Rotor.cp"}, range={0.0, 90000.0, -0.2, 0.6000000000000001}, grid=true, subPlot=4, colors={{28,108,200}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for pitch controller</p>
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
end TestPitchController;
