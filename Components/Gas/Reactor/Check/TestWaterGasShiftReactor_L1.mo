within TransiEnt.Components.Gas.Reactor.Check;
model TestWaterGasShiftReactor_L1

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



  extends TransiEnt.Basics.Icons.Checkmodel;

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var vle_sg6;

  TransiEnt.Components.Gas.Reactor.WaterGasShiftReactor_L1 wGS annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source(
    medium=vle_sg6,
    m_flow_const=-17.728,
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true,
    T_const=813.15) annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink(medium=vle_sg6, variable_p=true) annotation (Placement(transformation(extent={{88,-10},{68,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    offset=-1,
    duration=1000,
    startTime=1000)
                  annotation (Placement(transformation(extent={{-120,44},{-100,64}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    offset=373.15,
    duration=1000,
    startTime=3000,
    height=1300)   annotation (Placement(transformation(extent={{-120,14},{-100,34}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    height=-29e5,
    offset=30e5,
    duration=1000,
    startTime=9000)
                   annotation (Placement(transformation(extent={{120,-4},{100,16}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=[0,0.01,0.10,0.60,0.14,0.11; 5000,0.01,0.10,0.60,0.14,0.11; 6000,0.03,0.20,0.50,0.09,0.07; 11000,0.03,0.20,0.50,0.09,0.07; 12000,0.05,0.50,0,0.20,0.20; 14000,0.05,0.50,0,0.20,0.20])
                                                                                              annotation (Placement(transformation(extent={{-120,-16},{-100,4}})));
protected
  Modelica.Units.SI.MolarFlowRate n_flow_In;
public
  Modelica.Units.SI.MolarFlowRate n_flow_C_In;
  Modelica.Units.SI.MolarFlowRate n_flow_H_In;
  Modelica.Units.SI.MolarFlowRate n_flow_O_In;
  Modelica.Units.SI.MolarFlowRate n_flow_N_In;
protected
  Modelica.Units.SI.MolarFlowRate n_flow_Out;
public
  Modelica.Units.SI.MolarFlowRate n_flow_C_Out;
  Modelica.Units.SI.MolarFlowRate n_flow_H_Out;
  Modelica.Units.SI.MolarFlowRate n_flow_O_Out;
  Modelica.Units.SI.MolarFlowRate n_flow_N_Out;

  Modelica.Units.SI.MolarFlowRate Delta_n_flow_C=n_flow_C_In - n_flow_C_Out;
  Modelica.Units.SI.MolarFlowRate Delta_n_flow_H=n_flow_H_In - n_flow_H_Out;
  Modelica.Units.SI.MolarFlowRate Delta_n_flow_O=n_flow_O_In - n_flow_O_Out;
  Modelica.Units.SI.MolarFlowRate Delta_n_flow_N=n_flow_N_In - n_flow_N_Out;

  Real rel_Delta_n_flow_C=Delta_n_flow_C/n_flow_C_In;
  Real rel_Delta_n_flow_H=Delta_n_flow_H/n_flow_H_In;
  Real rel_Delta_n_flow_O=Delta_n_flow_O/n_flow_O_In;
  Real rel_Delta_n_flow_N=Delta_n_flow_N/n_flow_N_In;

  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompIn(medium=vle_sg6, compositionDefinedBy=2) annotation (Placement(transformation(extent={{-36,0},{-16,20}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureIn(medium=vle_sg6) annotation (Placement(transformation(extent={{-62,0},{-42,20}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureOut(medium=vle_sg6) annotation (Placement(transformation(extent={{16,0},{36,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompOut(medium=vle_sg6, compositionDefinedBy=2) annotation (Placement(transformation(extent={{42,0},{62,20}})));
equation
  n_flow_In=moleCompIn.gasPortIn.m_flow/moleCompIn.molarMass;
  n_flow_Out=moleCompOut.gasPortIn.m_flow/moleCompOut.molarMass;

  n_flow_C_In=n_flow_In*(1*moleCompIn.fraction[1]+1*moleCompIn.fraction[2]+1*moleCompIn.fraction[5]);
  n_flow_C_Out=n_flow_Out*(1*moleCompOut.fraction[1]+1*moleCompOut.fraction[2]+1*moleCompOut.fraction[5]);

  n_flow_H_In=n_flow_In*(4*moleCompIn.fraction[1]+2*moleCompIn.fraction[3]+2*moleCompIn.fraction[4]);
  n_flow_H_Out=n_flow_Out*(4*moleCompOut.fraction[1]+2*moleCompOut.fraction[3]+2*moleCompOut.fraction[4]);

  n_flow_O_In=n_flow_In*(2*moleCompIn.fraction[2]+1*moleCompIn.fraction[3]+1*moleCompIn.fraction[5]);
  n_flow_O_Out=n_flow_Out*(2*moleCompOut.fraction[2]+1*moleCompOut.fraction[3]+1*moleCompOut.fraction[5]);

  n_flow_N_In=n_flow_In*2*moleCompIn.fraction[6];
  n_flow_N_Out=n_flow_Out*2*moleCompOut.fraction[6];

  connect(ramp2.y, sink.p) annotation (Line(points={{99,6},{90,6}}, color={0,0,127}));
  connect(combiTimeTable.y, source.xi) annotation (Line(points={{-99,-6},{-99,-6},{-90,-6}}, color={0,0,127}));
  connect(source.gasPort, temperatureIn.gasPortIn) annotation (Line(
      points={{-68,0},{-65,0},{-62,0}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompIn.gasPortOut, wGS.gasPortIn) annotation (Line(
      points={{-16,0},{-13,0},{-10,0}},
      color={255,255,0},
      thickness=1.5));
  connect(wGS.gasPortOut, temperatureOut.gasPortIn) annotation (Line(
      points={{10,0},{10,0},{16,0}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompOut.gasPortOut, sink.gasPort) annotation (Line(
      points={{62,0},{68,0}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureOut.gasPortOut, moleCompOut.gasPortIn) annotation (Line(
      points={{36,0},{39,0},{42,0}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureIn.gasPortOut, moleCompIn.gasPortIn) annotation (Line(
      points={{-42,0},{-39,0},{-36,0}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp.y, source.m_flow) annotation (Line(points={{-99,54},{-94,54},{-94,6},{-90,6}}, color={0,0,127}));
  connect(ramp1.y, source.T) annotation (Line(points={{-99,24},{-96,24},{-96,0},{-90,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-20},{120,100}}), graphics={ Text(
          extent={{-58,94},{58,76}},
          lineColor={0,140,72},
          textString="1000-2000 s mass flow from 1 to 2 kg/s
3000-4000 s temperature from 100 to 1400 C
5000-6000 s composition changes
9000-10000 s pressure at output from 30 to 1 bar
11000-12000 s lowering steam supply until zero"),
                                 Text(
          extent={{-80,64},{76,48}},
          lineColor={0,140,72},
          textString="check molar components C, H, O, N
check that temperature rises because of exothermic process (for insufficient steam supply the composition at the outlet changes and the temperature is invalid)
check mass flows
check pressure loss in right direction
check that everything works for insufficient steam supply (molar outflow of nitrogen is negative because of the programming)")}),
                                            Icon(graphics,
                                                 coordinateSystem(extent={{-120,-20},{120,100}})),
    experiment(StopTime=14000, __Dymola_NumberOfIntervals=700),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the WaterGasShiftReactor_L1 model</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestWaterGasShiftReactor_L1;
