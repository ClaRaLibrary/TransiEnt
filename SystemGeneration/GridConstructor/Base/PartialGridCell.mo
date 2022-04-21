within TransiEnt.SystemGeneration.GridConstructor.Base;
partial model PartialGridCell


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





  // Base class for Basic_Grid_Element and Grid_Constructor model
  // Declaration of conditional inlet and outlet connectors for gas, electricity and district heating

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //            Parameters
  // _____________________________________________

  // Boolean parameters for activation and deactivation of inlet and outlet connectors

  parameter Boolean gas_in=true "Activate/Deactivate inlet gas connector" annotation (
    Dialog(group="Connectors"),
    choices(__Dymola_checkBox=true),
    HideResult=true);

  parameter Boolean gas_out=true "Activate/Deactivate outlet gas connector" annotation (
    Dialog(group="Connectors"),
    enable=gas_in,
    choices(__Dymola_checkBox=true),
    HideResult=true);

  parameter Boolean el_in=true "Activate/Deactivate inlet electric connector" annotation (
    Dialog(group="Connectors"),
    choices(__Dymola_checkBox=true),
    HideResult=true);

  parameter Boolean el_out=true "Activate/Deactivate outlet electric connector" annotation (
    Dialog(group="Connectors"),
    enable=el_in,
    choices(__Dymola_checkBox=true),
    HideResult=true);
  parameter Boolean dhn_in_s=false "Activate/Deactivate inlet dhn connector for supply line" annotation (
    Dialog(group="Connectors"),
    choices(__Dymola_checkBox=true),
    HideResult=true);

  parameter Boolean dhn_out_s=false "Activate/Deactivate outlet dhn connector for supply line" annotation (
    Dialog(group="Connectors"),
    choices(__Dymola_checkBox=true),
    HideResult=true);

  parameter Boolean dhn_in_r=false "Activate/Deactivate inlet dhn connector for return line" annotation (
    Dialog(group="Connectors"),
    choices(__Dymola_checkBox=true),
    HideResult=true);

  parameter Boolean dhn_out_r=false "Activate/Deactivate outlet dhn connector for return line" annotation (
    Dialog(group="Connectors"),
    choices(__Dymola_checkBox=true),
    HideResult=true);

  // _____________________________________________
  //
  //            Interfaces
  // _____________________________________________
  // Declaration of conditional connectors by using boolean parameters above

  // Deactivate inlet gas connector if gas_in = false
public
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=simCenter.gasModel1) if gas_in annotation (Placement(transformation(extent={{-190,50},{-170,70}}), iconTransformation(extent={{-190,50},{-170,70}})));

  // Deactivate outlet gas connector if gas_out = false or gas_in = false (if inlet connector is deactivated outlet connector is not needed as well)
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=simCenter.gasModel1) if gas_out and gas_in annotation (Placement(transformation(extent={{110,50},{130,70}}), iconTransformation(extent={{110,50},{130,70}})));

  // Deactivate inlet electric connector if el_in = false
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp_p if el_in annotation (Placement(transformation(extent={{-190,-70},{-170,-50}}), iconTransformation(extent={{-190,-70},{-170,-50}})));

  // Deactivate outlet electric connector if el_out = false or el_in = false (if inlet connector is deactivated outlet connector is not needed as well)
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp_n if el_out and el_in annotation (Placement(transformation(extent={{110,-70},{130,-50}}), iconTransformation(extent={{110,-70},{130,-50}})));

  // Deactivated fluid connectors

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_supply(Medium=simCenter.fluid1) if dhn_in_s "Inlet port" annotation (Placement(transformation(extent={{-190,10},{-170,30}}), iconTransformation(extent={{-190,10},{-170,30}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_supply(Medium=simCenter.fluid1) if dhn_out_s "Outlet port" annotation (Placement(transformation(extent={{110,8},{130,28}}), iconTransformation(extent={{110,8},{130,28}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_return(Medium=simCenter.fluid1) if dhn_out_r "Outlet port" annotation (Placement(transformation(extent={{-190,-30},{-170,-10}}), iconTransformation(extent={{-190,-30},{-170,-10}})));

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_return(Medium=simCenter.fluid1) if dhn_in_r "Inlet port" annotation (Placement(transformation(extent={{110,-30},{130,-10}}), iconTransformation(extent={{110,-30},{130,-10}})));

  annotation (
    Diagram(coordinateSystem(extent={{-180,-120},{120,120}})),
    Icon(coordinateSystem(extent={{-180,-120},{120,120}}), graphics={Line(points={{-116,72}}, color={28,108,200}), Rectangle(
          extent={{-180,-120},{120,120}},
          lineColor={28,108,200},
          lineThickness=0.5)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Base Class with connectors for Basic_Grid_Element and Grid_Constructor </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created during IntegraNet I </span></p>
</html>"));

end PartialGridCell;
