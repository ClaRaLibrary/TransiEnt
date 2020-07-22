within TransiEnt.Storage.Gas;
model GasStorage_varXi_L1 "L1: Model of a simple gas storage volume for variable composition"

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

  extends Base.PartialGasStorage_L1;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.MassFraction xi_gas_start[medium.nc-1]=medium.defaultMixingRatio[1:medium.nc-1] "Initial composition in the storage" annotation(Dialog(group="Initialization"));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
initial equation
  xi_gas=xi_gas_start;

equation

  der(m_gas)*xi_gas+m_gas*der(xi_gas)=gasPortIn.m_flow*noEvent(actualStream(gasPortIn.xi_outflow))+gasPortOut.m_flow*noEvent(actualStream(gasPortOut.xi_outflow));

  gasPortOut.xi_outflow=xi_gas;
  gasPortIn.xi_outflow=xi_gas;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a model for simple gas storage for real gases with variable composition.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The specific enthalpies are passed through, there is no energy balance. The pressure is constant.</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>The model is only valid if pressure and temperature of the gas are not of interest.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn and gasPortOut: Real gas input and output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Simple total and component mass balances are used.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation necessary because only fundamental equations are used.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Dec 2018</p>
</html>"));
end GasStorage_varXi_L1;
