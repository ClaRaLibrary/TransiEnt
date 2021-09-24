within TransiEnt.Basics.Tables.ElectricGrid.ElectricityPrices;
model GenericElectricityPriceTable


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




  extends GenericDataTable;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>This model creates a generic data table to be used for electricity price time series</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(none)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(none)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>Modelica RealOutput: y[MSL_combiTimeTable.nout]</p>
<p>Modelica RealOutput: y1</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(none)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(none)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Model created by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), July 2021</p>
</html>"));
end GenericElectricityPriceTable;
