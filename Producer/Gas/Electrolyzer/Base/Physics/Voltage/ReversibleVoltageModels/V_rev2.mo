within TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ReversibleVoltageModels;
model V_rev2
  "PEM reversible cell voltage as modeled by Garcia-Valverde et al, 2011"

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
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ReversibleVoltageModels.PartialReversibleModel;

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
  parameter SI.Voltage V_std=1.23 "std reverse voltage of electrolysis of water";
  outer parameter SI.Temperature T_std "STD temperature";

  // _____________________________________________
  //
  //              Variables
  // _____________________________________________
  //Voltage and Overpotential Variables
public
  outer SI.Voltage V_rev "Voltage from Gibb's free energy incl. pressure and temp";

  //Temperature
  outer SI.Temperature T_op "Operating stack temperature";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Reversible Voltage
  V_rev = 1.5184 - 1.5421*(10^(-3))*T_op + 9.523*(10^(-5))*T_op*log(T_op) + 9.84*(10^(-8))*T_op^2 "Garcia 2011";

  annotation (
    defaultConnectionStructurallyInconsistent=true,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model for reversible voltage of electrolysis.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Voltage is modeled according to Garcia-Valverde et al 2012 .</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>R. Garc&iacute;a-Valverde, N. Espinosa, and A. Urbina. Simple PEM water electrolyzer model and experimental validation. International Journal of Hydrogen Energy, 37(2):1927-1938, 2012. doi:10.1016/j.ijhydene.2011.09.027. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by John Webster (jcwebste@edu.uwaterloo.ca) October 2018.</p>
</html>"));
end V_rev2;
