within TransiEnt.Components.Heat;
model PipeFlow_L4_Simple_ground "Model of underground pipe"

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
  extends ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple(
    redeclare model HeatTransfer =
    ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4(alpha_nom=alpha), final Delta_p_nom= Delta_p);

  import SI = Modelica.SIunits;
  constant Real Pi = Modelica.Constants.pi;
  extends TransiEnt.Basics.Icons.PipeFlow_L4_Simple;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________
  final parameter SI.Length diameter_o = diameter_i +2*thickness_pipe "Outer diameter of pipe";
  final parameter SI.Length diameter_insulation = diameter_o + 2*thickness_insulation "Diameter with insulation";
  final parameter SI.Length depth_average= abs(z_in+z_out)/2;
  final parameter SI.CoefficientOfHeatTransfer alpha=2*lambda_ground/diameter_i/((lambda_ground/lambda_insulation)*Modelica.Math.log10(diameter_insulation/diameter_o)+Modelica.Math.acosh(2*depth_average/diameter_insulation));

  final parameter SI.Velocity v_nom= m_flow_nom/(N_tubes*rho_nom1*Pi*(diameter_i/2)^2) "Nominal fluid velocity";
  final parameter SI.PressureDifference Delta_p= length*(rho_nom1/2)*((4*m_flow_nom/N_tubes)/(rho_nom1*Pi*diameter_i^2))^2*0.11*((roughness*1000/diameter_i)+(68*v_nom*Pi*diameter_i*rho_nom1)/(4*m_flow_nom/N_tubes))^0.25;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  // the length now means the length of every pipe

  // Heat losses
  parameter SI.ThermalConductivity lambda_ground=0.5 "Thermal conductivity of ground" annotation(Dialog(tab="Additional Parameters",group="Heat Transfer"));
  parameter SI.ThermalConductivity lambda_insulation=0.04 "Thermal conductivity of insulation" annotation(Dialog(tab="Additional Parameters",group="Heat Transfer"));
  parameter SI.Length thickness_pipe= 0.002 "Thickness of pipe wall" annotation(Dialog(tab="Additional Parameters",group="Heat Transfer"));
  parameter SI.Length thickness_insulation= 0.037 "Thickness of insulation" annotation(Dialog(tab="Additional Parameters",group="Heat Transfer"));

  // Pressure losses
  // already inside the model:
  // m_flow_nom, diameter_i,length
  // m_flow_nom, diameter_i,length

  parameter SI.Density rho_nom1= 990 "Nominal Density" annotation(Dialog(tab="Additional Parameters",group="Pressure Loss"));
  parameter SI.Length roughness= 0.045e-3 "Roughness" annotation(Dialog(tab="Additional Parameters",group="Pressure Loss"));

   annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model extends the ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple model. Pipe model for underground model. Nominal pressure loss and heat transfer coefficent are calculated inside the model.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The general physics of the model are described in ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple. </p>
<p>The heat model is defined with constant heat transfer coefficent. The coefficient is calculated considering just heat conduction. The influence of the pipe wall on the heat conduction is assumed to be small. Just the insulation of the pipe and the underground are considered.</p>
<p>The nominal pressure loss is calculated using the method shown in [Krimmling,2011].</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Physics of model are described in ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>see ClaRa pipe for validation</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Tobias Ramm (tobias.ramm@tuhh.de) November 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Lisa Andresen (andresen@tuhh.de) December 2015</span></p>
</html>"), Icon(graphics={
        Polygon(
          points={{88,58},{88,58}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end PipeFlow_L4_Simple_ground;
