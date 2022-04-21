within TransiEnt.Storage.Electrical;
model PumpedStorage_Generator "Model of a pumped storage"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  extends TransiEnt.Storage.Electrical.Base.GenericElectricStorage_Generator(
    StorageModelParams=TransiEnt.Storage.Electrical.Specifications.PumpedStorage(T_plant=10),
    redeclare model StationaryLossModel = TransiEnt.Storage.Base.NoStationaryLoss,
    replaceable model CostModel = TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PumpStorage,
    storageModel(use_PowerRateLimiter=use_PowerRateLimiter, use_plantDynamic=true),
    prescribedPower(change_sign=false));
    //collectCosts(redeclare model StorageCostModel = CostVariables),
  extends TransiEnt.Basics.Icons.Hydroturbine;
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

   parameter Boolean use_PowerRateLimiter=true "Use Power Rate Limitation";

  //replaceable model CostVariables = TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PumpStorage  constrainedby TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs "Define storage type for cost calcualtions"
  //                                                                                                                                                                                                annotation (choicesAllMatching=true, Dialog(group="Statistics"));
equation
  connect(P_set, storageModel.P_set) annotation (Line(points={{-104,36},{-76,36},{-76,36.04},{-49.04,36.04}}, color={0,127,127}));
  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a pumped storage with generator.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>P_set: input for electric power in [W]</p>
<p>epp: choice of power port</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model extended by Anne Senkel (anne.senkel@tuhh.de), March 2020</span></p>
</html>"));
end PumpedStorage_Generator;
