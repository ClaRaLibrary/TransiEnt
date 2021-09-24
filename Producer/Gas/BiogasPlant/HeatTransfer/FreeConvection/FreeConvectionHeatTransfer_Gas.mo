within TransiEnt.Producer.Gas.BiogasPlant.HeatTransfer.FreeConvection;
partial model FreeConvectionHeatTransfer_Gas "Heat Transfer due to natural Convection"



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
  //             Visible Parameters
  // _____________________________________________

  replaceable parameter TILMedia.GasTypes.BaseGas medium constrainedby TILMedia.GasTypes.BaseGas "type record of the gas or gas mixture" annotation (choicesAllMatching=true);

  parameter Boolean useMassFractionDefault=false;
  parameter Modelica.Units.SI.Pressure p=101300 "pressure of fluid";
  parameter Modelica.Units.SI.Area A "Area through which heat is transported by Convection";
  parameter Modelica.Units.SI.Length L "specific lenght of geometry";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Units.SI.ThermalConductivity lamda=gas.transp.lambda "Thermal conductivity of fluid at T_m";
  Modelica.Units.SI.Density rho=gas.d "Density of fluid at T_m";
  Modelica.Units.SI.PrandtlNumber Pr=gas.transp.Pr "Prandtl number of the fluid";
  Modelica.Units.SI.KinematicViscosity nue=gas.transp.eta/gas.d;
  Modelica.Units.SI.DynamicViscosity eta=gas.transp.eta;

  Modelica.Units.SI.LinearExpansionCoefficient beta=gas.beta "Isobaric thermal expansion coefficient at given conditions";
  Modelica.Units.SI.CoefficientOfHeatTransfer alpha=Nu*gas.transp.lambda/L "heat transfer coefficient of convection";
  Modelica.Units.SI.SpecificHeatCapacityAtConstantPressure cp=gas.cp "specific heat capacity of fluid at given conditions";
  Modelica.Units.SI.RayleighNumber Ra=RayleighNumber(
      l=L,
      beta=beta,
      dT=dT,
      Pr=gas.transp.Pr,
      nue=gas.transp.eta/gas.d);
  Modelica.Units.SI.NusseltNumber Nu "Nusselt Number ";
  Modelica.Units.SI.MassFraction xi[medium.nc - 1]=gas.gasType.xi_default "Mass Fraction" annotation (Dialog(group="Variables", enable=not (useMassFractioDefault)));
  Modelica.Units.SI.HeatFlowRate Q_flow "Heat flow rate from solid -> fluid";
  Modelica.Units.SI.TemperatureDifference dT "= solid.T - fluid.T";
  Modelica.Units.SI.Temperature T_m=(heat_solid.T + heat_fluid.T)/2;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  ClaRa.Basics.Interfaces.HeatPort_a heat_solid annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  ClaRa.Basics.Interfaces.HeatPort_b heat_fluid annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  TILMedia.Gas_pT gas(
    gasType=medium,
    T=T_m,
    p=p,
    computeTransportProperties=true,
    xi=xi) annotation (Placement(transformation(extent={{-4,-12},{16,8}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  dT = heat_solid.T - heat_fluid.T;
  heat_solid.Q_flow = Q_flow;
  heat_fluid.Q_flow = -Q_flow;
  Q_flow = A*alpha*dT;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-62,80},{98,-80}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,80},{-60,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{-150,-90},{150,-130}},
          textString="%name",
          lineColor={0,0,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{-60,20},{76,20}}, color={191,0,0}),
        Line(points={{-60,-20},{76,-20}}, color={191,0,0}),
        Line(points={{-34,80},{-34,-80}}, color={0,127,255}),
        Line(points={{6,80},{6,-80}}, color={0,127,255}),
        Line(points={{40,80},{40,-80}}, color={0,127,255}),
        Line(points={{76,80},{76,-80}}, color={0,127,255}),
        Line(points={{-34,-80},{-44,-60}}, color={0,127,255}),
        Line(points={{-34,-80},{-24,-60}}, color={0,127,255}),
        Line(points={{6,-80},{-4,-60}}, color={0,127,255}),
        Line(points={{6,-80},{16,-60}}, color={0,127,255}),
        Line(points={{40,-80},{30,-60}}, color={0,127,255}),
        Line(points={{40,-80},{50,-60}}, color={0,127,255}),
        Line(points={{76,-80},{66,-60}}, color={0,127,255}),
        Line(points={{76,-80},{86,-60}}, color={0,127,255}),
        Line(points={{56,-30},{76,-20}}, color={191,0,0}),
        Line(points={{56,-10},{76,-20}}, color={191,0,0}),
        Line(points={{56,10},{76,20}}, color={191,0,0}),
        Line(points={{56,30},{76,20}}, color={191,0,0})}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model of linear heat convection, e.g., the heat transfer between a plate and the surrounding air; see also: ConvectiveResistor. It may be used for complicated solid geometries and fluid flow over the solid by determining the convective thermal conductance Gc by measurements.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p><span style=\"font-family: (Default);\">HeatPort_a:&nbsp;heat_solid</span></p>
