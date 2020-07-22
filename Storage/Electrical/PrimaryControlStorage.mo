within TransiEnt.Storage.Electrical;
model PrimaryControlStorage "Battery model participating on primary control"
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

  extends Base.PartialElectricStorage;
  extends TransiEnt.Basics.Icons.StorageGenericElectric;
  extends TransiEnt.Producer.Electrical.Base.ControlPower.PartialBalancingPowerProvider(
    primaryBalancingController(final P_n=Storage.StorageModelParams.P_max_unload),
    final P_n=Storage.StorageModelParams.P_max_unload,
    redeclare final TransiEnt.Producer.Electrical.Base.ControlPower.PrimaryBalancingStorage controlPowerModel(
      final P_max_load=Storage.StorageModelParams.P_max_load,
      final P_max_unload=Storage.StorageModelParams.P_max_unload,
      final P_pr_max=primaryBalancingController.P_pr_max,
      final P_el_is=epp.P,
      final P_grad_max_star=Storage.StorageModelParams.P_grad_max,
      final is_running=true,
      final P_PB_set=primaryBalancingController.P_PBP_set,
      final P_SB_set=P_SB_set_internal,
      final P_n=Storage.StorageModelParams.P_max_unload),
    final t_SB_act=0,
    redeclare final TransiEnt.Components.Sensors.ElectricFrequency gridFrequencySensor(isDeltaMeasurement=true),
    final isPrimaryControlActive=true,
    final isSecondaryControlActive=false,
    final isExternalSecondaryController=true,
    final P_el_grad_max_SB=0,
    final typeOfBalancingPowerResource=TransiEnt.Basics.Types.TypeOfResource.Generic);

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

//   parameter Base.GenericStorageParameters StorageModelParams "Record of generic storage parameters" annotation(choicesAllMatching=true);
//   replaceable model StationaryLossModel = Base.NoStationaryLoss "Model for stationary energy losses" annotation(choicesAllMatching=true);
//   replaceable TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.CostVariables CostModel "Cost statistics model" annotation(choicesAllMatching=true);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

    replaceable Base.GenericElectricStorage Storage              annotation (choicesAllMatching=true, Placement(transformation(extent={{-22,-22},{22,20}})));

//   replaceable Base.GenericElectricStorage Storage(final StorageModelParams=StorageModelParams, redeclare model StationaryLossModel = StationaryLossModel,
//     final CostModel=CostModel)              annotation (choicesAllMatching=true, Placement(transformation(extent={{-22,-22},{22,20}})));

equation
  connect(epp, Storage.epp) annotation (Line(
      points={{100,0},{22,0},{22,-1}},
      color={0,135,135},
      thickness=0.5));
  connect(gridFrequencySensor.epp, epp) annotation (Line(
      points={{34,54},{100,54},{100,0}},
      color={0,135,135},
      thickness=0.5));
connect(primaryBalancingController.P_PBP_set, Storage.P_set) annotation (Line(points={{-28.6,54},{-60,54},{-60,30},{0,30},{0,18.74}},
                                                                                                                                    color={0,0,127}));
annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Battery model participating on primary control.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_SB_set: input for power in [W] - secondary balancing setpoint</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: active power port</span></p>
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
end PrimaryControlStorage;
