within TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.GHI_Input;
model PVModule "Simple efficiency-based PV model"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.SolarElectricalModel;
  import Modelica.SIunits.Conversions.*;

  // _____________________________________________
  //
  //                   Outer
  // _____________________________________________

  outer ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Power P_inst=200 "combined installed power";
  parameter Modelica.SIunits.Power Pmpp=200 "peak power of one module";
  parameter Modelica.SIunits.Area Area=1.18 "area of one complete module";

  parameter Real Strings=1 "choose amount of strings";

  parameter Real DCtoACratio=1.1 "ratio between installed DC and AC power" annotation(Dialog(group="Inverter"));
  parameter Real GroundCoverageRatio=0.3 "ratio of covered ground of modules to area of modules";
  parameter Real LossesDC=4.44 "losses in % through connections, wiring, tracking error and mismatches";
  parameter Real LossesAC=1 "losses on AC side not included in inverter efficiency";
  parameter Real Soiling=5 "Average annual losses of radiation in % due to soiling";
  parameter Real Albedo=0.25 "Average annual losses of radiation in % due to soiling";
  parameter String DiffuseModel="Skartveit and Olseth" "Choose the diffuse fraction correlation" annotation(choices(choice="Skartveit and Olseth",choice="Erbs",choice="Orgill and Hollands",choice="Reindl et al. 1",choice="Reindl et al. 2"));

  replaceable model ProducerCosts =
       TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PV
      constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs
                                                 annotation (Dialog(group="Statistics"),
       __Dymola_choicesAllMatching=true);
  parameter TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.Generic_Characteristics_PVModule PVModuleCharacteristics=Characteristics.PVModule_Characteristics_Sanyo_HIT_200_BA3() "Characteristics of PV Module" annotation (choicesAllMatching);
  parameter Real lambda=10 "degree of longitude of location" annotation(Dialog(tab="Tracking and Mounting", group="Location parameters"));
  parameter Real phi=53.63 "degree of latitude of location" annotation(Dialog(tab="Tracking and Mounting",group="Location parameters"));
  parameter Real timezone=1 "timezone of location (UTC+) - for Hamburg timezone=1" annotation(Dialog(tab="Tracking and Mounting",group="Location parameters"));
  parameter String Tracking="No Tracking" "choose if sun position is tracked by tracking device" annotation(Dialog(tab="Tracking and Mounting",group="Tracking"),choices(choice="No Tracking",choice="Biaxial Tracking"));
  parameter Real Tilt=0 "inclination of surface" annotation(Dialog(tab="Tracking and Mounting",group="parameters for fixed mounting"));
  parameter Real Azimuth=0 "gyration of surface; Orientation: +90=West, -90=East, 0=South" annotation(Dialog(tab="Tracking and Mounting",group="parameters for fixed mounting"));
  parameter String IncidenceAngleModification="yes" "choose if decrease of irradiance due to reflexion depending of the angle of incidence is calculated"
                                                                                                    annotation(Dialog(tab="Tracking and Mounting"),choices(choice="Yes",choice="No"));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  //variables dependend on irradiation and temperature:
  Modelica.SIunits.Power POA_Irradiation(min=0) "plane of array irradiation usable for PV generation";
  Modelica.SIunits.Temperature T_module "module temperature";
  Modelica.SIunits.Temperature T_cell "cell temperature";

  //output variables:
  Modelica.SIunits.Power P_dc "DC input power for inverter";
  Modelica.SIunits.Power P_inverter "installed DC inverter power";
  Modelica.SIunits.Power P_out "outout power";
  Modelica.SIunits.Energy E_dc "accumulated DC energy";
  Modelica.SIunits.Energy E "accumulated AC energy";

  //statistics
  Modelica.SIunits.Time FLH(displayUnit="h") "Full load hours";

  //other
  Modelica.SIunits.Area Area_demand;
  Real ModulesPerString "Choose amount of modules per string";

  //input variables:
  Modelica.Blocks.Interfaces.RealInput T_in "ambient temperature in Celcius" annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-80,120}), iconTransformation(extent={{-140,60},{-100,100}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput WindSpeed_in "wind speed in m/s" annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=270,
        origin={-80,-120}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,-80})));

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp "power output" annotation (Placement(transformation(extent={{88,-8},{108,12}}), iconTransformation(extent={{76,-22},{110,10}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.PowerPlantCost collectCosts_PowerProducer(
    P_n=Pmpp,
    redeclare model PowerPlantCostModel = ProducerCosts,
    P_el_is=P_out) annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  Radiation_InclinedSurface radiation_InclinedSurface(DiffuseModel=DiffuseModel,Albedo=Albedo, Soiling=Soiling, lambda=lambda,phi=phi,timezone=timezone, Tracking=Tracking, Tilt=Tilt, Azimuth=Azimuth, IncidenceAngleModification=IncidenceAngleModification) annotation (Placement(transformation(extent={{-22,-50},{-2,-30}})));

public
    Modelica.Blocks.Interfaces.RealInput GHI_in "Global Horizontal Irradiation in W/m^2" annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Tables.CombiTable1Ds PowerCurve_PV_Irradiation(
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    table=PVModuleCharacteristics.MPP_dependency_on_irradiation_fixedTemperature,
    columns={2,2}) "Dependency of MPP on irradiation with fixed temperature" annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Modelica.Blocks.Tables.CombiTable1Ds PowerCurve_PV_Temp(
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    table=PVModuleCharacteristics.MPP_dependency_on_Temp_fixedIrradiation,
    columns={2,2}) "Dependency of MPP on temperature with fixed irradiation" annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Tables.CombiTable1Ds EfficiencyCurve_Inverter(
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=false,
    columns={2,2},
    table=[0,0; 0.5,70.6425; 1,84.9247; 1.5,89.6817; 2,92.0574; 2.5,93.4807; 3,94.4276; 3.5,95.1024; 4,95.6072; 4.5,95.9985; 5,96.3104; 5.5,96.5646; 6,96.7756; 6.5,96.9532; 7,97.1046; 7.5,97.2351; 8,97.3486; 8.5,97.4481; 9,97.536; 9.5,97.614; 10,97.6836; 10.5,97.7461; 11,97.8024; 11.5,97.8533; 12,97.8995; 12.5,97.9416; 13,97.98; 13.5,98.0151; 14,98.0473; 14.5,98.077; 15,98.1043; 15.5,98.1294; 16,98.1527; 16.5,98.1742; 17,98.1941; 17.5,98.2125; 18,98.2296; 18.5,98.2455; 19,98.2603; 19.5,98.274; 20,98.2868; 20.5,98.2986; 21,98.3097; 21.5,98.3199; 22,98.3295; 22.5,98.3384; 23,98.3466; 23.5,98.3543; 24,98.3614; 24.5,98.368; 25,98.3741; 25.5,98.3797; 26,98.3849; 26.5,98.3897; 27,98.3942; 27.5,98.3982; 28,98.4019; 28.5,98.4053; 29,98.4084; 29.5,98.4112; 30,98.4137; 30.5,98.416; 31,98.418; 31.5,98.4197; 32,98.4212; 32.5,98.4225; 33,98.4236; 33.5,98.4245; 34,98.4253; 34.5,98.4258; 35,98.4261; 35.5,98.4263; 36,98.4264; 36.5,98.4262; 37,98.426; 37.5,98.4256; 38,98.425; 38.5,98.4243; 39,98.4235;
        39.5,98.4226; 40,98.4216; 40.5,98.4204; 41,98.4192; 41.5,98.4178; 42,98.4163; 42.5,98.4148; 43,98.4131; 43.5,98.4114; 44,98.4096; 44.5,98.4077; 45,98.4057; 45.5,98.4036; 46,98.4014; 46.5,98.3992; 47,98.3969; 47.5,98.3946; 48,98.3921; 48.5,98.3897; 49,98.3871; 49.5,98.3845; 50,98.3818; 50.5,98.3791; 51,98.3763; 51.5,98.3735; 52,98.3706; 52.5,98.3676; 53,98.3646; 53.5,98.3616; 54,98.3585; 54.5,98.3554; 55,98.3522; 55.5,98.349; 56,98.3457; 56.5,98.3424; 57,98.3391; 57.5,98.3357; 58,98.3323; 58.5,98.3288; 59,98.3253; 59.5,98.3218; 60,98.3182; 60.5,98.3146; 61,98.311; 61.5,98.3074; 62,98.3037; 62.5,98.3; 63,98.2962; 63.5,98.2924; 64,98.2886; 64.5,98.2848; 65,98.281; 65.5,98.2771; 66,98.2732; 66.5,98.2692; 67,98.2653; 67.5,98.2613; 68,98.2573; 68.5,98.2533; 69,98.2492; 69.5,98.2451; 70,98.2411; 70.5,98.2369; 71,98.2328; 71.5,98.2287; 72,98.2245; 72.5,98.2203; 73,98.2161; 73.5,98.2119; 74,98.2076; 74.5,98.2033; 75,98.1991; 75.5,98.1948; 76,98.1904; 76.5,98.1861; 77,98.1818; 77.5,
        98.1774; 78,98.173; 78.5,98.1686; 79,98.1642; 79.5,98.1598; 80,98.1554; 80.5,98.1509; 81,98.1464; 81.5,98.142; 82,98.1375; 82.5,98.133; 83,98.1285; 83.5,98.1239; 84,98.1194; 84.5,98.1148; 85,98.1103; 85.5,98.1057; 86,98.1011; 86.5,98.0965; 87,98.0919; 87.5,98.0873; 88,98.0826; 88.5,98.078; 89,98.0733; 89.5,98.0687; 90,98.064; 90.5,98.0593; 91,98.0546; 91.5,98.0499; 92,98.0452; 92.5,98.0405; 93,98.0358; 93.5,98.031; 94,98.0263; 94.5,98.0215; 95,98.0168; 95.5,98.012; 96,98.0072; 96.5,98.0024; 97,97.9976; 97.5,97.9928; 98,97.988; 98.5,97.9832; 99,97.9784; 99.5,97.9735; 100,97.9687]) annotation (Placement(transformation(extent={{-10,0},{10,20}})));//From SAM: The average [efficiency] of MPPT-low and MPPT-high, as described in the CEC test protocol, Source: NREL2016
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //Input irradiation
  POA_Irradiation=radiation_InclinedSurface.E_gen;

  //calculation of module temperature
  T_module = 273.15 + T_in + POA_Irradiation * (exp(-3.47 - 0.0594 * WindSpeed_in)); //https://pvpmc.sandia.gov/modeling-steps/2-dc-module-iv/module-temperature/sandia-module-temperature-model/

  //calculation of cell temperature
  T_cell = T_module; //simplification

  //output power and Energy
  PowerCurve_PV_Irradiation.u=POA_Irradiation;
  PowerCurve_PV_Temp.u=Modelica.SIunits.Conversions.to_degC(T_cell);

  if (PowerCurve_PV_Irradiation.y[1] *  PowerCurve_PV_Temp.y[1] / Pmpp) > 0 then
    P_dc = PowerCurve_PV_Irradiation.y[1] *  PowerCurve_PV_Temp.y[1] / Pmpp * (100 - LossesDC) / 100 * P_inst / Pmpp;
  else
    P_dc = 0;
  end if;

  P_inverter=P_inst/DCtoACratio;
  EfficiencyCurve_Inverter.u=P_dc/P_inverter*100;

  if P_dc*EfficiencyCurve_Inverter.y[1]/100*(100-LossesAC)/100 < P_inverter then
    P_out=P_dc*EfficiencyCurve_Inverter.y[1]/100*(100-LossesAC)/100;
  else
    P_out=P_inverter;
  end if;

  der(E_dc)=P_dc;
  der(E)=P_out;

  //full load hours
  if time>0 then
    FLH=E/(P_inst);
  else
    FLH=0;
  end if;

  //area demand
  Area_demand=GroundCoverageRatio*Area*Strings*ModulesPerString;

  //Arrangement of modules
  ModulesPerString=P_inst/(Pmpp*Strings);

  //Connection to output

  epp.P=-P_out;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(modelStatistics.costsCollector, collectCosts_PowerProducer.costsCollector);
  connect(GHI_in, radiation_InclinedSurface.GHI_in) annotation (Line(points={{-120,0},{-72,0},{-72,-40},{-24,-40}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The purpose of this model is to calculate the power of a photovoltaic (PV) module or several modules.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model is based on empiric equations and PV manufacturers data. Optical losses are being consideres due to loss factors for soiling and refraction and reflexion (contained in the incidence angle modification). Degradation of the modules and inverter consumption is not included in the model. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has been validated with System Advisor Model simulation results [1] for fixed PV arrays without shading influences. The results are best with Tilt angle of ~30&deg;.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has not been entirely validated for sun tracking. Disabling Incidence Angle Modifications seems to improve results with tracking enabled.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Input: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">GHI_in</span></b> for global horizontal irradiation </p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">T_in</span></b> for ambient temperature</p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">WindSpeed_in</span></b> for wind speed</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Output: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">epp</span></b> for connection to a grid containing frequency and power</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See parameter and variable descriptions in the code.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.1. Plane of Array (POA) Irradiation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The POA irradiation is being calculated in Radiation_InclinedSurface model.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.2. Module Temperature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The module temperature <b>T_module </b>is estimated following [2]:</span></p>
<p><code>T_module&nbsp;=&nbsp;273.15&nbsp;+&nbsp;T_in&nbsp;+&nbsp;POA_Irradiation&nbsp;*&nbsp;(<span style=\"color: #ff0000;\">exp</span>(-3.47&nbsp;-&nbsp;0.0594&nbsp;*&nbsp;WindSpeed_in))</code></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.3. Direct Current Power output P_dc</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">P_dc</span></b> is calculated by:</p>
<p>P_dc = <code>PowerCurve_PV_Irradiation.y[1]&nbsp;*&nbsp;&nbsp;PowerCurve_PV_Temp.y[1]&nbsp;/&nbsp;Pmpp&nbsp;*&nbsp;(100&nbsp;-&nbsp;LossesDC)&nbsp;/&nbsp;100&nbsp;*&nbsp;P_inst&nbsp;/&nbsp;Pmpp</code></p>
<p><code><b>PowerCurve_PV_Irradiation.y[1]</b> is the Maximum Power Point (MPP) power at the current Irradiation at reference temperature of the simulated module. <b>PowerCurve_PV_Temp.y[1]</b> is the MPP power at the current temperature at reference irradiation of the simulated module. <b>Pmpp</b> is the MPP power at reference conditions of the simulated module. <b>LossesDC</b> are the losses&nbsp;in&nbsp;&percnt;&nbsp;through&nbsp;Connections,&nbsp;Wiring,&nbsp;Tracking&nbsp;Error&nbsp;and&nbsp;Mismatches. <b>P_inst</b> is the cumulated installed power.</code></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.3. Power Output P_out</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">P_out</span></b> is calculated by:</p>
<pre>if P_dc*EfficiencyCurve_Inverter.y[1]*(100-LossesAC)/100 &LT; P_inverter then
  P_out=P_dc*EfficiencyCurve_Inverter.y[1]*(100-LossesAC)/100;
else
  P_out=P_inverter;
end if;</pre>
<p><code><b>EfficiencyCurve_Inverter.y[1]</b> is the efficiency of the simulated inverter depending on the inverter load. If P_dc exceeds the inverter power <b>P_inverter</b> the output is cut off to P_inverter as its maximum, where P_inverter is defined as the installed PV DC power divided by <b>DCtoACratio</b> which is the ratio&nbsp;between&nbsp;installed&nbsp;DC&nbsp;and&nbsp;AC&nbsp;power. <b>LossesAC</b> are losses&nbsp;on&nbsp;the AC&nbsp;side&nbsp;not&nbsp;included&nbsp;in&nbsp;inverter&nbsp;efficiency.</code></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For the calculation of the output power, manufacturer datasheets are to be digitalized, e.g. with http://arohatgi.info/WebPlotDigitizer/. This is an example for a Sanyo HIT 200BA module [2]. Digitalize the following figures: </span></p>
<p><img src=\"modelica://TransiEnt/Images/Sanyo_HIT_200BA20_20C.jpg\"/>[2]</p>
<p><img src=\"modelica://TransiEnt/Images/Sanyo_HIT_200BA20_1000W.jpg\"/>[2]</p>
<p>After digitalization, calculate the MPP power of each curve and write those to a record as shown in TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics. For the above shown curves the record is:</p>
<p><code><span style=\"color: #0000ff;\">record</span>&nbsp;PVModule_Characteristics_Sanyo_HIT_200_BA3</code></p>
<p><code>&nbsp;&nbsp;<span style=\"color: #0000ff;\">extends&nbsp;</span><span style=\"color: #ff0000;\">Generic_Characteristics_PVModule</span>(</code></p>
<pre>&nbsp;&nbsp;MPP_dependency_on_Temp_fixedIrradiation=[
&nbsp;0,214.3545548;
&nbsp;25,200.8472531;
&nbsp;50,187.3094253;
&nbsp;75,173.1095017],
&nbsp;&nbsp;MPP_dependency_on_irradiation_fixedTemperature=[
&nbsp;&nbsp;0,0;
200,37.69290789;
400,77.36493756;
600,117.7097234;
800,159.0501238;
1000,201.294124]);</pre>
<p><code>&nbsp;&nbsp;<span style=\"color: #0000ff;\">annotation&nbsp;</span>(Icon(coordinateSystem(preserveAspectRatio=false)),&nbsp;Diagram(coordinateSystem(preserveAspectRatio=false)));</code></p>
<p><code><span style=\"color: #0000ff;\">end&nbsp;</span>PVModule_Characteristics_Sanyo_HIT_200_BA3;</code></p>
<p>Hereby the firste table (MPP_dependency_on_Temp_fixedIrradiation) gives the MPP power (second column) for fixed irradiation and different temperatures (first column) and the second table (MPP_dependency_on_irradiation_fixedTemperature) gives the MPP power (second column) for fixed temperature and different irradiation (first column).</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has been validated with System Advisor Model simulation results [1] for bigger fixed PV arrays without shading influences.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">IWEC or TMY data was used in Hamburg, Munich and Miami.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<pre>[1] https://sam.nrel.gov/
[2] http://store.affordable-solar.com/site/doc/Doc_sanyo_specs_20061106173925.pdf</pre>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<pre>Advanced_PV by Oliver Sch&uuml;lting and Ricardo Peniche, Technische Universit&auml;t Hamburg, Institut f&uuml;r Energietechnik, 2015
Revision by Tobias Becke, Technische Universit&auml;t Hamburg, Institut f&uuml;r Energietechnik, 2016</pre>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-100,-100},{100,-140}},
          lineColor={0,134,134},
          textString="%name"),
        Text(
          extent={{-100,100},{-62,58}},
          lineColor={0,134,134},
          textString="T_in"),
        Text(
          extent={{-100,20},{-58,-20}},
          lineColor={0,134,134},
          textString="GHI_in"),
        Text(
          extent={{-98,-60},{-58,-100}},
          lineColor={0,134,134},
          textString="WindSpeed_in")}));
end PVModule;
