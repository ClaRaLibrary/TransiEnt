within TransiEnt.Storage.Gas.Check;
model TestGasStorage_varXi

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

  TransiEnt.Storage.Gas.GasStorage_varXi_L2 gasStorage_L2_adiabatic(V_geo=500000, p_gas_start=10000000)       annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  inner TransiEnt.SimCenter simCenter                                                                    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundaryRealGas_Txim_flow1(variable_m_flow=true, variable_xi=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,40})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,-100; 30000,0; 60000,0])
                                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={36,82})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundaryRealGas_Txim_flow3(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-40})));
  Modelica.Blocks.Sources.TimeTable timeTable3(table=[0,0; 30000,0; 60000,100])
                                                                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={24,-80})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    timeTable2(table=[0,simCenter.gasModel1.xi_default[1],simCenter.gasModel1.xi_default[2],simCenter.gasModel1.xi_default[3],simCenter.gasModel1.xi_default[4],simCenter.gasModel1.xi_default[5],simCenter.gasModel1.xi_default[6]; 5000,simCenter.gasModel1.xi_default[1],simCenter.gasModel1.xi_default[2],simCenter.gasModel1.xi_default[3],simCenter.gasModel1.xi_default[4],simCenter.gasModel1.xi_default[5],simCenter.gasModel1.xi_default[6]; 10000,0,0,0,0,0.0,0.0; 20000,0,0,0,0,0.0,0.0; 25000,simCenter.gasModel1.xi_default[1],simCenter.gasModel1.xi_default[2],simCenter.gasModel1.xi_default[3],simCenter.gasModel1.xi_default[4],simCenter.gasModel1.xi_default[5],simCenter.gasModel1.xi_default[6]; 30000,simCenter.gasModel1.xi_default[1],simCenter.gasModel1.xi_default[2],simCenter.gasModel1.xi_default[3],simCenter.gasModel1.xi_default[4],simCenter.gasModel1.xi_default[5],simCenter.gasModel1.xi_default[6]])
                                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-16,82})));

  GasStorage_varXi_L2 gasStorage_L2_isothermal(
    V_geo=500000,
    includeHeatTransfer=true,
    p_gas_start=10000000,
    T_gas_start=283.15,
    redeclare model HeatTransfer = Base.IdealHTOuterTemperature_L2)
                                annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundaryRealGas_Txim_flow2(variable_m_flow=true, variable_xi=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,40})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundaryRealGas_Txim_flow4(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-40})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15) annotation (Placement(transformation(extent={{142,-8},{122,12}})));
  GasStorage_varXi_L2                       gasStorage_L2_adiabatic_simple(V_geo=500000, p_gas_start=10000000)             annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundaryRealGas_Txim_flow5(variable_m_flow=true, variable_xi=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,40})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundaryRealGas_Txim_flow6(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-40})));
  GasStorage_varXi_L1                       gasStorage_L1_adiabatic(V_geo=500000, m_gas_start=5.34421e7,
    variableCompositionEntries={7})                                                                                 annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundaryRealGas_Txim_flow7(variable_m_flow=true, variable_xi=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,40})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundaryRealGas_Txim_flow8(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-40})));
  GasStorage_varXi_L1                       gasStorage_L1_adiabatic_simple(V_geo=500000, m_gas_start=5.34421e7,
    variableCompositionEntries={7})                                                                                       annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundaryRealGas_Txim_flow9(variable_m_flow=true, variable_xi=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-90,40})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundaryRealGas_Txim_flow10(variable_m_flow=true)
                                                                                                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,-40})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 thinWall(
    diameter_o=0.55,
    diameter_i=0.5,
    length=0.5,
    N_ax=1,
    T_start=283.15*ones(thinWall.N_ax),
    stateLocation=2,
    initOption=213) annotation (Placement(transformation(extent={{-13,-5},{13,5}},
        rotation=90,
        origin={103,1})));
