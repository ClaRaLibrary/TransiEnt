within TransiEnt.Producer.Combined.SmallScaleCHP.Base;
record BaseCHPSpecification "Record used for specification of a CHP"


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

  extends TransiEnt.Basics.Icons.Record;
//  parameter Real CL_eta_el[:,2]=[P_el_min/P_el_max,eta_el_min/eta_el_max; 1.00,eta_el_max/eta_el_max] "Characteristic line eta/eta_max = f(Power output), x number of rows, 2 columns" annotation (Dialog(tab="General", group="Efficiencies"));
//  parameter Real CL_eta_th[:,2]=[P_el_min/P_el_max,eta_th_max/eta_th_max; 1.00,eta_th_min/eta_th_max] "Characteristic line eta/eta_max = f(Power output), x number of rows, 2 columns" annotation (Dialog(tab="General", group="Efficiencies"));
  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________
  parameter TransiEnt.Producer.Combined.SmallScaleCHP.Base.PartloadEfficiency.PartloadEfficiencyCharacteristic EfficiencyCharLine=TransiEnt.Producer.Combined.SmallScaleCHP.Base.PartloadEfficiency.PartloadEfficiencyCharacteristic(CL_eta_th=[P_el_min/P_el_max,eta_h_max /eta_h_max;  1.00,eta_h_min /eta_h_max], CL_eta_el=[P_el_min/P_el_max,eta_el_min/eta_el_max; 1.00,eta_el_max/eta_el_max]) "choose characteristic relative efficiency line" annotation(Dialog(tab="General", group="Efficiencies"), choicesAllMatching=true);

  // Electrical Parameters
  parameter Modelica.Units.SI.Power P_el_max=1e5 "Maximum power output in W" annotation (Dialog(tab="General", group="Electrical Parameters"));
  parameter Modelica.Units.SI.Power P_el_min=0.5*P_el_max "Minimum power output in W" annotation (Dialog(tab="General", group="Electrical Parameters"));

//   parameter Real Efficiency_el_Mat[:,2]=[P_el_max,eta_el_max; P_el_min,eta_el_min];
//   parameter Real Efficiency_th_Mat[:,2]=[P_el_max,eta_th_min; P_el_min,eta_th_max];

  // Efficiencies
  parameter Real eta_el_max(
    min=0,
    max=1) = 0.30 "Maximum electrical efficiency" annotation (Dialog(tab="General", group="Efficiencies"));
  parameter Real eta_el_min(
    min=0,
    max=1) = eta_el_max*0.85 "Electrical efficiency at P_el_min" annotation (Dialog(tab="General", group="Efficiencies"));
  parameter Real eta_h_max(
    min=0,
    max=1.12) = 0.98 "Fuel utilization at P_el_min" annotation (Dialog(group="Efficiencies"));
  parameter Real eta_h_min(
    min=0,
    max=1.12) = 0.95*eta_h_max "Fuel utilization at P_el_max" annotation (Dialog(group="Efficiencies"));
  parameter Real eta_m=0.9 "guessed value for mechanical efficiency (P_e/P_i=p_me/p_mi) (Hackbarth, Merhof)" annotation (Dialog(tab="General", group="Efficiencies"));

  //
  // Thermal Parameters
  parameter Modelica.Units.SI.Temperature T_opt=338.15 "Temperature of warm engine" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));
  parameter Modelica.Units.SI.Temperature T_return_max=343.15 "Maximum allowed coolant temperature" annotation (Dialog(tab="General", group="Thermal Parameters"));
  parameter Real shareExhaustHeat=0.3 "Share of exhaust heat flow Q_flow_exhaust on total heat flow fed into the grid Q_flow_out" annotation (Dialog(tab="General", group="Thermal Parameters"));
  parameter Real lambda=1 "Air–fuel ratio" annotation (Dialog(tab="General", group="Thermal Parameters"));
  parameter Real thermalConductivity=Q_flow_out_max/200 "Thermal conductivity between engines core and casing" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));
  parameter Modelica.Units.SI.Power Q_flow_out_max=P_el_max/eta_el_max*(eta_h_max - eta_el_max) "Maximum heat flow in W" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));
  parameter Modelica.Units.SI.Power Q_flow_out_min=P_el_min/eta_el_min*(eta_h_min - eta_el_min) "Minimum heat flow in W" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer k=20 "Coefficient of heat transfer" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));

  // Geometric Parameters
  parameter Modelica.Units.SI.Mass m_engine=1000 "Approximate mass of motor" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));
  parameter Modelica.Units.SI.Length length=1.5 "Size of motor block" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));
  parameter Modelica.Units.SI.Height height=1 "Size of motor block" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));
  parameter Modelica.Units.SI.Length width=1 "Size of motor block" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));
  parameter Integer n_cylinder=4 "Number of cylinders" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));

  //Default parameter of piston stroke assumes a ratio of piston stroke to diameter of 1
  parameter Modelica.Units.SI.Length pistonStroke=pistonDiameter "Piston stroke of engine" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));
  parameter Modelica.Units.SI.Diameter pistonDiameter=0.1 "Piston diameter of engine" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));
  final parameter Modelica.Units.SI.Volume engineDisplacement=pistonDiameter^2/4*Modelica.Constants.pi*pistonStroke "Engine displacement of single cylinder" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));

  //Mechanical and Dynamic Parameters
  parameter Real reactionTime=1/8 "Reaction time of engine" annotation (Dialog(tab="General", group="Dynamic Parameters"));
  parameter Real damping=3 "Damping of engine's transfer function" annotation (Dialog(tab="General", group="Dynamic Parameters"));
  parameter Modelica.Units.SI.Time syncTime=90 "Time needed for synchronistion to the grid" annotation (Dialog(tab="General", group="Dynamic Parameters"));
  parameter Modelica.Units.NonSI.AngularVelocity_rpm n_n=1500 "nominal angular velocity in rpm" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));
  final parameter Modelica.Units.SI.AngularVelocity omega_n=n_n/60*2*Modelica.Constants.pi "Nominal angular velocity" annotation (Dialog(tab="Technical Specifications", group="For informative purposes only"));

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Partial record for CHP specification data.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Jun 2013</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2013</p>
<p>Revised by Anne Senkel (anne.senkel@tuhh.de), Feb 2019</p>
</html>"));
end BaseCHPSpecification;
