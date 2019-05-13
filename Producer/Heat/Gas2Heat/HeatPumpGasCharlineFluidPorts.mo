within TransiEnt.Producer.Heat.Gas2Heat;
model HeatPumpGasCharlineFluidPorts "Gas heat pump model that produces a given heat flow via fluid ports with a charline"

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

  extends TransiEnt.Producer.Electrical.Base.PartialNaturalGasUnit;
  extends TransiEnt.Producer.Heat.Base.PartialHeatPumpCharlineFluidPorts(
                                            COP_n=1.37726);
  import SI = Modelica.SIunits;

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
  Modelica.Blocks.Sources.Constant const1(k=1)
                                          annotation (Placement(transformation(extent={{-100,46},{-80,66}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  Modelica.SIunits.MassFlowRate m_flow_cde_total;
  SI.EnthalpyFlowRate H_flow;
public
  Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric           collectGwpEmissions(typeOfEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas) annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
protected
  Modelica.SIunits.MolarFlowRate[5] ElementCompositionFuel;

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
  ElementCompositionFuel=TransiEnt.Basics.Functions.GasProperties.comps2Elements_realGas(medium,vleNCVSensor.xi,gasPortIn.m_flow);

  m_flow_gas=H_flow/vleNCVSensor.NCV;

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
</html>"));
end HeatPumpGasCharlineFluidPorts;
