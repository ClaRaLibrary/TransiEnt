within TransiEnt.Producer.Electrical.Wind.Check;
model TestIdealWindpark


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
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency Grid(useInputConnector=true) annotation (Placement(transformation(extent={{72,-8},{92,12}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  Modelica.Blocks.Sources.Constant
                                 step1(k=9)
              annotation (Placement(transformation(extent={{-78,-8},{-58,12}})));
  IdealWindpark windpark_SI(
    redeclare TransiEnt.Producer.Electrical.Wind.Windturbine_SI_DF WTG(
      beta_start=0,
      v_wind_start=9,
      use_inertia=true),
    v_wind_start=9,
    n_Turbines=100) annotation (Placement(transformation(extent={{-12,-8},{8,12}})));
  Modelica.Blocks.Sources.Ramp frequenz(
    duration=10,
    offset=50,
    startTime=10,
    height=-1)
    annotation (Placement(transformation(extent={{34,46},{54,66}})));
  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation
  connect(windpark_SI.epp, Grid.epp) annotation (Line(
      points={{8.4,2},{72,2},{72,2}},
      color={0,135,135},
      thickness=0.5));
  connect(step1.y, windpark_SI.v_wind)
    annotation (Line(points={{-57,2},{-12.4,2},{-12.4,1.8}}, color={0,0,127}));
  connect(frequenz.y, Grid.f_set) annotation (Line(points={{55,56},{76.6,56},{76.6,14}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestIdealWindpark.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 697}, y={"Grid.epp.f"}, range={0.0, 100.0, 48.8, 50.199999999999996}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 229}, y={"windpark_SI.P_el_is"}, range={0.0, 100.0, 120.0, 170.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 229}, y={"windpark_SI.WTG.P_el_is"}, range={0.0, 100.0, 1.2000000000000002, 1.7000000000000002}, grid=true, subPlot=3, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=3, position={0, 0, 793, 697}, y={"windpark_SI.P_el_is"}, range={0.0, 100.0, 120.0, 170.0}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=3, position={0, 0, 793, 346}, y={"windpark_SI.WTG.P_el_is"}, range={0.0, 100.0, 1.2000000000000002, 1.7000000000000002}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                                                               experiment(StopTime=100, Interval=0.1),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for ideal wind farms</p>
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
end TestIdealWindpark;
