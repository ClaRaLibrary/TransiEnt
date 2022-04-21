within TransiEnt.Producer.Electrical.Base;
partial model PartialCDEUnit "Adds a gas interface with a mass flow defining boundary to child components"


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

  extends TransiEnt.Basics.Icons.IndustryPlant;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter Boolean useCDEPort=false annotation(Dialog(group="Fundamental Definitions"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_CDE_deposited=simCenter.gasModel1 annotation(Dialog(enable = useCDEPort,group="Fundamental Definitions"));
  // _____________________________________________
  //
  //         Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_hxim_flow
                                                            massFlowSink_CDE_deposited(
    m_flow_nom=0,
    p_nom=1000,
    variable_h=false,
    m_flow_const=1,
    h_const=0,
    variable_m_flow=true,
    medium=medium_CDE_deposited,
    xi_const={0,0,0,0,0,1}) if      useCDEPort annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Blocks.Sources.RealExpression m_flow_set_CDE_deposited(y=-m_flow_gas_CDE_deposited_gasPort) if  useCDEPort "just for visualisation on diagram layer" annotation (Placement(transformation(extent={{-20,36},{2,56}})));
  SI.MassFlowRate m_flow_gas_CDE_deposited_gasPort=0*time;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut_CDE(Medium=medium_CDE_deposited) if  useCDEPort==true         annotation (Placement(transformation(extent={{92,32},{108,48}})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
 if useCDEPort then
  connect(m_flow_set_CDE_deposited.y,massFlowSink_CDE_deposited. m_flow) annotation (Line(
      points={{3.1,46},{18,46}},
      color={0,0,127},
      smooth=Smooth.None));
 end if;
  connect(massFlowSink_CDE_deposited.gasPort, gasPortOut_CDE) annotation (Line(
      points={{40,40},{70,40},{70,40},{100,40}},
      color={255,255,0},
      thickness=1.5));
    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Adds a gas interface with a mass flow for CO2 emissions</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasIn: inlet for real gas</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by <span style=\"font-family: MS Shell Dlg 2;\">Oliver Schülting (oliver.schuelting@tuhh.de) on Dez 2018</span></p>
</html>"));
end PartialCDEUnit;
