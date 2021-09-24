within TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems.Base;
partial model Systems


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
extends Basics.Icons.Model;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter Boolean el_grid annotation(HideResult=true);
  parameter Boolean gas_grid annotation(HideResult=true);
  parameter Boolean DHN annotation(HideResult=true);

protected
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 if DHN "Heat carrier medium for district heat, if applicable"
                         annotation(choicesAllMatching, Dialog(group="Fluid Definition"));

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium1= simCenter.gasModel1 "Medium to be used for fuel gas, if applicable"
             annotation(choicesAllMatching, Dialog(group="Fluid Definition"));

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

public
  TransiEnt.Basics.Interfaces.Combined.HouseholdDemandIn demand "Electricity, space heating, water heating" annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={0,100})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=medium) if  DHN annotation (Placement(transformation(extent={{-30,-108},{-10,-88}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=medium) if  DHN annotation (Placement(transformation(extent={{10,-108},{30,-88}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort    epp if      el_grid annotation (Placement(transformation(extent={{-90,-108},{-70,-88}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium1) if  gas_grid annotation (Placement(transformation(extent={{70,-106},{90,-86}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Base model for replaceable energy systems for household consumers.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>TransiEnt.Basics.Interfaces.Combined.HouseholdDemandIn <b>demand</b></p>
<p><i>Conditional interfaces depending on the technologies selected:</i></p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort <b>epp - connection to electrical grid</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortIn <b>waterPortIn</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortOut <b>waterPortOut - connection to district heating grid</b></p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn <b>gasPortIn - connection to gas grid</b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end Systems;
