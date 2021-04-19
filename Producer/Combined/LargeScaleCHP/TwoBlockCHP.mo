within TransiEnt.Producer.Combined.LargeScaleCHP;
model TwoBlockCHP "Example model of plants consisting of several units"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  extends TransiEnt.Basics.Icons.SteamCyclewHeatingCondenser2Blocks;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  Modelica.SIunits.Power P_out_net(displayUnit="MW");
  Modelica.SIunits.HeatFlowRate Q_flow_gen(displayUnit="MW");

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Boolean useGasPort=false "Choose if gas port is used or not" annotation(Dialog(group="Fundamental Definitions"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_gas=simCenter.gasModel1 if useGasPort==true "Gas Medium to be used - only if useGasPort==true" annotation(Dialog(group="Fundamental Definitions",enable=if useGasPort==true then true else false));

  // _____________________________________________
  //
  //                  Components
  // _____________________________________________

  //Visualization
  Basics.Interfaces.General.EyeOut eye annotation (Placement(transformation(extent={{240,-124},{260,-104}}), iconTransformation(extent={{240,-124},{260,-104}})));

   //Complex Components
  replaceable ContinuousCHP Block_1(
    PQCharacteristics=Base.Characteristics.PQ_Characteristics_WW1(),
    P_el_n = 150.369e6,
    useGasPort=useGasPort)
                        constrainedby Base.PartialCHP annotation (choicesAllMatching=true, Placement(transformation(extent={{-46,16},{-26,36}})));

  replaceable ContinuousCHP Block_2(
    PQCharacteristics=Base.Characteristics.PQ_Characteristics_WW2(),
    P_el_n = 137.106e6,
    useGasPort=useGasPort)
                         constrainedby Base.PartialCHP annotation (choicesAllMatching=true, Placement(transformation(extent={{-4,14},{16,34}})));

  //Boundaries
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow massflow_Tm_flow4(variable_m_flow=true, variable_T=true) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={-19,4})));

  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow massflow_Tm_flow3(variable_m_flow=true, variable_T=true) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={19,4})));

  //Visualization

  Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP2 annotation (Placement(transformation(extent={{52,-78},{98,-18}})));
  Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP3 annotation (Placement(transformation(extent={{-58,-78},{-104,-18}})));

  // Interfaces
  Basics.Interfaces.Electrical.ElectricPowerIn P_set_B1 "Set power B1" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-82,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-182,170})));
  Basics.Interfaces.Electrical.ElectricPowerIn P_set_B2 "Set power B2" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={28,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={78,170})));
  Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set_B1 "Set heat flow rate B1" annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={-41,111}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={-74,170})));
  Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set_B2 "Set heat flow rate B2" annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={71,111}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={164,172})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_set_B1 "Set mass flow rate B1" annotation (Placement(transformation(
        extent={{-13,-13},{13,13}},
        rotation=90,
        origin={-57,-100}), iconTransformation(
        extent={{-13,-13},{13,13}},
        rotation=90,
        origin={-174,-146})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_set_B2 "Set mass flow rate B2" annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={48,-100}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={112,-148})));
  Basics.Interfaces.General.TemperatureIn T_return_B2 "Set return temperature B2" annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={84,-100}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={184,-146})));
  Basics.Interfaces.Thermal.FluidPortOut outlet(Medium=medium) annotation (Placement(transformation(extent={{240,-28},{260,-8}}), iconTransformation(extent={{240,-28},{260,-8}})));
  Basics.Interfaces.General.TemperatureIn T_return_B1 "Set return temperature B1" annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={-30,-100}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={-98,-146})));
  Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{238,122},{258,142}}), iconTransformation(extent={{238,122},{258,142}})));

  Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium_gas) if useGasPort==true annotation (Placement(transformation(extent={{240,72},{260,92}})));


  //Sensors
  Components.Sensors.TemperatureSensor T_out_sensor annotation (Placement(transformation(extent={{114,26},{134,46}})));
  Components.Sensors.TemperatureSensor T_in_sensor annotation (Placement(transformation(extent={{72,-2},{92,18}})));

  Basics.Interfaces.General.EyeOut eye_Block1 annotation (Placement(transformation(extent={{240,-152},{260,-132}}), iconTransformation(extent={{240,-148},{260,-128}})));
  Basics.Interfaces.General.EyeOut eye_Block2 annotation (Placement(transformation(extent={{240,-176},{260,-156}}), iconTransformation(extent={{240,-170},{260,-150}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Summary Values
  P_out_net=-1*epp.P;
  Q_flow_gen=-1*outlet.m_flow*(outlet.h_outflow-inStream(Block_1.inlet.h_outflow));

  //Eye values
  eye.P=P_out_net;
  eye.Q_flow=Q_flow_gen;
  eye.T_supply=T_out_sensor.T_celsius;
  eye.T_return=T_in_sensor.T_celsius;
  eye.p = outlet.p/1e5;
  eye.h_supply = outlet.h_outflow/1e3;
  eye.h_return = Block_1.inlet.h_outflow/1e3;
  eye.m_flow = -outlet.m_flow;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  //Connect statements

  connect(massflow_Tm_flow4.fluidPortOut, Block_1.inlet) annotation (Line(
      points={{-19,8},{-19,22},{-25.8,22},{-25.8,21.5}},
      color={175,0,0},
      thickness=0.5));
  connect(massflow_Tm_flow3.fluidPortOut, Block_2.inlet) annotation (Line(
      points={{19,8},{19,20},{16.2,20},{16.2,19.5}},
      color={175,0,0},
      thickness=0.5));
  connect(Block_1.eye, infoBoxLargeCHP3.eye) annotation (Line(points={{-25,16.8333},{-24,16.8333},{-24,16},{-24,0},{-56,0},{-60.3,0},{-60.3,-43.0909}},
                                                                                                    color={28,108,200}));
  connect(Block_2.eye, infoBoxLargeCHP2.eye) annotation (Line(points={{17,14.8333},{27.5,14.8333},{27.5,-43.0909},{54.3,-43.0909}},
                                                                                                    color={28,108,200}));
  connect(P_set_B1, Block_1.P_set) annotation (Line(
      points={{-82,110},{-82,80},{-56,80},{-56,58},{-42.1,58},{-42.1,33.6667}},
      color={0,135,135},
      thickness=0.5));
  connect(Q_flow_set_B1, Block_1.Q_flow_set) annotation (Line(
      points={{-41,111},{-41,78.5},{-32.3,78.5},{-32.3,33.6667}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(P_set_B2, Block_2.P_set) annotation (Line(
      points={{28,110},{28,110},{28,80},{0,80},{0,31.6667},{-0.1,31.6667}},
      color={0,135,135},
      thickness=0.5));
  connect(Q_flow_set_B2, Block_2.Q_flow_set) annotation (Line(
      points={{71,111},{71,73.5},{9.7,73.5},{9.7,31.6667}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(m_flow_set_B1, massflow_Tm_flow4.m_flow) annotation (Line(points={{-57,-100},{-57,-7},{-20.8,-7},{-20.8,-0.8}},     color={0,0,127}));
  connect(m_flow_set_B2, massflow_Tm_flow3.m_flow) annotation (Line(points={{48,-100},{18,-100},{18,-0.8},{17.2,-0.8}},   color={0,0,127}));
  connect(T_return_B2, massflow_Tm_flow3.T) annotation (Line(points={{84,-100},{84,-100},{84,-86},{84,-86},{20.2,-86},{20.2,-0.8},{19,-0.8}},  color={0,0,127}));
  connect(Block_1.outlet, outlet) annotation (Line(
      points={{-25.8,23.8333},{-15.9,23.8333},{-15.9,-18},{250,-18}},
      color={175,0,0},
      thickness=0.5));
  connect(Block_2.outlet, outlet) annotation (Line(
      points={{16.2,21.8333},{52.1,21.8333},{52.1,-18},{250,-18}},
      color={175,0,0},
      thickness=0.5));
  connect(outlet, T_out_sensor.port) annotation (Line(
      points={{250,-18},{124,-18},{124,26}},
      color={175,0,0},
      thickness=0.5));
  connect(massflow_Tm_flow4.T, T_return_B1) annotation (Line(points={{-19,-0.8},{-19,-48.4},{-30,-48.4},{-30,-100}},     color={0,0,127}));
  connect(Block_1.epp, epp) annotation (Line(
      points={{-26.5,29},{-20.25,29},{-20.25,132},{248,132}},
      color={0,135,135},
      thickness=0.5));
  connect(Block_2.epp, epp) annotation (Line(
      points={{15.5,27},{27.75,27},{27.75,132},{248,132}},
      color={0,135,135},
      thickness=0.5));
  connect(massflow_Tm_flow3.fluidPortOut, T_in_sensor.port) annotation (Line(
      points={{19,8},{64,8},{64,-2},{82,-2}},
      color={175,0,0},
      thickness=0.5));

  //General annotations
  connect(Block_1.eye, eye_Block1) annotation (Line(points={{-25,16.8333},{-10.5,16.8333},{-10.5,-142},{250,-142}},
                                                                                                    color={28,108,200}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Block_2.eye, eye_Block2) annotation (Line(points={{17,14.8333},{28.5,14.8333},{28.5,-166},{250,-166}},
                                                                                                    color={28,108,200}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  if useGasPort then
    connect(Block_2.gasPortIn, gasPortIn) annotation (Line(
      points={{16,30.8333},{56,30.8333},{56,82},{250,82}},
      color={255,255,0},
      thickness=1.5));
    connect(Block_1.gasPortIn, gasPortIn) annotation (Line(
      points={{-26,32.8333},{-22,32.8333},{-22,82},{250,82}},
      color={255,255,0},
      thickness=1.5));
  end if;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{240,160}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model illustrates the use of several units located at a single feed-in site.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">eye: Eyeout</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_set_B1: input for electric power in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_set_B2: input for electric power in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_set_B1: input for heatflow rate in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_set_B2: input for heatflow rate in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">m_flow_set_B1: input for heatflow rate in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">m_flow_set_B2: input for heatflow rate in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">T_return_B2: input for return temperature in [K]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">outlet: FluidPortOut</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">T_return_B1: input for for return temperatrue in [K]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: active power port (choice of power port)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">gasPortIn: real gas inlet</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">eye_Block1: Eyeout</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">eye_Block2: Eyeout</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Schülting (oliver.schuelting@tuhh.de) in Nov 2018: added gasPort</span></p>
</html>"));
end TwoBlockCHP;
