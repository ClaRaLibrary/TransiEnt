within TransiEnt.Consumer.Gas;
model GasConsumer_HFlow_NCV "Gas sink dependent on net calorific value"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  parameter Boolean variable_H_flow=true "True, if enthalpy flow defined by variable input" annotation (Dialog(tab="General", group="General"));
  parameter SI.EnthalpyFlowRate H_flow_const=1e6 "Constant enthalpy flow rate" annotation (Dialog(tab="General", group="General",enable=not variable_H_flow));
  parameter String mode="Consumer" annotation(Dialog(tab="General", group="Controller"),choices(choice = "Consumer" "Consumer", choice = "Producer" "Producer", choice = "Both" "Both", __Dymola_radioButtons=true));
  parameter Boolean usePIDcontroller=true "if 'true' m_flow_desired' is calculated by PID" annotation (Dialog(tab="General", group="Controller"));
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "Type of controller" annotation (Dialog(tab="General", group="Controller"));
  parameter Real k=1000 "Gain for controller in maximum feed in control" annotation (Dialog(tab="General",  group="Controller"));
  parameter Real Ti=0.1 "Integrator time constant for controller in maximum feed in control" annotation (Dialog(tab="General",  group="Controller"));
  parameter Real Td=0.1 "Derivative time constant for controller in maximum feed in control" annotation (Dialog(tab="General",  group="Controller"));
  parameter Integer flowDefinition = if mode == "Consumer" then 3 elseif mode == "Producer" then 4 else 2 "Flow definition for sensors" annotation (Dialog(tab="General", group="General"),choices(choice = 1 "both", choice = 2 "both, noEvent", choice = 3 "in -> out", choice = 4 "out -> in"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.EnthalpyFlowRateIn H_flow if variable_H_flow "Input for enthalpy flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={110,0})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor(xiNumber=0,                        medium=medium)
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
  Control.NCVController nCVController(
    mode=mode,
    usePIDcontroller=usePIDcontroller,
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td) annotation (Placement(transformation(extent={{82,-16},{62,4}})));
  Components.Sensors.RealGas.NCVSensor                vleNCVSensor(medium=medium,flowDefinition=flowDefinition)
                                                                   annotation (Placement(transformation(extent={{-24,0},{-4,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor(compositionDefinedBy=2, medium=medium,flowDefinition=flowDefinition)
                                                                                                      annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Modelica.Blocks.Sources.Constant H_flow_const_(k=H_flow_const) if not variable_H_flow;
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(nCVController.m_flow_desired, sink.m_flow) annotation (Line(points={{61,-6},{56,-6}}, color={0,0,127}));
  connect(massflowSensor.m_flow,nCVController. m_flow_is) annotation (Line(points={{27,10},{30,10},{30,32},{68,32},{68,4.6}}, color={0,0,127}));
  connect(vleCompositionSensor.gasPortOut,vleNCVSensor. gasPortIn) annotation (Line(
      points={{-30,0},{-27,0},{-24,0}},
      color={255,255,0},
      thickness=1.5));
  connect(vleNCVSensor.gasPortOut, massflowSensor.gasPortIn) annotation (Line(
      points={{-4,0},{1,0},{6,0}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensor.gasPortOut, sink.gasPort) annotation (Line(
      points={{26,0},{30,0},{34,0}},
      color={255,255,0},
      thickness=1.5));
  connect(H_flow,nCVController. H_flow_set) annotation (Line(points={{110,0},{86,0},{86,-6},{83,-6}}, color={0,0,127}));
  connect(vleCompositionSensor.gasPortIn, fluidPortIn) annotation (Line(
      points={{-50,0},{-100,0},{-100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(vleNCVSensor.NCV_InToOut, nCVController.NCV_is_sink) annotation (Line(points={{-3,14},{0,14},{0,40},{76,40},{76,4.6}}, color={0,0,127}));
  connect(vleNCVSensor.NCV_OutToIn, nCVController.NCV_is_source) annotation (Line(points={{-3,6},{2,6},{2,36},{72,36},{72,4.6}}, color={0,0,127}));
  connect(H_flow_const_.y,nCVController.H_flow_set);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),           Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Real gas consumer, simple sink with controlled mass flow rate by measured net calorific value.</span></p>
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
end GasConsumer_HFlow_NCV;
