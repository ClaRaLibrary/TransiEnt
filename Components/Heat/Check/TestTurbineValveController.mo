within TransiEnt.Components.Heat.Check;
model TestTurbineValveController
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
  extends Basics.Icons.Checkmodel;
  Controller.TurbineValveController Valve_Fixed_Pressure(controlStrategy=TransiEnt.Basics.Types.ClaRaPlantControlStrategy.FP) annotation (Placement(transformation(extent={{-10,22},{26,52}})));
  Modelica.Blocks.Sources.Ramp P_set(
    height=1,
    duration=10,
    offset=0,
    startTime=0) annotation (Placement(transformation(extent={{-88,16},{-68,36}})));
  Controller.TurbineValveController Valve_Natural_Sliding_Pressure(controlStrategy=TransiEnt.Basics.Types.ClaRaPlantControlStrategy.NSP, y_T_slp=0.9) annotation (Placement(transformation(extent={{-12,-32},{24,-2}})));
  Controller.TurbineValveController Valve_Modified_Sliding_Pressure(
    controlStrategy=TransiEnt.Basics.Types.ClaRaPlantControlStrategy.MSP,
    m_T_set_slp_end=0.9,
    y_T_slp=0.9) annotation (Placement(transformation(extent={{-12,-78},{24,-48}})));
equation
  connect(P_set.y, Valve_Fixed_Pressure.P_T_set) annotation (Line(points={{-67,26},{-28,26},{-28,38},{-16,38},{-8.56,38},{-8.56,37.3}}, color={0,0,127}));
  connect(Valve_Natural_Sliding_Pressure.P_T_set, P_set.y) annotation (Line(points={{-10.56,-16.7},{-30,-16.7},{-30,26},{-67,26}}, color={0,0,127}));
  connect(P_set.y, Valve_Modified_Sliding_Pressure.P_T_set) annotation (Line(points={{-67,26},{-30,26},{-30,-62.7},{-10.56,-62.7}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-90,98},{22,50}},
          lineColor={0,0,0},
          textString="Look at:
P_set.y
Valve_Fixed_Pressure.y_T_set
Valve_Natural_Sliding_Pressure.y_T_set
Valve_Modified_Sliding_Pressure.y_T_set")}),
    experiment(StopTime=12),
    __Dymola_experimentSetupOutput);
end TestTurbineValveController;
