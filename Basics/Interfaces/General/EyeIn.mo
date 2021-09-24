within TransiEnt.Basics.Interfaces.General;
expandable connector EyeIn

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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import SI = ClaRa.Basics.Units;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input Real P "Real power output" annotation(HideResult=false);
  input Real Q_flow "Real heating output" annotation(HideResult=false);

  input Real p "Pressure in bar" annotation(HideResult=false);
  input Real h_supply "Specific enthalpy in kJ/kg" annotation(HideResult=false);
  input Real h_return "Specific enthalpy in kJ/kg" annotation(HideResult=false);
  input Real m_flow "Mass flow rate in kg/s" annotation(HideResult=false);
  input SI.Temperature_DegC T_supply "Supply tempearture in degC" annotation(HideResult=false);
  input SI.Temperature_DegC T_return "Return tempearture in degC" annotation(HideResult=false);
//  input Real s "Specific entropy in kJ/kgK" annotation(HideResult=false);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Polygon(
          points={{100,0},{-100,100},{-100,-100},{100,0}},
          lineColor={28,108,200},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
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
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Ricardo Peniche (peniche@tuhh.de), Jul 2015</p>
</html>"));
end EyeIn;
