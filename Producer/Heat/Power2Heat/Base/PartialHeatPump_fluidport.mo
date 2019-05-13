within TransiEnt.Producer.Heat.Power2Heat.Base;
partial model PartialHeatPump_fluidport "Partial model of a heat pump with fluid ports"
  import TransiEnt;
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

  extends PartialHeatPump;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fluid Definition"));
  parameter SI.Pressure delta_p=0;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterIn(Medium=medium) annotation (Placement(transformation(extent={{90,-68},{110,-48}}), iconTransformation(extent={{92,-68},{110,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterOut(Medium=medium) annotation (Placement(transformation(extent={{92,30},{112,50}}), iconTransformation(extent={{92,30},{112,50}})));
  replaceable TransiEnt.Components.Boundaries.Heat.Heatflow_L2 heatFlowBoundary constrainedby TransiEnt.Components.Boundaries.Heat.Base.PartialHeatBoundary annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={78,6})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(heatFlowBoundary.fluidPortOut, waterOut) annotation (Line(
      points={{86,10.8},{86,40},{102,40}},
      color={175,0,0},
      thickness=0.5));
  connect(heatFlowBoundary.fluidPortIn, waterIn) annotation (Line(
      points={{86,1.2},{86,-58},{100,-58}},
      color={175,0,0},
      thickness=0.5));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Partial model of a controlled heat pump model with fluidports useable in demand side management scenarios</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica.Blocks.Interfaces.RealInput: u_set (setpoint value)</p>
<p>Modelica.Blocks.Interfaces.RealInput: u_meas (measurement value)</p>
<p>Modelica.Blocks.Interfaces.RealInput: T_source_input_K (input ambient temperature in Kelvin)</p>
<p>Modelica.Blocks.Interfaces.RealInput: T_source_internal (ambient temperature from SimCenter)</p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortIn: waterIn</p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortOut: waterOut</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>eta_HP&nbsp;=&nbsp;COP_n/((273.15+40)/(40-2))</p>
<p>P_el_n&nbsp;=&nbsp;Q_flow_n&nbsp;/&nbsp;COP_n</p>
<p>COP(y=COP_Carnot*eta_HP)</p>
<p>COP_Carnot=(u_set&nbsp;+&nbsp;Delta_T_internal)/max(2*Delta_T_internal,&nbsp;u_set&nbsp;+&nbsp;2*Delta_T_internal&nbsp;-&nbsp;T_source_internal)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end PartialHeatPump_fluidport;
