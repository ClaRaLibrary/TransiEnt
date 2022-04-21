within TransiEnt.Producer.Electrical.Conventional.Components;
model TwoBlockPlant "Abstract model for power plants composed by two blocks"


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
  extends TransiEnt.Basics.Icons.SteamCycle2Blocks;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set_B1 "Setpoint of block 1" annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-119,120}),                                  iconTransformation(
          extent={{-15,-14},{15,14}},
        rotation=270,
        origin={-121,126})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set_B2 "Setpoint of block 1" annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={59,124}),                                    iconTransformation(
          extent={{-15,-14},{15,14}},
        rotation=270,
        origin={101,126})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{208,90},{228,110}}), iconTransformation(extent={{206,98},{236,126}})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable TransiEnt.Producer.Electrical.Conventional.Components.SecondOrderPlant Block1 constrainedby TransiEnt.Producer.Electrical.Base.PartialDispatchablePowerPlant annotation (choicesAllMatching=true, Placement(transformation(extent={{-167,-46},{-53,58}})));
  replaceable TransiEnt.Producer.Electrical.Conventional.Components.SecondOrderPlant Block2 constrainedby TransiEnt.Producer.Electrical.Base.PartialDispatchablePowerPlant annotation (choicesAllMatching=true, Placement(transformation(extent={{12,-46},{126,58}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Block1.epp, epp) annotation (Line(
      points={{-58.7,42.4},{-22,42.4},{-22,100},{218,100}},
      color={0,135,135},
      thickness=0.5));
  connect(Block2.epp, epp) annotation (Line(
      points={{120.3,42.4},{150,42.4},{150,100},{218,100}},
      color={0,135,135},
      thickness=0.5));
  connect(P_el_set_B1, Block1.P_el_set) annotation (Line(points={{-119,120},{-119,57.48},{-118.55,57.48}}, color={0,0,127}));
  connect(P_el_set_B2, Block2.P_el_set) annotation (Line(points={{59,124},{59,57.48},{60.45,57.48}}, color={0,0,127}));
  annotation (
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false, extent={{-220,-100},{220,120}})),
  Icon(graphics,
       coordinateSystem(preserveAspectRatio=false, extent={{-220,-100},{220,120}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Abstract model for power plants composed by two blocks.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_el_set_B1: input for electric power in W (setpoint for block1)</p>
<p>P_el_set_B2: input for electric power in W (setpoint for block 2)</p>
<p>epp: active power port</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end TwoBlockPlant;
