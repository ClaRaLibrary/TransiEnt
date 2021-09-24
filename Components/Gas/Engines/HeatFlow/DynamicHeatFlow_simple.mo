within TransiEnt.Components.Gas.Engines.HeatFlow;
model DynamicHeatFlow_simple

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



  extends TransiEnt.Components.Gas.Engines.HeatFlow.BasicHeatFlow;
  parameter Modelica.Units.NonSI.Temperature_degC theta_cylinder_opt=145 "Optimal temperature of cylinder";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_iron=490 "TILMedia steel";
  //defined only for calculation purposes (so that there only has to be one input for total heatflowrate)
  parameter Modelica.Units.SI.Mass m_engine=Specification.m_engine;
  parameter Modelica.Units.SI.ThermalConductance thermalConductivity=Specification.thermalConductivity;

protected
  Modelica.Units.SI.HeatFlowRate Q_flow_fuel=P_el_set/eta_el "energy provision from fuel";
public
  final parameter Modelica.Units.SI.CoefficientOfHeatTransfer k=Specification.k "heat transfer coefficient of engine";
  final parameter Modelica.Units.SI.Area A=Specification.width*Specification.height*2 + Specification.length*Specification.height*2 + Specification.width*Specification.length "Surface of engine";

  final parameter Modelica.Units.SI.Temperature T_site=293;

  Real C_out;
  Real C_loss;

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow standbyLoss
                             annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,-44})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor innerEngine(
                       C=0.5*cp_iron*m_engine, T(fixed=true, start=T_init))
                                               "Engine's core's heat capacity in J/K"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,-44})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor outerEngine(
                       C=0.5*cp_iron*m_engine, T(fixed=true, start=(T_site + T_init)/2))
                                               "Engine's outer part's heat capacity in J/K"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={10,-44})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductance(G=
        thermalConductivity)
                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-54})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow coolingHeat
                             annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={100,-10})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow exhaustHeat
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={94,52})));
  ClaRa.Components.HeatExchangers.IdealShell_L2 idealShell_L2_3(
    h_nom=20*4200,
    height=0.1,
    width=0.1,
    length=0.05,
    diameter_t=0.02,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    m_flow_nom=m_flow_nom,
    p_nom=Delta_p_nom,
    initOption=201,
    h_start=(T_init - 273.15)*4200,
    p_start=p_init)                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,52})));

  ClaRa.Components.HeatExchangers.IdealShell_L2 idealShell_L2_4(
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L2 (alpha_nom=10e9),
    h_nom=20*4200,
    height=0.1,
    width=0.1,
    length=0.05,
    diameter_t=0.02,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    m_flow_nom=m_flow_nom,
    p_nom=Delta_p_nom,
    initOption=201,
    h_start=(T_init - 273.15)*4200,
    p_start=p_init)                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,-54})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1(
      redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
         Delta_p_nom=Delta_p_nom, m_flow_nom=m_flow_nom)) annotation (Placement(
        transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={160,2})));
equation
  //calculate Q_flow_out from fuel and electrical output
  Q_flow_fuel = (P_el_set + Q_flow_out)/eta_h;

  if switch then
    // total heatflow through engine divides into heat flow into coolant and oil and losses to the ambient air
    Q_flow_engine_tot = Q_flow_engine + Q_flow_loss_room;
    // standard equation for heat losses
    Q_flow_loss = (1 - eta_h)*Q_flow_fuel;

  else
    //Energy flow rates
    //if engine is switched off, there are no more heatflows
    Q_flow_engine_tot = 0;
    // except for the losses to the ambient air caused by temperature difference
      //JB: CHECK THIS! continuous losses with no time-dependent variable? see eqation for Q_flow_loss_room
    Q_flow_loss = Q_flow_loss_room;
  end if;
      // Q_flow_loss_room = k*A*(T_engine-T_site) with constant and instantaneously T_engine:
    Q_flow_loss_room = k*A*(outerEngine.T-T_site);//(353.15 - T_site);

  // energy balances for usable heat flows
    // heatflow to exhaust by simple share of total heatflow
  Q_flow_exhaust = Specification.shareExhaustHeat*Q_flow_out;
    // heatflow through engine (body) + heatflow through exhaust = total heatflow
  Q_flow_out = Q_flow_exhaust + Q_flow_engine;

  // Energy balances for losses
  Q_flow_loss = Q_flow_loss_room + Q_flow_loss_exhaust;

  // Prescribe heat flows to heat ports
  coolingHeat.Q_flow = Q_flow_engine_tot;
  exhaustHeat.Q_flow = Q_flow_exhaust;
  standbyLoss.Q_flow = -Q_flow_loss_room;

    //Control variables
    // LA: ueberpruefen
  C_out = Q_flow_out - (Q_flow_exhaust + Q_flow_engine);
  C_loss = Q_flow_loss - (Q_flow_loss_room + Q_flow_loss_exhaust);

  TemperaturesOut[1] = outerEngine.T;
  TemperaturesOut[2] = innerEngine.T;
  connect(thermalConductance.port_b,innerEngine. port) annotation (Line(
      points={{50,-54},{70,-54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outerEngine.port,thermalConductance. port_a) annotation (Line(
      points={{10,-54},{30,-54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(standbyLoss.port,outerEngine. port) annotation (Line(
      points={{-20,-54},{10,-54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coolingHeat.port,innerEngine. port) annotation (Line(
      points={{100,-20},{102,-20},{102,-56},{70,-56},{70,-54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(idealShell_L2_4.inlet, waterPortIn) annotation (Line(
      points={{160,-64},{160,-110},{230,-110}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(idealShell_L2_3.outlet, waterPortOut) annotation (Line(
      points={{160,62},{160,130},{230,130}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(valveVLE_L1_1.outlet, idealShell_L2_3.inlet) annotation (Line(
      points={{160,12},{160,42}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(valveVLE_L1_1.inlet, idealShell_L2_4.outlet) annotation (Line(
      points={{160,-8},{160,-44}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(exhaustHeat.port, idealShell_L2_3.heat) annotation (Line(points={{104,52},{150,52}}, color={191,0,0}));
  connect(coolingHeat.port, idealShell_L2_4.heat) annotation (Line(points={{100,-20},{100,-54},{150,-54}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -160},{220,160}})),           Icon(graphics,
                                               coordinateSystem(extent={{
            -200,-160},{220,160}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple model for the thermal behaviour of an engine.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This model is based on the staticHeatFlow model. Two thermal capacitors are added, representing the thermal inertia of the engine itself and its cooling system.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>switch - boolean input to switch the engine on/off</p>
<p>P_el - target electrical power input</p>
<p>efficienciesIn[2] - Input connector for electrical [1] and overall [2] efficiency of the engine</p>
<p>temperaturesOut[2] - Output connector for temperature levels in the engine (as the efficiencies in the more complex models are calculated based on temperature-dependent empirical equations)</p>
<p>waterIn/waterOut - fluidports for return / supplystream of the heating system</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>This model is based on energy conservation equations, just as the static model. The following flowchart illustrates hte energy flow and its equations</p>
<p><img src=\"modelica://TransiEnt/Images/flowchart_heatFlow_simpleDynamic.png\"/></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>This model is meant to be used in combination with at least one engineMechanics-model from the engines.basics package.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>This model has been parametrised and validated as part of the overall CHP-model (DACHS HKA G5.5).</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Apr 2014</p>
<p>Edited by Jan Braune (jan.braune@tuhh.de), Mar 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2015</p>
</html>"));
end DynamicHeatFlow_simple;
