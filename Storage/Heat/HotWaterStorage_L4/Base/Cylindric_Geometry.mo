within TransiEnt.Storage.Heat.HotWaterStorage_L4.Base;
model Cylindric_Geometry "Vertical cylindric geometry extending the partial_Geometry"
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
  // The model extends the model partial_Geometry.
  // This model discribes the a vertiical cylindric geometry for the hot water storage.

  // The Content of the Base class Partial_geometry is:
  //    parameter SI.Volume volume "Volume of Tank";
  //    parameter SI.Length height "height of tank";
  //    parameter Integer nSeg "number of vertical tank segments";
  //
  //    parameter SI.Volume volume_Seg[nSeg] "Volume of segments of the tank";
  //    parameter SI.Area A_wall[nSeg]
  //     "Area of wall around the segments (without top and bottom area)";
  //    parameter SI.Area A_top "Top Area of Tank";
  //    parameter SI.Area A_bottom "Top Area of Tank";
  //
  //    parameter SI.Length height_Seg = height / nSeg "Height of a tank segment";

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Storage.Heat.HotWaterStorage_L4.Base.Partial_Geometry(
    final volume_Seg=fill(A_top*height_Seg, nSeg),
    final A_wall=fill(Modelica.Constants.pi*diameter*height_Seg, nSeg),
    final A_top=A_cross[1],
    final A_bottom=A_cross[1],
    final A_cross=fill(volume/height, nSeg - 1));

import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter SI.Volume volume "Volume of Tank";

  final parameter SI.Length diameter = 2*sqrt(A_top/Modelica.Constants.pi) "Tank diameter (without insulation)";

equation
  // Conditions to terminate simulation caused to illegal parameter values
   assert(volume>0,"Volume has to be positve");

annotation (
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Cylindric geometry for the one dimensional hot water storage. The model delivers shape informations for all segments.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The cylindric geometry is discretize in segments of same height. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<h5>Needed</h5>
<p><br>height: Height of storage</p><p><br>nSeg: Number of vertical storage segments (min = 2)</p><p><br>volume_Seg[nSeg]: Volumes of the storage segments</p>
<h5>Calculated</h5>
<p>A_wall[nSeg](calculated): Areas of wall around the storage segments</p><p>A_top(calculated): Top area of storage</p><p>A_bottom(calculated): Bottom area of storage</p><p>A_cross[nSeg-1](calculated): Cross-sectional areas between the segements of the storage</p><p>height_Seg(calculated): Height of one storage segment </p>
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
end Cylindric_Geometry;
