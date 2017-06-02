within TransiEnt.Producer.Heat.SolarThermal;
model SolarCollectorField_L1 "Solar collector field model with up to 12 collector in series and chooeable number in parallel"

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

  import SI = Modelica.SIunits;
  import Const = Modelica.Constants;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Integer n_serial(max=12)=1 "Number of collectors in series (max. 12)" annotation (Dialog(tab="General", group="General"));
  parameter Integer n_parallel=1 "Number of parallel collector rows" annotation (Dialog(tab="General", group="General"));
  parameter SI.Irradiance G_min=0 "minimum Irradiance before collector is working" annotation (Dialog(tab="General", group="General"));

 //Basic equation
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 annotation (Dialog(tab="General", group="General"));
  parameter Boolean useHomotopy=simCenter.useHomotopy "true =  homotopy method is used during initialisation" annotation (Dialog(tab="General", group="General"));
  parameter SI.HeatFlowRate Q_flow_n=100e3 "Nominal heat flow rate of one collector (only effects costs)" annotation (Dialog(tab="General", group="General"));
  parameter SI.Area area "aperture area of one collector" annotation (Dialog(tab="General", group="General"));
  parameter Real eta_0 "zero-loss collector efficiency" annotation (Dialog(group="Coefficients for thermal performance"));
  parameter Real a1(unit="W/(m2.K)") "heat loss coefficient at (T_m - T_amb) = 0" annotation (Dialog(group="Coefficients for thermal performance"));
  parameter Real a2(unit="W/(m2.K2)") "temperature dependent heat loss coefficient" annotation (Dialog(group="Coefficients for thermal performance"));
  parameter Real c_eff(unit="J/(m2.K)") "effective thermal capacity of one collector" annotation (Dialog(tab="General", group="General"));
  parameter Boolean noFriction=true "true = assume no pressure loss due to friction" annotation(Dialog(group="Pressure drop"));

  //pressure loss
  parameter Real a(unit="1/(s.m)")=0 "linear pressure drop coefficient" annotation (Dialog(group="Pressure drop"));
  parameter Real b(unit="1/(kg.m)")=0 "quadratic pressure drop coefficient" annotation (Dialog(group="Pressure drop"));
  parameter SI.Height z1=0 "height inlet" annotation (Dialog(group="Pressure drop"));
  parameter SI.Height z2=0 "height outlet"  annotation (Dialog(group="Pressure drop"));
  constant SI.Acceleration gravAcc=Const.g_n "standard acceleration of gravity on earth" annotation (Dialog(group="Pressure drop"));

  //parameter for SolarTime
  //parameter Real[4] offset(unit={"d","h","m","s"})={0,0,0,0} "(NOT USEABLE) day/hour/month/second; Offset=[0,0,0,0] at t=0 equals 1.1. 00:00:00"  annotation (Dialog(tab="Irradiance", group="Solartime"));
  parameter SI.Angle longitude_local=SI.Conversions.from_deg(10) "longitude of the local position, east positive, 10 East for Hamburg" annotation (Dialog(tab="Irradiance", group="Solartime"));
  parameter SI.Angle longitude_standard=SI.Conversions.from_deg(15) "needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time" annotation (Dialog(tab="Irradiance", group="Solartime"));
  SI.Conversions.NonSIunits.Time_day totaldays=365 "total days of the year, standard=365, leap year=366" annotation (Dialog(tab="Irradiance", group="Solartime"));

  //parameter for ExtraterrestrialIrradiance
  parameter SI.Angle latitude=SI.Conversions.from_deg(53.55) "latitude of the local position, north posiive, 53,55 North for Hamburg" annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));
  parameter SI.Angle slope=SI.Conversions.from_deg(53.55) "slope of the tilted surface, assumption"  annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));
  parameter SI.Angle surfaceAzimuthAngle=0 "surface azimuth angle" annotation (Dialog(tab="Irradiance", group="Extraterrestrial Irradiance"));

  //Skymodel
  replaceable model Skymodel=Base.SkymodelBase "choose between isotropic and anisotropic (HDKR) sky model" annotation (choicesAllMatching=true, Dialog(tab="Irradiance", group="Skymodel"));
  parameter Real reflectance_ground=0.2 "reflectance of the ground" annotation (Dialog(tab="Irradiance", group="Skymodel"));
  parameter Boolean direct_normal=true "Is the direct irradiance measured on a surface normal to irradiance?" annotation (Dialog(tab="Irradiance", group="Skymodel"));

  //parameter for IAM
  parameter Integer kind(min=1, max=3)=1 "different ways to determine the IAM's; 1: constant IAM (assumption) 2: IAM as a function of b0, 3: IAM by interpolation of record" annotation (Dialog(tab="IAM", group="General"));
  parameter Real constant_iam_dir=1 "constant IAM for direct irradiation" annotation (Dialog(tab="IAM", group="General"));
  parameter Real constant_iam_diff=1 "constant IAM for diffuse irradiation" annotation (Dialog(tab="IAM", group="General"));
  parameter Real constant_iam_ground=1 "constant IAM for ground-reflected irradiation" annotation (Dialog(tab="IAM", group="General"));
  parameter Real b0=1 "assumption: constant b0-value for IAM=1-b0*(1/cos(theta)-1)" annotation (Dialog(tab="IAM", group="General"));
  parameter Real[8] iam_SRCC={1,1,1,1,1,1,1,1} "IAM for theta = 0, 10, 20, ..., 70" annotation (Dialog(tab="IAM", group="General"));
  parameter SI.Conversions.NonSIunits.Angle_deg[8] theta={0,10,20,30,40,50,60,70} annotation (Dialog(tab="IAM", group="General"));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;

 // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealOutput G_total annotation (Placement(transformation(
        extent={{-28,-28},{28,28}},
        rotation=90,
        origin={582,102}), iconTransformation(
        extent={{-28,-28},{28,28}},
        rotation=90,
        origin={532,370})));
  Modelica.Blocks.Interfaces.RealOutput T_out annotation (Placement(transformation(extent={{-28,-28},{28,28}},
        rotation=90,
        origin={656,102}), iconTransformation(
        extent={{-28,-28},{28,28}},
        rotation=90,
        origin={612,370})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterIn(Medium=medium) annotation (Placement(transformation(extent={{-760,-20},{-720,20}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterOut(Medium=medium) annotation (Placement(transformation(extent={{720,-20},{760,20}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  SolarCollector_L1 solarcollector_1(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    n_serial=n_serial,
    Q_flow_n=Q_flow_n) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-632,-44})));
  SolarCollector_L1 solarcollector_2(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    Q_flow_n=Q_flow_n)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-566,-40})));

  SolarCollector_L1 solarcollector_3(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    Q_flow_n=Q_flow_n)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-500,-44})));

  SolarCollector_L1 solarcollector_4(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    Q_flow_n=Q_flow_n)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-428,-44})));

  SolarCollector_L1 solarcollector_5(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    Q_flow_n=Q_flow_n)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-302,-44})));

  SolarCollector_L1 solarcollector_6(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    Q_flow_n=Q_flow_n)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-166,-44})));

  SolarCollector_L1 solarcollector_7(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    Q_flow_n=Q_flow_n)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-44})));

  SolarCollector_L1 solarcollector_8(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    Q_flow_n=Q_flow_n)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={44,-44})));

  SolarCollector_L1 solarcollector_9(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    Q_flow_n=Q_flow_n)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={162,-44})));

  SolarCollector_L1 solarcollector_10(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    Q_flow_n=Q_flow_n)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={266,-44})));

  SolarCollector_L1 solarcollector_11(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    Q_flow_n=Q_flow_n)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={396,-44})));

  SolarCollector_L1 solarcollector_12(
    area=area,
    kind=kind,
    redeclare model Skymodel = Skymodel,
    constant_iam_dir=constant_iam_dir,
    constant_iam_diff=constant_iam_diff,
    constant_iam_ground=constant_iam_ground,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    a=a,
    b=b,
    noFriction=noFriction,
    z1=z1,
    z2=z2,
    useHomotopy=useHomotopy,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    iam_SRCC=iam_SRCC,
    b0=b0,
    theta=theta,
    G_min=G_min,
    Q_flow_n=Q_flow_n)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={534,-44})));

  TILMedia.VLEFluid_ph vleFluidIn(vleFluidType=medium, p=waterIn.p, h=h_in) annotation (Placement(transformation(extent={{-708,-12},{-688,8}})));
  TILMedia.VLEFluid_ph vleFluidOut(vleFluidType=medium, p=waterOut.p, h=h_out) annotation (Placement(transformation(extent={{720,-50},{740,-30}})));

  ClaRa.Components.Sensors.SensorVLE_L1_T temperature annotation (Placement(transformation(extent={{562,-44},{582,-24}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L1_simple(splitRatio_input=true) annotation (Placement(transformation(extent={{-608,-54},{-588,-36}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L1_simple1(splitRatio_input=true) annotation (Placement(transformation(extent={{-548,-54},{-528,-36}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L1_simple2(splitRatio_input=true) annotation (Placement(transformation(extent={{-470,-54},{-450,-36}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L1_simple3(splitRatio_input=true) annotation (Placement(transformation(extent={{-388,-54},{-368,-36}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L1_simple4(splitRatio_input=true) annotation (Placement(transformation(extent={{-10,-9},{10,9}},
        rotation=0,
        origin={-216,-45})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L1_simple5(splitRatio_input=true) annotation (Placement(transformation(extent={{-10,-9},{10,9}},
        rotation=0,
        origin={-108,-45})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L1_simple6(splitRatio_input=true) annotation (Placement(transformation(extent={{-10,-9},{10,9}},
        rotation=0,
        origin={-6,-45})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L1_simple7(splitRatio_input=true) annotation (Placement(transformation(extent={{-10,-9},{10,9}},
        rotation=0,
        origin={116,-45})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L1_simple8(splitRatio_input=true) annotation (Placement(transformation(extent={{-10,-9},{10,9}},
        rotation=0,
        origin={216,-45})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L1_simple9(splitRatio_input=true) annotation (Placement(transformation(extent={{-10,-9},{10,9}},
        rotation=0,
        origin={322,-45})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L1_simple10(splitRatio_input=true) annotation (Placement(transformation(extent={{-10,-9},{10,9}},
        rotation=0,
        origin={464,-45})));

  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=n_serial)  annotation (Placement(transformation(extent={{-698,34},{-662,62}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-566,6})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=1)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-574,82})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=Const.small) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-558,82})));

  Basics.Blocks.Equal lessEqual annotation (Placement(transformation(extent={{-608,18},{-588,38}})));
  Modelica.Blocks.Math.IntegerToReal integerToReal annotation (Placement(transformation(extent={{-648,38},{-628,58}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=1) annotation (Placement(transformation(extent={{-644,10},{-624,30}})));
  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-458,6})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=1)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-466,82})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=Const.small) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-450,82})));

  Basics.Blocks.Equal lessEqual1 annotation (Placement(transformation(extent={{-500,18},{-480,38}})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=2) annotation (Placement(transformation(extent={{-542,10},{-522,30}})));
  Modelica.Blocks.Logical.Switch switch3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-352,6})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=1)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-360,82})));
  Modelica.Blocks.Sources.RealExpression realExpression7(y=Const.small) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-344,82})));

  Basics.Blocks.Equal lessEqual2 annotation (Placement(transformation(extent={{-394,18},{-374,38}})));
  Modelica.Blocks.Sources.RealExpression realExpression8(y=3) annotation (Placement(transformation(extent={{-436,10},{-416,30}})));
  Modelica.Blocks.Logical.Switch switch4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-246,6})));
  Modelica.Blocks.Sources.RealExpression realExpression9(y=1)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-254,82})));
  Modelica.Blocks.Sources.RealExpression realExpression10(y=Const.small)
                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-238,82})));
  Basics.Blocks.Equal lessEqual3 annotation (Placement(transformation(extent={{-288,18},{-268,38}})));
  Modelica.Blocks.Sources.RealExpression realExpression11(y=4)
                                                              annotation (Placement(transformation(extent={{-330,10},{-310,30}})));
  Modelica.Blocks.Logical.Switch switch6 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-38,6})));
  Modelica.Blocks.Sources.RealExpression realExpression15(
                                                         y=1)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-46,82})));
  Modelica.Blocks.Sources.RealExpression realExpression16(y=Const.small)
                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,84})));
  Basics.Blocks.Equal lessEqual5 annotation (Placement(transformation(extent={{-80,18},{-60,38}})));
  Modelica.Blocks.Sources.RealExpression realExpression17(y=6)
                                                              annotation (Placement(transformation(extent={{-122,10},{-102,30}})));
  Modelica.Blocks.Logical.Switch switch5 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-142,6})));
  Modelica.Blocks.Sources.RealExpression realExpression12(
                                                         y=1)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-150,82})));
  Modelica.Blocks.Sources.RealExpression realExpression13(y=Const.small)
                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-134,82})));
  Basics.Blocks.Equal lessEqual4 annotation (Placement(transformation(extent={{-184,18},{-164,38}})));
  Modelica.Blocks.Sources.RealExpression realExpression14(y=5)
                                                              annotation (Placement(transformation(extent={{-226,10},{-206,30}})));
  Modelica.Blocks.Logical.Switch switch7 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={66,12})));
  Modelica.Blocks.Sources.RealExpression realExpression18(
                                                         y=1)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={58,86})));
  Modelica.Blocks.Sources.RealExpression realExpression19(y=Const.small)
                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={74,86})));
  Basics.Blocks.Equal lessEqual6 annotation (Placement(transformation(extent={{24,22},{44,42}})));
  Modelica.Blocks.Sources.RealExpression realExpression20(y=7)
                                                              annotation (Placement(transformation(extent={{-18,14},{2,34}})));
  Modelica.Blocks.Logical.Switch switch8 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={170,8})));
  Modelica.Blocks.Sources.RealExpression realExpression21(
                                                         y=1)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={162,82})));
  Modelica.Blocks.Sources.RealExpression realExpression22(y=Const.small)
                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={178,82})));
  Basics.Blocks.Equal lessEqual7 annotation (Placement(transformation(extent={{128,18},{148,38}})));
  Modelica.Blocks.Sources.RealExpression realExpression23(y=8)
                                                              annotation (Placement(transformation(extent={{86,10},{106,30}})));
  Modelica.Blocks.Logical.Switch switch9 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={274,8})));
  Modelica.Blocks.Sources.RealExpression realExpression24(
                                                         y=1)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={266,82})));
  Modelica.Blocks.Sources.RealExpression realExpression25(y=Const.small)
                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={284,82})));
  Basics.Blocks.Equal lessEqual8 annotation (Placement(transformation(extent={{232,18},{252,38}})));
  Modelica.Blocks.Sources.RealExpression realExpression26(y=9) annotation (Placement(transformation(extent={{190,10},{210,30}})));
  Modelica.Blocks.Logical.Switch switch10
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={380,8})));
  Modelica.Blocks.Sources.RealExpression realExpression27(
                                                         y=1)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={372,82})));
  Modelica.Blocks.Sources.RealExpression realExpression28(y=Const.small)
                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={388,82})));
  Basics.Blocks.Equal lessEqual9 annotation (Placement(transformation(extent={{338,18},{358,38}})));
  Modelica.Blocks.Sources.RealExpression realExpression29(y=10)
                                                              annotation (Placement(transformation(extent={{296,10},{316,30}})));
  Modelica.Blocks.Logical.Switch switch11
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={486,8})));
  Modelica.Blocks.Sources.RealExpression realExpression30(
                                                         y=1)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={478,82})));
  Modelica.Blocks.Sources.RealExpression realExpression31(y=Const.small)
                                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={494,82})));
  Basics.Blocks.Equal lessEqual10 annotation (Placement(transformation(extent={{444,18},{464,38}})));
  Modelica.Blocks.Sources.RealExpression realExpression32(y=11)
                                                              annotation (Placement(transformation(extent={{402,10},{422,30}})));

  Base.ScaleMassFlow upscaling(
    n_parallel=n_parallel,
    downscale=false,
    upscale=true) annotation (Placement(transformation(extent={{648,-54},{668,-34}})));
  Base.ScaleMassFlow dwonscaling(n_parallel=n_parallel) annotation (Placement(transformation(extent={{-706,-68},{-686,-48}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  h_in= if useHomotopy then homotopy(actualStream(waterIn.h_outflow), inStream(waterIn.h_outflow)) else actualStream(waterIn.h_outflow);
  h_out= if useHomotopy then homotopy(actualStream(waterOut.h_outflow), inStream(waterOut.h_outflow)) else actualStream(waterOut.h_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(switch1.y, threeWayValveVLE_L1_simple.splitRatio_external) annotation (Line(points={{-566,-5},{-566,-13},{-598,-13},{-598,-35}},
                                                                                                  color={0,0,127}));
  connect(integerExpression.y, integerToReal.u) annotation (Line(points={{-660.2,48},{-650,48}}, color={255,127,0}));
  connect(integerToReal.y, lessEqual.u1) annotation (Line(points={{-627,48},{-618,48},{-618,32},{-618,28},{-610,28}}, color={0,0,127}));
  connect(lessEqual.y, switch1.u2) annotation (Line(points={{-587,28},{-566,28},{-566,18}},
                                                                                          color={255,0,255}));
  connect(switch1.u3, realExpression.y) annotation (Line(points={{-574,18},{-574,71}},color={0,0,127}));
  connect(switch1.u1, realExpression1.y) annotation (Line(points={{-558,18},{-558,71}},color={0,0,127}));
  connect(lessEqual1.y, switch2.u2) annotation (Line(points={{-479,28},{-458,28},{-458,18}},
                                                                                      color={255,0,255}));
  connect(switch2.u3, realExpression3.y) annotation (Line(points={{-466,18},{-466,71}},
                                                                                     color={0,0,127}));
  connect(switch2.u1, realExpression4.y) annotation (Line(points={{-450,18},{-450,71}},
                                                                                     color={0,0,127}));
  connect(realExpression2.y, lessEqual.u2) annotation (Line(points={{-623,20},{-623,20},{-610,20}}, color={0,0,127}));
  connect(realExpression5.y, lessEqual1.u2) annotation (Line(points={{-521,20},{-510,20},{-502,20}},color={0,0,127}));
  connect(switch2.y, threeWayValveVLE_L1_simple1.splitRatio_external) annotation (Line(points={{-458,-5},{-458,-5},{-458,-10},{-538,-10},{-538,-35}},
                                                                                                  color={0,0,127}));
  connect(lessEqual1.u1, lessEqual.u1) annotation (Line(points={{-502,28},{-508,28},{-508,48},{-618,48},{-618,28},{-610,28}},
                                                                                                  color={0,0,127}));
  connect(lessEqual2.y,switch3. u2) annotation (Line(points={{-373,28},{-352,28},{-352,18}},
                                                                                      color={255,0,255}));
  connect(switch3.u3,realExpression6. y) annotation (Line(points={{-360,18},{-360,71}},
                                                                                     color={0,0,127}));
  connect(switch3.u1,realExpression7. y) annotation (Line(points={{-344,18},{-344,71}},
                                                                                     color={0,0,127}));
  connect(realExpression8.y,lessEqual2. u2) annotation (Line(points={{-415,20},{-404,20},{-396,20}},color={0,0,127}));
  connect(switch3.y, threeWayValveVLE_L1_simple2.splitRatio_external) annotation (Line(points={{-352,-5},{-352,-5},{-352,-18},{-460,-18},{-460,-35}},
                                                                                                  color={0,0,127}));
  connect(lessEqual2.u1, lessEqual.u1) annotation (Line(points={{-396,28},{-406,28},{-406,48},{-618,48},{-618,28},{-610,28}},
                                                                                                  color={0,0,127}));
  connect(lessEqual3.y,switch4. u2) annotation (Line(points={{-267,28},{-246,28},{-246,18}},
                                                                                      color={255,0,255}));
  connect(switch4.u3,realExpression9. y) annotation (Line(points={{-254,18},{-254,71}},
                                                                                     color={0,0,127}));
  connect(switch4.u1, realExpression10.y) annotation (Line(points={{-238,18},{-238,71}},color={0,0,127}));
  connect(realExpression11.y, lessEqual3.u2) annotation (Line(points={{-309,20},{-298,20},{-290,20}},
                                                                                                  color={0,0,127}));
  connect(lessEqual3.u1, lessEqual.u1) annotation (Line(points={{-290,28},{-300,28},{-300,48},{-618,48},{-618,28},{-610,28}},
                                                                                                  color={0,0,127}));
  connect(switch4.y, threeWayValveVLE_L1_simple3.splitRatio_external) annotation (Line(points={{-246,-5},{-246,-26},{-378,-26},{-378,-35}},
                                                                                                  color={0,0,127}));
  connect(lessEqual5.y,switch6. u2) annotation (Line(points={{-59,28},{-38,28},{-38,18}},
                                                                                      color={255,0,255}));
  connect(switch6.u3, realExpression15.y) annotation (Line(points={{-46,18},{-46,71}},  color={0,0,127}));
  connect(switch6.u1,realExpression16. y) annotation (Line(points={{-30,18},{-30,73}},  color={0,0,127}));
  connect(realExpression17.y,lessEqual5. u2) annotation (Line(points={{-101,20},{-90,20},{-82,20}},color={0,0,127}));
  connect(lessEqual4.y,switch5. u2) annotation (Line(points={{-163,28},{-142,28},{-142,18}},
                                                                                      color={255,0,255}));
  connect(switch5.u3, realExpression12.y) annotation (Line(points={{-150,18},{-150,71}},color={0,0,127}));
  connect(switch5.u1,realExpression13. y) annotation (Line(points={{-134,18},{-134,71}},color={0,0,127}));
  connect(realExpression14.y,lessEqual4. u2) annotation (Line(points={{-205,20},{-194,20},{-186,20}},
                                                                                                  color={0,0,127}));
  connect(threeWayValveVLE_L1_simple4.splitRatio_external, switch5.y) annotation (Line(points={{-216,-35},{-216,-35},{-216,-28},{-216,-14},{-142,-14},{-142,-5}},
                                                                                                  color={0,0,127}));
  connect(switch6.y, threeWayValveVLE_L1_simple5.splitRatio_external) annotation (Line(points={{-38,-5},{-38,-8},{-108,-8},{-108,-35}},
                                                                                                  color={0,0,127}));
  connect(lessEqual4.u1, lessEqual.u1) annotation (Line(points={{-186,28},{-190,28},{-190,26},{-200,26},{-200,48},{-618,48},{-618,28},{-610,28}},
                                                                                                  color={0,0,127}));
  connect(lessEqual5.u1, lessEqual.u1) annotation (Line(points={{-82,28},{-88,28},{-88,30},{-100,30},{-100,48},{-618,48},{-618,28},{-610,28}},
                                                                                                  color={0,0,127}));
  connect(lessEqual6.y,switch7. u2) annotation (Line(points={{45,32},{66,32},{66,24}},color={255,0,255}));
  connect(switch7.u3, realExpression18.y) annotation (Line(points={{58,24},{58,48},{58,75}},
                                                                                        color={0,0,127}));
  connect(switch7.u1,realExpression19. y) annotation (Line(points={{74,24},{74,48},{74,75}},
                                                                                        color={0,0,127}));
  connect(realExpression20.y,lessEqual6. u2) annotation (Line(points={{3,24},{14,24},{22,24}},     color={0,0,127}));
  connect(switch7.y, threeWayValveVLE_L1_simple6.splitRatio_external) annotation (Line(points={{66,1},{66,-18},{-6,-18},{-6,-35}},  color={0,0,127}));
  connect(lessEqual6.u1, lessEqual.u1) annotation (Line(points={{22,32},{18,32},{18,34},{-2,34},{-2,48},{-618,48},{-618,28},{-610,28}},      color={0,0,127}));
  connect(lessEqual7.y,switch8. u2) annotation (Line(points={{149,28},{170,28},{170,20}},
                                                                                      color={255,0,255}));
  connect(switch8.u3,realExpression21. y) annotation (Line(points={{162,20},{162,44},{162,71}},
                                                                                        color={0,0,127}));
  connect(switch8.u1,realExpression22. y) annotation (Line(points={{178,20},{178,44},{178,71}},
                                                                                        color={0,0,127}));
  connect(realExpression23.y,lessEqual7. u2) annotation (Line(points={{107,20},{118,20},{126,20}}, color={0,0,127}));
  connect(lessEqual8.y,switch9. u2) annotation (Line(points={{253,28},{274,28},{274,20}},
                                                                                      color={255,0,255}));
  connect(switch9.u3,realExpression24. y) annotation (Line(points={{266,20},{266,44},{266,71}},
                                                                                        color={0,0,127}));
  connect(switch9.u1,realExpression25. y) annotation (Line(points={{282,20},{282,71},{284,71}},
                                                                                        color={0,0,127}));
  connect(realExpression26.y,lessEqual8. u2) annotation (Line(points={{211,20},{222,20},{230,20}}, color={0,0,127}));
  connect(switch8.y, threeWayValveVLE_L1_simple7.splitRatio_external) annotation (Line(points={{170,-3},{166,-3},{166,-14},{116,-14},{116,-35}},
                                                                                                  color={0,0,127}));
  connect(switch9.y, threeWayValveVLE_L1_simple8.splitRatio_external) annotation (Line(points={{274,-3},{274,-3},{274,-18},{216,-18},{216,-35}},
                                                                                                  color={0,0,127}));
  connect(lessEqual7.u1, lessEqual.u1) annotation (Line(points={{126,28},{122,28},{122,26},{112,26},{112,48},{-618,48},{-618,28},{-610,28}}, color={0,0,127}));
  connect(lessEqual8.u1, lessEqual.u1) annotation (Line(points={{230,28},{210,28},{210,48},{-618,48},{-618,28},{-610,28}}, color={0,0,127}));
  connect(T_out, T_out) annotation (Line(points={{656,102},{656,102}}, color={0,0,127}));
  connect(solarcollector_1.waterPortOut, threeWayValveVLE_L1_simple.inlet) annotation (Line(
      points={{-624,-44},{-622,-44},{-622,-46},{-608,-46},{-608,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple.outlet1, solarcollector_2.waterPortIn) annotation (Line(
      points={{-588,-44},{-576,-44},{-574,-40}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(solarcollector_2.waterPortOut, threeWayValveVLE_L1_simple1.inlet) annotation (Line(
      points={{-558,-40},{-554,-44},{-548,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple1.outlet1, solarcollector_3.waterPortIn) annotation (Line(
      points={{-528,-44},{-508,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(solarcollector_3.waterPortOut, threeWayValveVLE_L1_simple2.inlet) annotation (Line(
      points={{-492,-44},{-470,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple2.outlet1, solarcollector_4.waterPortIn) annotation (Line(
      points={{-450,-44},{-446,-44},{-436,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(solarcollector_4.waterPortOut, threeWayValveVLE_L1_simple3.inlet) annotation (Line(
      points={{-420,-44},{-412,-44},{-412,-46},{-388,-46},{-388,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple3.outlet1, solarcollector_5.waterPortIn) annotation (Line(
      points={{-368,-44},{-356,-44},{-310,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(solarcollector_5.waterPortOut, threeWayValveVLE_L1_simple4.inlet) annotation (Line(
      points={{-294,-44},{-260,-44},{-226,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple4.outlet1, solarcollector_6.waterPortIn) annotation (Line(
      points={{-206,-44},{-174,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(solarcollector_6.waterPortOut, threeWayValveVLE_L1_simple5.inlet) annotation (Line(
      points={{-158,-44},{-138,-44},{-118,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple5.outlet1, solarcollector_7.waterPortIn) annotation (Line(
      points={{-98,-44},{-78,-44},{-58,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(solarcollector_7.waterPortOut, threeWayValveVLE_L1_simple6.inlet) annotation (Line(
      points={{-42,-44},{-29,-44},{-16,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple6.outlet1, solarcollector_8.waterPortIn) annotation (Line(
      points={{4,-44},{20,-44},{36,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(solarcollector_8.waterPortOut, threeWayValveVLE_L1_simple7.inlet) annotation (Line(
      points={{52,-44},{66,-44},{106,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple7.outlet1, solarcollector_9.waterPortIn) annotation (Line(
      points={{126,-44},{154,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(solarcollector_9.waterPortOut, threeWayValveVLE_L1_simple8.inlet) annotation (Line(
      points={{170,-44},{206,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple8.outlet1, solarcollector_10.waterPortIn) annotation (Line(
      points={{226,-44},{258,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(lessEqual9.y, switch10.u2) annotation (Line(points={{359,28},{380,28},{380,20}}, color={255,0,255}));
  connect(switch10.u3, realExpression27.y) annotation (Line(points={{372,20},{372,44},{372,71}},  color={0,0,127}));
  connect(switch10.u1, realExpression28.y) annotation (Line(points={{388,20},{388,44},{388,71}},  color={0,0,127}));
  connect(realExpression29.y,lessEqual9. u2) annotation (Line(points={{317,20},{328,20},{336,20}}, color={0,0,127}));
  connect(switch10.y, threeWayValveVLE_L1_simple9.splitRatio_external) annotation (Line(points={{380,-3},{380,-3},{380,-18},{322,-18},{322,-35}},
                                                                                                  color={0,0,127}));
  connect(threeWayValveVLE_L1_simple9.inlet, solarcollector_10.waterPortOut) annotation (Line(
      points={{312,-44},{304,-44},{274,-44}},
      color={0,131,169},
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple9.outlet1, solarcollector_11.waterPortIn) annotation (Line(
      points={{332,-44},{360,-44},{388,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(lessEqual10.y, switch11.u2) annotation (Line(points={{465,28},{486,28},{486,20}}, color={255,0,255}));
  connect(switch11.u3, realExpression30.y) annotation (Line(points={{478,20},{478,44},{478,71}},  color={0,0,127}));
  connect(switch11.u1, realExpression31.y) annotation (Line(points={{494,20},{494,44},{494,71}},  color={0,0,127}));
  connect(realExpression32.y, lessEqual10.u2) annotation (Line(points={{423,20},{434,20},{442,20}}, color={0,0,127}));
  connect(solarcollector_11.waterPortOut, threeWayValveVLE_L1_simple10.inlet) annotation (Line(
      points={{404,-44},{430,-44},{454,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple10.splitRatio_external, switch11.y) annotation (Line(points={{464,-35},{464,-18},{486,-18},{486,-3}},
                                                                                                  color={0,0,127}));
  connect(threeWayValveVLE_L1_simple10.outlet1, solarcollector_12.waterPortIn) annotation (Line(
      points={{474,-44},{500,-44},{526,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(solarcollector_12.waterPortOut, temperature.port) annotation (Line(
      points={{542,-44},{572,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(temperature.T, T_out) annotation (Line(points={{583,-34},{596,-34},{596,52},{656,52},{656,102}},  color={0,0,127}));
  connect(G_total, solarcollector_12.G) annotation (Line(points={{582,102},{582,-16},{541.8,-16},{541.8,-35.4}}, color={0,0,127}));
  connect(threeWayValveVLE_L1_simple.outlet2, temperature.port) annotation (Line(
      points={{-598,-54},{-598,-98},{572,-98},{572,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(lessEqual9.u1, lessEqual.u1) annotation (Line(points={{336,28},{322,28},{322,48},{-618,48},{-618,28},{-610,28}}, color={0,0,127}));
  connect(lessEqual10.u1, lessEqual.u1) annotation (Line(points={{442,28},{420,28},{420,48},{-618,48},{-618,28},{-610,28}}, color={0,0,127}));
  connect(threeWayValveVLE_L1_simple10.outlet2, temperature.port) annotation (Line(
      points={{464,-54},{464,-98},{572,-98},{572,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple9.outlet2, temperature.port) annotation (Line(
      points={{322,-54},{322,-98},{572,-98},{572,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple8.outlet2, temperature.port) annotation (Line(
      points={{216,-54},{216,-68},{216,-98},{572,-98},{572,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple7.outlet2, temperature.port) annotation (Line(
      points={{116,-54},{116,-98},{572,-98},{572,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple6.outlet2, temperature.port) annotation (Line(
      points={{-6,-54},{-6,-98},{572,-98},{572,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple5.outlet2, temperature.port) annotation (Line(
      points={{-108,-54},{-108,-98},{572,-98},{572,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple4.outlet2, temperature.port) annotation (Line(
      points={{-216,-54},{-216,-98},{572,-98},{572,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple3.outlet2, temperature.port) annotation (Line(
      points={{-378,-54},{-378,-98},{572,-98},{572,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple2.outlet2, temperature.port) annotation (Line(
      points={{-460,-54},{-460,-98},{572,-98},{572,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(threeWayValveVLE_L1_simple1.outlet2, temperature.port) annotation (Line(
      points={{-538,-54},{-538,-98},{572,-98},{572,-44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(waterOut, waterOut) annotation (Line(
      points={{740,0},{728,0},{740,0}},
      color={175,0,0},
      thickness=0.5));
  connect(temperature.port, upscaling.fluidPortIn) annotation (Line(
      points={{572,-44},{649,-44},{649,-43.4}},
      color={0,131,169},
      thickness=0.5));
  connect(waterOut, upscaling.fluidPortOut) annotation (Line(
      points={{740,0},{700,0},{700,-43.4},{667,-43.4}},
      color={175,0,0},
      thickness=0.5));
  connect(solarcollector_1.waterPortIn, dwonscaling.fluidPortOut) annotation (Line(
      points={{-640,-44},{-658,-44},{-658,-56},{-687,-56},{-687,-57.4}},
      color={175,0,0},
      thickness=0.5));
  connect(waterIn, dwonscaling.fluidPortIn) annotation (Line(
      points={{-740,0},{-738,0},{-738,-58},{-705,-58},{-705,-57.4}},
      color={175,0,0},
      thickness=0.5));
  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,-4})),
              Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Combining several SolarCollector models to one collector field</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Sascha Guddusch (sascha.guddusch@tuhh.de), May 2016</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Mar 2017</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de), Apr. 2017</p>
</html>"),
    Diagram(coordinateSystem(extent={{-760,-140},{760,140}}, preserveAspectRatio=false)),
    Icon(coordinateSystem(extent={{-760,-400},{760,400}}, preserveAspectRatio=false), graphics={
        Rectangle(extent={{-760,400},{760,-400}}, pattern=LinePattern.None),
        Rectangle(
          extent={{-760,400},{760,-400}}, pattern=LinePattern.None),
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={-360,240},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={-334,204},
          rotation=360),
        Line(
          points={{-95,-30},{19,-30},{19,-10},{-89,-10},{-89,10},{19,10},{19,30},{-89,30},{-89,50},{19,50},{19,70},{-89,70},{-89,90},{25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={-325,212},
          rotation=360),
        Line(
          points={{62,5},{22,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-282,235},
          rotation=360),
        Line(
          points={{-30,63},{-190,63}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-430,177},
          rotation=360),           Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={-120,240},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={-94,204},
          rotation=360),
        Line(
          points={{95,-30},{-19,-30},{-19,-10},{89,-10},{89,10},{-19,10},{-19,30},{89,30},{89,50},{-19,50},{-19,70},{89,70},{89,90},{-25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={-155,212},
          rotation=360),           Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={120,240},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={146,204},
          rotation=360),
        Line(
          points={{-95,-30},{19,-30},{19,-10},{-89,-10},{-89,10},{19,10},{19,30},{-89,30},{-89,50},{19,50},{19,70},{-89,70},{-89,90},{25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={155,212},
          rotation=360),           Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={-120,0},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={-94,-36},
          rotation=360),
        Line(
          points={{-95,-30},{19,-30},{19,-10},{-89,-10},{-89,10},{19,10},{19,30},{-89,30},{-89,50},{19,50},{19,70},{-89,70},{-89,90},{25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={-85,-28},
          rotation=360),           Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={-360,0},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={-334,-36},
          rotation=360),
        Line(
          points={{95,-30},{-19,-30},{-19,-10},{89,-10},{89,10},{-19,10},{-19,30},{89,30},{89,50},{-19,50},{-19,70},{89,70},{89,90},{-25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={-395,-28},
          rotation=360),
        Line(
          points={{-28,5},{-290,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-432,-5},
          rotation=360),           Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={120,0},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={146,-36},
          rotation=360),
        Line(
          points={{95,-30},{-19,-30},{-19,-10},{89,-10},{89,10},{-19,10},{-19,30},{89,30},{89,50},{-19,50},{-19,70},{89,70},{89,90},{-25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={85,-28},
          rotation=360),
        Line(
          points={{-146,-339},{-146,141}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-474,99},
          rotation=360),           Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={360,240},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={386,204},
          rotation=360),
        Line(
          points={{95,-30},{-19,-30},{-19,-10},{89,-10},{89,10},{-19,10},{-19,30},{89,30},{89,50},{-19,50},{-19,70},{89,70},{89,90},{-25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={325,212},
          rotation=360),           Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={360,0},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={386,-36},
          rotation=360),
        Line(
          points={{-95,-30},{19,-30},{19,-10},{-89,-10},{-89,10},{19,10},{19,30},{-89,30},{-89,50},{19,50},{19,70},{-89,70},{-89,90},{25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={395,-28},
          rotation=360),           Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={-120,-240},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={-94,-276},
          rotation=360),
        Line(
          points={{-95,-30},{19,-30},{19,-10},{-89,-10},{-89,10},{19,10},{19,30},{-89,30},{-89,50},{19,50},{19,70},{-89,70},{-89,90},{25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={-85,-268},
          rotation=360),           Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={-360,-240},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={-334,-276},
          rotation=360),
        Line(
          points={{95,-30},{-19,-30},{-19,-10},{89,-10},{89,10},{-19,10},{-19,30},{89,30},{89,50},{-19,50},{-19,70},{89,70},{89,90},{-25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={-395,-268},
          rotation=360),
        Line(
          points={{-30,5},{-190,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-430,-245},
          rotation=360),           Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={120,-240},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={146,-276},
          rotation=360),
        Line(
          points={{95,-30},{-19,-30},{-19,-10},{89,-10},{89,10},{-19,10},{-19,30},{89,30},{89,50},{-19,50},{-19,70},{89,70},{89,90},{-25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={85,-268},
          rotation=360),           Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}},
          origin={360,-240},
          rotation=360),
        Polygon(
          points={{-86,-34},{34,-34},{34,106},{-86,106},{-86,-34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5,
          origin={386,-276},
          rotation=360),
        Line(
          points={{-95,-30},{19,-30},{19,-10},{-89,-10},{-89,10},{19,10},{19,30},{-89,30},{-89,50},{19,50},{19,70},{-89,70},{-89,90},{25,90}},
          color={255,255,255},
          smooth=Smooth.None,
          origin={395,-268},
          rotation=360),
        Line(
          points={{30,63},{190,63}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={430,177},
          rotation=360),
        Line(
          points={{30,5},{330,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={428,-5},
          rotation=360),
        Line(
          points={{52,22},{92,2},{52,-18}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={468,-2},
          rotation=360),
        Line(
          points={{144,-337},{144,143}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={476,97},
          rotation=360),
        Line(
          points={{30,5},{190,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={430,-245},
          rotation=360),
        Line(
          points={{52,22},{92,2},{52,-18}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={468,238},
          rotation=360),
        Line(
          points={{52,22},{92,2},{52,-18}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={468,-242},
          rotation=360),
        Line(
          points={{52,22},{92,2},{52,-18}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-612,238},
          rotation=360),
        Line(
          points={{52,22},{92,2},{52,-18}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-612,-2},
          rotation=360),
        Line(
          points={{52,22},{92,2},{52,-18}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-612,-242},
          rotation=360),
        Line(
          points={{62,5},{22,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-42,235},
          rotation=360),
        Line(
          points={{62,5},{22,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={198,235},
          rotation=360),
        Line(
          points={{62,5},{22,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-282,-5},
          rotation=360),
        Line(
          points={{62,5},{22,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-282,-245},
          rotation=360),
        Line(
          points={{62,5},{22,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-42,-5},
          rotation=360),
        Line(
          points={{62,5},{22,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={198,-5},
          rotation=360),
        Line(
          points={{62,5},{22,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-42,-245},
          rotation=360),
        Line(
          points={{62,5},{22,5}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={198,-245},
          rotation=360)}));
end SolarCollectorField_L1;
