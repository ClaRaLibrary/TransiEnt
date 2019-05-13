within TransiEnt.Producer.Gas.MethanatorSystem.Controller;
model ControllerCO2ForMethanator

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
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.MolarMass M_H2=0.0020159 "Molar mass of hydrogen";
  constant SI.MolarMass M_CO2=0.0440095 "Molar mass of carbon dioxide";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real molarRatioH2toCO2=4 "Molar ratio hydrogen to carbon dioxide" annotation(Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_H2 "Hydrogen mass flow for methanation" annotation (Placement(transformation(extent={{120,-20},{80,20}})));

  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_CO2 "Carbon dioxide mass flow from source" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  m_flow_CO2=-(m_flow_H2*M_CO2/(molarRatioH2toCO2*M_H2));

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

 annotation (Icon(graphics,
                  coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is used to control m_flow_CO2 for a Methanator system. It is dependent on m_flow_H2.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput:&nbsp;m_flow_H2 in [kg/s]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealOutput:&nbsp;m_flow_CO2 in [kg/s]</span></p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>m_flow_CO2=-(m_flow_H2*M_CO2/(molarRatioH2toCO2*M_H2))</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end ControllerCO2ForMethanator;
