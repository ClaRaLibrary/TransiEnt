within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L2;
model HotWaterStorage_constProp_L2 "Very simple heat storage"



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

  extends TransiEnt.Basics.Icons.ThermalStorageBasic;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter SI.Volume Volume=d^2/4*Modelica.Constants.pi*height;
  final parameter SI.Area A=d*Modelica.Constants.pi*height + 2*d^2/4*Modelica.Constants.pi;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Boolean useFluidPorts=true annotation (Dialog(group="Fundamental Definitions"),choices(checkBox=true));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid Medium=simCenter.fluid1 "Medium in the component" annotation (Dialog(group="Fundamental Definitions",enable=useFluidPorts));

  parameter SI.Pressure p_drop_nom=simCenter.p_nom[2] - simCenter.p_nom[1] "Pressure drop on supply side" annotation (Dialog(group="Fundamental Definitions",enable=useFluidPorts));
  parameter SI.MassFlowRate m_flow_nom=20 "Nominal mass flow rate " annotation (Dialog(group="Fundamental Definitions",enable=useFluidPorts));

  parameter SI.Temperature T_max(displayUnit="degC") = 383.15 "Maximum allowed temperature in storage" annotation (Dialog(group="Temperatures"));

  SI.Temperature T_s_max=363.15 "Temperature at which storage is considered to be full" annotation (Dialog(group="Temperatures"));
  SI.Temperature T_s_min=333.15 "Temperature at which storage is considered to be empty" annotation (Dialog(group="Temperatures"));

  parameter SI.Height height=20 "Height of heat storage" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Diameter d=11.28 "Diameter of heat storage" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Temperature T_start=273.15 + 90 "Initial temperature" annotation (Dialog(group="Temperatures"));
  parameter SI.Temperature T_amb=273.15 + 15 "Assumed constant ambient temperature" annotation (Dialog(group="Temperatures"));
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "Coefficient of heat transfer" annotation (Dialog(group="Fundamental Definitions"));
  //According to BINE-Waermespeicher

  parameter SI.Density rho=1000 "Density of the storage medium" annotation (Dialog(group="Fluid Properties"));
  parameter SI.SpecificHeatCapacity cp=4200 "Heating capacity of the storage medium" annotation (Dialog(group="Fluid Properties"));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

