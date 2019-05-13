within TransiEnt.Producer.Electrical.Photovoltaics;
model DataSheetBasedPV "Efficiency based on Temperature and Radiation"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  parameter SI.Area A_module=1 "PV Module surface ";

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-84,-10},{-64,10}})));
  Modelica.Blocks.Sources.RealExpression GlobalSolarRadiation(y=
        simCenter.ambientConditions.globalSolarRadiation.value)
    annotation (Placement(transformation(extent={{-52,-16},{-36,20}})));

  TransiEnt.Producer.Electrical.Photovoltaics.Base.MPPEfficiencyModel efficiencyModel annotation (Placement(transformation(extent={{-20,-31},{2,-11}})));

  Modelica.Blocks.Sources.RealExpression AmbientTemperature(y=simCenter.T_amb_var)
    annotation (Placement(transformation(extent={{-52,-44},{-36,-8}})));
  replaceable TransiEnt.Components.Boundaries.Electrical.Power pQ_To_EPP(change_sign=true) constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (Dialog(group="Replaceable Components"),choices(choice(redeclare TransiEnt.Components.Boundaries.Electrical.Power pQ_To_EPP(change_sign=true) "P-Boundary for ActivePowerPort"), choice(redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower pQ_To_EPP(useInputConnectorP=true, useInputConnectorQ=false, useCosPhi=true, cosphi_boundary=1, change_sign=true)  "PQ-Boundary for ApparentPowerPort"),choice( redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary pQ_To_EPP(useInputConnectorQ=false, cosphi_boundary=1,change_sign=true) "PQ-Boundary for ComplexPowerPort"),choice(redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.PowerVoltage pQ_To_EPP(Use_input_connector_v=false, v_boundary=simCenter.v_n, change_sign=true)
                                                                                                                                                                                                        "PV-Boundary for ApparentPowerPort"), choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PVBoundary pQ_To_EPP(v_gen=simCenter.v_n, useInputConnectorP=true, change_sign=true) "PV-Boundary for ComplexPowerPort")),Placement(transformation(extent={{86,-9},{68,9}})));
  Modelica.Blocks.Math.MultiProduct Efficiency(nu=2)
    annotation (Placement(transformation(extent={{12,-7},{26,7}})));
  Modelica.Blocks.Math.Gain SurfacePower(k(unit="m2", value=A_module))
    annotation (Placement(transformation(extent={{35,-7},{49,7}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(pQ_To_EPP.epp, epp) annotation (Line(
      points={{86,0},{82,0},{82,0},{100,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(SurfacePower.u, Efficiency.y) annotation (Line(
      points={{33.6,8.88178e-016},{27.19,8.88178e-016}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(GlobalSolarRadiation.y, Efficiency.u[1]) annotation (Line(
      points={{-35.2,2},{-6,2},{-6,2.45},{12,2.45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(efficiencyModel.y, Efficiency.u[2]) annotation (Line(
      points={{3.1,-21},{12,-21},{12,-2.45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(GlobalSolarRadiation.y, efficiencyModel.u[1]) annotation (Line(
      points={{-35.2,2},{-28,2},{-28,-21},{-22.2,-21}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(AmbientTemperature.y, efficiencyModel.u[2]) annotation (Line(
      points={{-35.2,-26},{-32,-26},{-32,-21},{-22.2,-21}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SurfacePower.y, pQ_To_EPP.P_el_set) annotation (Line(points={{49.7,0},{62,0},{62,24},{82.4,24},{82.4,10.8}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                     graphics={
                                                     Line(
          points={{-80,0},{-48,0}},
          color={95,95,95},
          smooth=Smooth.None,
          pattern=LinePattern.Dash,
          thickness=0.5),                            Line(
          points={{-72,0},{-72,-26},{-50,-26},{-50,-26}},
          color={95,95,95},
          smooth=Smooth.None,
          pattern=LinePattern.Dash,
          thickness=0.5)}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Efficiency&nbsp;based&nbsp;on&nbsp;Temperature&nbsp;and&nbsp;Radiation.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L1E Models are based on characteristic lines, gains or efficiencies.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Solar radiation and abmient is used to calculate the effiency. Area of solar cell is regarded.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>epp: active power port</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Producer.Electrical.Photovoltaics.Check.Check_DataSheetBasedPV&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end DataSheetBasedPV;
