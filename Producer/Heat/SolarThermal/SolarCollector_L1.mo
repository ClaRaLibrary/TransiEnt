within TransiEnt.Producer.Heat.SolarThermal;
model SolarCollector_L1 "Solar flat plate collector model (EN 12975) with effective heat capacity for transient behavior"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import Const = Modelica.Constants;
  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.SolarThermalCollector;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  inner Base.IrradianceOnATiltedSurface irradiance(redeclare Base.Skymodel_HDKR skymodel(
      longitude_local=longitude_local,
      longitude_standard=longitude_standard,
      latitude=latitude,
      slope=slope,
      surfaceAzimuthAngle=surfaceAzimuthAngle,
      reflectance_ground=reflectance_ground,
      direct_normal=direct_normal,
      totaldays=totaldays)) annotation (Placement(transformation(extent={{-68,-60},{-36,-32}})));

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  //Basics
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 annotation (Dialog(tab="General", group="General"));
  parameter Boolean useHomotopy=simCenter.useHomotopy "true =  homotopy method is used during initialisation" annotation (Dialog(tab="General", group="General"));
  parameter SI.HeatFlowRate Q_flow_n "Nominal heat flow rate (for cost calculation)" annotation (Dialog(tab="General", group="General"));
  parameter SI.Area area "Aperture area" annotation (Dialog(tab="General", group="General"));
  parameter Real eta_0 "Zero-loss collector efficiency" annotation (Dialog(group="Coefficients for thermal performance"));
  parameter Real a1(unit="W/(m2.K)") "Heat loss coefficient at (T_m - T_amb) = 0" annotation (Dialog(group="Coefficients for thermal performance"));
  parameter Real a2(unit="W/(m2.K2)") "Temperature dependent heat loss coefficient" annotation (Dialog(group="Coefficients for thermal performance"));
  parameter Real c_eff(unit="J/(m2.K)") "Effective thermal capacity of the collector" annotation (Dialog(tab="General", group="General"));
  parameter SI.Irradiance G_min=0 "Minimum Irradiance before collector is working" annotation (Dialog(tab="General", group="General"));
  parameter Boolean noFriction=true "true = assume no pressure loss due to friction" annotation(Dialog(group="Pressure drop"));

  //Pressure loss
  parameter Integer n_serial(max=12)=1 "Number of collectors in series (max. 12)" annotation (Dialog(group="Pressure drop"));
  parameter Real a(unit="1/(s.m)")=0 "Linear pressure drop coefficient" annotation (Dialog(group="Pressure drop"));
  parameter Real b(unit="1/(kg.m)")=0 "Quadratic pressure drop coefficient" annotation (Dialog(group="Pressure drop"));
  parameter SI.Height z1=0 "Height inlet" annotation (Dialog(group="Pressure drop"));
  parameter SI.Height z2=0 "Height outlet"  annotation (Dialog(group="Pressure drop"));

  //Parameters for SolarTime
// parameter Real[4] offset(unit={"d","h","m","s"})={0,0,0,0} annotation (Dialog(tab="Irradiance", group="Solartime")); //(NOT USEABLE) day/hour/month/second; Offset=[0,0,0,0] at t=0 equals 1.1. 00:00:00
  parameter SI.Angle longitude_local=SI.Conversions.from_deg(10) "longitude of the local position, east positive, 10 East for Hamburg" annotation (Dialog(tab="Irradiance", group="Solartime"));
  parameter SI.Angle longitude_standard=SI.Conversions.from_deg(15) "needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time" annotation (Dialog(tab="Irradiance", group="Solartime"));
  SI.Conversions.NonSIunits.Time_day totaldays=365 "total days of the year, standard=365, leap year=366" annotation (Dialog(tab="Irradiance", group="Solartime"));

  //Parameters for ExtraterrestrialIrradiance
  parameter SI.Angle latitude=SI.Conversions.from_deg(53.55) "latitude of the local position, north posiive, 53,55 North for Hamburg" annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));
  parameter SI.Angle slope=SI.Conversions.from_deg(53.55) "slope of the tilted surface, assumption"  annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));
  parameter SI.Angle surfaceAzimuthAngle=0 "surface azimuth angle" annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));

  //Skymodel
  replaceable model Skymodel=Base.SkymodelBase "choose between HDKR and isotropic sky model" annotation (choicesAllMatching=true, Dialog(tab="Irradiance", group="Skymodel"));
  parameter Real reflectance_ground=0.2 "reflectance of the ground" annotation (Dialog(tab="Irradiance", group="Skymodel"));
  parameter Boolean direct_normal=true "Is the direct irradiance measured on a surface normal to irradiance?" annotation (Dialog(tab="Irradiance", group="Skymodel"));

  //Parameters for IAM
  parameter Integer kind(min=1, max=3)=1 "different ways to determine the IAM's; 1: constant IAM (assumption) 2: IAM as a function of b0, 3: IAM by interpolation of record" annotation (Dialog(tab="IAM", group="General"));
  parameter Real constant_iam_dir=1 "constant IAM for direct irradiation" annotation (Dialog(tab="IAM", group="General"));
  parameter Real constant_iam_diff=1 "constant IAM for diffuse irradiation" annotation (Dialog(tab="IAM", group="General"));
  parameter Real constant_iam_ground=1 "constant IAM for ground-reflected irradiation" annotation (Dialog(tab="IAM", group="General"));
  parameter Real b0=1 "assumption: constant b0-value for IAM=1-b0*(1/cos(theta)-1)" annotation (Dialog(tab="IAM", group="General"));
  parameter Real[8] iam_SRCC={1,1,1,1,1,1,1,1} "IAM for theta = 0, 10, 20, ..., 70" annotation (Dialog(tab="IAM", group="General"));
  parameter SI.Conversions.NonSIunits.Angle_deg[8] theta={0,10,20,30,40,50,60,70} annotation (Dialog(tab="IAM", group="General"));

  //Statistics
  replaceable model CostRecordSolarThermal = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.SolarThermal
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "|Statistics|Cost specification" annotation (choicesAllMatching=true);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Temperature T_amb=simCenter.T_amb_var+273.15 "Ambient temperature in K";
  SI.Temperature T_m "Average temperature of the medium";
  SI.TemperatureSlope der_T "Derivative of T_m";
  SI.Irradiance G_total "Total irradiance";
  SI.HeatFlowRate Q_flow_collector "Heat flow provided by solar collector";
  SI.HeatFlowRate Q_flow_out "Generated heat (tranferred to fluid)";
  Real eta "Efficiency factor";
