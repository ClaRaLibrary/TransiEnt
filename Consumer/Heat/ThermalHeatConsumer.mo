within TransiEnt.Consumer.Heat;
model ThermalHeatConsumer "Thermal Heat Consumer based on a room with capacity and heat losses"

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

  extends PartialHeatConsumer;
  // _____________________________________________
  //
  //                 Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Temperature T_set=20+273.15 "Setpoint for consumer (room) temperature";
  parameter Modelica.SIunits.Temperature T_start=T_set "Start value for consumer (room) temperature";
  parameter String T_amb_path="/ambientcsv/TemperatureHH_900s_01012012_0000_31122012_2345.txt" "Path relative to source directory";

 parameter Modelica.SIunits.CoefficientOfHeatTransfer kc_nom=1.75e7 "Constant heat transfer coefficient of radiator";
  parameter Modelica.SIunits.ThermalConductance G=4e7 "Constant thermal conductance of consumer";
  parameter Modelica.SIunits.HeatCapacity C=2.48e12 "Heat capacity of consumer (= cp*m)";

  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=3860 "Nominal mass flow rate";
  parameter ClaRa.Basics.Units.Pressure Delta_p_nom=0.4e5 "Valve Nominal pressure loss";
  parameter ClaRa.Basics.Units.DensityMassSpecific rho_in_nom=928 "Nominal mass flux density";

  parameter ClaRa.Basics.Units.Time t_ctrl_activationTime=0.0;
  parameter Real y_start=1 "Initial value of output";
  parameter ClaRa.Basics.Units.Length d_i=1.6;

  parameter Modelica.SIunits.Pressure dp_HX_nom=0 "Nominal pressure loss in heat exchanger";
  parameter Modelica.SIunits.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy in heat exchanger";
  parameter Modelica.SIunits.Length d_t=0.1 "Outer diameter of HX pipes";
  parameter Modelica.SIunits.Length L=1 "Length of heat exchanger pipes";
  parameter Integer Nt=1 "Number of heat exchanger tubes";

  parameter Modelica.SIunits.Time Ti_ctrl=0.5;
  parameter Real k_ctrl=1 "Gain of Proportional block";
  parameter Real yMax=1 "Upper limit of output";
  parameter Real yMin=-CTRL_T_room.y_max "Lower limit of output";

  replaceable model PressureLoss =
      ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (                   Delta_p_nom=Delta_p_nom, rho_in_nom=rho_in_nom, m_flow_nom=m_flow_nom) constrainedby ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.GenericPressureLoss
                                                                                                    annotation (__Dymola_choicesAllMatching=true);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  ClaRa.Basics.Interfaces.EyeOut eye
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(
      T(start=T_start), C=C)
    annotation (Placement(transformation(extent={{-44,-36},{-24,-56}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor heatLossConductance(G=G)
    annotation (Placement(transformation(extent={{-22,-40},{-2,-20}},
                                                                   rotation=0)));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{28,-40},{8,-20}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 tamb(datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic, relativepath="ambient/Temperature_Hamburg-Fuhlsbuettel_3600s_01012012_31122012.txt") annotation (Placement(transformation(extent={{-17,-67},{3,-47}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor T_Room "Temperature to be controlled"
                                   annotation (Placement(transformation(
        origin={-54,-38},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 Valve(
    opening_const_=0.5,
    openingInputIsActive=true,
    opening_leak_=0.005,
    redeclare model PressureLoss = PressureLoss)
                         annotation (Placement(transformation(
        extent={{-15,-14},{15,14}},
        rotation=0,
        origin={61,0})));
  Modelica.Blocks.Sources.Constant T_ConsumerTarget(k=T_set) annotation (Placement(transformation(extent={{-30,42},{-10,62}})));
  TransiEnt.Basics.Blocks.LimPID CTRL_T_room(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ni=0.9,
    t_activation=t_ctrl_activationTime,
    y_start=y_start,
    k=k_ctrl,
    Tau_i=Ti_ctrl,
    y_max=yMax,
    y_min=yMin,
    y_inactive=y_inactive,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(extent={{30,42},{50,62}})));

  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin                        to_DegC                                                                            annotation (Placement(transformation(extent={{0,42},{20,62}})));

  ClaRa.Components.HeatExchangers.IdealShell_L2 HX_Consumer(
    m_flow_nom=simCenter.m_flow_nom,
    h_start=4200*80,
    p_nom=dp_HX_nom,
    h_nom=h_nom,
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (                      alpha_nom=kc_nom),
    length=L,
    diameter_t=d_t,
    N_tubes=Nt,
    p_start=500000) annotation (Placement(transformation(
        extent={{-16.5,16.5},{16.5,-16.5}},
        rotation=0,
        origin={-54.5,-0.5})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.SIunits.HeatFlowRate Q_flow_cons=fluidPortIn.m_flow*(actualStream(fluidPortIn.h_outflow)-actualStream(fluidPortOut.h_outflow));
  Modelica.SIunits.Pressure dp=fluidPortOut.p-fluidPortIn.p;
  Modelica.SIunits.Temperature deltaT_water(displayUnit="K")=HX_Consumer.summary.inlet.T-HX_Consumer.summary.outlet.T;
  Modelica.SIunits.ThermalConductance G_eff_water = Q_flow_cons/deltaT_water;
  Modelica.SIunits.Temperature deltaT_room(displayUnit="K")=T_Room.T-tamb.y1;
  Modelica.SIunits.ThermalConductance G_eff_room = Q_flow_cons/deltaT_room;

  parameter Real y_inactive=1 "Reference value for actuated variable (used before controller is activated)";
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(heatLossConductance.port_a,heatCapacitor. port) annotation (Line(
      points={{-22,-30},{-34,-30},{-34,-36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatLossConductance.port_b,prescribedTemperature. port) annotation (
      Line(
      points={{-2,-30},{8,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port,T_Room. port) annotation (Line(
      points={{-34,-36},{-34,-28},{-54,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(CTRL_T_room.y, Valve.opening_in) annotation (Line(
      points={{51,52},{62,52},{62,21},{61,21}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_Room.T, CTRL_T_room.u_m) annotation (Line(
      points={{-54,-48},{-54,-80},{40.1,-80},{40.1,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HX_Consumer.heat, T_Room.port) annotation (Line(
      points={{-54.5,-17},{-54,-17},{-54,-28}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(HX_Consumer.outlet, Valve.inlet) annotation (Line(
      points={{-38,-0.5},{-8,-0.5},{-8,0},{46,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(Valve.eye, eye) annotation (Line(
      points={{76,-9.33333},{80,-9.33333},{80,-80},{100,-80}},
      color={190,190,190},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(tamb.y1, prescribedTemperature.T) annotation (Line(points={{4,-57},{14,-57},{14,-58},{38,-58},{38,-30},{30,-30}}, color={0,0,127}));
  connect(T_ConsumerTarget.y, to_DegC.Kelvin) annotation (Line(points={{-9,52},{-5.5,52},{-2,52}}, color={0,0,127}));
  connect(to_DegC.Celsius, CTRL_T_room.u_s) annotation (Line(points={{21,52},{28,52},{28,52}}, color={0,0,127}));
  connect(fluidPortIn, HX_Consumer.inlet) annotation (Line(
      points={{-98,20},{-80,20},{-80,2},{-80,-0.5},{-71,-0.5}},
      color={175,0,0},
      thickness=0.5));
  connect(fluidPortOut, Valve.outlet) annotation (Line(
      points={{-98,-20},{-98,-90},{66,-90},{66,-54},{92,-54},{92,0},{76,0}},
      color={175,0,0},
      thickness=0.5));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a thermal heat consumer supplied by hot water that controls the water mass flow in order to hold the consumer temperature steady.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<ol>
<li>The model consists of a thermal capacity whose temperature is the target value. </li>
<li>The incoming heat flow is dependent on the parameter kc_nom (heat transfer coefficient of radiator).</li>
<li>The loss heat flow / heat demand is calculated by conduction loss to the ambient defined by the thermal conducticity (G) and the ambient temperature defined by a modelica table.</li>
<li>The target temperature is controlled with a PI Controller by changing the valve opening, parameterized by delta_p_nom, rho_nom and m_flow_nom (and the pressure loss model)</li>
</ol>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>- No heat loss due to radiation</p>
<p>- No heat transfer inside consumer, transfered heat is directly connected to the consumer capacity</p>
<p>- Lumped Capacity</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>- FluidPortIn and FluidPort out for heating water flow</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Consumer.Heat.Check.TestThermalHeatConsumer&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no references)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</p>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{-58,68},{58,-50}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,62},{62,-56}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,56},{68,-62}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,52},{62,-56}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,16},{4,-16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-32,0},{-32,0},{-102,0}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{102,0},{102,0},{52,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{43,0},{43,38},{-14,38},{-14,16}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{6,44},{24,34}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{34,5},{52,-5},{52,5},{34,-5},{34,5}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-32,0},{-20,0},{-16,10},{-12,-10},{-8,0},{34,0}},
          color={0,0,0},
          smooth=Smooth.None)}),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end ThermalHeatConsumer;
