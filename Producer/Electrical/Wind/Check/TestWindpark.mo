within TransiEnt.Producer.Electrical.Wind.Check;
model TestWindpark

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
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency Grid(useInputConnector=false) annotation (Placement(transformation(extent={{72,-8},{92,12}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  PowerCurveWindPlant singleTurbine(
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.WindOffshore,
    height_data=100,
    height_hub=100,
    P_el_n=100*8e6,
    PowerCurveChar=TransiEnt.Producer.Electrical.Wind.Characteristics.VestasV164_8000kW()) annotation (Placement(transformation(extent={{-18,16},{2,36}})));
  Windpark windpark(
    redeclare PowerCurveWindPlant windTurbineModel,
    P_el_start=windpark.windTurbineModel.P_el_n/3,
    N=100,
    v_mean=8,
    z_0=0.1)                                                                                                           annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Base.DrydenTurbulence
                   turb_high(       sigma=0.1*2.4, t=0.1)
                               annotation (Placement(transformation(extent={{-98,0},{-78,20}})));
  Modelica.Blocks.Math.Add          v_turb       annotation (Placement(transformation(extent={{-62,-8},{-42,12}})));
  Modelica.Blocks.Sources.Constant                                     v_noturb(k=8)
                                                                                annotation (Placement(transformation(extent={{-98,-36},{-78,-16}})));
equation
  connect(singleTurbine.epp, Grid.epp) annotation (Line(
      points={{1,33},{25.65,33},{25.65,2},{72,2}},
      color={0,135,135},
      thickness=0.5));
  connect(windpark.epp, Grid.epp) annotation (Line(
      points={{0.4,-30},{30,-30},{30,2},{72,2}},
      color={0,135,135},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "TestWindpark.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={0, 0, 1616, 731}, y={"singleTurbine.P_el_is", "windpark.P_el_is"}, range={0.0, 300.0, 240.0, 360.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 363}, y={"v_turb.y"}, range={0.0, 300.0, 7.4, 8.600000000000001}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFile);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(turb_high.delta_v_turb,v_turb. u1) annotation (Line(points={{-77.6,10},{-77.6,8},{-64,8}},color={0,0,127}));
  connect(v_noturb.y, v_turb.u2) annotation (Line(points={{-77,-26},{-76,-26},{-76,-4},{-64,-4}}, color={0,0,127}));
  connect(v_turb.y, singleTurbine.v_wind) annotation (Line(points={{-41,2},{-36,2},{-36,32.1},{-16.9,32.1}}, color={0,0,127}));
  connect(v_turb.y, windpark.v_wind) annotation (Line(points={{-41,2},{-38,2},{-38,-10},{-38,-30},{-20.4,-30},{-20.4,-30.2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                     graphics={
                                     Text(
          extent={{-26,10},{12,-4}},
          lineColor={0,0,255},
          textString="Vestas V164: 8MW
scaled up to 68MW
Test for Offshore Conditions
(cut out+cut backin velocity, LCOE)"),
                                     Text(
          extent={{-26,-48},{12,-62}},
          lineColor={0,0,255},
          textString="Vestas V164: 8MW
scaled up to 68MW
Test for Offshore Conditions
(cut out+cut backin velocity, LCOE)"),
        Text(
          extent={{-2,96},{80,44}},
          lineColor={0,0,0},
          textString="Look at:
-singleTurbine.P_el_is
-windpark.P_el_is")}),                                                                                 experiment(StopTime=300, Interval=5),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for wind farms</p>
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
end TestWindpark;
