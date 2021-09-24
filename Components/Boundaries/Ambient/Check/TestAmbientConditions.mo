within TransiEnt.Components.Boundaries.Ambient.Check;
model TestAmbientConditions


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
  TransiEnt.Components.Boundaries.Ambient.AmbientConditions_Hamburg_TMY ambientConditions_Hamburg_TMY annotation (Placement(transformation(extent={{-6,40},{14,60}})));
  TransiEnt.Components.Boundaries.Ambient.AmbientConditions_Cologne_TRY ambientConditions_Cologne_TRY annotation (Placement(transformation(extent={{-8,-26},{12,-6}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  annotation (experiment(
      StopTime=86400,
      Interval=60,
      __Dymola_Algorithm="Dassl"), Diagram(graphics={
        Text(
          extent={{-34,40},{44,22}},
          textColor={28,108,200},
          textString="Ambient Conditions in Hamburg (TMY)"),
        Text(
          extent={{-36,-24},{42,-42}},
          textColor={28,108,200},
          textString="Ambient Conditions in Cologne (TRY)"),
        Text(
          extent={{-80,-76},{84,-104}},
          textColor={28,108,200},
          textStyle={TextStyle.Bold},
          textString="Look at summary_X to view ambient conditions of Hamburg and Cologne")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for ambient conditions</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end TestAmbientConditions;
