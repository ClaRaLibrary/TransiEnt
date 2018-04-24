within TransiEnt.Producer.Electrical.Base.ControlPower;
partial model PartialBalancingPowerProvider "Abstract model of any kind of electric balancing power provider with statistics and control input"

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

extends TransiEnt.Basics.Icons.PartialModel;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Power P_nom=300e6 "Nominal power of plant"     annotation (Dialog(group="Physical Constraints"), HideResult=false,
    Placement(transformation(extent=100)));

  parameter Boolean isPrimaryControlActive = true annotation ( choices(__Dymola_checkBox=true), Dialog(group="Frequency Control", tab="Block control"));

  parameter Boolean isSecondaryControlActive = false annotation ( choices(__Dymola_checkBox=true), Dialog(group="Frequency Control", tab="Block control"));

  parameter Boolean isExternalSecondaryController=true "False, provider generates its own control setpoint (only for lumped plants)"
                                                                                                  annotation ( choices(__Dymola_checkBox=true), Dialog(enable=isSecondaryControlActive, group="Frequency Control", tab="Block control"));

  parameter SI.Time t_SB_act=simCenter.t_SB_act "Maximum reaction time for SB" annotation (Dialog(enable=isSecondaryControlActive, group="Frequency Control", tab="Block control"));

  parameter Modelica.SIunits.Power P_el_grad_max_SB=0.02*P_nom/60 "Maximum power gradient for secondary balancing (default: 2%/min)"     annotation (Dialog(enable=isSecondaryControlActive, group="Frequency Control", tab="Block control"), HideResult=false,
    Placement(transformation(extent=100)));

  parameter EnergyResource typeOfBalancingPowerResource=EnergyResource.Conventional "Type of energy resource for global model statistics"  annotation (Dialog(group="Statistics"), HideResult = not simCenter.isExpertMode,
    Placement(transformation(extent=100)));

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

Modelica.Blocks.Interfaces.RealInput P_SB_set if isSecondaryControlActive and isExternalSecondaryController "Secondary balancing setpoint"
                                                                                                  annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-166,60}), iconTransformation(
      extent={{-11,-11},{11,11}},
      rotation=270,
      origin={-89,89})));

protected
  Modelica.Blocks.Interfaces.RealInput P_SB_set_internal "Needed to connect to conditional connector for active power";

// _____________________________________________
//
//                Complex Components
// _____________________________________________

  // *** Statistic adapters ***
public
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower generatedSBP annotation (Placement(transformation(extent={{-34,-100},{-14,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectSBPOffer[2] annotation (Placement(transformation(extent={{-12,-100},{8,-80}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower generatedPBP annotation (Placement(transformation(extent={{-78,-100},{-58,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectPBPOffer[2] annotation (Placement(transformation(extent={{-56,-100},{-36,-80}})));

  // *** Component models ***
  replaceable TransiEnt.Producer.Electrical.Controllers.PrimaryBalancingController primaryBalancingController(
    Td_GradientLimiter=simCenter.Td,
    useThresh=simCenter.useThresh,
    thres=simCenter.thres,
    k_part=if isPrimaryControlActive then 1 else 0,
    P_nom=P_nom) constrainedby TransiEnt.Producer.Electrical.Controllers.Base.PartialPrimaryBalancingController annotation (
    Dialog(
      enable=isPrimaryControlActive,
      group="Frequency Control",
      tab="Block control"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-8,44},{-28,64}})));

  replaceable TransiEnt.Components.Sensors.MechanicalFrequency gridFrequencySensor(final isDeltaMeasurement=true) constrainedby TransiEnt.Components.Sensors.PartialFrequency annotation (
    Dialog(
      enable=isPrimaryControlActive or isSecondaryControlActive,
      group="Frequency Control",
      tab="Block control"),
    choicesAllMatching=true,
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={24,54})));

  replaceable TransiEnt.Producer.Electrical.Base.ControlPower.IdealControlOffer controlPowerModel(P_SB_set=P_SB_set_internal) constrainedby TransiEnt.Producer.Electrical.Base.ControlPower.PartialBalancingPowerPotential annotation (choicesAllMatching=true, Dialog(
      enable=isPrimaryControlActive or isSecondaryControlActive,
      tab="Block control",
      group="Frequency Control"));
// _____________________________________________
//
//           Variables
// _____________________________________________

  Real P_SB_set_star = P_SB_set_internal/P_nom;
equation
// _____________________________________________
//
//           Characteristic equations
// _____________________________________________

  // *** Primary Balancing Power ***
  generatedPBP.powerCollector.P = controlPowerModel.P_pr_provided;
  collectPBPOffer[1].powerCollector.P = controlPowerModel.P_pr_pos_offer;
  collectPBPOffer[2].powerCollector.P = controlPowerModel.P_pr_neg_offer;

  // *** Secondary Balancing Power ***
  generatedSBP.powerCollector.P = controlPowerModel.P_sec_provided;
  collectSBPOffer[1].powerCollector.P = controlPowerModel.P_sec_pos_offer;
  collectSBPOffer[2].powerCollector.P = controlPowerModel.P_sec_neg_offer;

  if not isExternalSecondaryController or not isSecondaryControlActive then
    P_SB_set_internal = 0; // TODO: Do we nee dthis?
  end if;

// _____________________________________________
//
//               Connect Statements
// _____________________________________________

  // ** Primary Balancing Power ***
  connect(gridFrequencySensor.f, primaryBalancingController.delta_f) annotation (Line(
      points={{13.6,54},{-7,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modelStatistics.primBalPowerCollector[typeOfBalancingPowerResource],generatedPBP.powerCollector);
  connect(modelStatistics.primBalPowerOfferCollector, collectPBPOffer.powerCollector);

  // *** Secondary Balancing Power ***
  connect(P_SB_set_internal, P_SB_set);
  connect(modelStatistics.secBalPowerCollector[typeOfBalancingPowerResource],generatedSBP.powerCollector);
  connect(modelStatistics.secBalPowerOfferCollector, collectSBPOffer.powerCollector);

annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                            Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Prototype model for electric power plants models with primary and secondary control containting all relevant statistics blocks.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end PartialBalancingPowerProvider;
