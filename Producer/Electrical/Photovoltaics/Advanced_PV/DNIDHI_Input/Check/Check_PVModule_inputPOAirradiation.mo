within TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.DNIDHI_Input.Check;
model Check_PVModule_inputPOAirradiation

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
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_Fuhlsbuettel_3600s_2012 temperature_Hamburg_3600s_IWEC_from_SAM annotation (Placement(transformation(extent={{-78,20},{-58,40}})));
  TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_3600s_TMY wind_Hamburg_3600s_01012012_31122012_Wind_Hamburg_175m annotation (Placement(transformation(extent={{-74,-42},{-54,-22}})));
public
function plotResult

  constant String resultFileName = "Check_PVModule_inputPOAirradiation.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=3, position={809, 0, 791, 695}, y={"pVModule.epp.P", "dNI_Hamburg_3600s_IWEC_from_SAM.y1", "dHI_Hamburg_3600s_IWEC_from_SAM.y1"}, range={0.0, 1600000.0, -100.0, 500.0}, autoscale=false, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}}, range2={0.1, 0.6},filename=resultFile);
createPlot(id=3, position={809, 0, 791, 159}, y={"temperature_Hamburg_3600s_IWEC_from_SAM.y1"}, range={0.0, 1600000.0, -10.0, 20.0}, autoscale=false, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
createPlot(id=3, position={809, 0, 791, 146}, y={"wind_Hamburg_3600s_01012012_31122012_Wind_Hamburg_175m.y1"}, range={0.0, 1600000.0, 0.0, 20.0}, autoscale=false, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  PVModule pVModule(input_POA_irradiation=true)
    annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
  SinglePhasePVInverter singlePhasePVInverter(
    cosphi=0.9,
    behavior=1,                                                P_PV=200)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage
    ElectricGrid(
    Use_input_connector_f=false,
    Use_input_connector_v=false,
    v_boundary=400)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  TransiEnt.Basics.Tables.Ambient.POAIrradiaton_Az0_Tilt0_Hamburg_3600s_2012_TMY pOAIrradiaton_Az0_Tilt0_Hamburg_3600s_2012_TMY annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
equation
  connect(singlePhasePVInverter.epp_DC, pVModule.epp) annotation (Line(
      points={{20.2,0},{3.3,-0.6}},
      color={0,135,135},
      thickness=0.5));
  connect(ElectricGrid.epp, singlePhasePVInverter.epp_AC) annotation (Line(
      points={{60,0},{40,0}},
      color={0,127,0},
      thickness=0.5));
  connect(pVModule.T_in, temperature_Hamburg_3600s_IWEC_from_SAM.y1)
    annotation (Line(points={{-18,8},{-18,30},{-57,30}}, color={0,0,127}));
  connect(pVModule.WindSpeed_in,
    wind_Hamburg_3600s_01012012_31122012_Wind_Hamburg_175m.y1)
    annotation (Line(points={{-18,-8},{-18,-32},{-53,-32}}, color={0,0,127}));
  connect(pOAIrradiaton_Az0_Tilt0_Hamburg_3600s_2012_TMY.value, pVModule.POA_radiation_in) annotation (Line(points={{-57.2,0},{-16.6,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=3.1536e+007,
      Interval=3600,
      Tolerance=1e-008),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for the pVModule model with parameter <span style=\"font-family: Courier New;\">input_POA_irradiation set to true.</span></p>
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
end Check_PVModule_inputPOAirradiation;
