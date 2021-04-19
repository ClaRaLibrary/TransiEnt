within TransiEnt.Basics.Interfaces.General;
connector MechanicalPowerPort "1-dim. rotational flange of a shaft (filled square icon)"

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

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Angle phi "Absolute rotation angle of flange";
  flow SI.Torque tau "Cut torque in the flange";

 annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={Ellipse(
          extent={{80,80},{-80,-80}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Interface for rotational mechanical components focussing on power flow rather than momentum balances (see <a href=\"Modelica.Mechanics.Rotational.Interfaces.Flange_a\">Flange</a> for mechanical interface focussing on momentum).</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Provides information about the power flow across boundaries and the angular velocity at which this (rotating) power is transported.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Provides no information about heat transfer between mechanical components. Use <a href=\"TransiEnt.Base.Interfaces.Thermal.HeatPort\">HeatPort</a> for this purpose.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Models of components emiting gwp exhaust gases would use this interface to define the amount of CO2 equivalent mass they are causing. The Block <a href=\"TransiEnt.ModelStatistics\">ModelStatistics</a> is then be able to sum up the equivalent masses emited by all components present in the global model where it can be read by the user.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary, automatically set to state 4)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tu-harburg.de), Apr 2014</p>
</html>"));
end MechanicalPowerPort;
