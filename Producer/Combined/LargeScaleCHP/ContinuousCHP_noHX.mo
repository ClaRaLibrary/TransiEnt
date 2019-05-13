within TransiEnt.Producer.Combined.LargeScaleCHP;
model ContinuousCHP_noHX "Simple large CHP model with plant limits, time constants and fuel input matrix but without distinc operating states (always running)"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
  extends Base.PartialCHP(m_flow_cde_total=m_flow_cde_total_set);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real P_grad_max_star=0.03/60 "Fraction of nominal power per second (12% per minute)" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time T_steamGenerator = 0.5*(0.632/P_grad_max_star) "Time constant of steam generator (overrides value of P_grad_max_star)" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time T_turboGenerator = 60 "Time constant of turbo generator" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time T_heatingCondenser = 40 "Time constant of heating condenser" annotation(Dialog(group="Physical Constraints"));

     //Heating condenser parameters

  parameter Modelica.SIunits.Pressure p_nom(displayUnit="Pa")=1e5 "Nominal pressure" annotation(Dialog(group="Heating condenser parameters"));

  parameter SI.MassFlowRate m_flow_nom=10 "Nominal mass flow rate" annotation(Dialog(group="Heating condenser parameters"));

  parameter SI.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy" annotation(Dialog(group="Heating condenser parameters"));

  parameter SI.Temperature T_feed_init = 120+273.15 "Start temperature of feed water" annotation(Dialog(group="Initialization", tab="Advanced"));

  final parameter SI.SpecificEnthalpy h_start=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
      medium,
      p_nom,
      T_feed_init) "Start value of sytsem specific enthalpy" annotation(Dialog(group="Heating condenser parameters"));
  parameter Boolean useGasPort=false "Choose if gas port is used or not" annotation(Dialog(group="Fundamental Definitions"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_gas=simCenter.gasModel1 if useGasPort==true "Gas Medium to be used - only if useGasPort==true" annotation(Dialog(group="Fundamental Definitions",enable=if useGasPort==true then true else false));

  // _____________________________________________
  //
  //                Components
  // _____________________________________________

  Modelica.Blocks.Continuous.FirstOrder turboGenerator(
    T=T_turboGenerator,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=P_el_init) annotation (Placement(visible=true, transformation(
        origin={-7.8546,33.7058},
        extent={{-10.9091,-10.9091},{10.9091,10.9091}},
        rotation=0)));

  Modelica.Blocks.Continuous.FirstOrder steamGenerator(
    T=T_steamGenerator,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=if useEfficiencyForInit then P_el_init/eta_el_init else Q_flow_SG_init) annotation (Placement(transformation(extent={{-74,2},{-54,22}})));

  Modelica.Blocks.Continuous.FirstOrder heatingCondenser(
    T=T_heatingCondenser,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=Q_flow_init)                              annotation (Placement(transformation(extent={{-18,-22},{2,-2}})));

  replaceable TransiEnt.Components.Boundaries.Electrical.Power terminal(change_sign=true) constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary  annotation (choicesAllMatching=true,Placement(transformation(extent={{80,50},{60,70}})));

  Modelica.Blocks.Sources.RealExpression eta_el_source(y=eta_el_target)
                                                                 annotation (Placement(transformation(extent={{-72,32},{-52,52}})));

  Modelica.Blocks.Math.Product product annotation (Placement(transformation(extent={{-40,38},{-32,30}})));

  Modelica.Blocks.Sources.RealExpression eta_th_source(y=eta_th_target)
                                                                 annotation (Placement(transformation(extent={{-72,-36},{-52,-16}})));

  Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(extent={{-36,-16},{-28,-8}})));

  Modelica.Blocks.Nonlinear.VariableLimiter P_limit_on annotation (Placement(transformation(extent={{-42,92},{-22,112}})));
  Modelica.Blocks.Math.Gain P_el_set_pos(k=-1) "Sign changed electric setpoint (>0)"
                                               annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-69,102})));
  Consumer.Gas.GasConsumer_HFlow_NCV gasConsumer_HFlow_NCV(medium=medium_gas) if useGasPort==true annotation (Placement(transformation(extent={{64,82},{44,102}})));
  Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium_gas) if useGasPort==true annotation (Placement(transformation(extent={{90,92},{110,112}})));
  Components.Sensors.RealGas.CO2EmissionSensor cO2EmissionOfIdealCombustion if useGasPort                                                 ==true annotation (Placement(transformation(extent={{86,92},{74,104}})));
  Modelica.Blocks.Math.Gain m_flow_cde_gain(k=1) annotation (Placement(transformation(extent={{68,96},{64,100}})));
protected
  Modelica.Blocks.Sources.RealExpression Zero(y=0);
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
public
  Modelica.SIunits.MassFlowRate m_flow_cde_total_set;

  Components.Boundaries.Heat.Heatflow_L1        HX(change_sign=true)
                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={54,-18})));
