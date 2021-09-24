within TransiEnt;
model ModelStatistics

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



  extends TransiEnt.Basics.Icons.OuterElement;

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //              Final parameters
  // _____________________________________________

  final parameter Integer nTypesOfResource=TransiEnt.Basics.Types.nTypeOfResource annotation (HideResult=true);

  final parameter Integer nSubgrids=2 "For calculation of statistics in subgrids (=1 local grid, e.g. hamburg, =2 surrounding grid, e.g. UCTE grid"
                                                                                              annotation(HideResult=true);
  final parameter Integer nTypes=TransiEnt.Basics.Types.nTypeOfPrimaryEnergyCarrier annotation (HideResult=true);

  final parameter Integer nTypesHeat=TransiEnt.Basics.Types.nTypeOfPrimaryEnergyCarrierHeat annotation (HideResult=true);


  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
  parameter Boolean integrateElPower=simCenter.integrateElPower "true if electric powers shall be integrated" annotation(Dialog(group="Statistics"));
  parameter Boolean integrateHeatFlow=simCenter.integrateHeatFlow "true if heat flows shall be integrated" annotation(Dialog(group="Statistics"));
  parameter Boolean integrateCDE=simCenter.integrateCDE "true if CDE should be integrated" annotation(Dialog(group="Statistics"));

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________


  Components.Statistics.Collectors.GlobalCollectors.GwpEmissionsStatistics gwpEmissions(final nTypesHeat=nTypesHeat, final nTypes=nTypes,
    integrateCDE=integrateCDE)                                                                                                            annotation (Placement(transformation(extent={{28,-78},{80,-28}})));
  Components.Statistics.Collectors.GlobalCollectors.ElectricPowerStatistics electricPower(final nSubgrids=nSubgrids, final nTypes=nTypesOfResource,
    integrateElPower=integrateElPower)                                                                                                              annotation (Placement(transformation(extent={{-76,18},{-24,66}})));
  Components.Statistics.Collectors.GlobalCollectors.HeatingPowerStatistics heatingPower(final nTypes=nTypesOfResource, integrateHeatFlow=integrateHeatFlow)
                                                                                                                       annotation (Placement(transformation(extent={{30,18},{82,66}})));

  Components.Statistics.Collectors.GlobalCollectors.EconomicStatistics totalIncurredCosts annotation (Placement(transformation(extent={{-74,-78},{-22,-28}})));

  TransiEnt.Basics.Units.MassOfCDEperEnergy m_CDE_electricity_per_Energy=gwpEmissions.m_flow_CDE_total_electricity/(electricPower.P_gen_total + simCenter.P_el_small) "x 3.6e9 = g/kWh";
  TransiEnt.Basics.Units.MassOfCDEperEnergy m_CDE_electricity_per_ConsumedEnergy=gwpEmissions.m_flow_CDE_total_electricity/(electricPower.P_demand + simCenter.P_el_small) "x 3.6e9 = g/kWh";
  TransiEnt.Basics.Units.MassOfCDEperEnergy m_CDE_districtheating_per_Energy=gwpEmissions.m_flow_CDE_total_heat/(heatingPower.Q_flow_gen_cogeneration + simCenter.P_el_small) "x 3.6e9 = g/kWh";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // Note that these can not be moved to a subclass (e.g. in order to group them) because that leads to a
  // Dymola warning for each connector.

  // ------- Electric power statistics -------
  Basics.Interfaces.General.PowerCollector powerCollector[nTypesOfResource] annotation (HideResult=true);
  Basics.Interfaces.General.PowerCollector primBalPowerCollector[nTypesOfResource] annotation (HideResult=true);
  Basics.Interfaces.General.PowerCollector primBalPowerOfferCollector[2] annotation (HideResult=true);
  Basics.Interfaces.General.PowerCollector secBalPowerCollector[nTypesOfResource] annotation (HideResult=true);
  Basics.Interfaces.General.PowerCollector secBalPowerOfferCollector[2] annotation (HideResult=true);
  Basics.Interfaces.General.PowerCollector surroundingGridLoad annotation (HideResult=true);

  Basics.Interfaces.General.PowerCollector tielinePowerCollector "Power on tieline to subsystem" annotation (HideResult=true);
  Basics.Interfaces.General.PowerCollector tielineSetPowerCollector "Scheduled imports to subsystem" annotation (HideResult=true);

  TransiEnt.Basics.Interfaces.General.KineticEnergyCollector kineticEnergyCollector[nSubgrids];

  // -------- Carbon dioxide emissions -------
  Basics.Interfaces.General.GwpEmissionCollector gwpCollector[nTypes] annotation (HideResult=true);

  Basics.Interfaces.General.GwpEmissionCollector gwpCollectorHeat[nTypesHeat] annotation (HideResult=true);

  // -------- Heating power statistics -------
  Basics.Interfaces.General.HeatFlowCollector heatFlowCollector[nTypesOfResource];
  // ---------- Cost statistics ------
  Basics.Interfaces.General.CostsCollector costsCollector annotation (HideResult=True);

