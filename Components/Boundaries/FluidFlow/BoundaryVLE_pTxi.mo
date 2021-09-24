within TransiEnt.Components.Boundaries.FluidFlow;
model BoundaryVLE_pTxi "A boundary defining pressure, temperature and mass composition"

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
  extends TransiEnt.Basics.Icons.BoundaryVLE;



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

  TransiEnt.Basics.Interfaces.General.PressureIn p=p_in if (variable_p) "Variable absolute pressure"    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn T=T_in if (variable_T) "Variable temperature in K"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  TransiEnt.Basics.Interfaces.General.MassFractionIn xi[medium.nc-1]=xi_in if
       (variable_xi) "Variable mass composition"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
  Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  ClaRa.Basics.Interfaces.EyeOut eye if boundaryConditions.showData
    annotation (Placement(transformation(extent={{96,-78},{108,-66}}),
        iconTransformation(extent={{94,-86},{106,-74}})));
protected
  SI.Pressure p_in;
  SI.Temperature T_in;
  Modelica.Units.SI.MassFraction xi_in[medium.nc - 1];

  ClaRa.Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{65,-72},{66,-73}}),
        iconTransformation(extent={{55,-55},{57,-53}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph fluidIn(
    vleFluidType=medium,
    p=fluidPortIn.p,
    xi=xi_in,
    h=noEvent(actualStream(fluidPortIn.h_outflow))) annotation (Placement(transformation(extent={{30,-82},{50,-62}})));

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

  eye_int[1].m_flow = fluidPortIn.m_flow;
  eye_int[1].T = fluidIn.T-273.15;
  eye_int[1].s = fluidIn.s/1e3;
  eye_int[1].p = fluidPortIn.p/1e5;
  eye_int[1].h = noEvent(actualStream(fluidPortIn.h_outflow)/1e3);

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
  connect(eye, eye_int[1]) annotation (Line(points={{102,-72},{84,-72},{84,-72.5},{65.5,-72.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-100,30},{20,-30}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="%T
xi"),   Polygon(
          points={{-54,98},{-54,98}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,92},{-12,92}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a boundary for a vapor-liquid-equilibrium defining the pressure, the mass composition and the temperature</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>RealInput: pressure in [Pa]</p>
<p>RealInput: temperature in [K]</p>
<p>RealInput: mass fraction in [kg/kg]</p>
<p>FluidPortIn</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Components.Boundaries.FluidFlow.Check.TestBoundaryVLE_pTxi&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end BoundaryVLE_pTxi;
