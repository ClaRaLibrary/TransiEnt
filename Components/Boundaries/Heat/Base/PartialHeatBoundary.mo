within TransiEnt.Components.Boundaries.Heat.Base;
partial model PartialHeatBoundary

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.HeatSink;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid  Medium=simCenter.fluid1 "Medium model";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=Medium) annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{50,-110},{70,-90}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=Medium) annotation (Placement(transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-70,-110},{-50,-90}})));

  // _____________________________________________
  //
  //                Variables
  // _____________________________________________

  Modelica.SIunits.HeatFlowRate Q_flow_boundary = fluidPortIn.m_flow * (actualStream(fluidPortIn.h_outflow) - actualStream(fluidPortOut.h_outflow));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Ideal boundary base model.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Not time dependent because lack of volume</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortIn </p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortOut</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>Q_flow_boundary is a heat flow rate</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end PartialHeatBoundary;
