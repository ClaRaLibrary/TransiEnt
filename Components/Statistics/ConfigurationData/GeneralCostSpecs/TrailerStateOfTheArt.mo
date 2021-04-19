within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model TrailerStateOfTheArt "Cost model for state-of-the-art hydrogen trailers"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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
  extends PartialCostSpecs(
    size1=1 "Number of trailers",
    C_inv_size=332000*size1 "Stiller.2010 Potenziale der Wind-Wasserstoff-Technologie in der Freien und Hansestadt Hamburg und in Schleswig-Holstein",
    factor_OM=0.017 "1.7% Stiller.2010 Potenziale der Wind-Wasserstoff-Technologie in der Freien und Hansestadt Hamburg und in Schleswig-Holstein",
    lifeTime=20 "Stiller.2010 Potenziale der Wind-Wasserstoff-Technologie in der Freien und Hansestadt Hamburg und in Schleswig-Holstein");
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Cost model for state-of-the-art hydrogen trailers</p>
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
<p>[1] C.Stiller, P. Schmidt, J. Michalski, R.Wurster, U.Albrecht, U. Bünger, M. Altmann, &quot;Potenziale der Wind-Wasserstoff-Technologie in der Freien und Hansestadt Hamburg und in Schleswig-Holstein&quot;, 2010</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TrailerStateOfTheArt;
