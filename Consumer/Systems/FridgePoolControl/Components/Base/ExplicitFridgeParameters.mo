within TransiEnt.Consumer.Systems.FridgePoolControl.Components.Base;
record ExplicitFridgeParameters "record for explicit fridge parameters"

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




  constant Real A_over_m = 0.47;
  constant Real P_over_m = 10.48;

  parameter SI.Temperature Tamb;
  parameter SI.Temperature Tset;
  parameter SI.SpecificHeatCapacity cp;
  parameter SI.Mass m;
  parameter SI.CoefficientOfHeatTransfer k;
  parameter SI.TemperatureDifference DTdb;
  parameter Real COP;
  parameter SI.Temperature T0;
  parameter Real x0;

  final parameter SI.Power P_el_n = P_over_m * m;
  final parameter SI.Area A = A_over_m * m;
  final parameter SI.Time tau=m*cp/(k*A);
  final parameter Real k1=P_el_n/m*COP/cp;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>record for explicit fridge parameters</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
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
<p>P. Dubucq, &ldquo;Regelung in Energienetzen mit Kraft-Wärme-Kopplung zur hohen Ausnutzung erneuerbarer Energien,&rdquo; Hamburg University of Technology, 2018.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end ExplicitFridgeParameters;
