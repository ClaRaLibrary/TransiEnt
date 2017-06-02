within TransiEnt.Producer.Electrical.Base;
partial model PartialNaturalGasUnit "Adds a gas interface with a mass flow defining boundary to child components"
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
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1;

  // _____________________________________________
  //
  //         Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasIn(Medium=medium) annotation (Placement(transformation(extent={{92,74},{108,90}}), iconTransformation(extent={{90,-50},{110,-30}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSink(
    m_flow_nom=0,
    p_nom=1000,
    variable_h=false,
    m_flow_const=1,
    h_const=0,
    variable_m_flow=true,
    medium=medium) annotation (Placement(transformation(extent={{52,72},{72,92}})));
  Modelica.Blocks.Sources.RealExpression
                            m_flow_set(y=-m_flow_gas) "just for visualisation on diagram layer"
    annotation (Placement(transformation(extent={{12,78},{34,98}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  SI.MassFlowRate m_flow_gas;

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(gasIn,massFlowSink. steam_a) annotation (Line(
      points={{100,82},{72,82}},
      color={255,255,0},
      thickness=0.75,
      smooth=Smooth.None));
  connect(m_flow_set.y,massFlowSink. m_flow) annotation (Line(
      points={{35.1,88},{50,88}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Adds&nbsp;a&nbsp;gas&nbsp;interface&nbsp;with&nbsp;a&nbsp;mass&nbsp;flow&nbsp;defining&nbsp;boundary&nbsp;to&nbsp;child&nbsp;components.</p>
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
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end PartialNaturalGasUnit;
