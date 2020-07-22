within TransiEnt.Producer.Gas.MethanatorSystem;
model MethanatorSystem_L1
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

  extends TransiEnt.Producer.Gas.MethanatorSystem.PartialMethanatorSystem(N_cv=1);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompIn(medium=medium, compositionDefinedBy=2,
    flowDefinition=3)                                                                                       annotation (Placement(transformation(extent={{-82,0},{-70,12}})));

public
  inner Summary summary(
      gasPortIn(
      mediumModel=medium,
      xi=gasIn.xi,
      x=gasIn.x,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasPortIn.p,
      h=gasIn.h,
      rho=gasIn.d),
    gasPortOut(
      mediumModel=medium,
      xi=gasOut.xi,
      x=gasOut.x,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=gasOut.h,
      rho=gasOut.d),
     outline(
      N_cv=N_cv,
      Q_flow=Q_flow,
      T_flueGas=T_nom,
      H_flow_n_methanation_H2=H_flow_in_NCV,
      H_flow_n_methanation_CH4=H_flow_out_NCV,
      mass_SNG=mass_SNG,
      eta_NCV=eta_NCV),
   costs(
      costs=collectCosts.costsCollector.Costs,
      investCosts=collectCosts.costsCollector.InvestCosts,
      demandCosts=collectCosts.costsCollector.DemandCosts,
      oMCosts=collectCosts.costsCollector.OMCosts,
      otherCosts=collectCosts.costsCollector.OtherCosts,
      revenues=collectCosts.costsCollector.Revenues))
        annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    parameter Integer N_cv "Number of control volumes";
    input SI.HeatFlowRate Q_flow "Heat flow rate";
    input SI.Temperature T_flueGas[N_cv] "Flue gas temperature";
    input SI.Power H_flow_n_methanation_H2 "approximated nominal power of reactor based on NCV of hydrogen input";
    input SI.Power H_flow_n_methanation_CH4 "approximated nominal power of reactor based on NCV of methane outpur";
    input SI.Mass mass_SNG "produced mass SNG";
    input SI.Efficiency eta_NCV "efficiency based on NCV";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    Outline outline;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;

   TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
     der_E_n=if scalingOfReactor== 1 then m_flow_n_Methane*50.013e6 elseif scalingOfReactor==2 then m_flow_n_Hydrogen*119.972e6*0.83 elseif scalingOfReactor==3 then H_flow_n_Methane else H_flow_n_Hydrogen*0.83,
     redeclare model CostRecordGeneral = CostSpecsGeneral,
     produces_P_el=false,
     consumes_P_el=false,
     produces_Q_flow=false,
     consumes_Q_flow=false,
     produces_H_flow=false,
     consumes_H_flow=false,
     produces_other_flow=false,
     consumes_other_flow=false,
     produces_m_flow_CDE=false,
     consumes_m_flow_CDE=false) annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    h=inStream(gasPortIn.h_outflow),
    p=gasPortIn.p,
    xi=inStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true,
    vleFluidType=medium) annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    deactivateTwoPhaseRegion=true,
    vleFluidType=medium,
    p=gasPortOut.p,
    xi=gasPortOut.xi_outflow,
    h=gasPortOut.h_outflow) annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

