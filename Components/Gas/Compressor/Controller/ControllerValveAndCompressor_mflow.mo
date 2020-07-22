within TransiEnt.Components.Gas.Compressor.Controller;
model ControllerValveAndCompressor_mflow "Controls the mass flow through a valve or a compressor depending on the pressure difference"

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

  extends TransiEnt.Basics.Icons.Controller;
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Pressure p_before_low=1e5 "Lower limit for hysteresis to limit mass flow for too low pressures" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Pressure p_before_high=1.1e5 "Higher limit for hysteresis to limit mass flow for too low pressures" annotation(Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flowDesired "Desired mass flow rate" annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,100})));
  TransiEnt.Basics.Interfaces.General.PressureIn p_before "Pressure before the valve/compressor" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.General.PressureIn p_after "Pressure after the valve/compressor" annotation (Placement(transformation(extent={{110,-10},{90,10}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flowValve "Mass flow rate through the valve" annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-110})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flowCompressor "Mass flow rate through the compressor" annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-110})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=p_before_low, uHigh=p_before_high,
    pre_y_start=true)                           annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if not
        (hysteresis.y) then
    m_flowValve=0;
    m_flowCompressor=0;
  elseif p_before>p_after then
    m_flowValve=m_flowDesired;
    m_flowCompressor=0;
  else
    m_flowCompressor=m_flowDesired;
    m_flowValve=0;
  end if;

  connect(p_before, hysteresis.u) annotation (Line(points={{-100,0},{-91,0},{-82,0}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This controller gives the desired mass flow rate to a valve or compressor. The given pressures before and after the unit and the mass flow rate through the unit can be given by parameters or inputs.</p>
<p>The desired pressure difference (p_after - p_before) is the decisive factor. Hysteresis is limited.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(none) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>m_flowDesired: input for the desired mass flow rate in kg/s</p>
<p>p_before: input for the pressure before the unit in Pa</p>
<p>p_after: input for the pressure after the unit in Pa</p>
<p>m_flowValve: output for the mass flow rate through the valve in kg/s</p>
<p>m_flowCompressor: output for the mass flow rate throught the compressor  in kg/s</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end ControllerValveAndCompressor_mflow;
