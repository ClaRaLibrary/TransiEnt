within TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.DNIDHI_Input.Check;
model Check_PVPlant


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
  inner TransiEnt.SimCenter simCenter
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency
    ElectricGrid1
    annotation (Placement(transformation(extent={{34,-12},{54,8}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_Fuhlsbuettel_3600s_2012
    temperature_Hamburg_3600s_IWEC_from_SAM
    annotation (Placement(transformation(extent={{-74,30},{-54,50}})));
  TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_3600s_TMY
    wind_Hamburg_3600s_01012012_31122012_Wind_Hamburg_175m
    annotation (Placement(transformation(extent={{-74,-86},{-54,-66}})));
  TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY
    dNI_Hamburg_3600s_IWEC_from_SAM
    annotation (Placement(transformation(extent={{-74,-24},{-54,-4}})));
  TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY
    dHI_Hamburg_3600s_IWEC_from_SAM
    annotation (Placement(transformation(extent={{-74,-54},{-54,-34}})));
  PVPlant pVPlant(
    kind=4,
    redeclare model Skymodel =
        TransiEnt.Producer.Heat.SolarThermal.Base.Skymodel_Klucher,
    input_POA_irradiation=false,
    slope=Modelica.Units.Conversions.from_deg(30),
    Soiling=0) annotation (Placement(transformation(extent={{-20,-12},{0,8}})));
equation
  connect(wind_Hamburg_3600s_01012012_31122012_Wind_Hamburg_175m.y1, pVPlant.WindSpeed_in)
    annotation (Line(points={{-53,-76},{-34,-76},{-34,-10},{-22,-10}}, color={0,
          0,127}));
  connect(dHI_Hamburg_3600s_IWEC_from_SAM.y1, pVPlant.DHI_in) annotation (Line(
        points={{-53,-44},{-36,-44},{-36,-4.6},{-22,-4.6}}, color={0,0,127}));
  connect(dNI_Hamburg_3600s_IWEC_from_SAM.y1, pVPlant.DNI_in) annotation (Line(
        points={{-53,-14},{-38,-14},{-38,0.4},{-22,0.4}}, color={0,0,127}));
  connect(temperature_Hamburg_3600s_IWEC_from_SAM.y1, pVPlant.T_in) annotation (
     Line(points={{-53,40},{-34,40},{-34,6},{-22,6}}, color={0,0,127}));
  connect(pVPlant.epp, ElectricGrid1.epp) annotation (Line(
      points={{-0.7,-2.6},{15.65,-2.6},{15.65,-2},{34,-2}},
      color={0,135,135},
      thickness=0.5));
public
  function plotResult

    constant String resultFileName="Check_PVPlant.mat";

    output String resultFile;

  algorithm
    clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)),
      "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
    resultFile := TransiEnt.Basics.Functions.fullPathName(
      Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)
       + "/" + resultFileName);
    removePlots();
    createPlot(
      id=3,
      position={809,0,791,695},
      y={"pVPlant.epp.P","dNI_Hamburg_3600s_IWEC_from_SAM.y1","dHI_Hamburg_3600s_IWEC_from_SAM.y1"},
      range={0.0,1600000.0,-100.0,500.0},
      autoscale=false,
      grid=true,
      colors={{28,108,200},{238,46,47},{0,140,72}},
      range2={0.1,0.6},
      filename=resultFile);
    createPlot(
      id=3,
      position={809,0,791,159},
      y={"temperature_Hamburg_3600s_IWEC_from_SAM.y1"},
      range={0.0,1600000.0,-10.0,20.0},
      autoscale=false,
      grid=true,
      subPlot=2,
      colors={{28,108,200}},
      filename=resultFile);
    createPlot(
      id=3,
      position={809,0,791,146},
      y={"wind_Hamburg_3600s_01012012_31122012_Wind_Hamburg_175m.y1"},
      range={0.0,1600000.0,0.0,20.0},
      autoscale=false,
      grid=true,
      subPlot=3,
      colors={{28,108,200}},
      filename=resultFile);
    resultFile := "Successfully plotted results for file: " + resultFile;

  end plotResult;
  annotation (
    Diagram(graphics, coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(
      StopTime=3.1536e+007,
      Interval=3600,
      Tolerance=1e-008),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the pVPlant model</p>
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
end Check_PVPlant;
