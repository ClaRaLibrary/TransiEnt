within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base;
model IncompressibleFluidVolume "Control volume for incompressible liquids like water with constant media properties"
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

  extends TransiEnt.Basics.Icons.Fluid_Volume;
  import Modelica.Constants.eps;
  import ClaRa;
  import SI = Modelica.SIunits;

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  inner parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                                     annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter Integer nPorts = 2 "Number of fluid ports";
  parameter SI.Volume V=1e3 "Volume";
  parameter SI.Density d = 1e3;
  parameter SI.SpecificHeatCapacity c_v=4.2e3 "Specific Heat Capacity";
  //parameter SI.Temperature T_start= 273.15+20 "Start value of sytsem specific enthalpy" annotation(Dialog(tab="Initialisation"));

  constant SI.Temperature Tref = 273.15 "Reference temperature of incoming enthalpy flows";
  final parameter SI.Mass m = V*d "Total system mass";

  // _____________________________________________
  //
  //                   Internal variables
  // _____________________________________________

  SI.Temperature  T(start=273.15+20, fixed=true, stateSelect=StateSelect.prefer) "Volume bulk temperature"
                                                                                                          annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.EnthalpyFlowRate H_flow[nPorts] "Enthalpy flow rate passing from ports to volume";
  SI.EnthalpyFlowRate H_flow_total = sum(H_flow);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn[nPorts] ports(each Medium=medium) "Fluid port" annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (Placement(transformation(extent={{-10,86},{10,106}})));

  // _____________________________________________
  //
  //                  Equations
  // _____________________________________________

equation
  // ==== Mass balance ===
  sum(ports.m_flow) = 0 "Mass Balance";  // Nur bei Annahme der konstanten Dichte

  // === Energy balance ===
  der(T) = (sum(H_flow) + heatPort.Q_flow)/(m*c_v) "Energy balance";

  // === Interface allocation ===
  for i in 1:nPorts loop
   ports[i].h_outflow  = c_v * (T - Tref);
  end for;

  for i in 1:nPorts-1 loop
   ports[i].p  = ports[i+1].p;
  end for;

  heatPort.T = T;

  // ==== Variable assignment ====
  for i in 1:nPorts loop
  H_flow[i] = ports[i].m_flow*actualStream(ports[i].h_outflow);
  end for;

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Control volume for incompressible liquids like water with constant media properties</span></p>
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
</html>"));
end IncompressibleFluidVolume;
