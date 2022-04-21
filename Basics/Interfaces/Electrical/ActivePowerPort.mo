within TransiEnt.Basics.Interfaces.Electrical;
connector ActivePowerPort "General interface for electrical energy in TransiEnt library (Active power and frequency)"


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





extends PartialPowerPort;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // Potential variables ("technical connection conditions")
  Modelica.Units.SI.Frequency f "Frequency of grid";


  annotation (defaultComponentName="epp",Icon(graphics={Ellipse(
          extent={{82,80},{-78,-80}},
          fillColor={0,134,134},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          lineColor={0,135,135})}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Adds nothing but a symbol to the model <a href=\"TransiEnt.Base.Interfaces.Electrical.PartialElectricPowerPort\">TransiEnt.Base.Interfaces.Electrical.PartialElectricPowerPort</a></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The connector contains the transmitted reactive and active power, voltage and frequency. The frequency is always assumed to be ideally sinusoidal without harmonic components. Unsymmetric electric grids may be modelled by using three instances of this connector. </p>
<p>An example how to adapt models based on <a href=\"Modelica.Electrical.Analog.Interfaces.Pin\">Modelica.Electrical.Analog.Interfaces.Pin</a> can be found here: <a href=\"TransiEnt.Examples.ElectricGrid.Architecture.AdaptionOfComplexElectricLoad\">AdaptionOfComplexElectricLoad</a></p>
<p>An adaption to simple real values can be realized using an adapter block like <a href=\"TransiEnt.Components.Adapters.PQ_To_EPP\">PQ_To_EPP</a> or a boundary component <a href=\"TransiEnt.Components.Boundaries.Electrical.PrescribedPotentialVariableBoundary\">PrescribedPotentialVariableBoundary</a></p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>f is the frequency of alternating current</p>
<p>v is the voltage </p>
<p>P is the active power</p>
<p>Q is the reactive power</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary, automatically set to state 4)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tu-harburg.de), Dec 2013</p>
</html>"));

end ActivePowerPort;
