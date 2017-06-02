within TransiEnt.Basics.Interfaces.General;
connector CostsCollector

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

 flow TransiEnt.Basics.Units.MonetaryUnit Costs "Total costs";
 flow TransiEnt.Basics.Units.MonetaryUnit InvestCosts "Invest-related costs";
 flow TransiEnt.Basics.Units.MonetaryUnit DemandCosts "Demand-related costs";
 flow TransiEnt.Basics.Units.MonetaryUnit OMCosts "Operation-related costs incl. maintenance";
 flow TransiEnt.Basics.Units.MonetaryUnit OtherCosts "Other costs";
 flow TransiEnt.Basics.Units.MonetaryUnit Revenues "Revenues";

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={Ellipse(
          extent={{-80,82},{80,-80}},
          lineColor={0,0,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid)}));
end CostsCollector;