<p><span style=\"font-family: (Default);\">HeatPort_b:&nbsp;heat_fluid</span></p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The basic constitutive equation for convection is </p>
<p>Q_flow = A * alpha *(solid.T - fluid.T);</p>
<p>Q_flow: Heat flow rate from connector &apos;solid&apos; (e.g., a plate)</p>
<p>to connector &apos;fluid&apos; (e.g., the surrounding air)</p>
<p><br>A: Convection area (e.g., perimeter*length of a box)</p>
<p>alpha: Heat transfer coefficient</p>
<p>where the heat transfer coefficient alpha is calculated from properties of the fluid flowing over the solid. Examples: </p>
<p>Heat transfer by Free convection: External Flows (acording to W.Kast, et al.: VDI Heat Atlas, 2nd english edition, Springerl, 2010, p.667): </p>
<p>alpha = Nu*lamda/l;</p>
<p>Nu = f(Ra, Pr, Geometry)</p>
<p>where</p>
<p>alpha : Heat transfer coefficient</p>
<p>Nu : = alpha*l/lambda (Nusselt number)</p>
<p>Ra : = g*l^3*beta*dT (Rayleigh number)</p>
<p>Pr : = cp*eta/lambda (Prandtl number)</p>
<p>g : = Accelaration of gravity</p>
<p>l : characteristic length</p>
<p>height: height (characteristic lenght of vertical cylinder)</p>
<p>D : diameter of cylinder</p>
<p>rho : density of fluid (material constant)</p>
<p>eta : dynamic viscosity of fluid (material constant)</p>
<p>cp : specific heat capacity of fluid (material constant)</p>
<p>lambda : thermal conductivity of fluid (material constant)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] W.Kast, et al.: VDI Heat Atlas, 2nd english edition, Springerl, 2010, p.667</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,80},{-80,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Text(
          extent={{-40,40},{80,20}},
          lineColor={255,0,0},
          textString="Q_flow"),
        Line(points={{-76,20},{76,20}}, color={191,0,0}),
        Line(points={{-76,-20},{76,-20}}, color={191,0,0}),
        Line(points={{-50,80},{-50,-80}}, color={0,127,255}),
        Line(points={{-8,80},{-8,-80}}, color={0,127,255}),
        Line(points={{34,80},{34,-80}}, color={0,127,255}),
        Line(points={{76,80},{76,-80}}, color={0,127,255}),
        Line(points={{-50,-80},{-60,-60}}, color={0,127,255}),
        Line(points={{-50,-80},{-40,-60}}, color={0,127,255}),
        Line(points={{-8,-80},{-18,-60}}, color={0,127,255}),
        Line(points={{-8,-80},{2,-60}}, color={0,127,255}),
        Line(points={{34,-80},{24,-60}}, color={0,127,255}),
        Line(points={{34,-80},{44,-60}}, color={0,127,255}),
        Line(points={{76,-80},{66,-60}}, color={0,127,255}),
        Line(points={{76,-80},{86,-60}}, color={0,127,255}),
        Line(points={{56,-30},{76,-20}}, color={191,0,0}),
        Line(points={{56,-10},{76,-20}}, color={191,0,0}),
        Line(points={{56,10},{76,20}}, color={191,0,0}),
        Line(points={{56,30},{76,20}}, color={191,0,0})}));
end FreeConvectionHeatTransfer_Gas;
