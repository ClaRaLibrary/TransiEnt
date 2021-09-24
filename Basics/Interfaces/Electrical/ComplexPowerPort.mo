within TransiEnt.Basics.Interfaces.Electrical;
connector ComplexPowerPort "Single phase electric connector containing active, reactive power, frequency, voltage and voltage angle for quasistationary ac power models"

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




extends PartialPowerPort;

  // Potential variables ("technical connection conditions")
  Modelica.Units.SI.Angle delta "Voltage Angle";
  Modelica.Units.SI.Voltage v "Voltage of grid";
  TransiEnt.Basics.Units.Frequency2 f "Frequency of grid";

  // Flow variables ("Transmitted information")
  flow Modelica.Units.SI.ReactivePower Q "Reactive Power";

  annotation (defaultComponentName="epp",Icon(graphics={Ellipse(
          extent={{82,80},{-80,-80}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Power Port which allows power flow calculations </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The connector contains the transmitted reactive and active power, voltage (magnitude and angle) and frequency. The frequency is always assumed to be ideally sinusoidal without harmonic components. Symmetric grids are assumed. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>f is the frequency of alternating current</p>
<p>v is the voltage </p>
<p>P is the active power</p>
<p>Q is the reactive power</p>
<p>delta is the angle of the complex voltage</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary, automatically set to state 4)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in May 2018</p>
</html>"));
end ComplexPowerPort;
