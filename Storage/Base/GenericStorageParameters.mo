within TransiEnt.Storage.Base;
record GenericStorageParameters


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





extends TransiEnt.Basics.Icons.Record;

  parameter SI.Energy E_start=0 "Start value of energy" annotation(Dialog(group="Capacity"));
  parameter SI.Energy E_max=0 "Maximum storable energy" annotation(Dialog(group="Capacity"));
  parameter SI.Energy E_min=0 "Minimum storable energy" annotation(Dialog(group="Capacity"));

  parameter SI.Power P_max_unload=0 "Maximum power output while unloading" annotation(Dialog(group="Power"));
  parameter SI.Power P_max_load=P_max_unload "Maximum power output while loading" annotation(Dialog(group="Power"));

  parameter TransiEnt.Basics.Units.PowerRate P_grad_max=0 "Maximum power gradient" annotation (Dialog(group="Dynamic"));

  parameter Real eta_unload=1 "Conversion efficiency while unloading" annotation(Dialog(group="Efficiency"));
  parameter Real eta_load=1 "Conversion efficiency while loading" annotation(Dialog(group="Efficiency"));
  parameter SI.Frequency selfDischargeRate=0 "E.g. 0.5/3600 = 50% discharge per hour, used if no detailed staionary loss model is available" annotation(Dialog(group="Efficiency"));

  parameter Real P_max_load_over_SOC[:,:]=[0,1;1,1] "maximum possible relative load power over SOC";
  parameter Real P_max_unload_over_SOC[:,:]=[0,1;1,1] "maximum possible relative unload power over SOC";
  parameter Real a=0 "Approximation parameter for part load efficiency calculation";
  parameter Real b=1 "Approximation parameter for part load efficiency calculation";
  parameter Real c=1 "Approximation parameter for part load efficiency calculation";
  parameter Real d=1 "Approximation parameter for part load efficiency calculation";
  parameter SI.Time T_plant=0 "first order plant dynamic";


  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Generic parameters for storage models.</span></p>
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
end GenericStorageParameters;
