﻿within TransiEnt.Basics.Tables.Ambient;
model GHI_Hamburg_3600s_2012_TMY "Hamburg's global horizontal, 1 h resolution, Source: IWEC"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

extends GenericDataTable(
relativepath="ambient/GHI_Hamburg_3600s_TMY.txt",
datasource=DataPrivacy.isPublic);

extends TransiEnt.Components.Boundaries.Ambient.Base.PartialGlobalSolarRadiation;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
 connect(y1, value);
 connect(y[1], value);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Global Horizontal Irradiation in Hamburg in a typical meteorological year (TMY) with 60 minutes time resolution.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealOutput: y[MSL_combiTimeTable.nout]</p>
<p>Modelica RealOutput: y1</p>
<p>Modelica RealOutput: irradiance in [W/m2]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Source: IWEC file, EnergyPlus weather file, eere.energy.gov</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de), Apr 2014</p>
</html>"));
end GHI_Hamburg_3600s_2012_TMY;
