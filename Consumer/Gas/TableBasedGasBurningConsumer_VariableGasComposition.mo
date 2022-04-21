within TransiEnt.Consumer.Gas;
model TableBasedGasBurningConsumer_VariableGasComposition "Simple model of a consumer burning natural gas for covering heat demand."



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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Consumer;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1;

  parameter Boolean change_of_sign=false "Change sign of output signal relative to table data"
                                                          annotation (choices(__Dymola_checkBox=true));
  parameter Real constantfactor=1.0 "Multiply output with constant factor";

  parameter Modelica.Units.SI.Efficiency eta=0.95 "Efficiency of gas burner (heat loss to ambience)";

  parameter Modelica.Units.SI.Temperature T_exhaustgas=80 + 273.15 "Temperature of exhaust gas after heat exchanger (defines exhaust gas heat loss)";

  parameter Boolean use_Q_flow_input=false "True, if Q_flow defined by variable input";

  parameter Boolean consider_FlueGas_losses=true "True, if flue gas losses are considered in addition to 'eta'";
  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasIn(Medium=medium) annotation (Placement(transformation(extent={{-110,10},{-90,30}}), iconTransformation(extent={{90,-50},{110,-30}})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow if (use_Q_flow_input) "Variable Heat Demand" annotation (Placement(transformation(extent={{-120,40},{-80,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
protected
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_in;
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  replaceable TransiEnt.Basics.Tables.GenericDataTable consumerDataTable if (not use_Q_flow_input) constrainedby TransiEnt.Basics.Tables.GenericDataTable(final change_of_sign=change_of_sign, final constantfactor=constantfactor)  annotation (choicesAllMatching=true, Placement(transformation(extent={{90,-48},{55,-16}})));

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow massFlowSink(
    variable_m_flow=true,
    medium=medium) annotation (Placement(transformation(extent={{-16,10},{-36,30}})));

  Modelica.Blocks.Sources.RealExpression
                            m_flow_set(y=m_flow_gas_demand) "just for visualisation on diagram layer"
    annotation (Placement(transformation(extent={{28,16},{-2,36}})));

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT gasMediumExhaust(
    vleFluidType=medium,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    p=simCenter.p_amb_const,
    T=T_exhaustgas,
    xi=noEvent(actualStream(gasIn.xi_outflow))) if
                       consider_FlueGas_losses==true annotation (Placement(transformation(extent={{-10,74},{10,94}})));
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas);
public
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissions(typeOfEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas) annotation (Placement(transformation(extent={{2,-100},{22,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Units.SI.MassFlowRate m_flow_gas_demand;
  TransiEnt.Components.Sensors.RealGas.NCVSensor      vleNCVSensor(medium=medium)
                                                                   annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Units.SI.MassFlowRate m_flow_cde_total;

protected
  Modelica.Units.SI.MolarFlowRate[5] ElementCompositionFuel;
   Modelica.Blocks.Sources.RealExpression gasMediumExhaust_h(y=gasMediumExhaust.h) if consider_FlueGas_losses;
   Modelica.Blocks.Math.Gain gasMediumExhaust_h_gain(k=1);
   Modelica.Blocks.Sources.RealExpression Zero(y=0);
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  // === energy balance ===
  if consider_FlueGas_losses then
    m_flow_gas_demand * (inStream(gasIn.h_outflow) - gasMediumExhaust_h_gain.y + vleNCVSensor.NCV) * eta = Q_flow_in;
  else
    m_flow_gas_demand * (vleNCVSensor.NCV) * eta = Q_flow_in;
  end if;


  // === CO2 Emissions ===
  collectGwpEmissions.gwpCollector.m_flow_cde=m_flow_cde_total;
  m_flow_cde_total=-ElementCompositionFuel[1]*44.0095/1000;
  ElementCompositionFuel=TransiEnt.Basics.Functions.GasProperties.comps2Elements_realGas(medium,vleNCVSensor.xi,gasIn.m_flow);

  if use_Q_flow_input then
    connect(Q_flow_in,Q_flow);
  else
    connect(Q_flow_in,consumerDataTable.y1);
  end if;
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  if consider_FlueGas_losses then
    connect(gasMediumExhaust_h.y,gasMediumExhaust_h_gain.u);
  else
    connect(Zero.y,gasMediumExhaust_h_gain.u);
  end if;
  connect(modelStatistics.gwpCollectorHeat[PrimaryEnergyCarrier.NaturalGas],collectGwpEmissions.gwpCollector);

  connect(m_flow_set.y, massFlowSink.m_flow) annotation (Line(
      points={{-3.5,26},{-14,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasIn, vleNCVSensor.gasPortIn) annotation (Line(
      points={{-100,20},{-60,20}},
      color={255,255,0},
      thickness=1.5));
  connect(vleNCVSensor.gasPortOut, massFlowSink.gasPort) annotation (Line(
      points={{-40,20},{-36,20}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Line(
          points={{48,-32},{12,-32},{12,16}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled},
          pattern=LinePattern.Dash), Text(
          extent={{14,6},{52,-6}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Efficiency, 
Heat Of Combustion and 
Exhaust Gas Temperature"),               Line(
          points={{48,-32},{12,-32},{12,-72}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled},
          pattern=LinePattern.Dash)}),    Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-48,60},{2,-60}},
          lineColor={255,255,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-48,-60},{-48,60},{52,60},{52,-60},{-48,-60},{-48,-30},{52,
              -30},{52,0},{-48,0},{-48,30},{52,30},{52,60},{2,60},{2,-61}},
            color={0,0,0}),
        Polygon(
          points={{-12,-60},{-24,-40},{-14,-44},{-8,-26},{2,-42},{10,-30},{16,
              -44},{26,-34},{14,-60},{-12,-60}},
          lineColor={175,0,0},
          smooth=Smooth.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Table based model of gas consumer. Adaption of model &apos;TableBasedGasBurningConsumer&apos;. The caluclation in this model is based on the gas position at the input gas port (no constant heat of combustion).</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Assumptions:</p>
<p>Constant heat loss to ambience via radiation etc. (with lumped efficiency eta)</p>
<p>Constant tempearture of exhaust gas at output of heat exchanger (parameter T_exhaustgas)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasIn: inlet for real gas</p>
<p>Q_flow: input for heat flow rate in [W]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The usage of the model can be adapated by the following parameters:</p>
<p>use_Q_flow_input: Choose &quot;true&quot;, if input is used to define heat flow.</p>
<p>consider_FlueGas_losses: Choose &quot;true&quot;, if heat losses through flue gas is considered in addition to losses resulting from the parameter &apos;eta&apos;. If &quot;false&quot; the parameter &apos;eta&apos; represents the overall efficiency.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Schülting (oliver.schuelting@tuhh.de), Jun 2018</p>
</html>"));
end TableBasedGasBurningConsumer_VariableGasComposition;
