within TransiEnt.Producer.Electrical.Wind.Check;
model TestWindturbine_turbulence


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
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency Grid(useInputConnector=false) annotation (Placement(transformation(extent={{62,-10},{82,10}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  Windturbine windTurbinePitchControlled(
    beta_start=0,
    v_wind_start=5,
    operationRanges=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.WindSpeedOperationRanges(),
    P_el_n=3.6e6,
    turbineCharacteristics=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.VariableWTG_WU()) annotation (Placement(transformation(extent={{2,-16},{22,4}})));

  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Base.DrydenTurbulence
                   turb_high(       sigma=0.1*2.4, t=0.1)
                               annotation (Placement(transformation(extent={{-80,-4},{-60,16}})));
  Modelica.Blocks.Math.Add          v_turb       annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Modelica.Blocks.Sources.Constant                                     v_noturb(k=8)
                                                                                annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(windTurbinePitchControlled.epp, Grid.epp) annotation (Line(
      points={{21,1},{44,1},{44,0},{62,0}},
      color={0,135,135},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "TestWindturbine_turbulence.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=3, position={0, 0, 1616, 731}, y={"windTurbinePitchControlled.v_wind", "v_noturb.y"}, range={0.0, 200.0, 7.4, 8.600000000000001}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=3, position={0, 0, 1616, 241}, y={"windTurbinePitchControlled.P_el_is"}, range={0.0, 200.0, 200000.0, 1400000.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFile);
createPlot(id=3, position={0, 0, 1616, 240}, y={"windTurbinePitchControlled.omega_is.y", "windTurbinePitchControlled.w_nom",
"windTurbinePitchControlled.w_start"}, range={0.0, 200.0, 0.8, 2.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(turb_high.delta_v_turb, v_turb.u1) annotation (Line(points={{-59.6,6},{-59.6,6},{-30,6}}, color={0,0,127}));
  connect(v_turb.y, windTurbinePitchControlled.v_wind) annotation (Line(points={{-7,0},{3.1,0},{3.1,0.1}}, color={0,0,127}));
  connect(v_noturb.y, v_turb.u2) annotation (Line(points={{-59,-30},{-42,-30},{-42,-6},{-30,-6}}, color={0,0,127}));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=200, Interval=2),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for wind turbines turbulent wind speed</p>
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
end TestWindturbine_turbulence;
