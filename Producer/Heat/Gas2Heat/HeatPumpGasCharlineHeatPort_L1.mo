within TransiEnt.Producer.Heat.Gas2Heat;
model HeatPumpGasCharlineHeatPort_L1 "Gas heat pump model that produces a given heat flow via a heat port with a charline"

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

  extends TransiEnt.Producer.Electrical.Base.PartialNaturalGasUnit;
  extends TransiEnt.Producer.Heat.Base.PartialHeatPumpCharlineHeatPort_L1(
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

  Modelica.Blocks.Interfaces.RealOutput H_flow "Gas enthalpy consumed" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //charline
  COP=COP_n*1/1.37726*(4e-5*DeltaT^2-0.0111*DeltaT+1.7); //source: Andreas Palzer. 2016. Sektorübergreifende Modellierung Und Optimierung Eines Zukünftigen Deutschen Energiesystems Unter Berücksichtigung von Energieeffizienzmaßnahmen Im Gebäudesektor. Stuttgart: Fraunhofer Verlag. http://publica.fraunhofer.de/eprints/urn_nbn_de_0011-n-408742-11.pdf.
  H_flow=-Q_flow_set/COP;

  m_flow_gas=H_flow/vleNCVSensor.NCV;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple gas heat pump model that produces a given heat flow via a heat port and uses a charline.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Changing ambient temperature can be considered as well as varying COP depending on the temperature difference between heat port and source. The charline is linearly scalable with COP_n and Q_flow_n is used for the cost calculation.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Q_flow_set: set value for the heat flow</p>
<p>T_source_input_K: source temperature (ambient temperature) in K</p>
<p>heat: heat port for heat supply</p>
<p>H_flow: needed gas enthalpy flow</p>
<p>gasIn: gas port</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Temperature difference for charline (DeltaT) = heat port temperature - source temperature</p>
<p>COP=COP_n*1/1.37726*(4e-5*DeltaT^2-0.0111*DeltaT+1.7) [1]</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] A. Palzer, Sektorübergreifende Modellierung und Optimierung eines zukünftigen deutschen Energiesystems unter Berücksichtigung von Energieeffizienzmaßnahmen im Gebäudesektor. Stuttgart: Fraunhofer Verlag, 2016.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Feb 2018</p>
</html>"));
end HeatPumpGasCharlineHeatPort_L1;
