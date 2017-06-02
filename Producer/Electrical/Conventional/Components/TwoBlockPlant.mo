within TransiEnt.Producer.Electrical.Conventional.Components;
model TwoBlockPlant "Abstract model for power plants composed by two blocks"
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

/// ***** MOST IMPORTANT RULE: BEFORE PUSHING YOUR CHANGES YOUR MODEL SHOULD "CHECK" *****
/// (meaning if you press F8 or click the "check" Button there are no errors)

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.SteamCycle2Blocks;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput P_el_set_B1 "Setpoint of block 1" annotation (
      Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-119,120}),                                  iconTransformation(
          extent={{-15,-14},{15,14}},
        rotation=270,
        origin={-121,126})));
  Modelica.Blocks.Interfaces.RealInput P_el_set_B2 "Setpoint of block 1" annotation (
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
      points={{-55.85,35.12},{-22,35.12},{-22,100},{218,100}},
      color={0,135,135},
      thickness=0.5));
  connect(Block2.epp, epp) annotation (Line(
      points={{123.15,35.12},{150,35.12},{150,100},{218,100}},
      color={0,135,135},
      thickness=0.5));
  connect(P_el_set_B1, Block1.P_el_set) annotation (Line(points={{-119,120},{-119,57.48},{-118.55,57.48}}, color={0,0,127}));
  connect(P_el_set_B2, Block2.P_el_set) annotation (Line(points={{59,124},{59,57.48},{60.45,57.48}}, color={0,0,127}));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-100},{220,120}})),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,-100},{220,120}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Abstract&nbsp;model&nbsp;for&nbsp;power&nbsp;plants&nbsp;composed&nbsp;by&nbsp;two&nbsp;blocks.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
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
