within TransiEnt.Producer.Electrical.Photovoltaics;
model PhotovoltaicPlant "Simple efficiency-based PV model with constant efficiency and depending on global solar radiation"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import TransiEnt;
  extends Base.PartialPhotovoltaicModule;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Area A_module=1 "PV Module surface";
  parameter SI.Efficiency eta=0.2 "Total efficiency from radiation to power output";

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary(change_sign=true) constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (
    Dialog(group="Replaceable Components"),
    choices(
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary(change_sign=true) "P-Boundary for ActivePowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower powerBoundary(
          useInputConnectorP=true,
          useInputConnectorQ=false,
          useCosPhi=true,
          cosphi_boundary=1,
          change_sign=true) "PQ-Boundary for ApparentPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(
          useInputConnectorQ=false,
          cosphi_boundary=1,
          change_sign=true) "PQ-Boundary for ComplexPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.PowerVoltage powerBoundary(
          Use_input_connector_v=false,
          v_boundary=simCenter.v_n,
          change_sign=true) "PV-Boundary for ApparentPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PVBoundary powerBoundary(
          v_gen=simCenter.v_n,
          useInputConnectorP=true,
          change_sign=true) "PV-Boundary for ComplexPowerPort")),
    Placement(transformation(extent={{66,-9},{48,9}})));
  Modelica.Blocks.Sources.RealExpression GlobalSolarRadiation(y=simCenter.ambientConditions.globalSolarRadiation.value)
    annotation (Placement(transformation(extent={{-46,-18},{-30,18}})));
  Modelica.Blocks.Math.Gain Conversion(k(unit="m2", value=A_module*eta))
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
equation

  connect(powerBoundary.epp, epp) annotation (Line(
      points={{66,0},{74,0},{74,0},{100,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(GlobalSolarRadiation.y, Conversion.u) annotation (Line(
      points={{-29.2,0},{-4,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Conversion.y, powerBoundary.P_el_set) annotation (Line(points={{19,0},{32,0},{32,30},{62.4,30},{62.4,10.8}}, color={0,0,127}));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Line(
          points={{-80,0},{-46,0}},
          color={95,95,95},
          smooth=Smooth.None,
          pattern=LinePattern.Dash,
          thickness=0.5)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Simple efficiency-based PV model with constant efficiency and depending on global solar radiation.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>epp: electric power port</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Tested in check model &quot;Check_PhotovoltaicPlant&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end PhotovoltaicPlant;
