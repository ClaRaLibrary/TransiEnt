within TransiEnt.Storage.Heat.HotWaterStorage_L4.Base;
model PortGeometry
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

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter SI.Length height_port(min=0) "Height of port";
  parameter SI.Length height_segment "Height of one segment";
  parameter Integer nSeg(min=1) "Number of vertical tank segments";

  final parameter Integer segment = Utilities.get_Layer(height_port, height_segment, nSeg) "Segment in which the port is located";

  // _____________________________________________
  //
  //          Algorithms
  // _____________________________________________
algorithm
    assert(height_port >= 0,
      "Height of port hast to be zero or greater. Adjust!");
    assert(height_segment > 0,
      "Height of segment hast to be positive. Adjust!");
    assert(nSeg> 0,
      "Number of tank segments hast to be positive. Adjust!");
    assert(height_port <= nSeg*height_segment,
      "Height of port hast to be lower or equal to the all over height (nSeg*Height_segment). Adjust!");
    assert(height_port >= 0,
      "Height of port hast to be greater or equal to zero. Adjust!");

  // _____________________________________________
  //
  //          Dokumentation
  // _____________________________________________

 annotation (Icon(graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,134,134},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Calculation of the storage layer (segment) the port is connected to. The layer depends on the height the port is located at, the height of one segment and the number of segments. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects consideres.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>height_port: height the port is located </p><p>height_segment: height of one storage segment </p><p>nSeg: number of storage segments segment: calculated segment </p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Ramm (tobias.ramm@tuhh.de) on Fri Mar 20 2015</p>
<p>Revised and edited by Lisa Andresen (andresen@tuhh.de), Jun 2015</p>
</html>"));
end PortGeometry;
