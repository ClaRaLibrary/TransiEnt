within TransiEnt.Storage.Electrical.Base;
model GenericElectricStorage_Generator "Generic storage model that can be used for most electric storage types in quasistationary power system simulations"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
  extends TransiEnt.Storage.Electrical.Base.PartialElectricStorage;
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

  replaceable model StorageModel = TransiEnt.Storage.Base.GenericStorageHyst constrainedby TransiEnt.Storage.Base.GenericStorage_base
                                                                                          "Pick GenericStorage for a loss free storage and GenericStorageHyst for storage with losses" annotation(choicesAllMatching=true);
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
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Storage) annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
public
replaceable TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=1) constrainedby TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-18.5,-18},{18.5,18}},
        rotation=0,
        origin={55.5,-41})));
  TransiEnt.Components.Boundaries.Mechanical.Power prescribedPower(change_sign=true)   annotation (Placement(transformation(extent={{-38,-52},{-24,-38}})));
replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter constrainedby TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.PartialExcitationSystem  "Choice of excitation system model with voltage control" annotation (
    Dialog(group="Replaceable Components"),
    choicesAllMatching=true,
    Placement(transformation(
        extent={{-4,-4.5},{4,4.5}},
        rotation=-90,
        origin={56.5,34})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia      annotation (Placement(transformation(extent={{-14,-56},{6,-36}})));
  parameter SI.Inertia J "Moment of inertia";
equation

 collectElectricPower.powerCollector.P=epp.P;
 if calculateCost then
    connect(modelStatistics.costsCollector, collectCosts.costsCollector);
  end if;
  connect(modelStatistics.powerCollector[TransiEnt.Basics.Types.TypeOfResource.Storage],collectElectricPower.powerCollector);

  connect(Generator.epp, epp) annotation (Line(
      points={{74.185,-41.18},{100,-41.18},{100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(storageModel.P_is, prescribedPower.P_mech_set) annotation (Line(
      points={{-1.28,36.76},{-1.28,-32},{-31,-32},{-31,-36.74}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(Generator.E_input, Exciter.y) annotation (Line(points={{54.945,-23.18},{56,-23.18},{56,29.76},{56.5,29.76}}, color={0,0,127}));
  connect(epp, Exciter.epp1) annotation (Line(
      points={{100,0},{100,38},{56.5,38}},
      color={0,135,135},
      thickness=0.5));
  connect(prescribedPower.mpp, constantInertia.mpp_a) annotation (Line(points={{-24,-45},{-19,-45},{-19,-46},{-14,-46}}, color={95,95,95}));
  connect(constantInertia.mpp_b, Generator.mpp) annotation (Line(points={{6,-46},{12,-45},{12,-41},{37,-41}}, color={95,95,95}));
  connect(P_set, storageModel.P_set) annotation (Line(points={{-104,36},{-76,36},{-76,36.04},{-49.04,36.04}}, color={0,127,127}));
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
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model extended by a generator by Anne Senkel (anne.senkel@tuhh.de) in March 2020</span></p>
</html>"));
end GenericElectricStorage_Generator;