protected
  Real m_flowInv(unit="s/kg") "Regularization of 1/m_flow";
  Real x;
  Modelica.SIunits.SpecificEnthalpy h_out "Enthalpy of the medium flowing out of the collector";
  Modelica.SIunits.SpecificEnthalpy h_in "Enthalpy of the medium flowing into the collector";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
public
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=medium) annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=medium) annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Interfaces.RealOutput T_in=fluidIn.T annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,86}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,90})));
  Modelica.Blocks.Interfaces.RealOutput T_out=fluidOut.T annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={56,86}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,90})));
  Modelica.Blocks.Interfaces.RealOutput G=G_total annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,90}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,90})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
protected
  TILMedia.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    final p=waterPortIn.p,
    final h=h_in,
    computeTransportProperties=false,
    computeVLEAdditionalProperties=false,
    computeVLETransportProperties=false) annotation (Placement(transformation(extent={{-90,16},{-70,36}})));

  TILMedia.VLEFluid_ph fluidOut(
    vleFluidType=medium,
    final p=waterPortOut.p,
    final h=h_out,
    computeTransportProperties=false,
    computeVLEAdditionalProperties=false,
    computeVLETransportProperties=false) annotation (Placement(transformation(extent={{70,16},{90,36}})));

  Base.IAM IAM(
    kind=kind,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    b0=b0,
    iam_SRCC=iam_SRCC,
    theta=theta) annotation (Placement(transformation(extent={{40,-58},{60,-38}})));

public
  Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable) annotation (Placement(transformation(extent={{-60,100},{-40,80}})));
  Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    der_E_n=Q_flow_n,
    E_n=0,
    redeclare model CostRecordGeneral = CostRecordSolarThermal (size1=area),
    Q_flow=Q_flow_out,
    produces_P_el=false,
    consumes_P_el=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    consumes_H_flow=false,
    produces_other_flow=false,
    consumes_other_flow=false,
    produces_m_flow_CDE=false,
    consumes_m_flow_CDE=false)
                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,90})));
  Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsHeat collectGwpEmissions(typeOfEnergyCarrierHeat=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.Solar) annotation (Placement(transformation(extent={{-40,100},{-20,80}})));

