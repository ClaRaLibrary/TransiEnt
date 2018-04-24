within TransiEnt.Consumer.Gas;
model TableBasedGasBurningConsumer

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  parameter Modelica.SIunits.Efficiency eta=0.95 "Efficiency of gas burner (heat loss to ambience)";

  parameter Modelica.SIunits.Temperature T_exhaustgas = 80+273.15 "Temperature of exhaust gas after heat exchanger (defines exhaust gas heat loss)";

  parameter Modelica.SIunits.SpecificEnthalpy HoC_gas=40e6 "heat of combustion of natural gas";

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

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable TransiEnt.Basics.Tables.GenericDataTable consumerDataTable constrainedby TransiEnt.Basics.Tables.GenericDataTable(final change_of_sign=change_of_sign, final constantfactor=constantfactor) annotation (choicesAllMatching=true, Placement(transformation(extent={{90,-48},{55,-16}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSink(
    m_flow_nom=0,
    p_nom=1000,
    variable_h=false,
    m_flow_const=1,
    h_const=-23e3,
    variable_m_flow=true,
    medium=medium) annotation (Placement(transformation(extent={{-16,10},{-36,30}})));

  Modelica.Blocks.Sources.RealExpression
                            m_flow_set(y=-m_flow_gas_demand) "just for visualisation on diagram layer"
    annotation (Placement(transformation(extent={{28,16},{-2,36}})));

    Modelica.SIunits.MassFlowRate m_flow_gas_demand;
protected
   TILMedia.VLEFluid_pT gasMediumExhaust(
    vleFluidType=medium,
    xi=actualStream(gasIn.xi_outflow),
    p=simCenter.p_amb_const,
    T=T_exhaustgas)
    annotation (Placement(transformation(extent={{-10,74},{10,94}})));
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=PrimaryEnergyCarrier.NaturalGas);
public
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissions(typeOfEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas) annotation (Placement(transformation(extent={{2,-100},{22,-80}})));

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  // === energy balance ===
  m_flow_gas_demand * (inStream(gasIn.h_outflow) - gasMediumExhaust.h + HoC_gas) * eta = consumerDataTable.y1;

  // === CO2 Emissions ===
  collectGwpEmissions.gwpCollector.m_flow_cde=-1*fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*consumerDataTable.y1/eta;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.gwpCollectorHeat[PrimaryEnergyCarrier.NaturalGas],collectGwpEmissions.gwpCollector);

  connect(gasIn, massFlowSink.steam_a) annotation (Line(
      points={{-100,20},{-36,20}},
      color={255,255,0},
      thickness=0.75,
      smooth=Smooth.None));
  connect(m_flow_set.y, massFlowSink.m_flow) annotation (Line(
      points={{-3.5,26},{-14,26}},
      color={0,0,127},
      smooth=Smooth.None));
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
<p>Simple model of a consumer burning natural gas for covering heat demand.</p>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Table based model of gas consumer.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Assumptions:</p>
<p>Constant heat of combustion (HoC_Gas)</p>
<p>Constant heat loss to ambience via radiation etc. (with lumped efficiency eta)</p>
<p>Constant tempearture of exhaust gas at output of heat exchanger (parameter T_exhaustgas)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) on 11/2014</p>
</html>"));
end TableBasedGasBurningConsumer;
