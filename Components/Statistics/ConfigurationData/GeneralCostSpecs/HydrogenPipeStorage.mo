within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model HydrogenPipeStorage "Hydrogen buried pipe storage (1300...6800 m3 geo, <100 bar)"

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



//Source: Buenger U, Michalski J, Crotogino F, Kruck O. Large-scale underground storage of hydrogen for the grid integration of renewable energy and other applications. In: Ball M, Basile A, Veziroǧlu TN, editors. Compend. Hydrog. Energy, Oxford: Woodhead Publishing; 2016, p. 133–163. doi:http://dx.doi.org/10.1016/B978-1-78242-364-5.00007-5.
//page 138: 2...7 MPa
  extends PartialCostSpecs(
    size1=6800 "Geometric volume in m3",
    C_inv_size=size1*12e6/6800 "Scaled by given value in Buenger et al. 2016",
    factor_OM=0.02 "2%, Stolzenburg 2014, cavern",
    lifeTime=50 "Buenger et al. 2016, buried pipe");
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Hydrogen buried pipe storage (1300...6800 m3 geo, &lt;100 bar)</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] U.Buenger, J. Michalski, F. Crotogino, O. Kruck, &quot;Large-scale underground storage of hydrogen for the grid integration of renewable energy and other applications&quot; In: Ball M, Basile A, Veziroǧlu TN, editors. Compend. Hydrog. Energy, Oxford: Woodhead Publishing; 2016, p. 133&ndash;163.</p>
<p>[2] K. Stolzenburg, &quot;Integration von Wind-Wasserstoff-Systemen in das Energiesystem&quot;, 2014 </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end HydrogenPipeStorage;
