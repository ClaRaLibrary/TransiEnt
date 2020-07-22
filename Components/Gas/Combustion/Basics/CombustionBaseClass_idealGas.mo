within TransiEnt.Components.Gas.Combustion.Basics;
partial model CombustionBaseClass_idealGas "base class for combustion models"

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

  import TransiEnt;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //           Constants and Parameters
  // _____________________________________________

  parameter TILMedia.GasTypes.BaseGas FuelMedium = simCenter.gasModel2 "Fuel medium";
  final parameter TransiEnt.Basics.Media.Gases.Gas_ExhaustGas ExhaustGas "Exhaust gas medium type";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortOut gasPortOut(Medium=ExhaustGas) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortIn gasPortIn(Medium=FuelMedium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  annotation (Icon(graphics),Diagram(graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for combustion models</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortOut gasPortOut(Medium=ExhaustGas) <span style=\"font-family: Courier New; color: #006400;\">&quot;Exhaust gas medium type&quot;</span></p>
<p>TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortIn gasPortIn(Medium=FuelMedium)  <span style=\"font-family: Courier New; color: #006400;\">&quot;Fuel medium&quot;</span></p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end CombustionBaseClass_idealGas;