equation
  //
  // Pass collector values to statistic components
  //
  for i in 1:nTypesOfResource loop
    powerCollector[i].P = electricPower.powerCollector[i];
    primBalPowerCollector[i].P = electricPower.primBalPowerCollector[i];
    secBalPowerCollector[i].P = electricPower.secBalPowerCollector[i];
    heatFlowCollector[i].Q_flow = heatingPower.heatFlowCollector[i];
  end for;

  for i in 1:nTypes loop
    gwpCollector[i].m_flow_cde = gwpEmissions.gwpCollector[i];
  end for;

  for i in 1:nTypesHeat loop
    gwpCollectorHeat[i].m_flow_cde = gwpEmissions.gwpCollectorHeat[i];
  end for;
  primBalPowerOfferCollector[1].P=electricPower.primBalPowerOfferCollector[1];
  primBalPowerOfferCollector[2].P=electricPower.primBalPowerOfferCollector[2];
  secBalPowerOfferCollector[1].P=electricPower.secBalPowerOfferCollector[1];
  secBalPowerOfferCollector[2].P=electricPower.secBalPowerOfferCollector[2];
  tielinePowerCollector.P=electricPower.tielinePowerCollector;
  tielineSetPowerCollector.P=electricPower.tielineSetPowerCollector;

  for i in 1:nSubgrids loop
  kineticEnergyCollector[i].E_kin = electricPower.kineticEnergyCollector[i];
  end for;
  surroundingGridLoad.P = -electricPower.surroundingGridLoad;

  costsCollector.Costs=totalIncurredCosts.costsCollector[1];
  costsCollector.InvestCosts=totalIncurredCosts.costsCollector[2];
  costsCollector.DemandCosts=totalIncurredCosts.costsCollector[3];
  costsCollector.OMCosts=totalIncurredCosts.costsCollector[4];
  costsCollector.OtherCosts=totalIncurredCosts.costsCollector[5];
  costsCollector.Revenues=totalIncurredCosts.costsCollector[6];

  annotation (
    defaultComponentName="modelStatistics",
    defaultComponentPrefixes="inner",
        missingInnerMessage=
        "Your model is using an outer \"modelStatistics\" but it does not contain an inner \"modelStatistics\" component. Drag model TransiEnt.ModelStatistics into your model to make it work.",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-82,-40},{84,-42}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-82,10},{84,8}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-82,60},{84,58}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-86,86},{-82,-86}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,74},{-48,44}},
          lineColor={0,0,0},
          fillColor={0,127,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-46,74},{-16,44}},
          lineColor={0,0,0},
          fillColor={0,127,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-12,74},{18,44}},
          lineColor={0,0,0},
          fillColor={0,127,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{50,74},{80,44}},
          lineColor={0,0,0},
          fillColor={0,127,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-134,92},{-134,92}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,127,127},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,24},{-48,-6}},
          lineColor={0,0,0},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-16,24},{14,-6}},
          lineColor={0,0,0},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{16,24},{46,-6}},
          lineColor={0,0,0},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{50,24},{80,-6}},
          lineColor={0,0,0},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-78,-26},{-48,-56}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{50,-26},{80,-56}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{16,-26},{46,-56}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-46,-26},{-16,-56}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{82,86},{86,-86}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,134,134},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,100},{0,-100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-100,0},{102,0}},
          color={95,95,95},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Global parameters for all models depending only on TransiEnt core library.</p>
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
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</p>
</html>"));
end ModelStatistics;
