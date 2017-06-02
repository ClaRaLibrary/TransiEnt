within TransiEnt.Basics.Interfaces.General;
expandable connector EyeOut
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  import SI = ClaRa.Basics.Units;

  output Real P "Real power output";
  output Real Q_flow "Real heating output" annotation(HideResult=false);

  output Real p "Pressure in bar" annotation(HideResult=false);
  output Real h_supply "Specific enthalpy in kJ/kg" annotation(HideResult=false);
  output Real h_return "Specific enthalpy in kJ/kg" annotation(HideResult=false);
  output Real m_flow "Mass flow rate in kg/s" annotation(HideResult=false);
   output SI.Temperature_DegC T_supply "Supply tempearture in degC" annotation(HideResult=false);
  output SI.Temperature_DegC T_return "Return tempearture in degC" annotation(HideResult=false);
//  input Real s "Specific entropy in kJ/kgK" annotation(HideResult=false);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Polygon(
          points={{100,0},{-100,100},{-100,-100},{100,0}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid)}));
end EyeOut;
