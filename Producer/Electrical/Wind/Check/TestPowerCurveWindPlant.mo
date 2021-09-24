within TransiEnt.Producer.Electrical.Wind.Check;
model TestPowerCurveWindPlant

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
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantFrequency_L1_1(useInputConnector=false) annotation (Placement(transformation(extent={{70,-16},{90,4}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-104,80},{-84,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  PowerCurveWindPlant windTurbine_L0_scale_SenvionM104(
    PowerCurveChar=TransiEnt.Producer.Electrical.Wind.Characteristics.SenvionM104_3400kW(),
    P_el_n=51e6,
    height_hub=100,
    Roughness=TransiEnt.Producer.Electrical.Wind.Characteristics.RoughnessCharacteristics.Meadow(),
    height_data=10)                                                                                 annotation (Placement(transformation(extent={{-8,26},{12,46}})));
  PowerCurveWindPlant windTurbine_L0_scale_EnerconE82(
    PowerCurveChar=TransiEnt.Producer.Electrical.Wind.Characteristics.EnerconE82_2000kW(),
    height_hub=100,
    Roughness=TransiEnt.Producer.Electrical.Wind.Characteristics.RoughnessCharacteristics.Meadow(),
    height_data=10)                                                                                 annotation (Placement(transformation(extent={{-8,-22},{12,-2}})));
  PowerCurveWindPlant windTurbine_L0_scale_VestasV164_Offshore(
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.WindOffshore,
    P_el_n=68e6,
    height_hub=100,
    Roughness=TransiEnt.Producer.Electrical.Wind.Characteristics.RoughnessCharacteristics.Meadow(),
    height_data=10)                                                                                 annotation (Placement(transformation(extent={{-6,-70},{14,-50}})));
  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind_Hamburg_Fuhlsbuettel_3600s_2012_1 annotation (Placement(transformation(extent={{-80,-16},{-60,4}})));
equation
  connect(constantFrequency_L1_1.epp, windTurbine_L0_scale_SenvionM104.epp) annotation (Line(
      points={{70,-6},{36,-6},{36,43},{11,43}},
      color={0,135,135},
      thickness=0.5));
  connect(constantFrequency_L1_1.epp, windTurbine_L0_scale_EnerconE82.epp) annotation (Line(
      points={{70,-6},{36,-6},{36,-5},{11,-5}},
      color={0,135,135},
      thickness=0.5));
  connect(windTurbine_L0_scale_VestasV164_Offshore.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{13,-53},{35.65,-53},{35.65,-6},{70,-6}},
      color={0,135,135},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "TestPowerCurveWindPlant.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={0, 0, 793, 681}, y={"wind_Hamburg_3600s_175m.value"}, range={0.0, 30000.0, 2.0, 6.0}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={0, 0, 793, 338}, y={"windTurbine_L0_scale_SenvionM104.P_el_is", "windTurbine_L0_scale_EnerconE82.P_el_is",
 "windTurbine_L0_scale_VestasV164_Offshore.P_el_is"}, range={0.0, 30000.0, -10000000.0, 6000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(wind_Hamburg_Fuhlsbuettel_3600s_2012_1.y1, windTurbine_L0_scale_SenvionM104.v_wind) annotation (Line(points={{-59,-6},{-52,-6},{-32,-6},{-32,42.1},{-6.9,42.1}}, color={0,0,127}));
  connect(wind_Hamburg_Fuhlsbuettel_3600s_2012_1.y1, windTurbine_L0_scale_EnerconE82.v_wind) annotation (Line(points={{-59,-6},{-32,-6},{-32,-5.9},{-6.9,-5.9}}, color={0,0,127}));
  connect(wind_Hamburg_Fuhlsbuettel_3600s_2012_1.y1, windTurbine_L0_scale_VestasV164_Offshore.v_wind) annotation (Line(points={{-59,-6},{-32,-6},{-32,-53.9},{-4.9,-53.9}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                     Text(
          extent={{-16,26},{22,12}},
          lineColor={0,0,255},
          textString="Senvion M104: 3.4 MW
20 x 3.4= 68"),   Text(
          extent={{-96,78},{-56,48}},
          lineColor={0,128,0},
          textString="Plot: 
* windpark.value 
* windproduction wind hh 900s , value
",        horizontalAlignment=TextAlignment.Left),
                                     Text(
          extent={{-16,-22},{22,-36}},
          lineColor={0,0,255},
          textString="Enercon E82: 2 MW
34 x 2=68"),                         Text(
          extent={{-14,-76},{24,-90}},
          lineColor={0,0,255},
          textString="Vestas V164: 8MW
scaled up to 68MW
Test for Offshore Conditions
(cut out+cut backin velocity, LCOE)")}),                                                                      experiment(StopTime=604800, Interval=900),
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
end TestPowerCurveWindPlant;
