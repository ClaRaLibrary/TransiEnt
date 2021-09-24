within TransiEnt.Storage.Base;
partial model GenericStorage_base "Partial class for highly adaptable but non-physical model for all kinds of energy storages"


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

  extends TransiEnt.Basics.Icons.StorageGeneric;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter GenericStorageParameters params "Record of generic storage parameters" annotation (choicesAllMatching, Placement(transformation(extent={{76,80},{94,98}}), iconTransformation(extent={{-116,-24},{-76,16}})));
  //parameter SI.Time Td_GradientLimiter=simCenter.Td "Time step of derivative calculation" annotation(Dialog(tab="Expert Settings"));
  parameter Boolean use_PowerRateLimiter=true "Use Power Rate Limitation";
  parameter Real Nd_powerRateLimiter=1/simCenter.Td "The higher Nd, the closer y follows u in the power rate limiter";
  parameter SI.Time T_plant=params.T_plant "first order plant dynamic";
  parameter Boolean use_plantDynamic=false "choose if first order plant dynamic is used";
  parameter Boolean use_inverterEfficiency=false "choose if efficiency curve of inverter is used for loading and unloading";
  parameter Real efficiencyCurve_inverter[:,:]=[0, 0; 0.5, 70.6425; 1, 84.9247; 1.5, 89.6817; 2, 92.0574; 2.5, 93.4807; 3, 94.4276; 3.5, 95.1024; 4, 95.6072; 4.5, 95.9985; 5, 96.3104; 5.5, 96.5646; 6, 96.7756; 6.5, 96.9532; 7, 97.1046; 7.5, 97.2351; 8, 97.3486; 8.5, 97.4481; 9, 97.536; 9.5, 97.614; 10, 97.6836; 10.5, 97.7461; 11, 97.8024; 11.5, 97.8533; 12, 97.8995; 12.5, 97.9416; 13, 97.98; 13.5, 98.0151; 14, 98.0473; 14.5, 98.077; 15, 98.1043; 15.5, 98.1294; 16, 98.1527; 16.5, 98.1742; 17, 98.1941; 17.5, 98.2125; 18, 98.2296; 18.5, 98.2455; 19, 98.2603; 19.5, 98.274; 20, 98.2868; 20.5, 98.2986; 21, 98.3097; 21.5, 98.3199; 22, 98.3295; 22.5, 98.3384; 23, 98.3466; 23.5, 98.3543; 24, 98.3614; 24.5, 98.368; 25, 98.3741; 25.5, 98.3797; 26, 98.3849; 26.5, 98.3897; 27, 98.3942; 27.5, 98.3982; 28, 98.4019; 28.5, 98.4053; 29, 98.4084; 29.5, 98.4112; 30, 98.4137; 30.5, 98.416; 31, 98.418; 31.5, 98.4197; 32, 98.4212; 32.5, 98.4225; 33, 98.4236; 33.5, 98.4245; 34, 98.4253; 34.5, 98.4258; 35, 98.4261; 35.5, 98.4263; 36, 98.4264; 36.5, 98.4262; 37, 98.426; 37.5, 98.4256; 38, 98.425; 38.5, 98.4243; 39, 98.4235; 39.5, 98.4226; 40, 98.4216; 40.5, 98.4204; 41, 98.4192; 41.5, 98.4178; 42, 98.4163; 42.5, 98.4148; 43, 98.4131; 43.5, 98.4114; 44, 98.4096; 44.5, 98.4077; 45, 98.4057; 45.5, 98.4036; 46, 98.4014; 46.5, 98.3992; 47, 98.3969; 47.5, 98.3946; 48, 98.3921; 48.5, 98.3897; 49, 98.3871; 49.5, 98.3845; 50, 98.3818; 50.5, 98.3791; 51, 98.3763; 51.5, 98.3735; 52, 98.3706; 52.5, 98.3676; 53, 98.3646; 53.5, 98.3616; 54, 98.3585; 54.5, 98.3554; 55, 98.3522; 55.5, 98.349; 56, 98.3457; 56.5, 98.3424; 57, 98.3391; 57.5, 98.3357; 58, 98.3323; 58.5, 98.3288; 59, 98.3253; 59.5, 98.3218; 60, 98.3182; 60.5, 98.3146; 61, 98.311; 61.5, 98.3074; 62, 98.3037; 62.5, 98.3; 63, 98.2962; 63.5, 98.2924; 64, 98.2886; 64.5, 98.2848; 65, 98.281; 65.5, 98.2771; 66, 98.2732; 66.5, 98.2692; 67, 98.2653; 67.5, 98.2613; 68, 98.2573; 68.5, 98.2533; 69, 98.2492; 69.5, 98.2451; 70, 98.2411; 70.5, 98.2369; 71, 98.2328; 71.5, 98.2287; 72, 98.2245; 72.5, 98.2203; 73, 98.2161; 73.5, 98.2119; 74, 98.2076; 74.5, 98.2033; 75, 98.1991; 75.5, 98.1948; 76, 98.1904; 76.5, 98.1861; 77, 98.1818; 77.5, 98.1774; 78, 98.173; 78.5, 98.1686; 79, 98.1642; 79.5, 98.1598; 80, 98.1554; 80.5, 98.1509; 81, 98.1464; 81.5, 98.142; 82, 98.1375; 82.5, 98.133; 83, 98.1285; 83.5, 98.1239; 84, 98.1194; 84.5, 98.1148; 85, 98.1103; 85.5, 98.1057; 86, 98.1011; 86.5, 98.0965; 87, 98.0919; 87.5, 98.0873; 88, 98.0826; 88.5, 98.078; 89, 98.0733; 89.5, 98.0687; 90, 98.064; 90.5, 98.0593; 91, 98.0546; 91.5, 98.0499; 92, 98.0452; 92.5, 98.0405; 93, 98.0358; 93.5, 98.031; 94, 98.0263; 94.5, 98.0215; 95, 98.0168; 95.5, 98.012; 96, 98.0072; 96.5, 98.0024; 97, 97.9976; 97.5, 97.9928; 98, 97.988; 98.5, 97.9832; 99, 97.9784; 99.5, 97.9735; 100, 97.9687]/100;
  parameter Boolean stationaryLossOnlyIfInactive=false;
  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  // ------- State variables -----------

  Modelica.Units.SI.Energy E(
    start=params.E_start,
    fixed=true,
    stateSelect=StateSelect.prefer);

  // ------- Diagnostic variables -----------

  Real SOC = (E-params.E_min)/(params.E_max-params.E_min);
  Modelica.Units.SI.Energy E_delta=E - params.E_start "State of charge (0..1)";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_set "Grid side setpoint power (Positive = load request, negative = unload request)"
                                                                                                  annotation (Placement(transformation(extent={{-116,-24},{-76,16}}), iconTransformation(extent={{-116,-24},{-76,16}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_is "Grid side power (Positive = loading, negative = unloading)"
                                                                                        annotation (Placement(transformation(extent={{86,-20},{126,20}}), iconTransformation(extent={{88,-16},{118,14}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_max_load_is;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable model StationaryLossModel =
      NoStationaryLoss constrainedby TransiEnt.Storage.Base.PartialStationaryLoss(final params=params) annotation(choicesAllMatching=true);

  StationaryLossModel stationaryLoss annotation (Placement(transformation(extent={{-90,-94},{-68,-72}})));

  Modelica.Blocks.Sources.RealExpression E_is(y=E) "Internal energy level before stationary loss (energy level directly after load or unloading)" annotation (Placement(transformation(extent={{-67,-30},{-47,-10}})));
ClaRa.Components.Utilities.Blocks.VariableGradientLimiter
    PowerRateLimit(
    constantLimits=true,
    useThresh=simCenter.useThresh,
    thres=simCenter.thres,
    maxGrad_const=params.P_grad_max,
    minGrad_const=-params.P_grad_max,
    Nd=Nd_powerRateLimiter) if           use_PowerRateLimiter==true
    annotation (Placement(transformation(extent={{-30,56},{-10,76}})));
  Modelica.Blocks.Nonlinear.VariableLimiter
                                    PowerLimit(
    strict=true)
    annotation (Placement(transformation(extent={{-70,56},{-50,76}})));

  Modelica.Blocks.Logical.Nor CapacityOk annotation (Placement(transformation(extent={{15,-20},{28,-6}})));
  Modelica.Blocks.Sources.Constant CapacityLimit(k=0) annotation (Placement(transformation(extent={{16,-37},{29,-25}})));
  Modelica.Blocks.Logical.Switch P_is_external annotation (Placement(transformation(extent={{52,-21},{68,-5}})));
  Modelica.Blocks.Logical.And EmptyAndDischarging
    annotation (Placement(transformation(extent={{-8,-30},{5,-16}})));
  Modelica.Blocks.Logical.And FullAndCharging
    annotation (Placement(transformation(extent={{-7,-8},{6,6}})));
  Modelica.Blocks.Logical.LessEqualThreshold DischargeDemand
    annotation (Placement(transformation(extent={{-33,35},{-22,47}})));
  Modelica.Blocks.Logical.Not ChargeDemand
    annotation (Placement(transformation(extent={{5,25},{-7,37}})));

  Modelica.Blocks.Math.Product P_is_internal "Internal power that defines state of charge, i.e. after conversion losses (Losses while loading / unloading)"
                                                                                annotation (Placement(transformation(extent={{76,-62},{90,-48}})));
  Modelica.Blocks.Logical.Switch conversionEfficiency
                                               annotation (Placement(transformation(extent={{32,-67},{48,-51}})));
  Modelica.Blocks.Sources.RealExpression
                                   loadingEfficiency(y=params.eta_load)
                                                             annotation (Placement(transformation(extent={{10,-73},{23,-61}})));
  Modelica.Blocks.Sources.RealExpression eta_unload(y=1/params.eta_unload) annotation (Placement(transformation(extent={{9,-57},{22,-45}})));
  Modelica.Blocks.Sources.RealExpression P_max_load(y=params.P_max_load) annotation (Placement(transformation(extent={{-97,69},{-84,81}})));
  Modelica.Blocks.Sources.RealExpression P_max_unload_neg(y=-params.P_max_unload) annotation (Placement(transformation(extent={{-97,53},{-84,65}})));
  Modelica.Blocks.Logical.Switch stationaryLoss_internal annotation (Placement(transformation(extent={{-30,-65},{-14,-49}})));
  Modelica.Blocks.Sources.Constant CapacityLimit1(k=0)     annotation (Placement(transformation(extent={{-44,-48},{-38,-42}})));
  Basics.Blocks.FirstOrder plantDynamic(Tau=T_plant, initOption=4) if use_plantDynamic            annotation (Placement(transformation(extent={{76,-4},{84,4}})));
  Modelica.Blocks.Logical.Switch P_in_inverter if use_inverterEfficiency  annotation (Placement(transformation(extent={{6,-93},{22,-77}})));
  Modelica.Blocks.Math.Product eta_total if use_inverterEfficiency  annotation (Placement(transformation(extent={{56,-88},{70,-74}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds_inverterEfficiency(tableOnFile=false, table=efficiencyCurve_inverter) if                                      use_inverterEfficiency annotation (Placement(transformation(extent={{30,-92},{44,-78}})));
  Modelica.Blocks.Sources.RealExpression P_in_inverter_unloading(y=min(1, max(0, -P_is_external.u1/params.P_max_load))) if         use_inverterEfficiency annotation (Placement(transformation(extent={{-20,-85},{-7,-73}})));
  Modelica.Blocks.Sources.RealExpression P_in_inverter_loading(y=min(1, max(0, P_is_external.u1/(params.P_max_load)))) if
                                                                                                       use_inverterEfficiency annotation (Placement(transformation(extent={{-20,-97},{-7,-85}})));
  Modelica.Blocks.Logical.Greater greater annotation (Placement(transformation(extent={{-58,28},{-48,38}})));
  Modelica.Blocks.Logical.Less less annotation (Placement(transformation(extent={{-58,14},{-48,24}})));
  Modelica.Blocks.Sources.RealExpression realExpression annotation (Placement(transformation(extent={{-74,18},{-68,28}})));
  Modelica.Blocks.Logical.Nor notActive annotation (Placement(transformation(extent={{-44,22},{-36,30}})));
  Modelica.Blocks.Logical.Nor nor
                                 annotation (Placement(transformation(extent={{-70,-66},{-60,-56}})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch annotation (Placement(transformation(extent={{-46,-62},{-36,-52}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=if stationaryLossOnlyIfInactive then false else true) annotation (Placement(transformation(extent={{-70,-58},{-54,-44}})));
  Modelica.Blocks.Logical.Not active annotation (Placement(transformation(extent={{-32,22},{-24,30}})));
  Modelica.Blocks.Logical.Not not1 annotation (Placement(transformation(extent={{-56,-64},{-50,-58}})));
equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  der(E) = P_is_internal.y - stationaryLoss_internal.y;
  //der(E) = P_is_internal.y - stationaryLoss_internal.y;
  stationaryLoss.E_is = E;
  if FullAndCharging.u2==true then
    P_max_load_is=0;
  else
    P_max_load_is=P_max_load.y/params.P_max_load;
  end if;


  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(CapacityLimit.y, P_is_external.u3) annotation (Line(
      points={{29.65,-31},{48,-31},{48,-20},{50,-20},{50,-19.4},{50.4,-19.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FullAndCharging.y,CapacityOk. u1) annotation (Line(
      points={{6.65,-1},{10,-1},{10,-13},{13.7,-13}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(EmptyAndDischarging.y,CapacityOk. u2) annotation (Line(
      points={{5.65,-23},{10,-23},{10,-19},{13.7,-19},{13.7,-18.6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(loadingEfficiency.y, conversionEfficiency.u3) annotation (Line(points={{23.65,-67},{28,-67},{28,-65.4},{30.4,-65.4}}, color={0,0,127}));
  connect(eta_unload.y, conversionEfficiency.u1) annotation (Line(points={{22.65,-51},{28,-51},{28,-52},{32,-52},{32,-52.6},{30.4,-52.6}}, color={0,0,127}));
  connect(P_is_external.y, P_is_internal.u1) annotation (Line(points={{68.8,-13},{74,-13},{74,-30},{64,-30},{64,-50.8},{74.6,-50.8}},
                                                                                                                    color={0,0,127}));
  connect(PowerLimit.u, P_set) annotation (Line(points={{-72,66},{-80,66},{-80,-4},{-96,-4}},          color={0,0,127}));
  connect(DischargeDemand.y, ChargeDemand.u) annotation (Line(points={{-21.45,41},{10,41},{10,31},{6.2,31}},          color={255,0,255}));
  connect(DischargeDemand.y, EmptyAndDischarging.u1) annotation (Line(points={{-21.45,41},{-14,41},{-14,-23},{-9.3,-23}}, color={255,0,255}));
  connect(DischargeDemand.y, conversionEfficiency.u2) annotation (Line(points={{-21.45,41},{-14,41},{-14,-59},{30.4,-59}}, color={255,0,255}));
  connect(ChargeDemand.y, FullAndCharging.u1) annotation (Line(points={{-7.6,31},{-10,31},{-10,32},{-12,32},{-12,-1},{-8.3,-1}},
                                                                                                               color={255,0,255}));
  connect(CapacityOk.y, P_is_external.u2) annotation (Line(points={{28.65,-13},{50.4,-13}},            color={255,0,255}));
  connect(P_max_load.y, PowerLimit.limit1) annotation (Line(points={{-83.35,75},{-72,75},{-72,74}}, color={0,0,127}));
  connect(P_max_unload_neg.y, PowerLimit.limit2) annotation (Line(points={{-83.35,59},{-72,59},{-72,58}}, color={0,0,127}));
  connect(stationaryLoss.P_statloss, stationaryLoss_internal.u3) annotation (Line(points={{-67.34,-83},{-40,-83},{-40,-63.4},{-31.6,-63.4}}, color={0,0,127}));
  connect(stationaryLoss_internal.u1, CapacityLimit1.y) annotation (Line(points={{-31.6,-50.6},{-30,-50.6},{-30,-50},{-34,-50},{-34,-46},{-37.7,-46},{-37.7,-45}},   color={0,0,127}));
  if use_PowerRateLimiter==true then
    connect(PowerLimit.y, PowerRateLimit.u) annotation (Line(points={{-49,66},{-32,66}},            color={0,0,127}));
    connect(DischargeDemand.u, PowerRateLimit.y) annotation (Line(points={{-34.1,41},{-38,41},{-38,50},{-6,50},{-6,66},{-9,66}}, color={0,0,127}));
    connect(PowerRateLimit.y, P_is_external.u1) annotation (Line(points={{-9,66},{20,66},{20,-6.6},{50.4,-6.6}}, color={0,0,127}));
  else
    connect(PowerLimit.y,DischargeDemand.u);
    connect(PowerLimit.y,P_is_external.u1);
  end if;
  if use_plantDynamic then
    connect(plantDynamic.y, P_is) annotation (Line(points={{84.4,0},{106,0}}, color={0,0,127}));
    connect(plantDynamic.u, P_is_external.y) annotation (Line(points={{75.2,0},{74,0},{74,-13},{68.8,-13}}, color={0,0,127}));
  else
    connect(P_is,P_is_external.y);
  end if;

  if use_inverterEfficiency then
    connect(DischargeDemand.y, P_in_inverter.u2) annotation (Line(points={{-21.45,41},{-14,41},{-14,-85},{4.4,-85}}, color={255,0,255}));
    connect(conversionEfficiency.y, eta_total.u1) annotation (Line(points={{48.8,-59},{54,-59},{54,-76.8},{54.6,-76.8}}, color={0,0,127}));
    connect(eta_total.y, P_is_internal.u2) annotation (Line(points={{70.7,-81},{74.6,-81},{74.6,-59.2}}, color={0,0,127}));
    connect(P_in_inverter.y, combiTable1Ds_inverterEfficiency.u) annotation (Line(points={{22.8,-85},{25.4,-85},{25.4,-85},{28.6,-85}}, color={0,0,127}));
    connect(combiTable1Ds_inverterEfficiency.y[1], eta_total.u2) annotation (Line(points={{44.7,-85},{50.35,-85},{50.35,-85.2},{54.6,-85.2}}, color={0,0,127}));
    connect(P_in_inverter_unloading.y, P_in_inverter.u1) annotation (Line(points={{-6.35,-79},{4.4,-79},{4.4,-78.6}}, color={0,0,127}));
    connect(P_in_inverter_loading.y, P_in_inverter.u3) annotation (Line(points={{-6.35,-91},{4,-91},{4,-92},{4.4,-92},{4.4,-91.4}}, color={0,0,127}));
  else
      connect(conversionEfficiency.y, P_is_internal.u2) annotation (Line(points={{48.8,-59},{64,-59},{64,-59.2},{74.6,-59.2}}, color={0,0,127}));
  end if;



  connect(realExpression.y, greater.u2) annotation (Line(points={{-67.7,23},{-63.85,23},{-63.85,29},{-59,29}}, color={0,0,127}));
  connect(less.u2, realExpression.y) annotation (Line(points={{-59,15},{-62,15},{-62,23},{-67.7,23}},
                                                                                                    color={0,0,127}));
  connect(greater.y, notActive.u1) annotation (Line(points={{-47.5,33},{-44.8,33},{-44.8,26}}, color={255,0,255}));
  connect(less.y, notActive.u2) annotation (Line(points={{-47.5,19},{-47.5,20},{-44.8,20},{-44.8,22.8}},color={255,0,255}));
  connect(EmptyAndDischarging.y, nor.u2) annotation (Line(points={{5.65,-23},{5.65,-38},{-74,-38},{-74,-65},{-71,-65}}, color={255,0,255}));
  connect(logicalSwitch.u1, EmptyAndDischarging.y) annotation (Line(points={{-47,-53},{-47,-38},{5.65,-38},{5.65,-23}}, color={255,0,255}));
  connect(booleanExpression.y, logicalSwitch.u2) annotation (Line(points={{-53.2,-51},{-50,-51},{-50,-57},{-47,-57}},   color={255,0,255}));
  connect(greater.u1, P_is_external.y) annotation (Line(points={{-59,33},{-64,33},{-64,52},{68.8,52},{68.8,-13}}, color={0,0,127}));
  connect(P_is_external.y, less.u1) annotation (Line(points={{68.8,-13},{68.8,52},{-76,52},{-76,19},{-59,19}},
                                                                                                             color={0,0,127}));
  connect(notActive.y, active.u) annotation (Line(points={{-35.6,26},{-32.8,26}}, color={255,0,255}));
  connect(active.y, nor.u1) annotation (Line(points={{-23.6,26},{-22,26},{-22,12},{-78,12},{-78,-61},{-71,-61}},   color={255,0,255}));
  connect(logicalSwitch.y, stationaryLoss_internal.u2) annotation (Line(points={{-35.5,-57},{-31.6,-57}},                           color={255,0,255}));
  connect(nor.y, not1.u) annotation (Line(points={{-59.5,-61},{-56.6,-61}}, color={255,0,255}));
  connect(not1.y, logicalSwitch.u3) annotation (Line(points={{-49.7,-61},{-47,-61}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{88,-62},{96,-62},{96,-98},{-100,-98},{-100,-18},{-70,-18}},
          color={135,135,135},
          pattern=LinePattern.Dot,
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-58,-26},{-58,-26},{-58,-38},{-98,-38},{-98,-84},{-94,-84}},
          color={135,135,135},
          pattern=LinePattern.Dot,
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-42,-62},{-38,-62},{-38,-42},{-54,-42},{-54,-24}},
          color={135,135,135},
          pattern=LinePattern.Dot,
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled})}),     Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Base class for highly adaptable but non-physical model for all kinds of energy storages.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_set: input for electric power in [W] -Grid side setpoint power (Positive = load request, negative = unload request) [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_is: output for electric power in [W]- Grid side power (Positive = loading, negative = unloading) [W]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Boolean parameter use_PowerRateLimiter can deactive block &apos;PowerRateLimiter&apos;. This might lead to faster calculation results if power rate limitation is not needed.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">PlantDynamics: Set T_plant to 0 in StorageParameters to deactivate first order block</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Storage.Base.Check.TestGenericStorage&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model adapted by Lisa Andresen (andresen@tuhh.de), Jan 2017</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model adapted by Oliver Schülting (oliver.schuelting@tuhh.de), Jun 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Base class created by Carsten Bode (c.bode@tuhh.de), Nov 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model adapted by Oliver Schülting (oliver.schuelting@tuhh.de), April 2018: added first order plant dynamics block which can be deactivated</span></p>
</html>"));
end GenericStorage_base;
