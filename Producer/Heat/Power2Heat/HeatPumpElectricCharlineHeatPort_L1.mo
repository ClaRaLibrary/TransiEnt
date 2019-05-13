within TransiEnt.Producer.Heat.Power2Heat;
model HeatPumpElectricCharlineHeatPort_L1 "Electric heat pump model that produces a given heat flow via a heat port with a charline"
  import TransiEnt;

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

  extends TransiEnt.Producer.Heat.Base.PartialHeatPumpCharlineHeatPort_L1(
                                  COP_n=3.4744);
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Boolean usePowerPort=false  annotation(Dialog(group="Technical Specifications"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp if usePowerPort constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (Dialog(group="Replaceable Components",enable=usePowerPort),choicesAllMatching=true,enable=usePowerPort,Placement(transformation(extent={{100,0},{120,20}}),
                                                                                                                               iconTransformation(extent={{80,-20},{120,20}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set if not
                                                                        (use_Q_flow_input) "Setpoint value of the power, should be positive" annotation (Placement(transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent={{-120,-20},{-80,20}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  replaceable TransiEnt.Components.Boundaries.Electrical.Power powerBoundary if usePowerPort  constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary                         "Choice of power boundary model. The power boundary model must match the power port." annotation (Dialog(group="Replaceable Components",enable=usePowerPort), choices(choice(redeclare TransiEnt.Components.Boundaries.Electrical.Power powerBoundary "PowerBoundary for ActivePowerPort"),choice( redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=0.99) "Power Boundary for ComplexPowerPort")),enable=usePowerPort,Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-84,-42})));

protected
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer)
                                                                                                                                      annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));


  Modelica.Blocks.Sources.RealExpression realExpression(y=P_el) if usePowerPort annotation (Placement(transformation(extent={{-102,-32},{-82,-12}})));
  Modelica.Blocks.Math.Gain P_el_set_(k=1) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant const1(k=1)
                                          annotation (Placement(transformation(extent={{-100,46},{-80,66}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  SI.Power P_el;
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if use_Q_flow_input then
    Q_flow=Q_flow_set_.u;
    P_el=-Q_flow/COP;
  else
    Q_flow=-COP*P_el;
    P_el=P_el_set_.u;
  end if;

  //charline
  COP=COP_n*1/3.4744*(0.0005*DeltaT^2-0.0973*DeltaT+6.1408); //source: Andreas Palzer. 2016. Sektorübergreifende Modellierung Und Optimierung Eines Zukünftigen Deutschen Energiesystems Unter Berücksichtigung von Energieeffizienzmaßnahmen Im Gebäudesektor. Stuttgart: Fraunhofer Verlag. http://publica.fraunhofer.de/eprints/urn_nbn_de_0011-n-408742-11.pdf.

  //collector
  collectElectricPower.powerCollector.P=P_el;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.powerCollector[collectElectricPower.typeOfResource],collectElectricPower.powerCollector);
  if usePowerPort then
    connect(epp, powerBoundary.epp) annotation (Line(
      points={{110,10},{110,-42},{-74,-42}},
      color={0,135,135},
      thickness=0.5));
    connect(realExpression.y, powerBoundary.P_el_set) annotation (Line(points={{-81,-22},{-78,-22},{-78,-30}}, color={0,0,127}));
  end if;

  if not
        (use_Q_flow_input) then
    connect(P_el_set_.u, P_el_set) annotation (Line(points={{-62,30},{-68,30},{-68,16},{-84,16},{-84,0},{-100,0}},
                                                                                               color={0,0,127}));
  else
    connect(const1.y, P_el_set_.u) annotation (Line(points={{-79,56},{-68,56},{-68,30},{-62,30}}, color={0,0,127}));
  end if;
annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple electric heat pump model that produces a given heat flow via a heat port and uses a charline.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Changing ambient temperature can be considered as well as varying COP depending on the temperature difference between heat port and source. The charline is linearly scalable with COP_n and Q_flow_n is used for the cost calculation.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Q_flow_set: set value for the heat flow</p>
<p>T_source_input_K: source temperature (ambient temperature) in K</p>
<p>heat: heat port for heat supply</p>
<p>P_el: needed electric power</p>
<p>epp: electric power port</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Temperature difference for charline (DeltaT) = heat port temperature - source temperature</p>
<p>COP=COP_n*1/3.4744*(0.0005*DeltaT^2-0.0973*DeltaT+6.1408) [1]</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] A. Palzer, Sektorübergreifende Modellierung und Optimierung eines zukünftigen deutschen Energiesystems unter Berücksichtigung von Energieeffizienzmaßnahmen im Gebäudesektor. Stuttgart: Fraunhofer Verlag, 2016.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Feb 2018</p>
</html>"));
end HeatPumpElectricCharlineHeatPort_L1;
