within TransiEnt.Producer.Electrical.Photovoltaics;
model PhotovoltaicPlant "Simple efficiency-based PV model with constant efficiency and depending on global solar radiation"



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

  import TransiEnt;
  extends Base.PartialPhotovoltaicModule;
  //  extends Basics.Tables.GenericDataTable(relativepath="ambient/GHI_Hamburg_3600s_TMY.txt",
  //      datasource=DataPrivacy.isPublic);

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Area A_module=1 "PV Module surface";
  parameter SI.Efficiency eta=0.2
    "Total efficiency from radiation to power output";

  parameter Boolean useSimCenterAmbience=true
    "Gets radiation data from SimCenter" annotation (
    Evaluate=true,
    HideResult=true,
    choices(__Dymola_checkBox=true));

  //  parameter String radiationData=Modelica.Utilities.Files.loadResource("modelica://TransiEnt/Tables/ambient/Radiation_PVModule_TRY-Koeln_Az=0_Tilt=35.txt")
  //    annotation (choices(choice=Modelica.Utilities.Files.loadResource("modelica://TransiEnt/Tables/ambient/Radiation_PVModule_TRY-Koeln_Az=0_Tilt=35.txt")),
  //     Dialog(enable=not useSimCenterAmbience));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________


  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power
    powerBoundary(change_sign=true) constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary
    "Choice of power boundary model. The power boundary model must match the power port."
    annotation (
    Dialog(group="Replaceable Components"),
    choices(
      choice(redeclare
          TransiEnt.Components.Boundaries.Electrical.ActivePower.Power
          powerBoundary(change_sign=true) "P-Boundary for ActivePowerPort"),
      choice(redeclare
          TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower
          powerBoundary(
          useInputConnectorP=true,
          useInputConnectorQ=false,
          useCosPhi=true,
          cosphi_boundary=1,
          change_sign=true) "PQ-Boundary for ApparentPowerPort"),
      choice(redeclare
          TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary
          powerBoundary(
          useInputConnectorQ=false,
          cosphi_boundary=1,
          change_sign=true) "PQ-Boundary for ComplexPowerPort"),
      choice(redeclare
          TransiEnt.Components.Boundaries.Electrical.ApparentPower.PowerVoltage
          powerBoundary(
          Use_input_connector_v=false,
          v_boundary=simCenter.v_n,
          change_sign=true) "PV-Boundary for ApparentPowerPort"),
      choice(redeclare
          TransiEnt.Components.Boundaries.Electrical.ComplexPower.PVBoundary
          powerBoundary(
          v_gen=simCenter.v_n,
          useInputConnectorP=true,
          change_sign=true) "PV-Boundary for ComplexPowerPort")),
    Placement(transformation(extent={{66,-9},{48,9}})));
  replaceable TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY
    radiationData constrainedby TransiEnt.Components.Boundaries.Ambient.Base.PartialGlobalSolarRadiation
    "Choice of radiation data table" annotation (
    Dialog(group="Replaceable Components", enable=not useSimCenterAmbience),
    choicesAllMatching=true,
    Placement(transformation(extent={{-64,-16},{-44,4}}), iconTransformation(
          extent={{90,-10},{110,10}})));
  Modelica.Blocks.Sources.RealExpression GlobalSolarRadiation(y=simCenter.ambientConditions.globalSolarRadiation.value)
    annotation (Placement(transformation(extent={{-60,46},{-44,82}})));
  Modelica.Blocks.Math.Gain Conversion(k(unit="m2", value=A_module*eta))
    annotation (Placement(transformation(extent={{22,20},{42,40}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=
        useSimCenterAmbience)
    annotation (Placement(transformation(extent={{-62,20},{-42,40}})));
equation

  connect(powerBoundary.epp, epp) annotation (Line(
      points={{66,0},{74,0},{74,0},{100,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(Conversion.y, powerBoundary.P_el_set)
    annotation (Line(points={{43,30},{62.4,30},{62.4,10.8}}, color={0,0,127}));
  connect(switch1.y, Conversion.u)
    annotation (Line(points={{1,30},{20,30}}, color={0,0,127}));
  connect(booleanExpression.y, switch1.u2)
    annotation (Line(points={{-41,30},{-22,30}}, color={255,0,255}));
  connect(GlobalSolarRadiation.y, switch1.u1) annotation (Line(points={{-43.2,64},
          {-28,64},{-28,38},{-22,38}}, color={0,0,127}));
  connect(switch1.u3, radiationData.y1)
    annotation (Line(points={{-22,22},{-22,-6},{-43,-6}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Line(
          points={{-94,64},{-60,64}},
          color={95,95,95},
          smooth=Smooth.None,
          pattern=LinePattern.Dash,
          thickness=0.5), Line(
          points={{-94,-6},{-60,-6}},
          color={95,95,95},
          smooth=Smooth.None,
          pattern=LinePattern.Dash,
          thickness=0.5)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Simple efficiency-based PV model with constant efficiency and depending on global solar radiation.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L1E (defined in the CodingConventions)</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Julian Urbansky, Fraunhofer UMSICHT, in August 2021.</span></p>
</html>"));
end PhotovoltaicPlant;
