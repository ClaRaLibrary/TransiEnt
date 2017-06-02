within TransiEnt.Components.Boundaries.FluidFlow;
model BoundaryVLE_Txim_flow "A boundary defining temperature, composition and mass flow"
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

  extends ClaRa.Basics.Icons.FlowSource;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium to be used"                         annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Boolean variable_m_flow=true "True, if mass flow defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_T=false "True, if temperature defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_xi=false "True, if composition defined by variable input"    annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean changeSign=true "Change sign of mass flow input (True, m_flow<0 leaves boundary)"    annotation(Dialog(group="Define Variable Boundaries"));

  replaceable ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryConditions(
    final variable_m_flow=variable_m_flow,
    final variable_T=variable_T,
    final variable_xi=variable_xi,
    final medium=medium) "Click book icon to change boundary conditions" annotation (choicesAllMatching=true, Placement(transformation(extent={{-10,-10},{10,10}})));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{88,-12},{108,8}})));
  Modelica.Blocks.Math.Gain sign(k=if changeSign then -1 else 1) if variable_m_flow annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Modelica.Blocks.Interfaces.RealInput m_flow(value=m_flow_in) if variable_m_flow "Variable mass flow rate"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput T(value=T_in) if (variable_T) "Variable temperature in K"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput xi[medium.nc-1](value=xi_in) if
       (variable_xi) "Variable composition"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

protected
  Modelica.SIunits.MassFlowRate m_flow_in;
  SI.Temperature T_in;
  Modelica.SIunits.MassFraction xi_in[medium.nc-1];

   TILMedia.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    p=fluidPortOut.p,
    xi=xi_in,
    h=actualStream(fluidPortOut.h_outflow))
              annotation (Placement(transformation(extent={{32,-70},{52,-50}})));
public
  ClaRa.Basics.Interfaces.EyeOut eye if boundaryConditions.showData
    annotation (Placement(transformation(extent={{98,-66},{110,-54}}),
        iconTransformation(extent={{94,-86},{106,-74}})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int
    annotation (Placement(transformation(extent={{67,-60},{68,-61}}),
        iconTransformation(extent={{55,-55},{57,-53}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if (not variable_m_flow) then
    m_flow_in=boundaryConditions.m_flow_const;
  end if;
  if (not variable_T) then
    T_in=boundaryConditions.T_const;
  end if;
  if (not variable_xi) then
    xi_in=boundaryConditions.xi_const;
  end if;

  eye_int.m_flow = fluidPortOut.m_flow;
  eye_int.T = fluidIn.T-273.15;
  eye_int.s = fluidIn.s/1e3;
  eye_int.p = fluidPortOut.p/1e5;
  eye_int.h = actualStream(fluidPortOut.h_outflow)/1e3;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(fluidPortOut, boundaryConditions.steam_a) annotation (Line(
      points={{100,0},{55,0},{10,0}},
      color={175,0,0},
      thickness=0.5));
  connect(xi, boundaryConditions.xi) annotation (Line(points={{-100,-60},{-80,-60},{-46,-60},{-46,-6},{-12,-6}}, color={0,0,127}));
  connect(T, boundaryConditions.T) annotation (Line(points={{-100,0},{-12,0}}, color={0,0,127}));
  connect(m_flow, sign.u) annotation (Line(points={{-100,60},{-100,60},{-62,60}}, color={0,0,127}));
  connect(sign.y, boundaryConditions.m_flow) annotation (Line(points={{-39,60},{-30,60},{-30,6},{-12,6}}, color={0,0,127}));
  connect(eye,eye_int)  annotation (Line(points={{104,-60},{86,-60},{86,-60.5},{67.5,-60.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-96,32},{64,-28}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="T, xi")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)));
end BoundaryVLE_Txim_flow;
