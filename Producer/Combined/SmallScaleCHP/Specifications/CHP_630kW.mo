within TransiEnt.Producer.Combined.SmallScaleCHP.Specifications;
record CHP_630kW "ICE 630 kWel"
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

  import TransiEnt;

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Combined.SmallScaleCHP.Base.BaseCHPSpecification(
    P_el_max=630e3,
    lambda=1.877,
    eta_el_max=0.361,
    eta_el_min=0.327,
    eta_h_max=0.83,
    eta_h_min=0.846,
    pistonStroke=0.16,
    pistonDiameter=0.132,
    n_cylinder=16,
    m_engine=5510,
    k=110,
    length=3.5,
    height=2.1,
    width=2.0,
    reactionTime=1/40,
    shareExhaustHeat=0.43,
    thermalConductivity=846e3/50);
    //engineDisplacement=35/1000,

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>record for a combined heat and power plant with 630 kW (TBG616V16K from Deutz Energy)</p>
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
<p>A. K&ouml;ppen, &ldquo;Modellierung und Simulation von gekoppelten Energiesystemen in Modelica,&rdquo; Hamburg University of Technology, 2013.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end CHP_630kW;
