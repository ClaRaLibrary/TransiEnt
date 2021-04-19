within TransiEnt.Storage.Gas.Check;
model TestGasStorage_varXi_L2
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  TransiEnt.Storage.Gas.GasStorage_varXi_L2 compressedGasStorage_adiabatic(V_geo=500000, xi_gas_start={1,0,0,0,0,0}) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  inner TransiEnt.SimCenter simCenter                                                                    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundaryRealGas_Txim_flow1(variable_m_flow=true, variable_xi=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,40})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,-1000; 1000,0; 2000,0])
                                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={6,72})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundaryRealGas_Txim_flow3(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-40})));
  Modelica.Blocks.Sources.TimeTable timeTable3(table=[0,0; 1000,0; 2000,1000])
                                                                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-6,-70})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    timeTable2(table=[0,1,0.0,0.0,0.0,0.0,0.0; 200,1,0.0,0.0,0.0,0.0,0.0; 400,0.5,0.5,0.0,0.0,0.0,0.0; 600,0.5,0.5,0.0,0.0,0.0,0.0; 800,0.0,0.0,0.0,0.0,0.0,0.0; 1000,0.0,0.0,0.0,0.0,0.0,0.0; 2000,0.0,0.0,0.0,0.0,0.0,0.0])
                                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-26,72})));

  GasStorage_varXi_L2 compressedGasStorage_idealHT(
    V_geo=500000,
    includeHeatTransfer=true,
    T_gas_start=283.15,
    redeclare model HeatTransfer = Base.IdealHTOuterTemperature_L2,
    xi_gas_start={1,0,0,0,0,0}) annotation (Placement(transformation(extent={{48,-10},{68,10}})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundaryRealGas_Txim_flow2(variable_m_flow=true, variable_xi=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={58,40})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundaryRealGas_Txim_flow4(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={58,-40})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15) annotation (Placement(transformation(extent={{102,-10},{82,10}})));
equation
  connect(boundaryRealGas_Txim_flow1.m_flow,timeTable1. y) annotation (Line(points={{6,52},{6,61}},           color={0,0,127}));
  connect(boundaryRealGas_Txim_flow3.m_flow,timeTable3. y) annotation (Line(points={{-6,-52},{-6,-59}}, color={0,0,127}));
  connect(timeTable2.y, boundaryRealGas_Txim_flow1.xi) annotation (Line(points={{-26,61},{-26,58},{-6,58},{-6,52}}, color={0,0,127}));
  connect(boundaryRealGas_Txim_flow1.gasPort, compressedGasStorage_adiabatic.gasPortIn) annotation (Line(
      points={{0,30},{0,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(compressedGasStorage_adiabatic.gasPortOut, boundaryRealGas_Txim_flow3.gasPort) annotation (Line(
      points={{0,-6.3},{0,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryRealGas_Txim_flow2.m_flow,timeTable1. y) annotation (Line(points={{64,52},{64,61},{6,61}},  color={0,0,127}));
  connect(boundaryRealGas_Txim_flow4.m_flow,timeTable3. y) annotation (Line(points={{52,-52},{52,-59},{-6,-59}},
                                                                                                        color={0,0,127}));
  connect(timeTable2.y,boundaryRealGas_Txim_flow2. xi) annotation (Line(points={{-26,61},{-26,58},{52,58},{52,52}}, color={0,0,127}));
  connect(boundaryRealGas_Txim_flow2.gasPort, compressedGasStorage_idealHT.gasPortIn) annotation (Line(
      points={{58,30},{58,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(compressedGasStorage_idealHT.gasPortOut, boundaryRealGas_Txim_flow4.gasPort) annotation (Line(
      points={{58,-6.3},{58,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(fixedTemperature.port, compressedGasStorage_idealHT.heat) annotation (Line(points={{82,0},{72,0},{72,0},{62,0}}, color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=2000, __Dymola_Algorithm="Dassl"),
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
end TestGasStorage_varXi_L2;
