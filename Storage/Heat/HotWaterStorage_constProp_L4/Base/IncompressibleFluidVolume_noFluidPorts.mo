within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base;
model IncompressibleFluidVolume_noFluidPorts "Control volume for incompressible liquids like water with constant media properties"


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

  extends TransiEnt.Basics.Icons.Fluid_Volume;
  import Modelica.Constants.eps;
  import ClaRa;
  import      Modelica.Units.SI;

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  inner parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                                     annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter SI.Volume V=1e3 "Volume";
  parameter SI.Density d = 1e3 "Diameter";
  parameter SI.SpecificHeatCapacity c_v=4.2e3 "Specific Heat Capacity";
  //parameter SI.Temperature T_start= 273.15+20 "Start value of sytsem specific enthalpy" annotation(Dialog(tab="Initialisation"));

  final parameter SI.Mass m = V*d "Total system mass";

   parameter Boolean useFluidPorts=true;

  // _____________________________________________
  //
  //                   Internal variables
  // _____________________________________________

  SI.Temperature  T(start=273.15+20, fixed=true, stateSelect=StateSelect.prefer) "Volume bulk temperature"
                                                                                                          annotation (Dialog(group="Initialization", showStartAttribute=true));


  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (Placement(transformation(extent={{-10,86},{10,106}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
    // === Energy balance ===
  der(T) = (heatPort.Q_flow)/(m*c_v) "Energy balance";

  heatPort.T = T;


  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Control volume for incompressible liquids like water with constant media properties and no fluid ports</span></p>
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
<p>Model created by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de) in Aug 2021 by modifying  model TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base.IncompressibleFluidVolume</p>
</html>"));
end IncompressibleFluidVolume_noFluidPorts;
