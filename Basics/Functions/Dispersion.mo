within TransiEnt.Basics.Functions;
function Dispersion "Function calculates the statistical dispersion"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Icons.Function;
  import TransiEnt;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input Real x[:] "Input Vector";
  output Real result "Result value";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Real mean;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

algorithm
  result:=0 "variable initialisation";
  mean:=TransiEnt.Basics.Functions.MeanValue(x) "gets the mean value of x";
  for i in 1:size(x, 1) loop
      result:=result + abs(x[i] - mean);
  end for "sums up the absolute difference between value and mean value";
  result:=result / size(x, 1);


  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This function calculates the mean absolute deviation (MAD). The result is the mean of the data&apos;s absolute deviations around the mean.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description) </p>
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
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end Dispersion;
