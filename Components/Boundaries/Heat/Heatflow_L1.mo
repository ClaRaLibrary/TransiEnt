within TransiEnt.Components.Boundaries.Heat;
model Heatflow_L1 "Ideal Heat flow boundary with constant or prescribed power and constant pressure loss"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  extends TransiEnt.Components.Boundaries.Heat.Base.PartialHeatBoundary;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Power Q_flow_const=100e3 "Constant heating Power"                                       annotation (Dialog(enable = not use_Q_flow_in));
  parameter Boolean use_Q_flow_in=true "Use external Value for Q_flow" annotation(choices(__Dymola_checkBox=true));

  parameter SI.Pressure p_drop=simCenter.p_n[2]-simCenter.p_n[1] "Nominal pressure drop";
  parameter Boolean change_sign=false "Change sign on input values, false: negative setpoint will produce heat";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput Q_flow_prescribed if use_Q_flow_in
    annotation (Placement(transformation(extent={{120,-20},{80,20}}),
        iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-60,80})));

protected
  Modelica.Blocks.Interfaces.RealInput Q_flow_internal "Needed for conditional connector";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  Modelica.SIunits.SpecificEnthalpy dh;
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if not use_Q_flow_in then
    Q_flow_internal = Q_flow_const;
  end if;

  // impulse balance
  - fluidPortOut.p + fluidPortIn.p = p_drop;

  // mass balance
  fluidPortIn.m_flow + fluidPortOut.m_flow = 0;

  // energy balance in design flow direction
  //fluidPortOut.m_flow * actualStream(fluidPortOut.h_outflow) + fluidPortIn.m_flow * actualStream(fluidPortIn.h_outflow) =  Q_flow_internal;
  fluidPortOut.h_outflow = if change_sign then inStream(fluidPortIn.h_outflow) + dh else inStream(fluidPortIn.h_outflow) - dh;
  fluidPortIn.h_outflow = if change_sign then inStream(fluidPortOut.h_outflow) + dh else inStream(fluidPortOut.h_outflow) - dh;

// No chemical reaction taking place:
   fluidPortIn.xi_outflow  = inStream(fluidPortOut.xi_outflow);
   fluidPortOut.xi_outflow = inStream(fluidPortIn.xi_outflow);

  dh = Q_flow_internal / max(abs(fluidPortOut.m_flow), simCenter.m_flow_small);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Q_flow_prescribed, Q_flow_internal);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),           Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>Ideal boundary model with prescribed or constant heat flow and without fluid volume. Pressure loss is constant and given via parameter.</p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Constant pressureloss, no fluid volume </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>Not time dependent because lack of volume</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>TransiEnt.Base.Interfaces.Thermal.FluidPortIn (x2)</p>
<p>RealInput (for specification of boundary power)</p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>First law of thermodynamics</p>
<h4><span style=\"color:#008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>Tested in model TransiEnt.Components.Boundaries.Heat.Check.testHeatflow_L1</p>
<p>Seems that no further testing is necessary because of simplicity of component</p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</p>
</html>"));
end Heatflow_L1;
