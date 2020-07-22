within TransiEnt.Producer.Electrical.Base;
partial model PartialNaturalGasUnit "Adds a gas interface with a mass flow defining boundary to child components"
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

  extends TransiEnt.Basics.Icons.IndustryPlant;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumGas=simCenter.gasModel1
                                                                           annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean useGasPort=true "True if gas port shall be used" annotation (Dialog(group="Fundamental Definitions"));
  parameter Boolean useSecondGasPort=false annotation(Dialog(group="Physical Constraints"));

  // _____________________________________________
  //
  //         Instances of other Classes
  // _____________________________________________
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_hxim_flow massFlowSink(
    m_flow_nom=0,
    p_nom=1000,
    m_flow_const=1,
    h_const=0,
    variable_m_flow=true,
    medium=mediumGas) if useGasPort annotation (Placement(transformation(extent={{20,72},{40,92}})));
  TransiEnt.Components.Sensors.RealGas.NCVSensor      vleNCVSensor(flowDefinition=3) if useGasPort  annotation (Placement(transformation(extent={{74,82},{54,102}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=mediumGas,m_flow(start=0)) if useGasPort annotation (Placement(transformation(extent={{92,74},{108,90}}), iconTransformation(extent={{90,-50},{110,-30}})));
protected
  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_gas if useGasPort annotation (Placement(transformation(extent={{-12,68},{28,108}})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTx massFlowSink_2(m_flow_nom=0, medium=mediumGas) if useSecondGasPort annotation (Placement(transformation(extent={{20,110},{40,130}})));
  TransiEnt.Components.Sensors.RealGas.NCVSensor vleNCVSensor_2(flowDefinition=3) if useSecondGasPort annotation (Placement(transformation(extent={{74,120},{54,140}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn_2(Medium=mediumGas, m_flow(start=0)) if useSecondGasPort annotation (Placement(transformation(extent={{92,112},{108,128}}), iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Sources.RealExpression m_flow_gas_2_var(y=massFlowSink_2.gasPort.m_flow) if useSecondGasPort annotation (Placement(transformation(extent={{74,144},{54,164}})));
  Modelica.Blocks.Math.Product H_flow_secondGasPort annotation (Placement(transformation(extent={{8,138},{-12,158}})));
  Modelica.Blocks.Sources.RealExpression m_flow_gas_2_const(y=0) if not useSecondGasPort annotation (Placement(transformation(extent={{74,158},{54,178}})));
  Modelica.Blocks.Routing.RealPassThrough m_flow_gas_2 annotation (Placement(transformation(extent={{38,148},{26,160}})));
  Modelica.Blocks.Sources.RealExpression NCV_2_const(y=0) if not useSecondGasPort annotation (Placement(transformation(extent={{74,132},{54,152}})));
  Modelica.Blocks.Routing.RealPassThrough NCV_2 annotation (Placement(transformation(extent={{38,148},{26,136}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  if useGasPort then
  connect(gasPortIn, vleNCVSensor.gasPortIn) annotation (Line(
      points={{100,82},{88,82},{74,82}},
      color={255,255,0},
      thickness=1.5));
  connect(vleNCVSensor.gasPortOut, massFlowSink.gasPort) annotation (Line(
      points={{54,82},{48,82},{40,82}},
      color={255,255,0},
      thickness=1.5));
  end if;
  connect(massFlowSink.m_flow, m_flow_gas) annotation (Line(points={{18,88},{8,88}},   color={0,0,127}));
  if useSecondGasPort then
    connect(gasPortIn_2, vleNCVSensor_2.gasPortIn) annotation (Line(
      points={{100,120},{74,120}},
      color={255,255,0},
      thickness=1.5));
    connect(vleNCVSensor_2.gasPortOut, massFlowSink_2.gasPort) annotation (Line(
      points={{54,120},{40,120}},
      color={255,255,0},
      thickness=1.5));
    connect(vleNCVSensor_2.NCV, NCV_2.u) annotation (Line(points={{53,130},{48,130},{48,142},{39.2,142}}, color={0,0,127}));
    connect(m_flow_gas_2_var.y, m_flow_gas_2.u) annotation (Line(points={{53,154},{39.2,154}}, color={0,0,127}));
  else
    connect(m_flow_gas_2_const.y, m_flow_gas_2.u) annotation (Line(points={{53,168},{48,168},{48,154},{39.2,154}}, color={0,0,127}));
    connect(NCV_2_const.y, NCV_2.u) annotation (Line(points={{53,142},{48,142},{48,142},{39.2,142}}, color={0,0,127}));
  end if;
  connect(m_flow_gas_2.y, H_flow_secondGasPort.u1) annotation (Line(points={{25.4,154},{10,154}}, color={0,0,127}));
  connect(NCV_2.y, H_flow_secondGasPort.u2) annotation (Line(points={{25.4,142},{10,142}}, color={0,0,127}));
             annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Adds a gas interface with a mass flow defining boundary to child components.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: inlet for real gas</p>
<p>gasPortIn_2: second gas port - only active if useSecondGasPort==true</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Mass Flow of first gas port must be defined within the model via &apos;m_flow_gas&apos;. Mass flow of second gas port needs to be defined from outside.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end PartialNaturalGasUnit;
