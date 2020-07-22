within TransiEnt.Storage.Electrical.Base;
model GenericElectricStorage "Generic storage model that can be used for most electric storage types in quasistationary power system simulations "

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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
  extends PartialElectricStorage;
  extends TransiEnt.Basics.Icons.StorageGenericElectric;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
  parameter Boolean calculateCost=simCenter.calculateCost "true if costs shall be calculated" annotation(Dialog(group="Statistics"));
  parameter SI.Voltage v_n=simCenter.v_n "Nominal voltage";
  parameter Real Nd_powerRateLimiter=1/simCenter.Td "The higher Nd, the closer y follows u in the power rate limiter";
  parameter Boolean use_PowerRateLimiter=true "Use Power Rate Limitation";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.ModelStatistics modelStatistics;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

 TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_set annotation (Placement(transformation(extent={{-116,24},{-92,48}}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={0,94})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (
    Dialog(group="Replaceable Components"),
    choices(
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary "P-Boundary for ActivePowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower powerBoundary(
          useInputConnectorP=true,
          useInputConnectorQ=false,
          useCosPhi=true,
          cosphi_boundary=1) "PQ-Boundary for ApparentPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "PQ-Boundary for ComplexPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.PowerVoltage powerBoundary(Use_input_connector_v=false, v_boundary=Storage.v_n) "PV-Boundary for ApparentPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PVBoundary powerBoundary(v_gen=Storage.v_n, useInputConnectorP=true) "PV-Boundary for ComplexPowerPort")),
    Placement(transformation(extent={{52,-10},{32,10}})));

  replaceable model StorageModel = TransiEnt.Storage.Base.GenericStorage constrainedby TransiEnt.Storage.Base.GenericStorage_base "Pick GenericStorage for a loss free storage and GenericStorageHyst for storage with losses" annotation(choicesAllMatching=true);
  parameter TransiEnt.Storage.Base.GenericStorageParameters StorageModelParams "Record of generic storage parameters" annotation (choicesAllMatching=true);
  replaceable model StationaryLossModel = TransiEnt.Storage.Base.NoStationaryLoss constrainedby TransiEnt.Storage.Base.PartialStationaryLoss "Model for stationary energy losses" annotation(choicesAllMatching=true);

  replaceable model CostModel = TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs constrainedby TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs "Cost statistics model" annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);

  StorageModel storageModel(final params=StorageModelParams, redeclare final model StationaryLossModel = StationaryLossModel, final Nd_powerRateLimiter=Nd_powerRateLimiter,
    use_PowerRateLimiter=use_PowerRateLimiter)                                                                                                                               annotation (choicesAllMatching=true, Placement(transformation(extent={{-50,13},{-2,61}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.StorageCost collectCosts(
    P_n=StorageModelParams.P_max_unload,
    redeclare model StorageCostModel = CostModel,
    Delta_E_n=StorageModelParams.E_max,
    P_el_is=storageModel.P_is,
    produces_Q_flow=false,
    consumes_Q_flow=false) if calculateCost    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Components.Statistics.Collectors.LocalCollectors.CollectElectricPower           collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Storage)
                                                                                                       annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
equation

 collectElectricPower.powerCollector.P=epp.P;
 if calculateCost then
    connect(modelStatistics.costsCollector, collectCosts.costsCollector);
  end if;
  connect(P_set, storageModel.P_set) annotation (Line(points={{-104,36},{-49.04,36},{-49.04,36.04}}, color={0,0,127}));
  connect(powerBoundary.epp, epp) annotation (Line(
      points={{52,0},{76,0},{76,0},{100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(storageModel.P_is, powerBoundary.P_el_set) annotation (Line(points={{-1.28,36.76},{-1.28,36.76},{48,36.76},{48,12}}, color={0,0,127}));
  connect(modelStatistics.powerCollector[TransiEnt.Basics.Types.TypeOfResource.Storage],collectElectricPower.powerCollector);

annotation(defaultComponentName="Storage", Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Generic storage model that can be used for most electric storage types in quasistationary power system simulations.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Type of electical power port can be chosen</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_set: input for electric power in [W]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">With the choice of the boundary the the model can be used as PQ or PU bus.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Storage.Electrical.Base.Check.TestGenericElectricStorage&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
</html>"));
end GenericElectricStorage;
