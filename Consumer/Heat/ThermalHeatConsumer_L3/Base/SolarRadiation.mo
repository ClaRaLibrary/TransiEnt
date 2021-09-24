within TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base;
model SolarRadiation


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import      Modelica.Units.SI;
  extends TransiEnt.Basics.Icons.RadiationModel;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  //Parameters for SolarTime
  parameter SI.Angle longitude_local=Modelica.Units.Conversions.from_deg(10) "longitude of the local position, east positive, 10 East for Hamburg" annotation (Dialog(tab="Irradiance", group="Solartime"));
  parameter SI.Angle longitude_standard=Modelica.Units.Conversions.from_deg(15) "needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time" annotation (Dialog(tab="Irradiance", group="Solartime"));
  Modelica.Units.NonSI.Time_day totaldays=365 "total days of the year, standard=365, leap year=366" annotation (Dialog(tab="Irradiance", group="Solartime"));

  //Parameters for ExtraterrestrialIrradiance
  parameter SI.Angle latitude=Modelica.Units.Conversions.from_deg(53.55) "latitude of the local position, north posiive, 53,55 North for Hamburg" annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));
  parameter SI.Angle slope=Modelica.Units.Conversions.from_deg(90) "slope of the tilted surface, assumption" annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));
  parameter SI.Angle surfaceAzimuthAngle=0 "surface azimuth angle" annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));

  //Skymodel
  parameter Real reflectance_ground=0.2 "reflectance of the ground" annotation (Dialog(tab="Irradiance", group="Skymodel"));
  parameter Boolean direct_normal=true "Is the direct irradiance measured on a surface normal to irradiance?" annotation (Dialog(tab="Irradiance", group="Skymodel"));

  // geometric parameters
  parameter SI.Area A_Win[4]={6.28,3.87,5.816,0};
  parameter SI.Area A[3];
  final parameter SI.Area A_sum=A[1]+A[2]+A[3]+A_Win[1]+A_Win[2]+A_Win[3]+A_Win[4];

  //transmittance of glas
  parameter Real tau_diff=0.6;
  parameter Real tau_dir_glas=0.6;
  parameter Real abs=0.05;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real tau_dir[4] "incident-depending transmittance of glas";
  Real cosang[4] "incident angle";

  SI.HeatFlowRate Q_flow_diff "diffuse transmitted Irradiation";

  SI.HeatFlowRate Q_flow_dir_S "direct transmitted Irradiation (S)";
  SI.HeatFlowRate Q_flow_dir_E "direct transmitted Irradiation (E)";
  SI.HeatFlowRate Q_flow_dir_N "direct transmitted Irradiation (N)";
  SI.HeatFlowRate Q_flow_dir_W "direct transmitted Irradiation (W)";
  SI.HeatFlowRate Q_flow_dir "total direct transmitted Irradiation";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a wall annotation (Placement(transformation(extent={{88,34},{108,54}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a roof annotation (Placement(transformation(extent={{88,-70},{108,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a ground annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a window annotation (Placement(transformation(extent={{88,68},{108,88}})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

   TransiEnt.Producer.Heat.SolarThermal.Base.IrradianceOnATiltedSurface[4] irrTilt(redeclare TransiEnt.Producer.Heat.SolarThermal.Base.Skymodel_isotropicDiffuse skymodel(
   each longitude_local=longitude_local,
   each longitude_standard=longitude_standard,
   each latitude=latitude,
   each slope=slope,
   surfaceAzimuthAngle={0,Modelica.Constants.pi*0.5,Modelica.Constants.pi,Modelica.Constants.pi*1.5},
   each reflectance_ground=reflectance_ground,
   each direct_normal=direct_normal,
   each totaldays=totaldays)) annotation (Placement(transformation(extent={{-12,-4},{8,16}})));

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // Calculation of tau_dir as a function of the incidence angle
  cosang=cos(irrTilt.angle_direct_tilted);
  for i in 1:4 loop
  tau_dir[i]=max(0,tau_dir_glas*(-0.002+2.813*cosang[i]-2.341*cosang[i]^2-0.05725*cosang[i]^3+0.599*cosang[i]^4));
  end for;

  //Calculation of transmitted Radiation
  Q_flow_dir=Q_flow_dir_S+Q_flow_dir_N+Q_flow_dir_W+Q_flow_dir_E;
  Q_flow_dir_S =tau_dir[1]*(A_Win[1]*(irrTilt[1].irradiance_direct_tilted));
  Q_flow_dir_W=tau_dir[2]*A_Win[2]*(irrTilt[2].irradiance_direct_tilted);
  Q_flow_dir_N=tau_dir[3]*(A_Win[3]*(irrTilt[3].irradiance_direct_tilted));
  Q_flow_dir_E=tau_dir[4]*(A_Win[4]*(irrTilt[4].irradiance_direct_tilted));

  Q_flow_diff =tau_diff*(A_Win[1]*(irrTilt[1].irradiance_diffuse_tilted+irrTilt[1].irradiance_ground_tilted)+A_Win[2]*(irrTilt[2].irradiance_diffuse_tilted+irrTilt[2].irradiance_ground_tilted)+A_Win[3]*(irrTilt[3].irradiance_diffuse_tilted+irrTilt[3].irradiance_ground_tilted)+A_Win[4]*(irrTilt[4].irradiance_diffuse_tilted+irrTilt[4].irradiance_ground_tilted));

  //Calculation of distribution of radiations to surfaces
  -window.Q_flow = abs*(A_Win[1]*(irrTilt[1].irradiance_direct_tilted) + A_Win[2]*(irrTilt[2].irradiance_direct_tilted) + A_Win[3]*(irrTilt[3].irradiance_direct_tilted) + A_Win[4]*(irrTilt[4].irradiance_direct_tilted) + A_Win[1]*(irrTilt[1].irradiance_diffuse_tilted+irrTilt[1].irradiance_ground_tilted) + A_Win[2]*(irrTilt[2].irradiance_diffuse_tilted+irrTilt[2].irradiance_ground_tilted) + A_Win[3]*(irrTilt[3].irradiance_diffuse_tilted+irrTilt[3].irradiance_ground_tilted) + A_Win[4]*(irrTilt[4].irradiance_diffuse_tilted+irrTilt[4].irradiance_ground_tilted));
  -ground.Q_flow=(A[1]/A_sum*Q_flow_diff+Q_flow_dir*0.5);
  -wall.Q_flow=((A[2]+A_Win[1]+A_Win[2]+A_Win[3])/A_sum*Q_flow_diff+(A[2]+A_Win[1]+A_Win[2]+A_Win[3])/(A_sum-A[1])*Q_flow_dir*0.5);
  -roof.Q_flow = (A[3]/A_sum*Q_flow_diff + A[3]/(A_sum - A[1])*Q_flow_dir*0.5);
 annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{76,-8},{114,-12}},
          color={255,255,0},
          thickness=1)}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008c48\">1. Purpose of model</span></h4>
<p><br>Calculation of heat flow rates to building due to solar radiation</p>
<h4><span style=\"color: #008c48\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Calculation of direct irradiation to walls with 4 instances of TransiEnt.Producer.Heat.SolarThermal.Base.IrradianceOnATiltedSurface (one for each direction).</p>
<p>Calculation of transmittance for windows of each direction.</p>
<p>Calculation of homogenous distribution of diffuse irradiation on all surfaces considered.</p>
<p>It is assumed that 50 &percnt; of the direct irradiation is absorbed by the floor and the rest distributed evenly to the other surfaces.</p>
<p>Calculation of absorbed heat by windows.</p>
<h4><span style=\"color: #008c48\">3. Limits of validity </span></h4>
<h4><span style=\"color: #008c48\">4. Interfaces</span></h4>
<p>Heat Ports to window and surrounding surfaces</p>
<h4><span style=\"color: #008c48\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008c48\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008c48\">7. Remarks for Usage</span></h4>
<p>To be used in ThermalHeatConsumer_L3</p>
<h4><span style=\"color: #008c48\">8. Validation</span></h4>
<h4><span style=\"color: #008c48\">9. References</span></h4>
<p>Michael Wetter, Wangda Zuo, Thierry S. Nouidui &amp; Xiufeng Pang (2014) Modelica Buildings library, Journal of Building Performance Simulation, 7:4, 253-270, DOI: 10.1080/19401493.2013.765506</p>
<p>Senkel, A. (2017) Vergleich verschiedener Arten der W&auml;rmeverbrauchsmodellierung in Modelica. Master Thesis. Hamburg University of Technology.</p>
<h4><span style=\"color: #008c48\">10. Version History</span></h4>
<p>Model created by Anne Senkel (anne.senkel@tuhh.de) September 2017</p>
</html>"));
end SolarRadiation;
