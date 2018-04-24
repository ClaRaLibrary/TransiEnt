within TransiEnt.Storage.Heat.HeatStorageStratified_constProp.Base;
model IncompressibleFluidVolume "Control volume for incompressible liquids like water with constant media properties"
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

  extends ClaRa.Basics.Icons.Volume;

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
  parameter SI.Temperature T_start= 273.15+20 "Start value of sytsem specific enthalpy"
                                                    annotation(Dialog(tab="Initialisation"));

  constant SI.Temperature Tref = 273.15 "Reference temperature of incoming enthalpy flows";
  final parameter SI.Mass m = V*d "Total system mass";

  // _____________________________________________
  //
  //                   Internal variables
  // _____________________________________________

  SI.Temperature  T(start=T_start, fixed=true, stateSelect=StateSelect.prefer) "Volume bulk temperature";
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

end IncompressibleFluidVolume;
