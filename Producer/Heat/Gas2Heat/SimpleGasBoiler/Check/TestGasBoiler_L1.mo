within TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.Check;
model TestGasBoiler_L1


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




  extends Basics.Icons.Checkmodel;
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-22,1})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    variable_m_flow=false,
    m_flow_const=100,
    T_const=60 + 273) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,0})));
  SimpleBoiler gasBoiler(useGasPort=true) annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=3600,
    duration=900,
    height=-40e6,
    offset=-50e6) annotation (Placement(transformation(extent={{-92,34},{-72,54}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource annotation (Placement(transformation(extent={{-76,-60},{-56,-40}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={86,1})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source1(
    variable_m_flow=false,
    m_flow_const=100,
    T_const=60 + 273) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={18,0})));
  SimpleBoiler gasBoiler1(useGasPort=false) annotation (Placement(transformation(extent={{42,-10},{62,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink2(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={144,-61})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source2(
    variable_m_flow=false,
    m_flow_const=100,
    T_const=60 + 273) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={76,-62})));
  TwoFuelBoiler twoFuelBoiler annotation (Placement(transformation(extent={{100,-72},{120,-52}})));
  SimpleBoiler gasBoiler2(
    useFluidPorts=false,
    useHeatPort=false,
    useGasPort=false,
    change_sign=false) annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(ramp.y, gasBoiler.Q_flow_set) annotation (Line(
      points={{-71,44},{-56,44},{-56,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSource.gasPort, gasBoiler.gasIn) annotation (Line(
      points={{-56,-50},{-56,-10},{-55.8,-10}},
      color={255,255,0},
      thickness=0.75));
  connect(gasBoiler.outlet, sink.steam_a) annotation (Line(
      points={{-46,0},{-32,0},{-32,1}},
      color={175,0,0},
      thickness=0.5));
  connect(gasBoiler.inlet, source.steam_a) annotation (Line(
      points={{-65.8,0},{-80,0}},
      color={175,0,0},
      thickness=0.5));
  connect(gasBoiler1.outlet, sink1.steam_a) annotation (Line(
      points={{62,0},{76,0},{76,1}},
      color={175,0,0},
      thickness=0.5));
  connect(gasBoiler1.inlet, source1.steam_a) annotation (Line(
      points={{42.2,0},{28,0}},
      color={175,0,0},
      thickness=0.5));
  connect(ramp.y, gasBoiler1.Q_flow_set) annotation (Line(points={{-71,44},{52,44},{52,10}}, color={0,0,127}));
  connect(twoFuelBoiler.outlet, sink2.steam_a) annotation (Line(
      points={{120,-62},{134,-62},{134,-61}},
      color={175,0,0},
      thickness=0.5));
  connect(twoFuelBoiler.inlet, source2.steam_a) annotation (Line(
      points={{100.2,-62},{86,-62}},
      color={175,0,0},
      thickness=0.5));
  connect(ramp.y, twoFuelBoiler.Q_flow_set_B1) annotation (Line(points={{-71,44},{104.2,44},{104.2,-52.2}}, color={0,0,127}));
  connect(ramp.y, twoFuelBoiler.Q_flow_set_B2) annotation (Line(points={{-71,44},{116,44},{116,-52.2}}, color={0,0,127}));
  connect(ramp.y, gasBoiler2.Q_flow_set) annotation (Line(points={{-71,44},{0,44},{0,-50}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{160,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for GasBoiler_L1</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"),
    experiment(StopTime=7200),
    Icon(coordinateSystem(extent={{-100,-100},{160,100}})));
end TestGasBoiler_L1;
