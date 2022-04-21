within TransiEnt.Producer.Heat.Gas2Heat;
model HeatPumpGasCharline "Gas heat pump model that produces a given heat flow via fluid ports with a charline"



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

  extends TransiEnt.Producer.Electrical.Base.PartialNaturalGasUnit(final useGasPort=true,final useSecondGasPort=false);
  extends TransiEnt.Producer.Heat.Base.PartialHeatPumpCharline(COP_n=1.37726);
  import Modelica.Units.SI;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.EnthalpyFlowRateIn H_flow_set if not
                                                                      (use_Q_flow_input) "Setpoint value of the enthalpy flow rate, should be positive" annotation (Placement(transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent={{-120,-20},{-80,20}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Math.Gain H_flow_set_(k=1) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant const1(k=1) annotation (Placement(transformation(extent={{-100,46},{-80,66}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  Modelica.Units.SI.MassFlowRate m_flow_cde_total;
  SI.EnthalpyFlowRate H_flow;
public
  Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissions(typeOfEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas) annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=H_flow) annotation (Placement(transformation(extent={{-88,84},{-68,104}})));
  Modelica.Blocks.Math.Division division annotation (Placement(transformation(extent={{-60,78},{-40,98}})));

protected
  Modelica.Units.SI.MolarFlowRate[5] ElementCompositionFuel;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if use_Q_flow_input then
    Q_flow=Q_flow_set_.u;
    H_flow = -Q_flow/COP;
  else
    Q_flow=-COP*H_flow;
    H_flow = H_flow_set_.u;
  end if;

  //charline
  COP=COP_n*1/1.37726*(4e-5*DeltaT^2-0.0111*DeltaT+1.7); //source: Andreas Palzer. 2016. Sektorübergreifende Modellierung Und Optimierung Eines Zukünftigen Deutschen Energiesystems Unter Berücksichtigung von Energieeffizienzmaßnahmen Im Gebäudesektor. Stuttgart: Fraunhofer Verlag. http://publica.fraunhofer.de/eprints/urn_nbn_de_0011-n-408742-11.pdf.
  // === CO2 Emissions ===
  collectGwpEmissions.gwpCollector.m_flow_cde=m_flow_cde_total;
  m_flow_cde_total=-ElementCompositionFuel[1]*44.0095/1000;
  ElementCompositionFuel=TransiEnt.Basics.Functions.GasProperties.comps2Elements_realGas(
    mediumGas,
    vleNCVSensor.xi,
    gasPortIn.m_flow);


  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(modelStatistics.gwpCollectorHeat[PrimaryEnergyCarrier.NaturalGas],collectGwpEmissions.gwpCollector);

  if not
        (use_Q_flow_input) then
    connect(H_flow_set_.u, H_flow_set) annotation (Line(points={{-62,30},{-68,30},{-68,16},{-84,16},{-84,0},{-100,0}}, color={0,0,127}));
  else
    connect(const1.y, H_flow_set_.u) annotation (Line(points={{-79,56},{-68,56},{-68,30},{-62,30}}, color={0,0,127}));
  end if;

  connect(realExpression1.y, division.u1) annotation (Line(points={{-67,94},{-62,94}}, color={0,0,127}));
  connect(division.y, m_flow_gas) annotation (Line(points={{-39,88},{8,88}}, color={0,0,127}));

  connect(vleNCVSensor.NCV, division.u2) annotation (Line(points={{53,92},{50,92},{50,110},{-96,110},{-96,82},{-62,82}},                                         color={0,0,127}));


annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for simple heat pump models that produce a given heat flow via fluid ports and use a charline.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Changing ambient temperature can be considered as well as varying COP depending on the temperature difference between waterPortOut and source. The charline is linearly scalable with COP_n and Q_flow_n is used for the cost calculation. Different heat flow boundaries, in which the heat flow is transfered to the water, can</p>
<p>be chosen.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Q_flow_set: set value for the heat flow</p>
<p>T_source_input_K: source temperature (ambient temperature) in K</p>
<p>waterPortIn: inlet port for heating water</p>
<p>waterPortOut: outlet port for heating water</p>
<p>H_flow: needed gas enthalpy flow</p>
<p>gasIn: gas port</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Temperature difference for charline = waterPortOut temperature - source temperature</p>
<p>COP=COP_n*1/1.37726*(4e-5*DeltaT^2-0.0111*DeltaT+1.7) [1]</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] A. Palzer, Sektor&uuml;bergreifende Modellierung und Optimierung eines zuk&uuml;nftigen deutschen Energiesystems unter Ber&uuml;cksichtigung von Energieeffizienzma&szlig;nahmen im Geb&auml;udesektor. Stuttgart: Fraunhofer Verlag, 2016.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Feb 2018</p>
<p>Model modified by Jan Westphal (j.westphal@tuhh.de), Jul 2019 (added boolean for using heat port insead of fluid ports)</p>
</html>"));
end HeatPumpGasCharline;
