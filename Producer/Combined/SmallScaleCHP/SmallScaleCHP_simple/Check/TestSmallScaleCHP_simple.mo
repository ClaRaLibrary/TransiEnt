within TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Check;
model TestSmallScaleCHP_simple


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





  extends TransiEnt.Basics.Icons.Checkmodel;

  Modelica.Blocks.Sources.Sine sine(
    amplitude=1500,
    f=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,60})));
  TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.SmallScaleCHP_simple smallScaleCHP_simple(useGasPort=true) annotation (Placement(transformation(extent={{-50,30},{10,90}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-74,56},{-66,64}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(variable_m_flow=false, boundaryConditions(m_flow_const=-1)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,60})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi boundaryVLE_pTxi(boundaryConditions(p_const(displayUnit="bar") = 100000)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,82})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi annotation (Placement(transformation(extent={{88,38},{68,58}})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=1500,
    f=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,-56})));
  TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.SmallScaleCHP_simple smallScaleCHP_simple1(
    useGasPort=true,
    useFluidPorts=false) annotation (Placement(transformation(extent={{-50,-90},{10,-30}})));
  Modelica.Blocks.Math.Gain gain1(k=-1) annotation (Placement(transformation(extent={{-74,-60},{-66,-52}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi1 annotation (Placement(transformation(extent={{86,-82},{66,-62}})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid1 annotation (Placement(transformation(extent={{40,-106},{60,-86}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=308.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,-14})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{72,78},{92,98}})));
  TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.SmallScaleCHP_simple smallScaleCHP_simple2(
    useGasPort=true,
    useFluidPorts=false,
    useHeatPort=false) annotation (Placement(transformation(extent={{-48,-198},{12,-138}})));
  Modelica.Blocks.Sources.Sine sine2(
    amplitude=1500,
    f=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-88,-166})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid2 annotation (Placement(transformation(extent={{44,-200},{64,-180}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi2 annotation (Placement(transformation(extent={{90,-176},{70,-156}})));
  Modelica.Blocks.Math.Gain gain4(k=-1) annotation (Placement(transformation(extent={{-70,-170},{-62,-162}})));

equation

  connect(gain.y, smallScaleCHP_simple.Q_flow_set) annotation (Line(points={{-65.6,60},{-50,60}}, color={0,0,127}));
  connect(sine.y, gain.u) annotation (Line(points={{-79,60},{-74.8,60}}, color={0,0,127}));
  connect(smallScaleCHP_simple.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{10,48},{68,48}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryVLE_Txim_flow.fluidPortOut, smallScaleCHP_simple.waterPortIn) annotation (Line(
      points={{40,60},{26,60},{26,54},{10,54}},
      color={175,0,0},
      thickness=0.5));
  connect(smallScaleCHP_simple.waterPortOut, boundaryVLE_pTxi.fluidPortIn) annotation (Line(
      points={{10,72},{26,72},{26,82},{40,82}},
      color={175,0,0},
      thickness=0.5));
  connect(ElectricGrid.epp, smallScaleCHP_simple.epp) annotation (Line(
      points={{40,20},{26,20},{26,36.6},{9.4,36.6}},
      color={0,135,135},
      thickness=0.5));
  connect(gain1.y, smallScaleCHP_simple1.Q_flow_set) annotation (Line(points={{-65.6,-56},{-58,-56},{-58,-60},{-50,-60}}, color={0,0,127}));
  connect(sine1.y, gain1.u) annotation (Line(points={{-79,-56},{-74.8,-56}}, color={0,0,127}));
  connect(smallScaleCHP_simple1.gasPortIn, boundary_pTxi1.gasPort) annotation (Line(
      points={{10,-72},{66,-72}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid1.epp, smallScaleCHP_simple1.epp) annotation (Line(
      points={{40,-96},{26,-96},{26,-83.4},{9.4,-83.4}},
      color={0,135,135},
      thickness=0.5));
  connect(smallScaleCHP_simple1.heatPort, fixedTemperature1.port) annotation (Line(points={{10,-41.4},{10,-24}}, color={191,0,0}));
  connect(smallScaleCHP_simple2.epp, ElectricGrid2.epp) annotation (Line(
      points={{11.4,-191.4},{38,-191.4},{38,-190},{44,-190}},
      color={0,135,135},
      thickness=0.5));
  connect(boundary_pTxi2.gasPort, smallScaleCHP_simple2.gasPortIn) annotation (Line(
      points={{70,-166},{22,-166},{22,-180},{12,-180}},
      color={255,255,0},
      thickness=1.5));
  connect(sine2.y, gain4.u) annotation (Line(points={{-77,-166},{-70.8,-166}}, color={0,0,127}));
  connect(gain4.y, smallScaleCHP_simple2.Q_flow_set) annotation (Line(points={{-61.6,-166},{-48,-166},{-48,-168}}, color={0,0,127}));
  annotation (
    Icon(graphics, coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},{100,100}})),
    experiment(StopTime=432000, Interval=900),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for model SmallScaleCHP</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4.Interfaces</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
</html>"));
end TestSmallScaleCHP_simple;
