within TransiEnt.Consumer.Gas;
model GasConsumer_HFlow "Gas sink dependent on gross calorific value"
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
  extends TransiEnt.Basics.Icons.GasSink;
  import SI = ClaRa.Basics.Units;
  outer TransiEnt.SimCenter simCenter;
   parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "|General|Medium to be used";
  //parameter Boolean change_of_sign=false "|Sink|Gas Demand|change of sign of table data";
  //parameter Real constantFactor=4.7 "|Sink|Gas Demand|constant factor multiplied with table data";
  //parameter SI.Time startTime=0 "|Sink|Gas Demand|startTime of m_flow";
  //parameter SI.EnthalpyMassSpecific h_const=1e6 "|Sink|General|constant enthalpy";
  parameter SI.MassFraction xi_const[medium.nc - 1]=medium.xi_default "|Sink|General|Constant composition of medium (nc-1)";
  parameter SI.Temperature T_const=283.15 "|Sink|General|constant Temperature";
  //parameter SI.EnthalpyMassSpecific h_const=2274.9 "|Sink|General|constant specific Enthalpy";

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "|Controller|Type of controller";
  parameter Real k=1000 "|Controller|Gain for controller in maximum feed in control";
  parameter Real Ti=0.1 "|Controller|Integrator time constant for controller in maximum feed in control";
  parameter Real Td=0.1 "|Controller|Derivative time constant for controller in maximum feed in control";

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealInput H_flow annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={110,0})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor(xiNumber=massflowSensor.medium.nc) annotation (Placement(transformation(extent={{6,0},{26,20}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink(
    medium=simCenter.gasModel1,
    T_const=T_const,
    xi_const=xi_const,
    variable_m_flow=true,
    m(fixed=true)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={44,0})));
  Control.GCVController gCVController(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td) annotation (Placement(transformation(extent={{82,-16},{62,4}})));
  TransiEnt.Components.Sensors.RealGas.WobbeGCVSensor vleGCVSensor annotation (Placement(transformation(extent={{-24,0},{-4,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
equation

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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),           Documentation(info="<html>
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
