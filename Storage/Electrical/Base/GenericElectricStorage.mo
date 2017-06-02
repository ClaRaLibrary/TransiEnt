within TransiEnt.Storage.Electrical.Base;
model GenericElectricStorage "Generic storage model that can be used for most electric storage types in quasistationary power system simulations "

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
  extends PartialElectricStorage;
  extends TransiEnt.Basics.Icons.StorageGenericElectric;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput P_set annotation (Placement(transformation(extent={{-116,24},{-92,48}}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={0,94})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Storage.Base.GenericStorage storageModel(final params=StorageModelParams, redeclare final model StationaryLossModel = StationaryLossModel) annotation (choicesAllMatching=true, Placement(transformation(extent={{-50,13},{-2,61}})));
  parameter TransiEnt.Storage.Base.GenericStorageParameters StorageModelParams "Record of generic storage parameters" annotation (choicesAllMatching=true);
  replaceable model StationaryLossModel = TransiEnt.Storage.Base.NoStationaryLoss
                                                           constrainedby TransiEnt.Storage.Base.PartialStationaryLoss(
                                                                                               params=StorageParams) "Model for stationary energy losses" annotation(choicesAllMatching=true, Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Stationary loss model for electric storage.</span></p>
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

  replaceable TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs CostModel constrainedby TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs "Cost statistics model" annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);
  TransiEnt.Components.Boundaries.Electrical.Power terminal annotation (Placement(transformation(extent={{52,-10},{32,10}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.StorageCost collectCosts(
    P_n=StorageModelParams.P_max_unload,
    redeclare model StorageCostModel = TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.ElectricStorageGeneral,
    Delta_E_n=StorageModelParams.E_max,
    P_el_is=storageModel.P_is) annotation (Placement(transformation(extent={{72,-100},{100,-74}})));
equation

  connect(modelStatistics.costsCollector, collectCosts.costsCollector);
  connect(P_set, storageModel.P_set) annotation (Line(points={{-104,36},{-49.04,36},{-49.04,36.04}}, color={0,0,127}));
  connect(terminal.epp, epp) annotation (Line(
      points={{52.1,-0.1},{76,-0.1},{76,0},{100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(storageModel.P_is, terminal.P_el_set) annotation (Line(points={{-1.28,36.76},{-1.28,36.76},{48,36.76},{48,12}}, color={0,0,127}));
annotation(defaultComponentName="Storage", Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Generic&nbsp;storage&nbsp;model&nbsp;that&nbsp;can&nbsp;be&nbsp;used&nbsp;for&nbsp;most&nbsp;electric&nbsp;storage&nbsp;types&nbsp;in&nbsp;quasistationary&nbsp;power&nbsp;system&nbsp;simulations.</p>
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
end GenericElectricStorage;
