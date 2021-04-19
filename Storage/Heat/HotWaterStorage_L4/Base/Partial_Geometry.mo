within TransiEnt.Storage.Heat.HotWaterStorage_L4.Base;
partial model Partial_Geometry "Partial model of storage geometry"
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
// This model defines the parameters which geometries for the hot water storage
// have to provide at least.
// Constraints are:
// - the geometry has to be diveded in segments of same height
// - the volume and and the areas enclosing the volume have to be determined
//   for every segment

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

   parameter SI.Length height "Height of tank";
   parameter Integer nSeg = 2 "Number of vertical tank segments";

   parameter SI.Volume volume_Seg[nSeg] "Volume of segments of the tank";
   parameter SI.Area A_wall[nSeg] "Area of wall around the segments (without top and botom area)";
   parameter SI.Area A_top "Top Area of Tank";
   parameter SI.Area A_bottom "Top Area of Tank";
   parameter SI.Area A_cross[nSeg-1] "Cross-sectional area of the tank";

   final parameter SI.Length height_Seg = height/ nSeg "Height of a tank segment";

equation
  // Conditions to terminate simulation caused to illegal parameter values
  assert(height>0,"Height has to be positve");
  assert(nSeg>0,"Number of tank segmaents has to be positve");
  assert(A_top>0,"Area has to be positve");
  assert(A_bottom>0,"Area has to be positve");
annotation (Icon(graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-90,90},{90,-90}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          closure=EllipseClosure.Radial)}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base model for the shape of the one dimensional hot water storage. The model delivers shape informations for all segments. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The shape of the hot water storage has to be descretized in segments of same height. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p><br>height: Height of tank</p><p><br>nSeg: Number of vertical tank segments (min = 2)</p><p><br>volume_Seg[nSeg]: Volumes of the storage segments</p><p><br>A_wall[nSeg]: Areas of wall around the storage segments</p><p><br>A_top: Top area of storage</p><p><br>A_bottom: Bottom area of storage</p><p><br>A_cross[nSeg-1]: Cross-sectional areas between the segements of the storage</p><p><br>height_Seg(calculated) : Height of one storage segment </p>
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
end Partial_Geometry;