protected
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Solar);
initial equation
   x=T_m;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  Q_flow_out = waterPortOut.m_flow*(actualStream(waterPortOut.h_outflow)-actualStream(waterPortIn.h_outflow));

  m_flowInv =Basics.Functions.inverseXRegularized(x=waterPortIn.m_flow, delta=0.001);

  if G_total >= G_min and waterPortIn.m_flow > 0.001 then
                                                     // if condition important to avoid jumps during turning on and off the plant. Caution! Take care that XY in waterIn.m_flow > XY (here 0.003) is smaller than the minimal mass flow rate specified by P_drive_min in the COntrollerModell. This means XY can vary.
    der(x) = 100*(T_m - x);
    der_T = 100*(T_m - x);
  else
    der_T=der(x);
    der(x)=0;
  end if;

  T_m = 0.5*(T_in+T_out);

  G_total =IAM.iam_dir*irradiance.irradiance_direct_tilted + IAM.iam_diff*irradiance.irradiance_diffuse_tilted + IAM.iam_ground*irradiance.irradiance_ground_tilted;

  Q_flow_collector = area*((G_total*eta_0)-a1*(T_m-T_amb)-a2*(T_m-T_amb)^2-c_eff*der_T);

  h_in=if useHomotopy then homotopy(actualStream(waterPortIn.h_outflow), inStream(waterPortIn.h_outflow)) else actualStream(waterPortIn.h_outflow);
  h_out=h_in+Q_flow_collector*m_flowInv;

  if abs(SI.Conversions.to_deg(irradiance.angle_direct_tilted)) <=90 then
    eta=min(1, max(0, Q_flow_collector/max(Const.small, ((area*(irradiance.irradiance_direct_tilted+irradiance.irradiance_diffuse_tilted+irradiance.irradiance_ground_tilted))))));
  else
    eta=0;
  end if;

  waterPortIn.m_flow + waterPortOut.m_flow = 0;

  waterPortIn.h_outflow = inStream(waterPortIn.h_outflow);
  waterPortIn.xi_outflow = inStream(waterPortOut.xi_outflow);

  waterPortOut.h_outflow = inStream(waterPortIn.h_outflow) + Q_flow_collector*m_flowInv;
  waterPortOut.xi_outflow = inStream(waterPortIn.xi_outflow);

  waterPortOut.p = if noFriction then waterPortIn.p + Const.g_n*fluidIn.d*(z1 - z2) else waterPortIn.p + Const.g_n*fluidIn.d*(z1 - z2) - (a*waterPortIn.m_flow + b*waterPortIn.m_flow^2)*10^3*n_serial;

 // Statistics
 // Heating power Q_flow has to be negative
 collectHeatingPower.heatFlowCollector.Q_flow= Q_flow_out;
 // Emissions
 collectGwpEmissions.gwpCollector.m_flow_cde=fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*Q_flow_collector;

 connect(modelStatistics.costsCollector, collectCosts.costsCollector);
 connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Renewable],collectHeatingPower.heatFlowCollector);
 connect(modelStatistics.gwpCollectorHeat[TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Solar],collectGwpEmissions.gwpCollector);
  annotation (Dialog(tab="Irradiance", group="Solartime"),
                                                 Placement(transformation(extent={{-10,16},{10,36}},  rotation=0)),
               choicesAllMatching, Dialog(group="Environment"),
              Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model provides thermal performance and pressure loss as described in EN 12975 for steady state.</p>
<p>A&nbsp;simple&nbsp;solar&nbsp;collector&nbsp;providing&nbsp;useful&nbsp;energy&nbsp;gain&nbsp;as&nbsp;recommended&nbsp;by&nbsp;EN&nbsp;12975&nbsp;steady&nbsp;state&nbsp;thermal&nbsp;performance&nbsp;equation</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical but parameter based model. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Without effective heat capacity only valid for steady state performance.</p>
<p>Model ignores wind speed.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>&nbsp;&nbsp;TransiEnt.Basics.Interfaces.Thermal.FluidPortOut&nbsp;waterOut</p>
<p>&nbsp;&nbsp;TransiEnt.Basics.Interfaces.Thermal.FluidPortIn&nbsp;waterIn</p>
<p>&nbsp;&nbsp;Modelica.Blocks.Interfaces.RealOutput&nbsp;T_in</p>
<p>&nbsp;&nbsp;Modelica.Blocks.Interfaces.RealOutput&nbsp;T_out</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-8097vOgT.png\" alt=\"

  Q= area*((G_total*eta_0)-a1*(T_m-T_amb)-a2*(T_m-T_amb)^2)

\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-KAbYMmch.png\" alt=\"G_total = iam*direct_irradiance.irradiance+IAM_diffuse*(diffuse_irradiance.irradiance+ground_reflected_irradiance.irradiance)\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-5hGbZvPy.png\" alt=\"    iam= if biaxial then iam_obj.value_longitudinal*iam_obj.value_transversal
  else
   iam_obj.value\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-knGUakuE.png\" alt=\" T_m=0.5*(T_in+T_out)\"/></p>
<p><br><img src=\"modelica://TransiEnt/Images/equations/equation-PTHT2yie.png\" alt=\"
  waterIn.m_flow + waterOut.m_flow = 0
\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-BTvGh3Xd.png\" alt=\"  waterOut.p =  if noFriction then waterIn.p+gravAcc*fluidIn.d*(z1-z2) else waterIn.p+gravAcc*fluidIn.d*(z1-z2)-(a*waterOut.m_flow+b*waterOut.m_flow^2)\"/></p>
<p>Values for T_in and T_out are calculated by instances of other classes.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Note that the inlet temperature should never fall below 0 &deg;C. A possible controller for this case can be looked at under TransiEnt.Producer.Heat.SolarThermal.Controller.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>not validated yet</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Osorio/Carvalho: Testing of solar thermal collectors under transient conditions (2014)</p>
<p>Peter Kovacs: A guide to the standard EN 12975 (2012)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Toerber (tobias.toerber@tuhh.de), Jul 2015</p>
<p>Edited by Sascha Guddusch (sascha.guddusch@tuhh.de), May 2016</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Mar 2017</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de), Apr. 2017</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end SolarCollector_L1;
