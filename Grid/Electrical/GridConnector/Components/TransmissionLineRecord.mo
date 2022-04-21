within TransiEnt.Grid.Electrical.GridConnector.Components;
record TransmissionLineRecord "Define Transmission Line
  from: number of starting node (purely informational value)
  to: number of ending node (purely informational value)
  ChooseVoltageLevel: defines which cable type is used: LV, MV, HV or Custom Data(r,x,c,ir_custom)
  p: Number of parallel lines
  l: cable length in m
  LVCableType: Cable type choice if ChooseVoltageLevel==1
  MVCableType: Cable type choice if ChooseVoltageLevel==2
  HVCableType: Cable type choice if ChooseVoltageLevel==3
  r,x,c,i_r_custom: Cable data if ChooseVoltageLevel==4
  hasTransformer: adds transformers at each end of line
  voltageLevel: set voltage level of transmission line if hasTransformer=true"



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
  //              Visible Parameters
  // _____________________________________________

   parameter Integer from=1 "from number of superstructure - purely informational";
   parameter Integer to=1 "to number of superstructure - purely informational";
   parameter Integer ChooseVoltageLevel=3 "Choose Voltage Level" annotation(choices(__Dymola_radioButtons=true, choice=1 "Low Voltage", choice=2 "Medium Voltage", choice=3 "High Voltage", choice=4 "Custom Data"));
   parameter Real p = 1 "Number of parallel lines";
   parameter Modelica.Units.SI.Length l = 1000*20 "Cable Length in m";
   parameter TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1 "Type of low voltage cable" annotation (
     Evaluate=true,
     HideResult=true,
     Dialog(enable = if ChooseVoltageLevel==1 then true else false));
   parameter TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1 "Type of Medium voltage cable" annotation (
     Evaluate=true,
     HideResult=true,
     Dialog(enable = if ChooseVoltageLevel==2 then true else false));
   parameter TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6 "Type of high voltage cable" annotation (
   Evaluate=true,
   HideResult=true,
   Dialog(enable = if ChooseVoltageLevel==3 then true else false));
   parameter TransiEnt.Basics.Units.SpecificResistance r_custom=0.06e-3 "Resistance load per unit length" annotation(Dialog(enable=if ChooseVoltageLevel==4 then true else false));
   parameter TransiEnt.Basics.Units.SpecificReactance x_custom=0.301e-3 "Reactance load per unit length" annotation(Dialog(enable=if ChooseVoltageLevel==4 then true else false));
   parameter TransiEnt.Basics.Units.SpecificCapacitance c_custom=0.0125e-9 "Capacitance load per unit length" annotation(Dialog(enable=if ChooseVoltageLevel==4 then true else false));
   parameter SI.Current i_r_custom=1290 "Rated current" annotation(Dialog(enable=if ChooseVoltageLevel==4 then true else false));
   parameter Boolean hasTransformers=false "has a voltage level other than 380kV and transformers at each end";
   parameter Real voltageLevel=220e3 "voltage level of transmission line" annotation(Dialog(enable=hasTransformers));

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record for the parametrization of transmission lines in <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.ElectricalGrid.TransmissionGrid_ConnectionMatrix\">TransmissionGrid_ConnectionMatrix</a></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
end TransmissionLineRecord;
