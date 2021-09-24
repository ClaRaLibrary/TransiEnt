within TransiEnt.Components.Boundaries.Gas;
model BoundaryRealGas_hxim_flow "A real gas boundary defining enthalpy, mass composition and mass flow"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.GasSource;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Boolean calculateMass=false "True if mass in boundary shall be calculated" annotation (Dialog(group="Fundamental Definitions"));
  parameter Boolean calculateH_GCV=false "True if energy related to GCV shall be calculated" annotation (Dialog(group="Fundamental Definitions"));
  parameter Boolean calculateH_NCV=false "True if energy related to NCV shall be calculated" annotation (Dialog(group="Fundamental Definitions"));

  parameter Boolean variable_m_flow=false "True, if mass flow defined by variable input" annotation (Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_h=false "True, if enthalpy defined by variable input" annotation (Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_xi=false "True, if composition defined by variable input" annotation (Dialog(group="Define Variable Boundaries"));

  parameter Boolean verbose=false "show initial gas compostion in log" annotation (Dialog(group="Define Variable Boundaries"));

  parameter SI.MassFlowRate m_flow_const=0 "Constant mass flow rate (negative sign for outflowing)" annotation (Dialog(group="Constant Boundaries", enable=not variable_m_flow));
  parameter SI.SpecificEnthalpy h_const=8e5 "Constant specific enthalpy of source" annotation (Dialog(group="Constant Boundaries", enable=not variable_h));
  parameter SI.MassFraction xi_const[medium.nc - 1]=medium.xi_default "Constant mass composition" annotation (Dialog(group="Constant Boundaries", enable=not variable_xi));
  parameter SI.Pressure p_nom=1e5 "Nominal flange pressure" annotation (Dialog(group="Nominal Values"));
  parameter SI.MassFlowRate m_flow_nom=0 "Nominal flange mass flow (zero refers to ideal boundary)" annotation (Dialog(group="Nominal Values"));

  // _____________________________________________
  //
  //          Variables
  // _____________________________________________

  SI.Mass m(start=0, stateSelect=StateSelect.never) annotation (Dialog(group="Initialization", showStartAttribute=true));
protected
  SI.MassFlowRate m_flow_in;
  SI.SpecificEnthalpy h_in;
  SI.MassFraction xi_in[medium.nc - 1];
  /*model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    TransiEnt.Basics.Records.FlangeRealGas port;
  end Summary;*/

  // _____________________________________________
  //
  //           Interfaces
  // _____________________________________________

  TransiEnt.Basics.Media.RealGasGCV_xi_Block realGasGCV_xi(realGasType=medium) if
                                                                   calculateH_GCV annotation (Placement(transformation(extent={{-30,76},{-10,96}})));
  TransiEnt.Basics.Media.RealGasNCV_xi_Block realGasNCV_xi(realGasType=medium) if
                                                                   calculateH_NCV annotation (Placement(transformation(extent={{-28,-44},{-8,-24}})));
public
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPort(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow=m_flow_in if (variable_m_flow) "Variable mass flow rate" annotation (Placement(transformation(extent={{-120,40},{-80,80}}), iconTransformation(extent={{-140,40},{-100,80}})));
  TransiEnt.Basics.Interfaces.General.SpecificEnthalpyIn h=h_in if (variable_h) "Variable specific enthalpy" annotation (Placement(transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  TransiEnt.Basics.Interfaces.General.MassFractionIn xi[medium.nc - 1]=xi_in if
       (variable_xi) "Variable mass composition" annotation (Placement(transformation(extent={{-120,-80},{-80,-40}}), iconTransformation(extent={{-140,-80},{-100,-40}})));

  // _____________________________________________
  //
  //           Instances of other classes
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  /*protected 
  TILMedia.VLEFluid_ph gas_ph(
    vleFluidType=medium,
    p=gasPort.p,
    h=actualStream(gasPort.h_outflow),
    xi=xi_in,
    deactivateTwoPhaseRegion=true)  annotation (Placement(transformation(extent={{20,-12},{40,8}})));
public 
  inner Summary summary(port(mediumModel=medium,
          xi = gas_ph.xi,
          x = gas_ph.x,
          m_flow = gasPort.m_flow,
          T = gas_ph.T,
          p = gasPort.p,
          h = gas_ph.h,
          rho = gas_ph.d))   annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));*/

  Modelica.Blocks.Sources.RealExpression xi_actual[medium.nc - 1](y=noEvent(actualStream(gasPort.xi_outflow))) if calculateH_GCV annotation (Placement(transformation(extent={{-60,76},{-40,96}})));
  Modelica.Blocks.Math.Product product if calculateH_GCV annotation (Placement(transformation(extent={{18,58},{38,78}})));
  Modelica.Blocks.Continuous.Integrator integrator if calculateH_GCV annotation (Placement(transformation(extent={{54,58},{74,78}})));
  Modelica.Blocks.Sources.Constant zero(k=0, y(unit="J")) if not calculateH_GCV annotation (Placement(transformation(extent={{18,30},{38,50}})));
  Modelica.Blocks.Sources.RealExpression MassFlow(y=gasPort.m_flow) if calculateH_GCV annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Interfaces.RealOutput H_GCV annotation (Placement(transformation(extent={{80,50},{100,70}}), iconTransformation(extent={{80,50},{100,70}})));
  Modelica.Blocks.Sources.RealExpression xi_actual2[medium.nc - 1](y=noEvent(actualStream(gasPort.xi_outflow))) if calculateH_NCV annotation (Placement(transformation(extent={{-60,-44},{-40,-24}})));
  Modelica.Blocks.Math.Product product1 if calculateH_NCV annotation (Placement(transformation(extent={{18,-64},{38,-44}})));
  Modelica.Blocks.Continuous.Integrator integrator1 if calculateH_NCV annotation (Placement(transformation(extent={{48,-64},{68,-44}})));
  Modelica.Blocks.Sources.Constant zero1(k=0, y(unit="J")) if not calculateH_NCV annotation (Placement(transformation(extent={{18,-90},{38,-70}})));
  Modelica.Blocks.Sources.RealExpression Massflow2(y=gasPort.m_flow) if calculateH_NCV annotation (Placement(transformation(extent={{-60,-84},{-40,-64}})));
  Modelica.Blocks.Interfaces.RealOutput H_NCV annotation (Placement(transformation(extent={{80,-70},{100,-50}}), iconTransformation(extent={{80,-70},{100,-50}})));
initial equation

  if verbose and variable_xi then
    TransiEnt.Basics.Functions.GasProperties.verboseXi(medium.vleFluidNames, xi_in);
  end if;

equation
  // _____________________________________________
  //
  //          Characteristic equations
  // _____________________________________________

  if (not variable_m_flow) then
    m_flow_in = m_flow_const;
  end if;
  if (not variable_h) then
    h_in = h_const;
  end if;
  if (not variable_xi) then
    xi_in = xi_const;
  end if;

  //change of mass in boundary
  if calculateMass then
    der(m) = gasPort.m_flow;
  else
    m = 0;
  end if;

  //give values to gasPort
  gasPort.h_outflow = h_in;
  if m_flow_nom > 0 then
    gasPort.m_flow = m_flow_in - (m_flow_nom/p_nom)*(p_nom - gasPort.p);
  else
    gasPort.m_flow = m_flow_in;
  end if;
  gasPort.xi_outflow = xi_in;

  connect(realGasGCV_xi.xi_input, xi_actual.y) annotation (Line(points={{-30,86},{-39,86}}, color={0,0,127}));
  connect(product.u1, realGasGCV_xi.GCV) annotation (Line(points={{16,74},{2,74},{2,86},{-9,86}}, color={0,0,127}));
  connect(product.y, integrator.u) annotation (Line(points={{39,68},{52,68}}, color={0,0,127}));
  connect(zero.y, H_GCV) annotation (Line(points={{39,40},{80,40},{80,60},{90,60}}, color={0,0,127}));
  connect(product.u2, MassFlow.y) annotation (Line(points={{16,62},{2,62},{2,50},{-39,50}}, color={0,0,127}));
  connect(integrator.y, H_GCV) annotation (Line(points={{75,68},{82,68},{82,60},{90,60}},
                                                                          color={0,0,127}));
  connect(realGasNCV_xi.xi_input, xi_actual2.y) annotation (Line(points={{-28,-34},{-39,-34}}, color={0,0,127}));
  connect(realGasNCV_xi.NCV, product1.u1) annotation (Line(points={{-7,-34},{4,-34},{4,-48},{16,-48}}, color={0,0,127}));
  connect(product1.y, integrator1.u) annotation (Line(points={{39,-54},{46,-54}}, color={0,0,127}));
  connect(integrator1.y, H_NCV) annotation (Line(points={{69,-54},{80,-54},{80,-60},{90,-60}},
                                                                             color={0,0,127}));
  connect(zero1.y, H_NCV) annotation (Line(points={{39,-80},{80,-80},{80,-60},{90,-60}}, color={0,0,127}));
  connect(product1.u2, Massflow2.y) annotation (Line(points={{16,-60},{4,-60},{4,-74},{-39,-74}}, color={0,0,127}));
  annotation (
    defaultComponentName="boundary_hxim_flow",
    Icon(graphics={Text(
          extent={{-78,32},{82,-28}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="h, xi")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Boundary for real gases with mass flow, specific enthalpy and mass fraction input. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Gas</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">IdealGasEnthPortIn</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: mass flow rate in kg/s</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: mass fraction in kg/kg</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: specific enthalpy in kJ/kg</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Created by Lisa Andresen (andresen@tuhh.de), Aug 2015</span></p>
</html>"));
end BoundaryRealGas_hxim_flow;
