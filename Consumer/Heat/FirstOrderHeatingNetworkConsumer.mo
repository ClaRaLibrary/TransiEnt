within TransiEnt.Consumer.Heat;
model FirstOrderHeatingNetworkConsumer "Heating network consumer, mass flow control dynamic approximated by first order system"

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

  extends PartialHeatConsumer;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter ClaRa.Basics.Units.Temperature T_return_const=293.15 "Return temperature, if use_T_return_const";
  parameter SI.Pressure p_feed_const = 12e5 "Pressure at consumer station, feed water side";
  parameter SI.Pressure p_return_const = 10e5 "Pressure at consumer station, return water side";
  parameter SI.MassFlowRate m_flow_large=2000 "Limit of mass flow rate";
  parameter SI.MassFlowRate m_flow_small=simCenter.m_flow_small "Lower limits of input signals";
  parameter SI.Time T_massflow_ctrl=0.5 "Time constant of mass flow adaption";
  parameter Real m_flow_init=750 "Initial or guess value of output (= state)";
  parameter Boolean use_T_return_const = true;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_demand "Total heatflowrate demand" annotation (Placement(transformation(
        extent={{-15,-15},{15,15}},
        rotation=270,
        origin={1,103}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-4,94})));

  TransiEnt.Basics.Interfaces.General.TemperatureIn T_return_set if not use_T_return_const "Return temperature set point"  annotation (Placement(transformation(
        extent={{-15,-15},{15,15}},
        rotation=270,
        origin={67,103}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={74,92})));

protected
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_return_internal annotation (Placement(transformation(
        extent={{-15,-15},{15,15}},
        rotation=180,
        origin={15,34}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-4,94})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    m_flow_const=550,
    variable_m_flow=true,
    p_nom=p_return_const,
    variable_T=true)      annotation (Placement(transformation(extent={{-26,-44},{-46,-24}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(                                       p_const(displayUnit="bar") = p_feed_const, variable_T=true)
                                                                                                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-44,34})));

  Modelica.Blocks.Sources.RealExpression m_flow_target_set(y=m_flow_target) annotation (Placement(transformation(extent={{86,-38},{66,-18}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.MassFlowRate m_flow_target "Mass flow is determined by heat balance";
  SI.SpecificHeatCapacity cp_in = TILMedia.VLEFluidFunctions.liquidSpecificHeatCapacity_phxi(medium, fluidPortIn.p, inStream(fluidPortIn.h_outflow), inStream(fluidPortIn.xi_outflow));
  SI.Density rho = TILMedia.VLEFluidFunctions.liquidDensity_phxi(medium, fluidPortIn.p, inStream(fluidPortIn.h_outflow), inStream(fluidPortIn.xi_outflow));
  SI.HeatFlowRate Q_consumer_is = fluidPortIn.m_flow * inStream(fluidPortIn.h_outflow) + fluidPortOut.m_flow * fluidPortOut.h_outflow;

  Modelica.Blocks.Nonlinear.Limiter m_flow_lim_set(uMax=m_flow_large, uMin=m_flow_small) annotation (Placement(transformation(extent={{50,-38},{30,-18}})));

  Modelica.Blocks.Continuous.FirstOrder m_flow(
    T=T_massflow_ctrl,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=m_flow_init) annotation (Placement(transformation(extent={{20,-38},{0,-18}})));

  TransiEnt.Basics.Interfaces.General.EyeOut eye annotation (Placement(transformation(extent={{102,-100},{122,-80}}), iconTransformation(extent={{102,-100},{122,-80}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  Q_flow_demand = m_flow_target*(inStream(fluidPortIn.h_outflow) - fluidPortOut.h_outflow);

  if use_T_return_const then
    T_return_internal = T_return_const;
  end if;

  //Eye values (Visualization)
  eye.P=0;
  eye.Q_flow=Q_flow_demand;
  eye.T_supply=T_in.T_celsius;
  eye.T_return=T_return_internal;
  eye.p = p_return_const;
  eye.h_supply = inStream(fluidPortIn.h_outflow)/1e3;
  eye.h_return = fluidPortOut.h_outflow/1e3;
  eye.m_flow = -fluidPortOut.m_flow;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(T_return_internal, T_return_set);

  connect(T_return_internal, sink.T) annotation (Line(points={{15,34},{15,34},{-34,34}}, color={0,0,127}));
  connect(T_return_internal, source.T) annotation (Line(points={{15,34},{-18,34},{-18,-34},{-24,-34}}, color={0,0,127}));
  connect(m_flow_lim_set.y, m_flow.u) annotation (Line(points={{29,-28},{29,-28},{22,-28}}, color={0,0,127}));
  connect(m_flow.y, source.m_flow) annotation (Line(points={{-1,-28},{-14,-28},{-24,-28}}, color={0,0,127}));
  connect(m_flow_lim_set.u, m_flow_target_set.y) annotation (Line(points={{52,-28},{62,-28},{65,-28}},          color={0,0,127}));
  connect(fluidPortIn, sink.steam_a) annotation (Line(
      points={{-98,20},{-68,20},{-68,34},{-54,34}},
      color={175,0,0},
      thickness=0.5));
  connect(fluidPortOut, source.steam_a) annotation (Line(
      points={{-98,-20},{-80,-20},{-80,-34},{-46,-34}},
      color={175,0,0},
      thickness=0.5));
  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model represents a district heating station consumer. The model calculates the mass flow according to the feed water temperature and the prescribed heat flow demand. It reacts to a change in feed water temperature by reducing mass flow in returning mass flow path. There is no mass flow balance active.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model makes sense only if it is used in a closed loop, meaning that the mass flow at outlet and inlet is the same by definition. Otherwise mass flow balance is not forfilled!</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in the check models &quot;TransiEnt.Consumer.Heat.Check.TestFirstOrderHeatingNetworkConsumer&quot; and &quot;TransiEnt.Consumer.Heat.Check.TestFirstOrderHeatingNetworkConsumer_withPlant&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by pd (dubucq@tuhh.de) in April 2016.</span></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-75,-75},{75,75}}),
        Line(points={{46,60},{-60,-46}}, color={0,127,127}),
        Line(points={{60,46},{-46,-60}}, color={0,127,127})}),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end FirstOrderHeatingNetworkConsumer;
