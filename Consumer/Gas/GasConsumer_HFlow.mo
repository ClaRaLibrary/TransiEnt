within TransiEnt.Consumer.Gas;
model GasConsumer_HFlow "Gas sink dependent on gross calorific value"
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

  extends TransiEnt.Basics.Icons.GasSink;
  import SI = ClaRa.Basics.Units;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

   parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used" annotation (Dialog(tab="General", group="General"));
  //parameter Boolean change_of_sign=false "change of sign of table data" annotation (Dialog(tab="Sink", group="Gas Demand"));
  //parameter Real constantFactor=4.7 "constant factor multiplied with table data" annotation (Dialog(tab="Sink", group="Gas Demand"));
  //parameter SI.Time startTime=0 "startTime of m_flow" annotation (Dialog(tab="Sink", group="Gas Demand"));
  //parameter SI.EnthalpyMassSpecific h_const=1e6 "constant enthalpy" annotation (Dialog(tab="Sink", group="General"));
  parameter SI.MassFraction xi_const[medium.nc - 1]=medium.xi_default "Constant composition of medium (nc-1)" annotation (Dialog(tab="Sink", group="General"));
  parameter SI.Temperature T_const=283.15 "constant Temperature" annotation (Dialog(tab="Sink", group="General"));
  //parameter SI.EnthalpyMassSpecific h_const=2274.9 "constant specific Enthalpy" annotation (Dialog(tab="Sink", group="General"));

  parameter String mode="Consumer" annotation(Dialog(tab="General", group="Controller"),choices(choice = "Consumer" "Consumer", choice = "Producer" "Producer", choice = "Both" "Both", __Dymola_radioButtons=true));
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "Type of controller" annotation (Dialog(tab="General", group="Controller"));
  parameter Real k=1000 "Gain for controller in maximum feed in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Real Ti=0.1 "Integrator time constant for controller in maximum feed in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Real Td=0.1 "Derivative time constant for controller in maximum feed in control" annotation (Dialog(tab="General", group="Controller"));
  final parameter Integer flowDefinition = if mode == "Consumer" then 3 elseif mode == "Producer" then 4 else 1;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.EnthalpyFlowRateIn H_flow "Input for enthalpy flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={110,0})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor(xiNumber=massflowSensor.medium.nc, medium=medium)
                                                                                                        annotation (Placement(transformation(extent={{6,0},{26,20}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink(
    T_const=T_const,
    xi_const=xi_const,
    variable_m_flow=true,
    m(fixed=true),
    medium=medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={44,0})));
  Control.GCVController gCVController(
    mode=mode,
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td) annotation (Placement(transformation(extent={{82,-16},{62,4}})));
  TransiEnt.Components.Sensors.RealGas.WobbeGCVSensor vleGCVSensor(medium=medium,flowDefinition=flowDefinition)
                                                                   annotation (Placement(transformation(extent={{-24,0},{-4,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor(compositionDefinedBy=2, medium=medium,flowDefinition=flowDefinition)
                                                                                                      annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(gCVController.m_flow_desired, sink.m_flow) annotation (Line(points={{61,-6},{56,-6}}, color={0,0,127}));
  connect(massflowSensor.m_flow, gCVController.m_flow_is) annotation (Line(points={{27,10},{30,10},{30,32},{68,32},{68,4.6}}, color={0,0,127}));
  connect(vleGCVSensor.GCV, gCVController.GCV_is) annotation (Line(points={{-3,10},{2,10},{2,46},{76,46},{76,4.4}}, color={0,0,127}));
  connect(vleCompositionSensor.gasPortOut, vleGCVSensor.gasPortIn) annotation (Line(
      points={{-30,0},{-27,0},{-24,0}},
      color={255,255,0},
      thickness=1.5));
  connect(vleGCVSensor.gasPortOut, massflowSensor.gasPortIn) annotation (Line(
      points={{-4,0},{1,0},{6,0}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensor.gasPortOut, sink.gasPort) annotation (Line(
      points={{26,0},{30,0},{34,0}},
      color={255,255,0},
      thickness=1.5));
  connect(H_flow, gCVController.H_flow_set) annotation (Line(points={{110,0},{86,0},{86,-6},{83,-6}}, color={0,0,127}));
  connect(vleCompositionSensor.gasPortIn, fluidPortIn) annotation (Line(
      points={{-50,0},{-100,0},{-100,0}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),           Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Real gas consumer, simple sink with controlled mass flow rate by measured gross calorific value.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">RealGas port, RealInput for gas enthalpy flow rate</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Created by Lisa Andresen (andresen@tuhh.de) in Jun 2016</span></p>
</html>"));
end GasConsumer_HFlow;
