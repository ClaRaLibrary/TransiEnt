within TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply;
model LocalHeatingDemand_HeatStorage


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

  import TransiEnt;
  import Const = Modelica.Constants;
  extends TransiEnt.Basics.Icons.ThermalStorageBasic;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Heat Q_annual_solarthermal;
  parameter SI.Heat Q_max_storage;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput Q_flow_set annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_solarthermal_pu annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_set_residual annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Math.Add add(k1=-1, k2=-1) annotation (Placement(transformation(extent={{-54,-4},{-34,16}})));
  Modelica.Blocks.Math.Gain gain(k=Q_annual_solarthermal/(512.56e3*3600)) annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=1e99, uMin=1e3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,0})));
  TransiEnt.Storage.Base.GenericStorageHyst genericStorage(
    params=TransiEnt.Storage.Base.GenericStorageParameters(
              E_max=Q_max_storage,
              P_max_unload=Q_annual_solarthermal/0.2/31536000,
              selfDischargeRate=0.003187/3600),
    use_PowerRateLimiter=false,
    redeclare model StationaryLossModel = TransiEnt.Storage.Base.SelfDischargeRateRelative,
    P_max_load(y=batteryPowerLimit.P_max_load_star*genericStorage.params.P_max_load),
    P_max_unload_neg(y=-batteryPowerLimit.P_max_unload_star*genericStorage.params.P_max_unload)) annotation (Placement(transformation(extent={{-8,-16},{12,4}})));
  Modelica.Blocks.Math.Add add1(k1=-1, k2=+1) annotation (Placement(transformation(extent={{24,-10},{44,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  TransiEnt.Storage.Electrical.Base.BatteryPowerLimit batteryPowerLimit annotation (Placement(transformation(extent={{-4,16},{16,36}})));
  Modelica.Blocks.Sources.RealExpression SOC(y=genericStorage.SOC) annotation (Placement(transformation(extent={{-36,16},{-12,36}})));
  Modelica.Blocks.Sources.RealExpression SOC1(y=0) annotation (Placement(transformation(extent={{-10,-44},{14,-24}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(gain.y, add.u2) annotation (Line(points={{-59,-40},{-56,-40},{-56,0}}, color={0,0,127}));
  connect(add.y, genericStorage.P_set) annotation (Line(points={{-33,6},{-20,6},{-20,-6},{-14,-6},{-14,-6.4},{-7.6,-6.4}}, color={0,0,127}));
  connect(add.y, add1.u1) annotation (Line(points={{-33,6},{22,6}}, color={0,0,127}));
  connect(add1.y, limiter.u) annotation (Line(points={{45,0},{58,0}}, color={0,0,127}));
  connect(Q_flow_solarthermal_pu, gain.u) annotation (Line(points={{-120,-40},{-82,-40}}, color={0,0,127}));
  connect(Q_flow_set, add.u1) annotation (Line(points={{-120,40},{-56,40},{-56,12}}, color={0,0,127}));
  connect(limiter.y, Q_flow_set_residual) annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(SOC.y, batteryPowerLimit.SOC) annotation (Line(points={{-10.8,26},{-4.4,26}}, color={0,0,127}));
  connect(genericStorage.P_is, add1.u2) annotation (Line(
      points={{12.3,-6.1},{17.15,-6.1},{17.15,-6},{22,-6}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=864000, Interval=10),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of generic heat storage to be used with models from the LocalHeatSupply package.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
</html>"));
end LocalHeatingDemand_HeatStorage;
