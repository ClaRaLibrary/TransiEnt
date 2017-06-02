within TransiEnt.Components.Boundaries.FluidFlow;
model BoundaryVLE_pTxi "A boundary defining pressure, temperature and composition"
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

  extends ClaRa.Basics.Icons.FlowSink;

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
  parameter Boolean variable_p=false "True, if pressure defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_T=false "True, if spc. enthalpy defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_xi=false "True, if composition defined by variable input"    annotation(Dialog(group="Define Variable Boundaries"));

 replaceable ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryConditions(
   final variable_p=variable_p,
   final variable_T=variable_T,
   final variable_xi=variable_xi,
   final medium=medium) "Click book icon to change boundary conditions" annotation (choicesAllMatching=true, Placement(transformation(extent={{-10,-10},{10,10}})));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput p(value=p_in) if (variable_p) "Variable mass flow rate"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput T(value=T_in) if (variable_T) "Variable temperature in K"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealInput xi[medium.nc-1](value=xi_in) if
       (variable_xi) "Variable composition"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
  Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{88,-12},{108,8}})));
  ClaRa.Basics.Interfaces.EyeOut eye if boundaryConditions.showData
    annotation (Placement(transformation(extent={{96,-78},{108,-66}}),
        iconTransformation(extent={{94,-86},{106,-74}})));
protected
  SI.Pressure p_in;
  SI.Temperature T_in;
  Modelica.SIunits.MassFraction xi_in[medium.nc-1];

  ClaRa.Basics.Interfaces.EyeIn eye_int
    annotation (Placement(transformation(extent={{65,-72},{66,-73}}),
        iconTransformation(extent={{55,-55},{57,-53}})));

   TILMedia.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    p=fluidPortIn.p,
    xi=xi_in,
    h=actualStream(fluidPortIn.h_outflow))
              annotation (Placement(transformation(extent={{30,-82},{50,-62}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if (not variable_p) then
    p_in=boundaryConditions.p_const;
  end if;
  if (not variable_T) then
    T_in=boundaryConditions.T_const;
  end if;
  if (not variable_xi) then
    xi_in=boundaryConditions.xi_const;
  end if;

  eye_int.m_flow = fluidPortIn.m_flow;
  eye_int.T = fluidIn.T-273.15;
  eye_int.s = fluidIn.s/1e3;
  eye_int.p = fluidPortIn.p/1e5;
  eye_int.h = actualStream(fluidPortIn.h_outflow)/1e3;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(p, boundaryConditions.p) annotation (Line(points={{-100,60},{-86,60},{-86,62},{-66,62},{-66,6},{-10,6}}, color={0,0,127}));
  connect(T, boundaryConditions.T) annotation (Line(points={{-100,0},{-55,0},{-10,0}}, color={0,0,127}));
  connect(xi, boundaryConditions.xi) annotation (Line(points={{-100,-60},{-66,-60},{-66,-6},{-10,-6}}, color={0,0,127}));
  connect(fluidPortIn, boundaryConditions.steam_a) annotation (Line(
      points={{100,0},{55,0},{10,0}},
      color={175,0,0},
      thickness=0.5));
  connect(eye, eye_int) annotation (Line(points={{102,-72},{84,-72},{84,-72.5},{65.5,-72.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-96,32},{14,-28}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
        textString="T
xi")}),                                                          Diagram(coordinateSystem(preserveAspectRatio=false)),
              Icon(coordinateSystem(preserveAspectRatio=false)),                                                          Diagram(coordinateSystem(preserveAspectRatio=false)));
end BoundaryVLE_pTxi;
