within TransiEnt.Components.Boundaries.Gas;
model Gasflow_L1 "Ideal gas flow boundary with constant or prescribed power and constant pressure loss"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.GasSource;
  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid  Medium=simCenter.gasModel1 "Medium model";
  parameter SI.Power H_flow_const=100e3 "Constant heating Power"                                       annotation (Dialog(enable = not use_H_flow_in));
  parameter Boolean use_H_flow_in=false "Use external Value for H_flow" annotation(choices(__Dymola_checkBox=true));
  parameter SI.Pressure p_drop=simCenter.p_nom[2]-simCenter.p_nom[1] "Nominal pressure drop";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.EnthalpyFlowRateIn H_flow_set if        use_H_flow_in "RealInput (for specification of boundary power)"
    annotation (Placement(transformation(extent={{120,-20},{80,20}}),
        iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-70,92})));

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasIn(Medium=Medium) annotation (Placement(transformation(extent={{-60,-110},{-40,-90}}), iconTransformation(extent={{-60,-110},{-40,-90}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasOut(Medium=Medium) annotation (Placement(transformation(extent={{40,-110},{60,-90}}), iconTransformation(extent={{40,-110},{60,-90}})));

protected
  TransiEnt.Basics.Interfaces.Gas.EnthalpyFlowRateIn H_flow_internal "Needed for conditional connector";
  // _____________________________________________
  //
  //             Complex Components
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  Modelica.SIunits.SpecificEnthalpy dh;
public
  Modelica.SIunits.EnthalpyFlowRate H_in = gasIn.m_flow * inStream(gasIn.h_outflow);
  Modelica.SIunits.EnthalpyFlowRate H_out = gasIn.m_flow * gasOut.h_outflow;

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if not use_H_flow_in then
    H_flow_internal = H_flow_const;
  end if;

  // impulse balance
  gasOut.p - gasIn.p = p_drop;

  // mass balance
  gasIn.m_flow + gasOut.m_flow = 0;

  // energy balance in design flow direction
  gasOut.h_outflow = inStream(gasIn.h_outflow) + dh;

  // energy balance in opposite flow direction
  gasIn.h_outflow = inStream(gasOut.h_outflow) + dh;

  // No chemical reaction taking place:
  gasIn.xi_outflow  = inStream(gasOut.xi_outflow);
  gasOut.xi_outflow = inStream(gasIn.xi_outflow);

  // Sign convention: Positive set value means consumption = out smaller than in!
  dh = -H_flow_internal / max(abs(gasOut.m_flow), simCenter.m_flow_small);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(H_flow_set, H_flow_internal);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Ideal boundary model with prescribed or constant enthalpy flow and without fluid volume. Pressure loss is constant and given via parameter.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Constant pressureloss, no fluid volume </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>Not time dependent because lack of volume</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>TransiEnt.Base.Interfaces.Thermal.gasIn (x2)</p>
<p>RealInput (for specification of boundary power)</p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>First law of thermodynamics</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>Tested in model TransiEnt.Components.Boundaries.Heat.Check.testHeatflow_L1</p>
<p>Seems that no further testing is necessary because of simplicity of component</p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end Gasflow_L1;
