within TransiEnt.Producer.Combined.LargeScaleCHP;
model ContinuousCHP "Simple large CHP model with plant limits, time constants and fuel input matrix but without distinc operating states (always running)"

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
  extends Base.PartialCHP;

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
  parameter Boolean UseGasPort=false "Choose if gas port is used or not" annotation(Dialog(group="Fundamental Definitions"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_gas=simCenter.gasModel1 if UseGasPort==true "Gas Medium to be used - only if UseGasPort==true" annotation(Dialog(group="Fundamental Definitions",enable=if UseGasPort==true then true else false));

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

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow(T_ref(displayUnit="degC"))
     annotation (Placement(
        transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={31,-13})));

  TransiEnt.Components.Boundaries.Electrical.Power terminal(change_sign=true) annotation (Placement(transformation(extent={{80,50},{60,70}})));

  ClaRa.Components.HeatExchangers.TubeBundle_L2 HX(
    length=15,
    N_tubes=10,
    N_passes=2,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    m_flow_nom=m_flow_nom,
    p_nom(displayUnit="Pa") = p_nom,
    h_nom=h_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    h_start=h_start,
    p_start=p_nom) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={64,-12})));

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
  Consumer.Gas.GasConsumer_HFlow_NCV gasConsumer_HFlow_NCV(medium=medium_gas) if UseGasPort==true annotation (Placement(transformation(extent={{80,82},{60,102}})));
  Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium_gas) if UseGasPort==true annotation (Placement(transformation(extent={{90,92},{110,112}})));
equation

  // _____________________________________________
  //
  //         Characteristic Equations
  // _____________________________________________

  Q_flow_input = steamGenerator.u;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(prescribedHeatFlow.port, HX.heat) annotation (Line(
      points={{40,-13},{48,-13},{48,-12},{54,-12}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(outlet, HX.outlet) annotation (Line(
      points={{100,4},{65,4},{65,-2},{64,-2}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));

  connect(inlet, HX.inlet) annotation (Line(
      points={{100,-24},{64,-24},{64,-22}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));

  connect(eta_el_source.y, product.u2) annotation (Line(points={{-51,42},{-51,42},{-46,42},{-44.8,42},{-44.8,36.4},{-40.8,36.4}}, color={0,0,127}));

  connect(product.y, turboGenerator.u) annotation (Line(points={{-31.6,34},{-20.9455,34},{-20.9455,33.7058}}, color={0,0,127}));

  connect(eta_th_source.y, product1.u2) annotation (Line(points={{-51,-26},{-42,-26},{-42,-14.4},{-36.8,-14.4}}, color={0,0,127}));

  connect(turboGenerator.y, terminal.P_el_set) annotation (Line(points={{4.14541,33.7058},{26,33.7058},{26,34},{46,34},{46,78},{76,78},{76,72}},
                                                                                                                                      color={0,0,127}));

  connect(terminal.epp, epp) annotation (Line(
      points={{80,60},{72,60},{72,60},{100,60}},
      color={0,135,135},
      thickness=0.5));

  connect(steamGenerator.y, product.u1) annotation (Line(points={{-53,12},{-48,12},{-48,31.6},{-40.8,31.6}}, color={0,0,127}));
  connect(steamGenerator.y, product1.u1) annotation (Line(points={{-53,12},{-46,12},{-46,-9.6},{-36.8,-9.6}}, color={0,0,127}));
  connect(product1.y, heatingCondenser.u) annotation (Line(points={{-27.6,-12},{-23.8,-12},{-20,-12}}, color={0,0,127}));
  connect(heatingCondenser.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{3,-12},{12,-12},{12,-13},{22,-13}}, color={0,0,127}));
  connect(steamGenerator.u, Q_flow_set_SG.Q_flow_input) annotation (Line(points={{-76,12},{-86,12},{-86,14},{-86,66},{-0.909091,66},{-0.909091,79}},
                                                                                                                                     color={0,0,127}));
  connect(P_limit_on.y, Q_flow_set_SG.P) annotation (Line(points={{-21,102},{-7.27273,102},{-7.27273,102}},
                                                                                                color={0,0,127}));
  connect(P_limit_on.limit1, pQDiagram.P_max) annotation (Line(points={{-44,110},{-44,110},{-54,110},{-54,128.4},{-11,128.4}}, color={0,0,127}));
  connect(pQDiagram.P_min, P_limit_on.limit2) annotation (Line(points={{-11,121},{-60,121},{-60,94},{-44,94}}, color={0,0,127}));
  connect(P_el_set_pos.y, P_limit_on.u) annotation (Line(points={{-62.4,102},{-62.4,102},{-44,102}},         color={0,0,127}));
  connect(P_set,P_el_set_pos. u) annotation (Line(points={{-84,144},{-84,144},{-84,102},{-76.2,102}}, color={0,0,127}));
  if UseGasPort==true then
    connect(gasConsumer_HFlow_NCV.fluidPortIn,gasPortIn)  annotation (Line(
      points={{80,92},{88,92},{88,102},{100,102}},
      color={255,255,0},
      thickness=1.5));
    connect(steamGenerator.y, gasConsumer_HFlow_NCV.H_flow) annotation (Line(points={{-53,12},{-52,12},{-52,-16},{-92,-16},{-92,70},{40,70},{40,92},{59,92}},   color={0,0,127}));
  end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,140}})), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>This model represents the simplest of all large scale CHP models in the library. It allows a quick representation of a CHP plant with three main characteristics:</p>
<ul>
<li>Plant&apos;s operation limits</li>
<li>Plant&apos;s fuel input requirements based on electricity and heating outputs</li>
<li>Time delay between the plant&apos;s set point values and actual production values</li>
</ul>
<p><br>This component extends from the base class <span style=\"color: #0000ff;\">TransiEnt.Producer.Combined.LargeScaleCHPpackage.Base.BaseLargeScaleCHP</span>. </p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Two things are required for using this component: parametrisation and set-value definition</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The parametrisation of this component consists of the following steps:</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">C-Value: this corresponds to the power to heat ratio, defined as P_CHP/Q_useful. Common values can be taken from [1]</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">PQ-Boundaries: select a record representing the plant&apos;s PQ-boundaries as defined in the package: <span style=\"color: #0000ff;\">TransiEnt.Producer.Combined.LargeScaleCHPpackage.Base.PQboundariesPackage</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_input_PQDiagram: select a text file containing the fuel input matrix as defined in the component: <span style=\"color: #ee2e2f;\">TransiEnt.Distribution.Heat.HeatGridControl.HeatInput_f_PQ</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Q_max: maximum heat flow output (default: value is automatically taken from the PQ-Boundaries)</span></li>
</ul>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">The set-value definition occurs either at the </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Ricardo Peniche, 2016</span></p>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,140}})));
end ContinuousCHP;
