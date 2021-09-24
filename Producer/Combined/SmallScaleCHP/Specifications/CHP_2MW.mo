within TransiEnt.Producer.Combined.SmallScaleCHP.Specifications;
record CHP_2MW "ICE 2 MWel"

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




 // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Combined.SmallScaleCHP.Base.BaseCHPSpecification(
    P_el_max=2000e3,
    eta_el_max=0.437,
    eta_h_min=0.833,
    m_engine=8070,
    length=3.7,
    height=2.6,
    width=1.5,
    P_el_min=0.5*P_el_max,
    eta_el_min=0.41,
    eta_h_max=0.903,
    n_cylinder=20);//deadweight Motor
    // from data sheet
    // not from data sheet

    //lambda=1.8,
    // T_opt=348.15,
    // eta_m=0.85,
    //
    // k=5,
    // reactionTime=1/15,
    // pistonStroke=0.091,
    // pistonDiameter=0.09);
    // //engineDisplacement=580/100^3,
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>record for a combined heat and power plant with 2 MW (MWM TCG2020V2)</p>
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
<p>A. Zaczek, &ldquo;Modeling of CHP-based local heating networks in order to cover the positive residual load,&rdquo; Hamburg University of Technology, 2016.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end CHP_2MW;
