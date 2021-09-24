within TransiEnt.Basics.Tables.Check;
model TestTableUnits "Model for testing table units"

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



  extends TransiEnt.Basics.Icons.Checkmodel;
  Ambient.GHI_Hamburg_3600s_2012_TMY irradiationHamburg_3600s_010120120_010120130_1 annotation (Placement(transformation(extent={{-18,-2},{2,18}})));
  ElectricGrid.PowerData.ElectricityGeneration_HHAltona_3600s_2012
    electricityGeneration_HHAltona_3600s_2012_1
    annotation (Placement(transformation(extent={{-22,40},{-2,60}})));
  Ambient.Temperature_Hamburg_Fuhlsbuettel_3600s_2012 temperatureHH_900s_01012012_0000_31122012_2345_1 annotation (Placement(transformation(extent={{-16,-40},{4,-20}})));
  Ambient.Temperature_Hamburg_Fuhlsbuettel_86400s_2012 temperatureHH_86400s_01012012_0000_31122012_2345_2 annotation (Placement(transformation(extent={{-16,-66},{4,-46}})));
  GasGrid.NaturalGasVolumeFlowSTP naturalGasVolumeFlowSTP annotation (Placement(transformation(extent={{-16,-94},{4,-74}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{30,20},{90,-30}},
          lineColor={0,0,255},
          textString="Plot outputs (y1) and check units

")}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the different ambient table units</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestTableUnits;
