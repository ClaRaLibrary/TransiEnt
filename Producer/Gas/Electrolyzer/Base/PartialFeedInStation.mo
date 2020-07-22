within TransiEnt.Producer.Gas.Electrolyzer.Base;
partial model PartialFeedInStation

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

  extends TransiEnt.Basics.Icons.FeedInStation;
  import TransiEnt;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_feedIn "Mass flow rate input" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={108,70}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=180,
        origin={100,80})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set "Electric power input" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,108}), iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={0,104})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-10,-106},{10,-86}}), iconTransformation(extent={{-20,-116},{10,-86}})));
  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp if usePowerPort constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (choicesAllMatching=true, Dialog(tab="General", group="General"), Placement(transformation(extent={{-110,-10},{-90,10}})));
  parameter Boolean usePowerPort=true "True if power port shall be used" annotation (Dialog(group="General"));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics),                    Diagram(graphics,
                                                                       coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This partial model can be used for feed in stations where hydrogen and/or methane is produced with an electrolyzer (and methanator) and fed into a natural gas grid. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_el_set: input for the set value for the electric power </p>
<p>m_flow_feedIn: input for the possible feed-in mass flow into the natural grid etc. </p>
<p>epp: electric power port for the electrolyzer, type can be chosen </p>
<p>gasPortOut: outlet of the hydrogen </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Oliver Schülting (oliver.schuelting@tuhh.de) in April 2018</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
</html>"));
end PartialFeedInStation;
