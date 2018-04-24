within TransiEnt.Storage.Base;
model GenericStorage "Highly adaptable but non-physical model for all kinds of energy storages"

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
  parameter SI.Time Td_GradientLimiter=simCenter.Td "Time step of derivative calculation"
                                             annotation(Dialog(tab="Expert Settings"));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  // ------- State variables -----------

  Modelica.SIunits.Energy E(start=params.E_start, fixed=true,
      stateSelect=StateSelect.prefer);

  // ------- Diagnostic variables -----------

  Real SOC = (E-params.E_min)/(params.E_max-params.E_min);
  Modelica.SIunits.Energy E_delta = E - params.E_start "State of charge (0..1)";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput P_set "Grid side setpoint power (Positive = load request, negative = unload request)"
                                                                                                  annotation (Placement(transformation(extent={{-116,-24},{-76,16}}), iconTransformation(extent={{-116,-24},{-76,16}})));

  Modelica.Blocks.Interfaces.RealOutput P_is "Grid side power (Positive = loading, negative = unloading)"
                                                                                        annotation (Placement(transformation(extent={{86,-20},{126,20}}), iconTransformation(extent={{88,-16},{118,14}})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable model StationaryLossModel =
      NoStationaryLoss constrainedby TransiEnt.Storage.Base.PartialStationaryLoss(final params=params)
                                                                                                     annotation(choicesAllMatching=true, Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Stationary model for system losses.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));

  StationaryLossModel stationaryLoss annotation (Placement(transformation(extent={{-72,-74},{-50,-52}})));

  Modelica.Blocks.Sources.RealExpression E_is(y=E) "Internal energy level before stationary loss (energy level directly after load or unloading)" annotation (Placement(transformation(extent={{-67,-28},{-47,-8}})));
ClaRa.Components.Utilities.Blocks.VariableGradientLimiter
    PowerRateLimit(
    constantLimits=true,
    Nd=1/simCenter.Td,
    useThresh=simCenter.useThresh,
    thres=simCenter.thres,
    maxGrad_const=params.P_grad_max,
    minGrad_const=-params.P_grad_max)
    annotation (Placement(transformation(extent={{-28,42},{-8,62}})));
  Modelica.Blocks.Nonlinear.VariableLimiter
                                    PowerLimit(
    strict=true)
    annotation (Placement(transformation(extent={{-68,42},{-48,62}})));

  Modelica.Blocks.Logical.GreaterEqualThreshold
                                           isStorageFull(threshold=params.E_max)
                                                                          annotation (Placement(transformation(extent={{-32,-14},{-19,0}})));
  Modelica.Blocks.Logical.LessEqualThreshold isStorageEmpty(threshold=params.E_min)
                                                                               annotation (Placement(transformation(extent={{-33,-35},{-20,-22}})));
  Modelica.Blocks.Logical.Nor CapacityOk annotation (Placement(transformation(extent={{15,-20},{28,-6}})));
  Modelica.Blocks.Sources.Constant CapacityLimit(k=0) annotation (Placement(transformation(extent={{24,-47},{37,-35}})));
  Modelica.Blocks.Logical.Switch P_is_external annotation (Placement(transformation(extent={{54,-21},{70,-5}})));
  Modelica.Blocks.Logical.And EmptyAndDischarging
    annotation (Placement(transformation(extent={{-8,-30},{5,-16}})));
  Modelica.Blocks.Logical.And FullAndCharging
    annotation (Placement(transformation(extent={{-5,-8},{8,6}})));
  Modelica.Blocks.Logical.LessEqualThreshold DischargeDemand
    annotation (Placement(transformation(extent={{-31,21},{-20,33}})));
  Modelica.Blocks.Logical.Not ChargeDemand
    annotation (Placement(transformation(extent={{7,11},{-5,23}})));

  Modelica.Blocks.Math.Product P_is_internal "Internal power that defines state of charge, i.e. after conversion losses (Losses while loading / unloading)"
                                                                                annotation (Placement(transformation(extent={{76,-76},{90,-62}})));
  Modelica.Blocks.Logical.Switch conversionEfficiency
                                               annotation (Placement(transformation(extent={{38,-81},{54,-65}})));
  Modelica.Blocks.Sources.RealExpression
                                   loadingEfficiency(y=params.eta_load)
                                                             annotation (Placement(transformation(extent={{10,-91},{23,-79}})));
  Modelica.Blocks.Sources.RealExpression eta_unload(y=1/params.eta_unload) annotation (Placement(transformation(extent={{9,-67},{22,-55}})));
  Modelica.Blocks.Sources.RealExpression P_max_load(y=params.P_max_load) annotation (Placement(transformation(extent={{-95,55},{-82,67}})));
  Modelica.Blocks.Sources.RealExpression P_max_unload_neg(y=-params.P_max_unload) annotation (Placement(transformation(extent={{-95,39},{-82,51}})));
  Modelica.Blocks.Logical.Switch stationaryLoss_internal annotation (Placement(transformation(extent={{-34,-65},{-18,-49}})));
  Modelica.Blocks.Sources.Constant CapacityLimit1(k=0)
                                                      annotation (Placement(transformation(extent={{-50,-39},{-44,-32}})));
equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  der(E) = P_is_internal.y - stationaryLoss.P_statloss;
  //der(E) = P_is_internal.y - stationaryLoss_internal.y;
  stationaryLoss.E_is = E;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(CapacityLimit.y, P_is_external.u3) annotation (Line(
      points={{37.65,-41},{48,-41},{48,-20},{50,-20},{50,-19.4},{52.4,-19.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FullAndCharging.y,CapacityOk. u1) annotation (Line(
      points={{8.65,-1},{10,-1},{10,-4},{10,-13},{12,-13},{13.7,-13}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(isStorageEmpty.y,EmptyAndDischarging. u2) annotation (Line(
      points={{-19.35,-28.5},{-15.625,-28.5},{-15.625,-28.6},{-9.3,-28.6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(EmptyAndDischarging.y,CapacityOk. u2) annotation (Line(
      points={{5.65,-23},{10,-23},{10,-19},{13.7,-19},{13.7,-18.6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(isStorageFull.y, FullAndCharging.u2) annotation (Line(points={{-18.35,-7},{-12.175,-7},{-12.175,-6.6},{-6.3,-6.6}}, color={255,0,255}));
  connect(conversionEfficiency.y, P_is_internal.u2) annotation (Line(points={{54.8,-73},{64,-73},{64,-73.2},{74.6,-73.2}}, color={0,0,127}));
  connect(loadingEfficiency.y, conversionEfficiency.u3) annotation (Line(points={{23.65,-85},{28,-85},{28,-79.4},{36.4,-79.4}}, color={0,0,127}));
  connect(eta_unload.y, conversionEfficiency.u1) annotation (Line(points={{22.65,-61},{28,-61},{28,-66},{32,-66},{32,-66.6},{36.4,-66.6}}, color={0,0,127}));
  connect(P_is_external.y, P_is) annotation (Line(points={{70.8,-13},{74,-13},{74,0},{106,0}},     color={0,0,127}));
  connect(P_is_external.y, P_is_internal.u1) annotation (Line(points={{70.8,-13},{74,-13},{74,-34},{64,-34},{64,-64.8},{74.6,-64.8}},
                                                                                                                    color={0,0,127}));
  connect(E_is.y, isStorageFull.u) annotation (Line(points={{-46,-18},{-42,-18},{-42,-7},{-33.3,-7}}, color={0,0,127}));
  connect(E_is.y, isStorageEmpty.u) annotation (Line(points={{-46,-18},{-42,-18},{-42,-28.5},{-34.3,-28.5}}, color={0,0,127}));
  connect(PowerLimit.y, PowerRateLimit.u) annotation (Line(points={{-47,52},{-38.5,52},{-30,52}}, color={0,0,127}));
  connect(PowerLimit.u, P_set) annotation (Line(points={{-70,52},{-78,52},{-78,-4},{-96,-4}},          color={0,0,127}));
  connect(DischargeDemand.y, ChargeDemand.u) annotation (Line(points={{-19.45,27},{-12,27},{12,27},{12,17},{8.2,17}}, color={255,0,255}));
  connect(DischargeDemand.y, EmptyAndDischarging.u1) annotation (Line(points={{-19.45,27},{-14,27},{-14,-23},{-9.3,-23}}, color={255,0,255}));
  connect(DischargeDemand.y, conversionEfficiency.u2) annotation (Line(points={{-19.45,27},{-14,27},{-14,-73},{36.4,-73}}, color={255,0,255}));
  connect(ChargeDemand.y, FullAndCharging.u1) annotation (Line(points={{-5.6,17},{-12,17},{-12,-1},{-6.3,-1}}, color={255,0,255}));
  connect(CapacityOk.y, P_is_external.u2) annotation (Line(points={{28.65,-13},{52.4,-13},{52.4,-13}}, color={255,0,255}));
  connect(P_max_load.y, PowerLimit.limit1) annotation (Line(points={{-81.35,61},{-70,61},{-70,60}}, color={0,0,127}));
  connect(P_max_unload_neg.y, PowerLimit.limit2) annotation (Line(points={{-81.35,45},{-70,45},{-70,44}}, color={0,0,127}));
  connect(DischargeDemand.u, PowerRateLimit.y) annotation (Line(points={{-32.1,27},{-36,27},{-36,36},{-4,36},{-4,52},{-7,52}}, color={0,0,127}));
  connect(PowerRateLimit.y, P_is_external.u1) annotation (Line(points={{-7,52},{36,52},{36,-6.6},{52.4,-6.6}}, color={0,0,127}));
  connect(EmptyAndDischarging.y, stationaryLoss_internal.u2) annotation (Line(points={{5.65,-23},{10,-23},{10,-44},{-40,-44},{-40,-57},{-35.6,-57}}, color={255,0,255}));
  connect(stationaryLoss.P_statloss, stationaryLoss_internal.u3) annotation (Line(points={{-49.34,-63},{-40,-63},{-40,-63.4},{-35.6,-63.4}}, color={0,0,127}));
  connect(stationaryLoss_internal.u1, CapacityLimit1.y) annotation (Line(points={{-35.6,-50.6},{-38,-50.6},{-38,-50},{-42,-50},{-42,-36},{-43.7,-36},{-43.7,-35.5}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{88,-68},{96,-68},{96,-96},{-88,-96},{-88,-16},{-70,-16}},
          color={135,135,135},
          pattern=LinePattern.Dot,
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-58,-24},{-58,-26},{-58,-38},{-80,-38},{-80,-62},{-74,-62}},
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
<p>Highly&nbsp;adaptable&nbsp;but&nbsp;non-physical&nbsp;model&nbsp;for&nbsp;all&nbsp;kinds&nbsp;of&nbsp;energy&nbsp;storages.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model adapted by Lisa Andresen (andresen@tuhh.de), Jan 2017</span></p>
</html>"));
end GenericStorage;
