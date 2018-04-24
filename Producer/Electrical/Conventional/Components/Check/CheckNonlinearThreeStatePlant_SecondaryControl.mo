within TransiEnt.Producer.Electrical.Conventional.Components.Check;
model CheckNonlinearThreeStatePlant_SecondaryControl "Example of the component PowerPlant_PoutGrad_L1"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.Checkmodel;

  Components.NonlinearThreeStatePlant Gen_1(
    P_el_n=500e6,
    P_min_star=0.2,
    P_grad_max_star=0.1/60,
    nSubgrid=2,
    fixedStartValue_w=false,
    isSecondaryControlActive=true,
    P_init=-doubleRamp.offset) annotation (Placement(transformation(extent={{14,-88},{50,-54}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer LinearGrid(
    useInputConnectorP=false,
    P_el=300e6,
    kpf=0.5) annotation (Placement(transformation(extent={{70,-72},{90,-52}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Thermal.FluidHeatFlow.Examples.Utilities.DoubleRamp doubleRamp(
    startTime=3600,
    interval=3600,
    duration_2=300,
    duration_1=5,
    height_1=+50e6,
    height_2=-100e6,
    offset=-300e6)
    annotation (Placement(transformation(extent={{-44,-42},{-24,-22}})));
  Modelica.Blocks.Sources.Constant SC_T(k=60)   annotation (Placement(transformation(extent={{22,62},{42,82}})));
  Modelica.Blocks.Sources.Constant SC_K(k=1)    annotation (Placement(transformation(extent={{62,62},{82,82}})));
  TransiEnt.Grid.Electrical.SecondaryControl.SecondaryBalancingController AGC_Grid_1(
    P_nom=Gen_1.P_el_n,
    K_r=1,
    is_singleton=false,
    T_r=SC_T.k,
    beta=SC_K.k) annotation (Placement(transformation(extent={{-30,-15},{-8,7}})));
  Modelica.Blocks.Sources.Constant Gen_1_tie_set(k=-3e8)
                                                      annotation (Placement(transformation(extent={{-64,16},{-44,36}})));
  TransiEnt.Components.Sensors.ElectricFrequency electricPower_L1_1 annotation (Placement(transformation(extent={{54,0},{74,20}})));
  TransiEnt.Components.Sensors.ElectricActivePower P_tie_is annotation (Placement(transformation(extent={{72,-24},{92,-4}})));
  Modelica.Blocks.Math.Feedback delta_f annotation (Placement(transformation(extent={{-80,-14},{-60,6}})));
  Modelica.Blocks.Sources.Constant f_nom(k=50) annotation (Placement(transformation(extent={{-96,-38},{-76,-18}})));
equation

  connect(AGC_Grid_1.P_tie_set, Gen_1_tie_set.y) annotation (Line(points={{-28.9,6.01},{-28.9,26},{-43,26}},  color={0,0,127}));
  connect(Gen_1.epp, P_tie_is.epp_IN) annotation (Line(
      points={{49.1,-61.48},{49.1,-14},{72.8,-14}},
      color={0,135,135},
      thickness=0.5));
  connect(electricPower_L1_1.epp, P_tie_is.epp_IN) annotation (Line(
      points={{54,10},{46,10},{46,-14},{72.8,-14}},
      color={0,135,135},
      thickness=0.5));
  connect(delta_f.y, AGC_Grid_1.u) annotation (Line(points={{-61,-4},{-54,-4},{-32.2,-4}},            color={0,0,127}));
  connect(f_nom.y, delta_f.u2) annotation (Line(points={{-75,-28},{-70,-28},{-70,-12}},    color={0,0,127}));
  connect(electricPower_L1_1.f, delta_f.u1) annotation (Line(points={{74.4,10},{74.4,10},{74.4,46},{-90,46},{-90,-4},{-78,-4}},color={0,0,127}));
  connect(P_tie_is.P, AGC_Grid_1.P_tie_is) annotation (Line(points={{78.2,-6.2},{78.2,38},{-23.62,38},{-23.62,6.01}}, color={0,0,127}));
  connect(doubleRamp.y, Gen_1.P_el_set) annotation (Line(points={{-23,-32},{-23,-32},{30,-32},{30,-54.17},{29.3,-54.17}},color={0,0,127}));
  connect(P_tie_is.epp_OUT, LinearGrid.epp) annotation (Line(
      points={{91.4,-14},{94,-14},{94,-36},{62,-36},{62,-62},{70.2,-62}},
      color={0,135,135},
      thickness=0.5));
  connect(AGC_Grid_1.y, Gen_1.P_SB_set) annotation (Line(points={{-6.9,-4},{8,-4},{8,-6},{15.98,-6},{15.98,-55.87}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,100}}), graphics={Text(
          extent={{-72,-76},{-18,-126}},
          lineColor={0,0,0},
          textString="Look at:
Gen_1.P_star
Gen_1.P_min_star
Gen_1.P_set_star

Gen_1.epp.P
Gen_1.P_el_set

Gen_1.epp.f

AGC.Grid_1.y")}),
    experiment(StopTime=7200),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-160},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end CheckNonlinearThreeStatePlant_SecondaryControl;
