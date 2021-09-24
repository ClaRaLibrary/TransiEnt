within TransiEnt.Storage.Gas;
model GasStorage_constXi_L1 "L1: Model of a simple gas storage volume for constant composition"


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

  extends Base.PartialGasStorage_L1;

  parameter Boolean useXiConstParameter = false "true if parameter xi_const shall be used, false if actualStream(gasPortIn.xi_outflow) shall be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.MassFraction xi_const[medium.nc-1] = medium.xi_default "Constant composition" annotation(Dialog(group="Fundamental Definitions"),enable=useXiConstParameter);

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  xi_gas=if useXiConstParameter then xi_const else inStream(gasPortIn.xi_outflow);

  gasPortIn.xi_outflow=inStream(gasPortOut.xi_outflow);
  gasPortOut.xi_outflow=inStream(gasPortIn.xi_outflow);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a model for simple gas storage for real gases with constant composition.</p>
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
<p><span style=\"font-family: Courier New;\">useXiConstParameter</span> can be used to either use the <span style=\"font-family: Courier New;\">inStream</span> value of <span style=\"font-family: Courier New;\">gasPortIn</span> or <span style=\"font-family: Courier New;\">xi_const</span> for the composition.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation necessary because only fundamental equations are used.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Dec 2018</p>
</html>"));
end GasStorage_constXi_L1;
