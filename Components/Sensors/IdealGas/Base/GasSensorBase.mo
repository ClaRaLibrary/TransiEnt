within TransiEnt.Components.Sensors.IdealGas.Base;
model GasSensorBase "Base class for gas sensors"
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
  //              Visible Parameters
  // _____________________________________________

inner parameter TILMedia.GasTypes.BaseGas medium = simCenter.gasModel2 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortIn inlet(Medium=medium) annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortOut outlet(Medium=medium) annotation (Placement(transformation(extent={{90,-110},{110,-90}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  inlet.p = outlet.p;
  inlet.m_flow + outlet.m_flow = 0;
  inlet.h_outflow=inStream(outlet.h_outflow);
  outlet.h_outflow=inStream(inlet.h_outflow);
  inlet.xi_outflow=inStream(outlet.xi_outflow);
  outlet.xi_outflow=inStream(inlet.xi_outflow);

  annotation (                               Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                  graphics),
                                 Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for ideal gas sensors.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>IdealGasEnthPortIn: ideal gas enthalpy inlet</p>
<p>IdealGasEnthPortOut: ideal gas enthalpy outlet</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Sep 2016</p>
</html>"));
end GasSensorBase;
