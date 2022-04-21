within TransiEnt.Components.Heat.Fan;
model Fan_L1 "Simple L1 model for fan"



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

  import SI = ClaRa.Basics.Units;

  // _____________________________________________
  //
  //          Internal Model Declaration
  // _____________________________________________

    model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    input SI.VolumeFlowRate V_flow_out "Volume flow rate";
    input SI.Power P_hyd "Hydraulic power";
    input SI.Power P_mech "Mechanical power";
    input SI.Power P_el "Electrical power";
    input ClaRa.Basics.Units.Power P_el_loss "Electric Power lost at conversion";
    input SI.PressureDifference Delta_p "Pressure difference";
    end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeGas  inlet;
    ClaRa.Basics.Records.FlangeGas  outlet;
  end Summary;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real eta_polytropic = 0.85 "polytropic efficiency" annotation (Dialog(group="Fundamental Definitions"));

  parameter Real eta_mech = 0.95 "mechanical efficiency" annotation (Dialog(group="Fundamental Definitions"));

  parameter Real eta_el = 0.9 "electric efficiency" annotation (Dialog(group="Fundamental Definitions"));

  parameter SI.MassFlowRate m_flow_max = 15 "maximum mass flow rate" annotation (Dialog(group="Fundamental Definitions"));

  parameter SI.Time timeConstant_m_flow = 60 "time constant of mass flow with respect to set point variation" annotation (Dialog(group="Time Response Definition"));

  parameter TILMedia.GasTypes.BaseGas medium1=simCenter.airModel "Medium"
    annotation (Dialog(    group="Fundamental Definitions"), choicesAllMatching);

  parameter Boolean showData=false "True if a data port containing p,T,h,s,m_flow shall be shown, else false" annotation (Dialog(tab="Summary and Visualisation"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

    outer ClaRa.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium1) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})), HideResult=true);
  ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium1) annotation (Placement(transformation(extent={{90,-10},{110,10}})), HideResult=true);
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp
    annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_set annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,106})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Boundaries.Electrical.ActivePower.Power Power annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  TILMedia.Gas_pT air_inlet(
    p=inlet.p,
    T=inStream(inlet.T_outflow),
    xi=inStream(inlet.xi_outflow),
    gasType=medium1) annotation (Placement(transformation(extent={{-94,-42},{-74,-22}})));

  TILMedia.Gas_pT air_outlet(
    gasType=medium1,
    T=T_out,
    p=outlet.p,
    xi=air_inlet.xi) annotation (Placement(transformation(extent={{68,-44},{88,-24}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=P_el)      annotation (Placement(transformation(extent={{-56,-44},{-36,-24}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow boundaryGas_Txim_flow(
    variable_m_flow=true,
    medium=medium1,
    variable_T=true,
    xi_const=medium1.xi_default) annotation (Placement(transformation(extent={{48,-10},{68,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow
                                                       boundaryGas_Txim_flow1(
    medium=medium1,
    variable_m_flow=true,
    variable_T=true,
    xi_const=medium1.xi_default) annotation (Placement(transformation(extent={{-52,-10},{-72,10}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(y=air_outlet.T)    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Summary summary(
    outline(
      V_flow_out=V_flow_out,
      P_hyd=P_hyd,
      P_mech=P_mech,
      P_el=P_el,
      P_el_loss=P_el - P_hyd,
      Delta_p=air_outlet.p - air_inlet.p),
    inlet(
      mediumModel=medium1,
      m_flow=inlet.m_flow,
      T=air_inlet.T,
      p=air_inlet.p,
      h=air_inlet.h,
      xi=air_inlet.xi,
      H_flow=inlet.m_flow*air_inlet.h),
    outlet(
      mediumModel=medium1,
      m_flow=outlet.m_flow,
      T=air_outlet.T,
      p=air_outlet.p,
      h=air_outlet.h,
      xi=air_outlet.xi,
      H_flow=outlet.m_flow*air_outlet.h)) annotation (Placement(transformation(extent={{-80,-84},{-60,-64}})));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=timeConstant_m_flow) annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Nonlinear.VariableLimiter massFlowLimit(strict=true) annotation (Placement(transformation(extent={{-52,40},{-32,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=m_flow_max) annotation (Placement(transformation(extent={{-100,56},{-80,76}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=0) annotation (Placement(transformation(extent={{-100,34},{-80,54}})));

  Modelica.Blocks.Sources.RealExpression realExpression2(y=inStream(inlet.T_outflow)) annotation (Placement(transformation(extent={{-20,-20},{-40,0}})));

  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-10,8},{-30,28}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

 Real kappa "Ratio of specific heats";
 SI.Temperature T_out "outlet fluid temperature";
 SI.EnthalpyMassSpecific Delta_h "fluid enthalpy difference";

 SI.Pressure    Delta_p(final start=100) "pressure difference across fan";
 SI.Power    P_hyd "Hydraulic power";
 SI.Power    P_mech "Mechanical power";
 SI.Power    P_el "Electric power";
 SI.MassFlowRate     m_flow "fluid mass flow rate";
 SI.VolumeFlowRate     V_flow_out "outlet volume flow rate";

 SI.Power P_check "residuum power for verification purpose";
 SI.Energy E_check "residuum energy for verification purpose";

equation

    // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  m_flow = firstOrder.y;

  air_inlet.cv * kappa = air_inlet.cp;

  Delta_p = air_inlet.p - air_outlet.p;

  P_hyd = Delta_h*m_flow;

  P_mech = P_hyd/(eta_mech);

  P_el = P_mech/(eta_el);

  V_flow_out = m_flow / air_outlet.d;

  T_out = air_inlet.T * (air_outlet.p/air_inlet.p)^((kappa -1.0)/(eta_polytropic*kappa));

  Delta_h = air_outlet.h - air_inlet.h;

  P_check = P_hyd + summary.inlet.H_flow + summary.outlet.H_flow;

   der(E_check) = P_check;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Power.epp, epp) annotation (Line(
      points={{-10,-50},{-20,-50},{-20,-80},{0,-80},{0,-98}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression.y, Power.P_el_set) annotation (Line(points={{-35,-34},{-6,-34},{-6,-38}}, color={0,0,127}));
  connect(boundaryGas_Txim_flow.gas_a, outlet) annotation (Line(
      points={{68,0},{100,0}},
      color={118,106,98},
      thickness=0.5));
  connect(boundaryGas_Txim_flow1.gas_a, inlet) annotation (Line(
      points={{-72,0},{-100,0}},
      color={118,106,98},
      thickness=0.5));
  connect(realExpression1.y, boundaryGas_Txim_flow.T) annotation (Line(points={{21,-10},{36,-10},{36,-2},{48,-2},{48,0}}, color={0,0,127}));
  connect(m_flow_set, massFlowLimit.u) annotation (Line(points={{0,106},{0,78},{-70,78},{-70,50},{-54,50}}, color={0,0,127}));
  connect(realExpression4.y, massFlowLimit.limit2) annotation (Line(points={{-79,44},{-68,44},{-68,42},{-54,42}}, color={0,0,127}));
  connect(realExpression3.y, massFlowLimit.limit1) annotation (Line(points={{-79,66},{-66,66},{-66,58},{-54,58}}, color={0,0,127}));
  connect(massFlowLimit.y, firstOrder.u) annotation (Line(points={{-31,50},{-22,50}}, color={0,0,127}));
  connect(firstOrder.y, boundaryGas_Txim_flow.m_flow) annotation (Line(points={{1,50},{16,50},{16,6},{48,6}}, color={0,0,127}));

  connect(firstOrder.y, gain.u) annotation (Line(points={{1,50},{16,50},{16,18},{-8,18}}, color={0,0,127}));
  connect(gain.y, boundaryGas_Txim_flow1.m_flow) annotation (Line(points={{-31,18},{-40,18},{-40,6},{-52,6}}, color={0,0,127}));
  connect(realExpression2.y, boundaryGas_Txim_flow1.T) annotation (Line(points={{-41,-10},{-46,-10},{-46,0},{-52,0}}, color={0,0,127}));
     annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-20,56},{56,20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-20,-56},{56,-20}},
          color={0,0,0},
          thickness=0.5)}),                                                          Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Simple model for electric fan using a polytropic as well as electric and mechanical efficiency. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<ul>
<li>The mass flow through the fan is set independendy of the in- and outlet boundary conditions, which is not physical. </li>
<li>No air control volume is used, and thus there is no momentum, mass or energy storage in the component.</li>
<li><span style=\"font-family: MS Shell Dlg 2;\">No backflow is possible.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">The mass flow is ideally controlled.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Dynamics are modelled as first order system with set point and actual massflow (due to mechanical and control inertia)</span></li>
</ul>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<ul>
<li>Constant efficiencies are currently used, but may be replaced with performance tables.</li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<ol>
<li>Air Inlet</li>
<li>Air Outlet</li>
<li>Mass_flow_set</li>
<li>Active power port</li>
</ol>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has been validated with the fan unit of the Electric Thermal Energy Storage demonstration plant of Siemens Gamesa Renewable Energy in Hamburg-Bergedorf, Germany.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] M. von der Heyde, Abschlussbericht zum Teilprojekt der TUHH im Verbundforschungsprojekt Future Energy Solution (FES), BMWI 03ET6072C, 2021</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[2] M. von der Heyde, Electric Thermal Energy Storage based on Packed Beds for Renewable Energy Integration, Dissertation, Hamburg University of Technology, 2021</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">First Version in 04.2020 for the research project Future Energy Solution (FES) by Michael von der Heyde (heyde@tuhh.de)</span></p>
</html>"));
end Fan_L1;
