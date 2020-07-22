within TransiEnt.Components.Boundaries.Electrical.ComplexPowerAdvanced.Characteristics;
model Qcurve_genericDeadband "Generic Q(v)-curve with deadband for all voltage levels"
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

  extends TransiEnt.Components.Boundaries.Electrical.ComplexPowerAdvanced.Characteristics.Qcurve_empty;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Voltage v_n=simCenter.v_n;
    parameter Modelica.SIunits.ReactivePower Q_max_star=0.41;
    parameter Real lowerLimit=0.98 "percent of v_n";
    parameter Real upperLimit=1.02 "percent of v_n";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation

  if voltageIn <= lowerLimit*v_n then
    reactivePowerOut =Q_max_star/((0.1 - (1 - lowerLimit))*v_n)*(voltageIn - lowerLimit*v_n);

  elseif voltageIn > lowerLimit*v_n and voltageIn < upperLimit*v_n then

  reactivePowerOut= 0;

else

    reactivePowerOut =Q_max_star/((0.1 - (upperLimit - 1))*v_n)*(voltageIn - upperLimit*v_n);
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
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
<p>(no references)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Jan-Peter Heckel (jan.heckel@tuhh.de), Feb 2019</p>
</html>"));
end Qcurve_genericDeadband;