equation
  connect(boundaryRealGas_Txim_flow1.m_flow,timeTable1. y) annotation (Line(points={{36,52},{36,71}},         color={0,0,127}));
  connect(boundaryRealGas_Txim_flow3.m_flow,timeTable3. y) annotation (Line(points={{24,-52},{24,-69}}, color={0,0,127}));
  connect(timeTable2.y, boundaryRealGas_Txim_flow1.xi) annotation (Line(points={{-16,71},{-16,58},{24,58},{24,52}}, color={0,0,127}));
  connect(boundaryRealGas_Txim_flow1.gasPort, gasStorage_L2_adiabatic.gasPortIn) annotation (Line(
      points={{30,30},{30,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(gasStorage_L2_adiabatic.gasPortOut, boundaryRealGas_Txim_flow3.gasPort) annotation (Line(
      points={{30,-6.3},{30,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryRealGas_Txim_flow2.m_flow,timeTable1. y) annotation (Line(points={{76,52},{76,71},{36,71}}, color={0,0,127}));
  connect(boundaryRealGas_Txim_flow4.m_flow,timeTable3. y) annotation (Line(points={{64,-52},{64,-69},{24,-69}},
                                                                                                        color={0,0,127}));
  connect(timeTable2.y,boundaryRealGas_Txim_flow2. xi) annotation (Line(points={{-16,71},{-16,58},{64,58},{64,52}}, color={0,0,127}));
  connect(boundaryRealGas_Txim_flow2.gasPort, gasStorage_L2_isothermal.gasPortIn) annotation (Line(
      points={{70,30},{70,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(gasStorage_L2_isothermal.gasPortOut, boundaryRealGas_Txim_flow4.gasPort) annotation (Line(
      points={{70,-6.3},{70,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryRealGas_Txim_flow5.m_flow,timeTable1. y) annotation (Line(points={{-4,52},{-4,71},{36,71}}, color={0,0,127}));
  connect(timeTable2.y,boundaryRealGas_Txim_flow5. xi) annotation (Line(points={{-16,71},{-16,52}},                 color={0,0,127}));
  connect(boundaryRealGas_Txim_flow5.gasPort, gasStorage_L2_adiabatic_simple.gasPortIn) annotation (Line(
      points={{-10,30},{-10,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(gasStorage_L2_adiabatic_simple.gasPortOut, boundaryRealGas_Txim_flow6.gasPort) annotation (Line(
      points={{-10,-6.3},{-10,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryRealGas_Txim_flow7.m_flow,timeTable1. y) annotation (Line(points={{-44,52},{-44,71},{36,71}},
                                                                                                              color={0,0,127}));
  connect(timeTable2.y,boundaryRealGas_Txim_flow7. xi) annotation (Line(points={{-16,71},{-16,58},{-56,58},{-56,52}},
                                                                                                                    color={0,0,127}));
  connect(boundaryRealGas_Txim_flow7.gasPort, gasStorage_L1_adiabatic.gasPortIn) annotation (Line(
      points={{-50,30},{-50,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(gasStorage_L1_adiabatic.gasPortOut, boundaryRealGas_Txim_flow8.gasPort) annotation (Line(
      points={{-50,-6.3},{-50,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryRealGas_Txim_flow8.m_flow, timeTable3.y) annotation (Line(points={{-56,-52},{-56,-69},{24,-69}}, color={0,0,127}));
  connect(boundaryRealGas_Txim_flow6.m_flow, timeTable3.y) annotation (Line(points={{-16,-52},{-16,-69},{24,-69}}, color={0,0,127}));
  connect(boundaryRealGas_Txim_flow9.m_flow,timeTable1. y) annotation (Line(points={{-84,52},{-84,71},{36,71}},
                                                                                                              color={0,0,127}));
  connect(timeTable2.y,boundaryRealGas_Txim_flow9. xi) annotation (Line(points={{-16,71},{-16,58},{-96,58},{-96,52}},
                                                                                                                    color={0,0,127}));
  connect(boundaryRealGas_Txim_flow9.gasPort, gasStorage_L1_adiabatic_simple.gasPortIn) annotation (Line(
      points={{-90,30},{-90,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(gasStorage_L1_adiabatic_simple.gasPortOut, boundaryRealGas_Txim_flow10.gasPort) annotation (Line(
      points={{-90,-6.3},{-90,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryRealGas_Txim_flow10.m_flow, timeTable3.y) annotation (Line(points={{-96,-52},{-96,-69},{24,-69}}, color={0,0,127}));
  connect(thinWall.innerPhase[1], fixedTemperature.port) annotation (Line(
      points={{108,1},{122,2}},
      color={167,25,48},
      thickness=0.5));
  connect(gasStorage_L2_isothermal.heat, thinWall.outerPhase[1]) annotation (Line(points={{74,0},{86,0},{86,1},{98,1}}, color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{52,-92},{88,-100}},
          textColor={28,108,200},
          textString="L2 isothermal"),
        Text(
          extent={{12,-92},{48,-100}},
          textColor={28,108,200},
          textString="L2 adiabatic"),
        Text(
          extent={{-28,-92},{8,-108}},
          textColor={28,108,200},
          textString="L2 adiabatic
simplified"),
        Text(
          extent={{-68,-92},{-32,-100}},
          textColor={28,108,200},
          textString="L1 adiabatic"),
        Text(
          extent={{-108,-92},{-72,-108}},
          textColor={28,108,200},
          textString="L1 adiabatic
simplified")}),
    experiment(StopTime=60000, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #4b8a49\">1. Purpose of model</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Apr 2017</p>
</html>"));
end TestGasStorage_varXi;
