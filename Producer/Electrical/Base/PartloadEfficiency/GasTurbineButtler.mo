within TransiEnt.Producer.Electrical.Base.PartloadEfficiency;
record GasTurbineButtler "Gas turbine part load efficiency by Buttler et al. 2015"
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

  extends TransiEnt.Producer.Electrical.Base.PartloadEfficiency.PartloadEfficiencyCharacteristic(CL_eta_P=[0, 0.2599;
0.05, 0.32536225;
0.1, 0.387829;
0.15, 0.44730025;
0.2, 0.503776;
0.25, 0.55725625;
0.3, 0.607741;
0.35, 0.65523025;
0.4, 0.699724;
0.45, 0.74122225;
0.5, 0.779725;
0.55, 0.81523225;
0.6, 0.847744;
0.65, 0.87726025;
0.7, 0.903781;
0.75, 0.92730625;
0.8, 0.947836;
0.85, 0.96537025;
0.9, 0.979909;
0.95, 0.99145225;
1, 1]);
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Gas turbine part load efficiency curve by [1].</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] A. Buttler, J. Hentschel, S. Kahlert, and M. Angerer, &ldquo;Statusbericht Flexibilitätsbedarf im Stromsektor,&rdquo; München, 2015.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end GasTurbineButtler;
