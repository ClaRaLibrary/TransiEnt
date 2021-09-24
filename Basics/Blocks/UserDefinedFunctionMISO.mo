within TransiEnt.Basics.Blocks;
model UserDefinedFunctionMISO "MISO User defined function"

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


    extends Modelica.Blocks.Icons.Block;

  // _____________________________________________
  //
  //          Paraemters
  // _____________________________________________

    parameter Integer ni=2;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput u[ni] "Connector of Real input signal" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y=f(u[1]+u[2]) "Value of Real output"    annotation (Dialog(group="Time varying output signal"),Placement(
        transformation(extent={{100,-10},{120,10}})));

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>User defined function inspired by Simulink</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>no technical modeling</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(nothing)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealInput: connector for input signals </p>
<p>Modelica RealOutput: value of real output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>no remarks</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">nothing</span></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan-Peter Heckel (jan.heckel@tuhh.de), Aug 2018</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false),
                   graphics={Text(
          extent={{-96,15},{96,-15}},
          lineColor={0,0,255},
          textString="%y")}),                                  Diagram(graphics,
                                                                          coordinateSystem(preserveAspectRatio=false, initialScale=0.1)));
end UserDefinedFunctionMISO;
