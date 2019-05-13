within TransiEnt.Producer.Gas.Electrolyzer.Base;
partial model PartialElectrolyzerDynamics "Partial class for electrolyzer dynamics"

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

  import SI = Modelica.SIunits;

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //              Variable Declarations
  // _____________________________________________

  parameter Boolean useHomotopy "true if homotopy method is used during initialization" annotation (Dialog(enable=false));

  parameter SI.ActivePower P_el_n "Nominal power of the electrolyzer" annotation (Dialog(enable=false));
  parameter SI.Efficiency eta_n "Nominal efficiency coefficient" annotation (Dialog(enable=false));

  SI.Power P_el "Electric power";
  SI.Efficiency eta(start=1) "Efficiency of the electrolyzer" annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.EnthalpyFlowRate H_flow_H2 "H2 enthalpy flow rate out of electrolyzer";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Line(
          points={{-80,-40}},
          color={255,0,0},
          smooth=Smooth.Bezier), Line(
          points={{-75,-30},{-40,60},{0,-60},{40,60},{75,-30}},
          color={255,0,0},
          smooth=Smooth.Bezier)}),Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a partial model for electrolyzer dynamics. </p>
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
end PartialElectrolyzerDynamics;
