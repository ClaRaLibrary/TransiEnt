within TransiEnt.Basics.Tables.ElectricGrid.PowerData;
model ElectricityGeneration_HHMitte_3600s_2012 "Hourly electricity generation data in Hamburg-Mitte. Source: Energie Portal Hamburg"

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

  extends PowerData.GenericPowerDataTable(
                                      relativepath="electricity/ElectricityGeneration_Mitte_3600s_01012012_31122012.txt",
      datasource=DataPrivacy.isPublic);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Total electricity generation in Hamburg-Mitte in the year 2012 in [W] with 60 minutes time resolution.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealOutput: y[MSL_combiTimeTable.nout]</p>
<p>Modelica RealOutput: y1</p>
<p>Modelica RealOutput: electric power in W</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Source:</p>
<p>[1] Stromnetz Hamburg GmbH: <i>Energieportal Hamburg</i>. URL http://www.energieportal-hamburg.de/distribution/energieportal/</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
<p><br><br><img src=\"modelica://TransiEnt/Images/ElectricityGeneration_HHMitte_3600s_2012.png\"/></p>
</html>"));
end ElectricityGeneration_HHMitte_3600s_2012;
