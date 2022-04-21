within TransiEnt.Producer.Electrical.Base;
package PartloadEfficiency


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




extends TransiEnt.Basics.Icons.DataPackage;















annotation (Documentation(info="<html>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">1. Purpose of model</span></b></p>
<p>The records contained in this package describe the relative efficiency of conventional power plants as a function of the plant&apos;s load. Both quantities are defined as decimal values (percent).</p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">These records are used in the following component: <span style=\"color: #5500ff;\">TransiEnt.Producer.Electrical.Conventional.SecondOrderContinuousPlant</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">The relative efficiency is defined as follows:</span></p>
<p align=\"center\"><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TransiEnt/Images/equations/equation-HH6jSgFa.png\" alt=\"eta_rel=eta_partload/eta_nominal\"/></span></p>
<p><br><br><span style=\"font-family: MS Shell Dlg 2;\">The result of multiplying the relative efficiency and the nominal efficiency results in part load efficiency characteristic lines such as these:</span></p>
<p align=\"center\"><img src=\"modelica://TransiEnt/Images/PartloadEfficiency.tiff\"/></p>
<p><br><br><br><br><br><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">Purely technical component without physical modeling.</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">Purely technical component without physical modeling.</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">none</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">no elements</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">no equations</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>none</p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">no validation or testing necessary, automatically set to state 3</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">none</span></p>
<p><b><span style=\"font-family: Arial,sans-serif; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: Arial,sans-serif;\">Model created by Ricardo Peniche and Pascal Dubucq (peniche@tuhh.de) on 2016</span></p>
</html>"));
end PartloadEfficiency;