public
  SI.Energy E_stor(start=cp*(T_start - 273.15)*Volume*rho) "Stored energy" annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.HeatFlowRate Q_flow_loss "Surface losses";
  SI.HeatFlowRate Q_flow_balance "Heat flow to or from storage";

  SI.Temperature T_stor;

  //Real SoC "State of charge of the storage";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fpGenIn(Medium=Medium) if useFluidPorts "inlet from heat generator" annotation (Placement(transformation(extent={{-72,70},{-52,90}}), iconTransformation(extent={{-72,70},{-52,90}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fpGenOut(Medium=Medium) if useFluidPorts "outlet to heat generator" annotation (Placement(transformation(extent={{-74,-92},{-54,-72}}), iconTransformation(extent={{-74,-92},{-54,-72}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fpGridIn(Medium=Medium) if useFluidPorts "inlet (return) from consumer/grid" annotation (Placement(transformation(extent={{42,-90},{62,-70}}), iconTransformation(extent={{42,-90},{62,-70}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fpGridOut(Medium=Medium) if useFluidPorts "outlet to consumer/grid" annotation (Placement(transformation(extent={{52,72},{72,92}}), iconTransformation(extent={{52,72},{72,92}})));
  TransiEnt.Basics.Interfaces.General.TemperatureOut T_stor_out "Temperature in heat reservoir in K" annotation (
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-12,100}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-18,96})));
  Modelica.Blocks.Interfaces.RealOutput SoC "State of charge" annotation (
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={20,98}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={18,96})));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________


  ClaRa.Components.HeatExchangers.TubeBundle_L2 heatExchangerGen(
    medium=Medium,
    h_start=50*cp,
    p_nom=simCenter.p_nom[1],
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=p_drop_nom),
    m_flow_nom=m_flow_nom,
    p_start=simCenter.p_nom[2],
    initOption=0) if  useFluidPorts annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,0})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatToStorage(T_ref=343.15) if  useFluidPorts annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-32,0})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureGenIn(medium=Medium) if useFluidPorts annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 heatExchangerConsumer(
    medium=Medium,
    h_start=70*cp,
    p_start=simCenter.p_nom[2],
    m_flow_nom=m_flow_nom,
    p_nom=simCenter.p_nom[2],
    initOption=0) if  useFluidPorts annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={60,0})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureGridOut(medium=Medium) if useFluidPorts annotation (Placement(transformation(extent={{90,50},{70,70}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureGridIn(medium=Medium) if useFluidPorts annotation (Placement(transformation(extent={{42,-70},{22,-50}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureGenOut(medium=Medium) if useFluidPorts annotation (Placement(transformation(extent={{-92,-70},{-72,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatFromStorage if useFluidPorts annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={32,0})));
  Modelica.Blocks.Math.Add add(k2=-1) if useFluidPorts annotation (Placement(transformation(extent={{-10,32},{6,48}})));
  Modelica.Blocks.Math.Add add1(k2=-1) if useFluidPorts annotation (Placement(transformation(extent={{-20,-38},{-4,-22}})));
  TransiEnt.Basics.Blocks.Sources.TemperatureExpression T_return_gen(y=if noEvent(fpGridIn.m_flow > fpGenIn.m_flow) then temperatureGridIn.T else (fpGridIn.m_flow*temperatureGridIn.T + T_stor*(fpGenIn.m_flow - fpGridIn.m_flow))/fpGenIn.m_flow) if
                                                                                                                                                                                                        useFluidPorts annotation (Placement(transformation(extent={{-48,22},{-28,42}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_gen "Generated heat flow";
  TransiEnt.Basics.Blocks.Sources.TemperatureExpression T_supply_grid(y=if noEvent(fpGridIn.m_flow < fpGenIn.m_flow) then min(temperatureGenIn.T, simCenter.heatingCurve.T_supply) else min((fpGenIn.m_flow*temperatureGenIn.T + (fpGridIn.m_flow - fpGenIn.m_flow)*T_stor)/fpGridIn.m_flow, simCenter.heatingCurve.T_supply)) if
                                                                                                                                                                                                        useFluidPorts annotation (Placement(transformation(extent={{-54,-36},{-28,-14}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_con "Consumed heat flow";
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_store if not useFluidPorts "Heat flow into the storage" annotation (HideResult=true, Placement(transformation(extent={{-108,-14},{-80,14}}), iconTransformation(extent={{-108,-14},{-80,14}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_demand if  not useFluidPorts "Heat flow from the storage" annotation (HideResult=true, Placement(transformation(extent={{114,-14},{86,14}}), iconTransformation(extent={{114,-14},{86,14}})));
  Modelica.Blocks.Math.Product product1 if useFluidPorts annotation (Placement(transformation(extent={{10,-38},{22,-26}})));
  Modelica.Blocks.Sources.RealExpression heatCapacity_gen(y=fpGridIn.m_flow*cp) if                                                                                                                                                                                                         useFluidPorts annotation (Placement(transformation(extent={{-20,-64},{6,-42}})));
  Modelica.Blocks.Sources.RealExpression heatCapacity_gen1(y=fpGenIn.m_flow*cp) if                                                                                                                                                                                                         useFluidPorts annotation (Placement(transformation(extent={{-4,52},{12,72}})));
  Modelica.Blocks.Math.Product product2 if useFluidPorts annotation (Placement(transformation(extent={{24,30},{40,46}})));
  Modelica.Blocks.Math.Gain gain(k=-1) if useFluidPorts annotation (Placement(transformation(extent={{6,0},{-10,16}})));


equation
  // _____________________________________________
  //
  //                Characteristic Equations
  // _____________________________________________


  assert(T_stor < T_max, "Heat storage too hot. Adjust your control!");

  //Heat transfer of a body
  Q_flow_loss = k*A*(T_stor - T_amb);

  //Differential equation
  der(E_stor) = Q_flow_gen - Q_flow_con - Q_flow_loss;

  //Just for comparison and statistics
  Q_flow_balance = Q_flow_con + Q_flow_gen;


  T_stor = E_stor/(Volume*rho*cp) + 273.15;
  T_stor_out = T_stor;

  SoC = (T_stor - T_s_min)/(T_s_max - T_s_min);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(temperatureGenIn.port, fpGenIn) annotation (Line(points={{-80,50},{-100,50},{-100,80},{-62,80}}, smooth=Smooth.None));
  connect(heatExchangerConsumer.inlet, fpGridOut) annotation (Line(
      points={{60,10},{60,82},{62,82}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatExchangerConsumer.outlet, fpGridIn) annotation (Line(
      points={{60,-10},{60,-80},{52,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(temperatureGridOut.port, fpGridOut) annotation (Line(
      points={{80,50},{62,50},{62,82}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(temperatureGridIn.port, fpGridIn) annotation (Line(
      points={{32,-70},{32,-80},{52,-80}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(temperatureGenOut.port, fpGenOut) annotation (Line(points={{-82,-70},{-100,-70},{-100,-82},{-64,-82}}, smooth=Smooth.None));
  connect(heatExchangerConsumer.heat, heatFromStorage.port) annotation (Line(
      points={{50,1.77636e-015},{46,1.77636e-015},{46,-1.33227e-015},{42,-1.33227e-015}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatExchangerGen.heat, heatToStorage.port) annotation (Line(
      points={{-50,0},{-42,0}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatExchangerGen.inlet, fpGenIn) annotation (Line(
      points={{-60,10},{-60,80},{-62,80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heatExchangerGen.outlet, fpGenOut) annotation (Line(
      points={{-60,-10},{-60,-82},{-64,-82}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(add1.u1, T_supply_grid.y) annotation (Line(points={{-21.6,-25.2},{-21.6,-25},{-26.7,-25}}, color={0,0,127}));
  connect(temperatureGridIn.T, add1.u2) annotation (Line(points={{21,-60},{-28,-60},{-28,-38},{-21.6,-38},{-21.6,-34.8}}, color={0,0,127}));
  connect(Q_flow_store, Q_flow_gen);
  connect(product2.y, Q_flow_gen);
  connect(Q_flow_demand, Q_flow_con);
  connect(product1.y, Q_flow_con);
  connect(add1.y, product1.u1) annotation (Line(points={{-3.2,-30},{2,-30},{2,-28.4},{8.8,-28.4}}, color={0,0,127}));
  connect(product1.y, heatFromStorage.Q_flow) annotation (Line(points={{22.6,-32},{26,-32},{26,-14},{14,-14},{14,1.22125e-15},{22,1.22125e-15}}, color={0,0,127}));
  connect(heatCapacity_gen.y, product1.u2) annotation (Line(points={{7.3,-53},{12,-53},{12,-42},{8,-42},{8,-38},{2,-38},{2,-35.6},{8.8,-35.6}}, color={0,0,127}));
  connect(temperatureGenIn.T, add.u1) annotation (Line(points={{-69,60},{-16,60},{-16,44.8},{-11.6,44.8}}, color={0,0,127}));
  connect(heatCapacity_gen1.y, product2.u1) annotation (Line(points={{12.8,62},{18,62},{18,48},{14,48},{14,42.8},{22.4,42.8}}, color={0,0,127}));
  connect(add.y, product2.u2) annotation (Line(points={{6.8,40},{14,40},{14,33.2},{22.4,33.2}}, color={0,0,127}));
  connect(heatToStorage.Q_flow, gain.y) annotation (Line(points={{-22,-1.11022e-15},{-16,-1.11022e-15},{-16,8},{-10.8,8}}, color={0,0,127}));
  connect(product2.y, gain.u) annotation (Line(points={{40.8,38},{46,38},{46,8},{7.6,8}}, color={0,0,127}));
  connect(T_return_gen.y, add.u2) annotation (Line(points={{-27,32},{-16,32},{-16,35.2},{-11.6,35.2}}, color={0,0,127}));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Line(
          points={{-62,80},{-18,80},{-18,46}},
          color={127,0,0},
          thickness=1,
          smooth=Smooth.None),Line(
          points={{-20,-60},{-20,-82},{-68,-82}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None),Line(
          points={{21,-60},{21,-82},{52,-82}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None),Line(
          points={{64,80},{20,80},{20,46}},
          color={127,0,0},
          thickness=1,
          smooth=Smooth.None),Line(
          points={{52,-82},{52,80}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None),Polygon(
          points={{46,8},{58,8},{46,-10},{58,-10},{46,8}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),Line(
          points={{-50,80},{34,80},{34,80}},
          color={127,0,0},
          thickness=1,
          smooth=Smooth.None,
          pattern=LinePattern.Dot),Line(
          points={{-42,-82},{42,-82},{42,-82}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None,
          pattern=LinePattern.Dot)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Line(
          points={{-54,60},{-54,34},{-54,26}},
          color={0,0,255},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled}),Line(
          points={{54,26},{54,52},{54,60}},
          color={0,0,255},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled})}),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Simple energy balance model of a hot water storage without spatial discretisation. Thermodynamic properties are not calculated in dependance of the temperature.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>fpGenIn: inlet from heat generator</p>
<p>fpGenOut: outlet from heat generator</p>
<p>fpGridIn: inlet (return) from consumer/grid</p>
<p>fpGridOut: outlet to consumer/grid</p>
<p>T_stor_out: Temperature in heat reservoir in K [K]</p>
<p>SoC: State of charge of the storage</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Apr 2013</p>
<p>Edited and revised by Lisa Andresen (andresen@tuhh.de), Jun 2013</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Dec 2017</p>
<p>Modified by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), July 2021 (FluidPorts as conditional components, corrected equation for E_start).</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-62,80},{-18,80},{-18,46}},
          color={127,0,0},
          thickness=1,
          smooth=Smooth.None),
        Line(
          points={{-20,-60},{-20,-82},{-68,-82}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None),
        Line(
          points={{21,-60},{21,-82},{52,-82}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None),
        Line(
          points={{64,80},{20,80},{20,46}},
          color={127,0,0},
          thickness=1,
          smooth=Smooth.None),
        Line(
          points={{52,-82},{52,80}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None),
        Polygon(
          points={{46,8},{58,8},{46,-10},{58,-10},{46,8}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-50,80},{34,80},{34,80}},
          color={127,0,0},
          thickness=1,
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Line(
          points={{-42,-82},{42,-82},{42,-82}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None,
          pattern=LinePattern.Dot)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Line(
          points={{-54,60},{-54,34},{-54,26}},
          color={0,0,255},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled}), Line(
          points={{54,26},{54,52},{54,60}},
          color={0,0,255},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled})}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple energy balance model of a hot water storage without spatial discretisation. Thermodynamic properties are not calculated in dependance of the temperature.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>fpGenIn: inlet from heat generator</p>
<p>fpGenOut: outlet from heat generator</p>
<p>fpGridIn: inlet (return) from consumer/grid</p>
<p>fpGridOut: outlet to consumer/grid</p>
<p>T_stor_out: Temperature in heat reservoir in K [K]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Apr 2013</p>
<p>Edited and revised by Lisa Andresen (andresen@tuhh.de), Jun 2013</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Dec 2017</p>
</html>"));
end HotWaterStorage_constProp_L2;
