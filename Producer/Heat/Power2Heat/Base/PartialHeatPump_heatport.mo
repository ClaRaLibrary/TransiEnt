within TransiEnt.Producer.Heat.Power2Heat.Base;
partial model PartialHeatPump_heatport "Partial model of a heat pump with a heat port"
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
  extends PartialHeatPump;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatFlowBoundary annotation (Placement(transformation(extent={{72,-10},{92,10}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(heatFlowBoundary.port,heatPort)  annotation (Line(points={{92,0},{92,0},{100,0}},
                                                                                     color={191,0,0}));


  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Partial model of a controlled heat pump model with heatport useable in demand side management scenarios</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica.Blocks.Interfaces.RealInput: u_set (setpoint value)</p>
<p>Modelica.Blocks.Interfaces.RealInput: u_meas (measurement value)</p>
<p>Modelica.Blocks.Interfaces.RealInput: T_source_input_K (input ambient temperature in Kelvin)</p>
<p>Modelica.Blocks.Interfaces.RealInput: T_source_internal (ambient temperature from SimCenter)</p>
<p>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b: heatPort</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>eta_HP = COP_n/((273.15+40)/(40-2))</p>
<p>P_el_n = Q_flow_n / COP_n</p>
<p>COP(y=COP_Carnot*eta_HP)</p>
<p>COP_Carnot=(u_set + Delta_T_internal)/max(2*Delta_T_internal, u_set + 2*Delta_T_internal - T_source_internal)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end PartialHeatPump_heatport;
