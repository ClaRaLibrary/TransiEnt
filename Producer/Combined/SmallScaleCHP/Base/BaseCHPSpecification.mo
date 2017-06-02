within TransiEnt.Producer.Combined.SmallScaleCHP.Base;
record BaseCHPSpecification "Record used for specification of a CHP"
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Record;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________
  parameter Modelica.SIunits.Power P_el_max=1e5 "Maximum power output in W"
    annotation (Dialog(tab="Technical Specifications"));
  parameter Modelica.SIunits.Power P_el_min=0.5*P_el_max "Minimum power output in W"
    annotation (Dialog(tab="Technical Specifications"));
  parameter Real lambda=1 "Air–fuel ratio";
  parameter Real eta_el_max(
    min=0,
    max=1) = 0.30 "Maximum electrical efficiency"
   annotation (Dialog(tab="Technical Specifications"));
  parameter Real eta_el_min(
    min=0,
    max=1) = eta_el_max*0.85 "Electrical efficiency at P_el_min"
   annotation (Dialog(tab="Technical Specifications"));
  parameter Real[:,:] field_eta_el={{P_el_min,(P_el_min+P_el_max)/2,P_el_max},{eta_el_min,(eta_el_min+eta_el_max)/2,eta_el_max}} "Field of electrical efficiencies";
  parameter Real[:,:] field_eta_h={{P_el_min,(P_el_min+P_el_max)/2,P_el_max},{eta_h_min,(eta_h_min+eta_h_max)/2,eta_h_max}} "Field of fuel utilization efficiencies";
  parameter Real eta_h_max(
    min=0,
    max=1.12) = 0.98 "Fuel utilization at P_el_min"
   annotation (Dialog(tab="Technical Specifications"));
  parameter Real eta_h_min(
    min=0,
    max=1.12) = 0.95*eta_h_max "Fuel utilization at P_el_max"
   annotation (Dialog(tab="Technical Specifications"));
  parameter Real eta_m=0.9 "guessed value for mechanical efficiency (P_e/P_i=p_me/p_mi) (Hackbarth, Merhof)";
    parameter Real thermalConductivity=Q_flow_out_max/200 "Thermal conductivity between engines core and casing";
  parameter Modelica.SIunits.Power Q_flow_out_max=P_el_max/eta_el_max*(
      eta_h_max - eta_el_max) "Maximum heat flow in W"
    annotation (Dialog(tab="Technical Specifications"));
  parameter Modelica.SIunits.Power Q_flow_out_min=P_el_min/eta_el_min*(
      eta_h_min - eta_el_min) "Minimum heat flow in W"
    annotation (Dialog(tab="Technical Specifications"));

   parameter Modelica.SIunits.Mass m_engine=1000 "Approximate mass of motor"
   annotation (Dialog(tab="Technical Specifications"));
  parameter Modelica.SIunits.Length length=1.5 "Size of motor block";
  parameter Modelica.SIunits.Height height=1 "Size of motor block";
  parameter Modelica.SIunits.Length width=1 "Size of motor block";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer k=20 "Coefficient of heat transfer";
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm n_n=1500 "nominal angular velocity in rpm";

  //Default parameter of piston stroke assumes a ratio of piston stroke to diameter of 1
  parameter Modelica.SIunits.Length pistonStroke=pistonDiameter "Piston stroke of engine";
  parameter Modelica.SIunits.Diameter pistonDiameter=0.1 "Piston diameter of engine";
  parameter Integer n_cylinder=4 "Number of cylinders";

  parameter Modelica.SIunits.Temperature T_opt=338.15 "Temperature of warm engine";
  parameter Modelica.SIunits.Temperature T_return_max=343.15 "Maximum allowed coolant temperature";
  parameter Real reactionTime=1/8 "Reaction time of engine";
  parameter Real damping=3 "Damping of engine's transfer function";
  parameter Real shareExhaustHeat=0.3 "Share of exhaust heat flow Q_flow_exhaust on total heat flow fed into the grid Q_flow_out";
  parameter Modelica.SIunits.Time syncTime=90 "Time needed for synchronistion to the grid";
  final parameter Modelica.SIunits.Volume engineDisplacement=pistonDiameter
      ^2/4*Modelica.Constants.pi*pistonStroke "Engine displacement of single cylinder";
  final parameter Modelica.SIunits.AngularVelocity omega_n=n_n/60*2*
      Modelica.Constants.pi "Nominal angular velocity";

      annotation(Documentation(info="<html>
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
</html>"));
end BaseCHPSpecification;