public
  parameter Real conversionFactor_H2=0.9889744935 "fraction of hydrogen that is methanated" annotation (Dialog(tab="General", group="General"));
  parameter SI.Temperature T_out_coolant_max_set=700+273.15 "technically feasible limitation for coolant output temperature" annotation (Dialog(enable=useFluidCoolantPort,group="Coolant"));
  final parameter SI.MolarMass M_H2O= 18.01528;
  final parameter SI.MolarMass M_H2= 2.01588;
  final parameter SI.MolarMass M_CO2= 44.0095;
  final parameter SI.MolarMass M_CH4= 16.0425;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

 SI.Mass mass_SNG "total produced SNG";
 SI.MassFlowRate m_flow_bypass;
 SI.MassFlowRate m_flow_methanator_in_H2;
 SI.MassFlowRate m_flow_methanator_out;
 SI.MassFlowRate m_flow_methanator_out_CH4;
 SI.MassFlowRate m_flow_methanator_out_CO2;
 SI.MassFlowRate m_flow_methanator_out_H2;
 SI.MassFlowRate m_flow_methanator_out_H2O;
 SI.MassFlowRate m_flow_out;
 SI.MassFraction composition_methanator_out_dried[6];
 SI.MassFraction composition_out[6];
 SI.VolumeFraction x_H2 "calculated hydrogen volume fraction in output";

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi(medium=medium) annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=-m_flow_out)                               annotation (Placement(transformation(extent={{-16,16},{4,36}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Sink_CO2(
    medium=medium,
    variable_m_flow=true,
    xi_const={0,0,0,0,0,1},
    T_const=493.15) if useCO2Input annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-60,-78})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=m_flow_methanator_in_H2)
                                                         annotation (Placement(transformation(extent={{-72,-40},{-58,-26}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=x_H2)
                                                         annotation (Placement(transformation(extent={{-38,58},{-48,70}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=hydrogenFraction_fixed) annotation (Placement(transformation(extent={{-38,66},{-48,78}})));
  TransiEnt.Basics.Blocks.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    sign=-1,
    y_max=1,
    y_min=0,
    k=3,
    Tau_i=5,
    Tau_d=5,
    initOption=501,
    y_start=1)
             annotation (Placement(transformation(extent={{-54,68},{-60,74}})));
  Modelica.Blocks.Sources.RealExpression realExpression3[6](y=composition_out)                 annotation (Placement(transformation(extent={{-16,-34},{4,-14}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow1(medium=medium,
    variable_m_flow=true,
    variable_xi=true,                                                                              T_const=T_out_SNG) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  SI.Efficiency eta_NCV "overall efficiency of reactor based on NCV";
  SI.Efficiency eta_GCV "overall efficiency of reactor based on GCV";
  SI.Power H_flow_in_NCV "inflowing enthalpy flow based on NCV";
  SI.Power H_flow_out_NCV "outflowing enthalpy flow based on NCV";
  SI.Power H_flow_in_GCV "inflowing enthalpy flow based on GCV";
  SI.Power H_flow_out_GCV "outflowing enthalpy flow based on GCV";
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompOut_Dried(
    medium=medium,
    compositionDefinedBy=2,
    flowDefinition=3) annotation (Placement(transformation(extent={{58,0},{70,12}})));
  TransiEnt.Producer.Gas.MethanatorSystem.Controller.ControllerCO2ForMethanator controllerCO2ForMethanator annotation (Placement(transformation(extent={{-40,-42},{-48,-34}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-44,-52})));

equation
  T_out_coolant_max=T_out_coolant_target;
  m_flow_methanator_in_H2 = gasPortIn.m_flow*PID.y+Modelica.Constants.eps;
  m_flow_bypass=gasPortIn.m_flow*(1-PID.y);
  m_flow_methanator_out_CH4=max(0,((m_flow_methanator_in_H2) - m_flow_methanator_out_H2)*M_CH4/(4*M_H2));
  m_flow_methanator_out_H2=max(0, (1 - conversionFactor_H2)*(m_flow_methanator_in_H2));
  m_flow_methanator_out_CO2=max(0,m_flow_methanator_out_H2*M_CO2/(4*M_H2));
  m_flow_methanator_out_H2O=max(0,M_H2O/(2*M_H2)*(m_flow_methanator_in_H2));
  m_flow_methanator_out=m_flow_methanator_out_CH4+m_flow_methanator_out_H2+m_flow_methanator_out_CO2+m_flow_methanator_out_H2O;
  composition_methanator_out_dried={m_flow_methanator_out_CH4/max(Modelica.Constants.eps,(m_flow_methanator_out-m_flow_methanator_out_H2O)),0,0,0,0,m_flow_methanator_out_CO2/max(Modelica.Constants.eps,(m_flow_methanator_out-m_flow_methanator_out_H2O))};
  m_flow_out=m_flow_methanator_out-m_flow_methanator_out_H2O+m_flow_bypass;
  composition_out={m_flow_methanator_out_CH4/max(Modelica.Constants.eps,(m_flow_methanator_out-m_flow_methanator_out_H2O+m_flow_bypass)),0,0,0,0,m_flow_methanator_out_CO2/max(Modelica.Constants.eps,(m_flow_methanator_out-m_flow_methanator_out_H2O+m_flow_bypass))};
  H_flow_in_NCV=gasPortIn.m_flow*sum(NCV*cat(1,gasIn.xi,{1-sum(gasIn.xi)}));
  H_flow_out_NCV=gasPortOut.m_flow*sum(NCV*cat(1,gasOut.xi,{1-sum(gasOut.xi)}));
  H_flow_in_GCV=gasPortIn.m_flow*sum(GCV*cat(1,gasIn.xi,{1-sum(gasIn.xi)}));
  H_flow_out_GCV=gasPortOut.m_flow*sum(GCV*cat(1,gasOut.xi,{1-sum(gasOut.xi)}));

  eta_NCV=-H_flow_out_NCV/(max(Modelica.Constants.eps,H_flow_in_NCV));
  eta_GCV=-H_flow_out_GCV/(max(Modelica.Constants.eps,H_flow_in_GCV));
  Q_flow=-(H_flow_in_GCV+H_flow_out_GCV)-Q_loss;
  m_flow_n_Hydrogen_is=m_flow_n_Hydrogen;

  if integrateMassFlow then
   der(mass_SNG)=-realExpression.y;
  else
    mass_SNG=0;
  end if;

  //x_H2=(1-sum(composition_out))/rho_H2*gasOut.d;
  x_H2=moleCompOut_Dried.fraction[7];
  connect(moleCompIn.gasPortIn, gasPortIn) annotation (Line(
      points={{-82,0},{-100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompIn.gasPortOut, boundary_pTxi.gasPort) annotation (Line(
      points={{-70,4.44089e-16},{-58,4.44089e-16},{-58,0},{-40,0}},
      color={255,255,0},
      thickness=1.5));
  if useCO2Input then
      connect(gasPortIn_CO2,Sink_CO2. gasPort) annotation (Line(
  points={{-60,-100},{-60,-84}},
  color={255,255,0},
  thickness=1.5));
  end if;
  if useVariableHydrogenFraction then
      connect(hydrogenFraction_input,PID.u_m);
  else
      connect(realExpression2.y,PID. u_m) annotation (Line(points={{-48.5,64},{-57.03,64},{-57.03,67.4}}, color={0,0,127}));
  end if;
  connect(PID.u_s,realExpression4. y) annotation (Line(points={{-53.4,71},{-48.5,71},{-48.5,72}}, color={0,0,127}));
  connect(realExpression.y, boundary_Txim_flow1.m_flow) annotation (Line(points={{5,26},{10,26},{10,6},{18,6}}, color={0,0,127}));
  connect(realExpression3.y, boundary_Txim_flow1.xi) annotation (Line(points={{5,-24},{5,-23},{18,-23},{18,-6}}, color={0,0,127}));
  connect(boundary_Txim_flow1.gasPort, moleCompOut_Dried.gasPortIn) annotation (Line(
      points={{40,0},{49,0},{49,4.44089e-16},{58,4.44089e-16}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompOut_Dried.gasPortOut, gasPortOut) annotation (Line(
      points={{70,4.44089e-16},{85,4.44089e-16},{85,0},{100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(Sink_CO2.m_flow, gain.y) annotation (Line(points={{-56.4,-70.8},{-56.4,-64},{-44,-64},{-44,-56.4}}, color={0,0,127}));
  connect(gain.u, controllerCO2ForMethanator.m_flow_CO2) annotation (Line(points={{-44,-47.2},{-44,-42.4}}, color={0,0,127}));
  connect(collectCosts.costsCollector, modelStatistics.costsCollector);

  connect(realExpression1.y, controllerCO2ForMethanator.m_flow_H2) annotation (Line(points={{-57.3,-33},{-52.65,-33},{-52.65,-38},{-48,-38}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{50,62},{84,32}},
          lineColor={28,108,200},
          textString="CH4"),
        Polygon(
          points={{30,-62},{31,-57},{33,-54},{34,-50},{34,-46},{38,-50},{40,-54},{42,-58},{42,-62},{30,-62}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,-56},{42,-68}},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255},
          pattern=LinePattern.None),
        Polygon(
          points={{52,-52},{53,-47},{55,-44},{56,-40},{56,-36},{60,-40},{62,-44},{64,-48},{64,-52},{52,-52}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{44,-74},{45,-69},{47,-66},{48,-62},{48,-58},{52,-62},{54,-66},{56,-70},{56,-74},{44,-74}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{52,-46},{64,-58}},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255},
          pattern=LinePattern.None),
        Ellipse(
          extent={{44,-68},{56,-80}},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255},
          pattern=LinePattern.None),
        Line(
          points={{16,-30},{16,-92}},
          color={28,108,200},
          arrow={Arrow.None,Arrow.Open},
          thickness=0.5,
          smooth=Smooth.Bezier)}),                               Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This represents a simplified version of the model &apos;MethanatorSystem&apos;.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This model contains no detailed physical equations, but mainly consists of a stoichiometric balance for the methanation process. The methanation process can be defined via the parameter &apos;conversionFactor_H2&apos; which defines the fraction of input hydrogen, that is methanation. With a conversion factor &lt;1 the product gas also contains H2 and CO2 besides CH4 which represents a physically realistic result.</p>
<p>Calculation of Coolant Heat Flow:</p>
<p>Via the parameteres &apos;useHeatPort&apos; or &apos;useFluidCoolantPort&apos; a heat port or two fluid ports can be activated to model the needed coolant heat flow. Only one port at a time can be modeled. When using the fluid ports the output temperature can be defined via the input &apos;T_set_coolant_out&apos;. This temperature will be limited by the technical feasible temperature. This input needs to be activated via the parameter &apos;useVariableCoolantOutputTemperature&apos;. If not used the temperature of the coolant will be equal to the technical feasible temperature, in this case defined by the parameter &apos;T_coolant_out_max_set&apos;. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: inlet for real gas</p>
<p>gasPortOut: outlet for real gas</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Jul 2019</p>
</html>"));
end MethanatorSystem_L1;
