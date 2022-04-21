within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model TrailerHighCapacity "Cost model for high capacity hydrogen trailers"


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




  extends PartialCostSpecs(
    size1=1 "Number of trailers",
    C_inv_size=700000*size1 "651854 EUR + cost for rolling platform, NT 2, Zerhusen, Jan (2013): Impact of High Capacity CGH2 Trailers. Key Assumptions, Methodology and Results",
    factor_OM=0.017 "1.7% Stiller, Christoph; Schmidt, Patrick; Michalski, Jan; Wurster, Reinhold; Albrecht, Uwe; Bnger, Ulrich; Altmann, Matthias (2010): Potenziale der Wind-Wasserstoff-Technologie in der Freien und Hansestadt Hamburg und in Schleswig-Holstein. Ludwig-Blkow-Systemtechnik GmbH.",
    lifeTime=20 "Stiller, Christoph; Schmidt, Patrick; Michalski, Jan; Wurster, Reinhold; Albrecht, Uwe; Bnger, Ulrich; Altmann, Matthias (2010): Potenziale der Wind-Wasserstoff-Technologie in der Freien und Hansestadt Hamburg und in Schleswig-Holstein. Ludwig-Blkow-Systemtechnik GmbH.");
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Cost model for high capacity hydrogen trailers</p>
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
<p>[1] C.Stiller, P. Schmidt, J. Michalski, R.Wurster, U.Albrecht, U. Bünger, M. Altmann, &quot;Potenziale der Wind-Wasserstoff-Technologie in der Freien und Hansestadt Hamburg und in Schleswig-Holstein&quot;, 2010, Ludwig-Boelkow-Systemtechnik GmbH</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TrailerHighCapacity;