equation

  // _____________________________________________
  //
  //         Characteristic Equations
  // _____________________________________________
  if useGasPort==false then
    m_flow_cde_total_set=Q_flow_input*fuelSpecificEmissions.m_flow_CDE_per_Energy;
  else
    m_flow_cde_total_set=m_flow_cde_gain.y;
  end if;

  Q_flow_input = steamGenerator.u;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(eta_el_source.y, product.u2) annotation (Line(points={{-51,42},{-51,42},{-46,42},{-44.8,42},{-44.8,36.4},{-40.8,36.4}}, color={0,0,127}));

  connect(product.y, turboGenerator.u) annotation (Line(points={{-31.6,34},{-20.9455,34},{-20.9455,33.7058}}, color={0,0,127}));

  connect(eta_th_source.y, product1.u2) annotation (Line(points={{-51,-26},{-42,-26},{-42,-14.4},{-36.8,-14.4}}, color={0,0,127}));

  connect(turboGenerator.y, terminal.P_el_set) annotation (Line(points={{4.14541,33.7058},{24,33.7058},{24,30},{44,30},{44,74},{76,74},{76,72}},
                                                                                                                                      color={0,0,127}));

  connect(terminal.epp, epp) annotation (Line(
      points={{80,60},{72,60},{72,60},{100,60}},
      color={0,135,135},
      thickness=0.5));

  connect(steamGenerator.y, product.u1) annotation (Line(points={{-53,12},{-48,12},{-48,31.6},{-40.8,31.6}}, color={0,0,127}));
  connect(steamGenerator.y, product1.u1) annotation (Line(points={{-53,12},{-46,12},{-46,-9.6},{-36.8,-9.6}}, color={0,0,127}));
  connect(product1.y, heatingCondenser.u) annotation (Line(points={{-27.6,-12},{-23.8,-12},{-20,-12}}, color={0,0,127}));
  connect(steamGenerator.u, Q_flow_set_SG.Q_flow_input) annotation (Line(points={{-76,12},{-86,12},{-86,14},{-86,66},{-0.909091,66},{-0.909091,79}},
                                                                                                                                     color={0,0,127}));
  connect(P_limit_on.y, Q_flow_set_SG.P) annotation (Line(points={{-21,102},{-7.27273,102},{-7.27273,102}},
                                                                                                color={0,0,127}));
  connect(P_limit_on.limit1, pQDiagram.P_max) annotation (Line(points={{-44,110},{-44,110},{-54,110},{-54,128.4},{-11,128.4}}, color={0,0,127}));
  connect(pQDiagram.P_min, P_limit_on.limit2) annotation (Line(points={{-11,121},{-60,121},{-60,94},{-44,94}}, color={0,0,127}));
  connect(P_el_set_pos.y, P_limit_on.u) annotation (Line(points={{-62.4,102},{-62.4,102},{-44,102}},         color={0,0,127}));
  connect(P_set,P_el_set_pos. u) annotation (Line(points={{-84,144},{-84,144},{-84,102},{-76.2,102}}, color={0,0,127}));
  if useGasPort==true then
    connect(steamGenerator.y, gasConsumer_HFlow_NCV.H_flow) annotation (Line(points={{-53,12},{-52,12},{-52,-16},{-92,-16},{-92,70},{40,70},{40,92},{43,92}},   color={0,0,127}));

    connect(cO2EmissionOfIdealCombustion.m_flow_cde,m_flow_cde_gain. u) annotation (Line(points={{73.4,102.08},{70,102.08},{70,98},{68.4,98}},
                                                                                                                                    color={0,0,127}));
    connect(gasConsumer_HFlow_NCV.fluidPortIn, cO2EmissionOfIdealCombustion.gasPortOut) annotation (Line(
      points={{64,92},{74,92}},
      color={255,255,0},
      thickness=1.5));
    connect(cO2EmissionOfIdealCombustion.gasPortIn, gasPortIn) annotation (Line(
      points={{86,92},{92,92},{92,102},{100,102}},
      color={255,255,0},
      thickness=1.5));
  else
     connect(Zero.y,m_flow_cde_gain.u);
  end if;
  connect(heatingCondenser.y, HX.Q_flow_prescribed) annotation (Line(points={{3,-12},{24,-12},{24,-24},{46,-24}}, color={0,0,127}));
  connect(T_out_sensor.port, HX.fluidPortOut) annotation (Line(
      points={{78,4},{72,4},{72,-12},{64,-12}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_in_sensor.port, HX.fluidPortIn) annotation (Line(
      points={{78,-42},{72,-42},{72,-24},{64,-24}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,140}})), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>This model is equal to the model &apos;ContinuousCHP&apos; except for that the heat exchanger model is exchanged by a simple heat boundary</p><p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) on Nov 2018</span></p>
</html>"),
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,140}})));
end ContinuousCHP_noHX;
