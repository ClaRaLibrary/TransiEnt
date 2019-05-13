within TransiEnt.Producer.Electrical.Base;
partial model PartialElectricPowerPlant "Abstract model of an electric power plant with L1 on electric side"

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

  extends TransiEnt.Basics.Icons.IndustryPlant;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Power P_el_n=300e6 "Nominal power of plant"     annotation (Dialog(group="Physical Constraints"), HideResult=false,
    Placement(transformation(extent=100)));

  parameter Modelica.SIunits.Efficiency eta_total=0.6 "Total efficiency of plant for emission calculation"
      annotation (Dialog(group="Statistics"), HideResult = not simCenter.isExpertMode,
    Placement(transformation(extent=100)));

  parameter EnergyResource typeOfResource=EnergyResource.Conventional "Type of energy resource for global model statistics"
    annotation (Dialog(group="Statistics"), HideResult = not simCenter.isExpertMode,
    Placement(transformation(extent=100)));

  parameter PrimaryEnergyCarrier typeOfPrimaryEnergyCarrier=PrimaryEnergyCarrier.BlackCoal "Type of primary energy carrier for co2 emissions global statistics"
    annotation (Dialog(group="Statistics"), HideResult = not simCenter.isExpertMode);

  parameter Boolean integrateElPower=simCenter.integrateElPower "true if electric powers shall be integrated" annotation(Dialog(group="Statistics"));
  parameter Boolean integrateCDE=simCenter.integrateCDE "true if CDE shall be integrated" annotation(Dialog(group="Statistics"));
  parameter Boolean calculateCost=simCenter.calculateCost "true if costs shall be calculated" annotation(Dialog(group="Statistics"));
  final parameter Integer nSubgrids=simCenter.iDetailedGrid "For calculation of statistics in subgrids (=1 local grid, e.g. hamburg, =2 surrounding grid, e.g. UCTE grid";

   replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BrownCoal              constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs
                                               annotation (Dialog(group="Statistics"),
      __Dymola_choicesAllMatching=true);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (choicesAllMatching=true,Dialog(group="Replaceable Components"), Placement(transformation(extent={{90,68},{110,88}}), iconTransformation(extent={{80,60},{100,80}})));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(integrateElPower=integrateElPower)
                                                                                                       annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissions(typeOfEnergyCarrier=typeOfPrimaryEnergyCarrier, integrateCDE=integrateCDE)
                                                                                                                                                             annotation (Placement(transformation(extent={{56,-100},{76,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.PowerPlantCost collectCosts(
    P_n=P_el_n,
    redeclare model PowerPlantCostModel = ProducerCosts,
    Q_flow_fuel_is=Q_flow_fuel_is,
    m_flow_CDE_is=m_flow_CDE,
    P_el_is=P_el_is,
    produces_Q_flow=false)
                     annotation (HideResult=false, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-90})));//if calculateCost
//  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectInertiaConstant collectInertiaConstant;

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  SI.ActivePower P_el_is = -epp.P;
  Real P_star = P_el_is/P_el_n;
  SI.Efficiency eta;

  SI.Time t_fullload(displayUnit="h")=E_total_generation/P_el_n "full load time in hours";
  SI.Energy E_total_generation(start=0, fixed=true,displayUnit="kWh") "Start value for generated electricity statistics" annotation (Dialog(group="Initialization"));
  Boolean is_running(start=true, fixed=true) "For continuous plants always true, for discontinous depending on state";

  SI.EnthalpyFlowRate Q_flow_fuel_is = P_el_is/eta;
  SI.MassFlowRate m_flow_CDE = fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*abs(P_el_is)/eta-m_flow_gas_CDE_deposited;
  SI.MassFlowRate m_flow_gas_CDE_deposited=0*time;
protected
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=typeOfPrimaryEnergyCarrier);

public
  Real delta_f_star = (epp.f-simCenter.f_n)/simCenter.f_n;

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  collectElectricPower.powerCollector.P=epp.P;

  if not typeOfResource == EnergyResource.Cogeneration then
  collectGwpEmissions.gwpCollector.m_flow_cde=-1*m_flow_CDE;
     connect(modelStatistics.gwpCollector[typeOfPrimaryEnergyCarrier],collectGwpEmissions.gwpCollector);
  end if;

  if integrateElPower then
    der(E_total_generation) = max(0,-epp.P);
  else
    E_total_generation=0;
  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.powerCollector[typeOfResource],collectElectricPower.powerCollector);
  //if calculateCost then
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);
  //end if;
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                    Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Line(
          points={{90,-40},{90,-40},{90,-74}},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),                                     Line(
          points={{66,-40},{66,-40},{66,-74}},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),                                     Line(
          points={{90,-40},{-90,-40},{-90,-76}},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled})}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Prototype model for electric power plant models containing all relevant statistic blocks.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2; background-color: #ffffff;\">L1E (defined in the CodingConventions)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>epp: active power port</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end PartialElectricPowerPlant;
