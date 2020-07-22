within TransiEnt.Producer.Gas.Electrolyzer.Base;
partial model PartialElectrolyzerEfficiencyCharline "Partial class for electrolyzer efficiency charlines"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.ActivePower P_el_n(min=0) "Nominal power input of the electrolyzer (min = 0)" annotation (Dialog(enable=false));
  parameter Modelica.SIunits.Efficiency eta_n(min=0, max=1) "Nominal efficiency coefficient (min = 0, max = 1)" annotation (Dialog(enable=false));
  parameter Modelica.SIunits.Efficiency eta_scale(min=0, max=1) "Sets an linear degrading efficency coefficient with increasing input power (min = 0, max = 1)" annotation (Dialog(enable=false));
protected
  parameter Modelica.SIunits.Efficiency eta_n_cl "Nominal efficency coefficient of the charline";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  Modelica.SIunits.ActivePower P_el "Input power";
  Modelica.SIunits.Efficiency eta "Output efficency";
protected
  Modelica.SIunits.Efficiency eta_cl;

  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-50,44},{-44,54},{-30,62},{-18,56},{-14,44},{-16,36},{-30,-16},{-16,36},{-4,48},{12,52},{28,48},{34,36},{36,22},{30,6},{14,-48},{14,-68},{22,-76},{34,-72},{40,-64}},
          color={0,0,0},
          smooth=Smooth.Bezier)}),                               Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a partial model for electrolyzer efficiency curves. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in March 2017<br> </p>
</html>"));
end PartialElectrolyzerEfficiencyCharline;
