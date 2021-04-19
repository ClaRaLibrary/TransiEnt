within TransiEnt.Grid.Electrical.LumpedPowerGrid.Check;
model LocalPlantInteractingWithUCTE_withIncident "Example how the continental europe grid interacts with a local grid"
  import TransiEnt;
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
  inner TransiEnt.SimCenter  simCenter(         thres=1e-9,
    useThresh=true,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    P_n_ref_1=4e9,
    P_n_ref_2=300e9,
    Td=5)
    annotation (Placement(transformation(extent={{-69,80},{-49,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-99,80},{-79,100}})));

  LumpedGridWithIncident                                       UCTE(
    T_r=150,
    redeclare Noise.ZeroError genericGridError,
    lambda_sec=3e9/0.2,
    k_pr=1,
    t_incident=100,
    P_el_n=300e9 - 2e9,
    P_L=150e9 - 1e9,
    P_pr_grad_max_star=0.01/30,
    P_pr_max_star=0.01,
    beta=0.5)
            annotation (Placement(transformation(extent={{60,-38},{40,-18}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer Demand(useInputConnectorP=true, kpf=0.5) annotation (Placement(transformation(extent={{12,2},{32,22}})));
  TransiEnt.Producer.Electrical.Conventional.LumpedGridGenerators lumpedGrid(
    P_el_n=2e9,
    k_pr=1,
    secondaryBalancingController(G(k={0,0})),
    delta_pr=0.3956,
    P_pr_grad_max_star=0.01/30,
    P_pr_max_star=0.01)                       annotation (Placement(transformation(extent={{-30,2},{-10,22}})));
  TransiEnt.Components.Sensors.ElectricActivePower P_12 annotation (Placement(transformation(extent={{14,-36},{34,-16}})));
  Modelica.Blocks.Sources.Constant P_load_local(k=1e9) annotation (Placement(transformation(extent={{-74,40},{-54,60}})));
  Modelica.Blocks.Sources.Constant P_set_tie(k=0) annotation (Placement(transformation(extent={{-74,6},{-54,26}})));
  Modelica.Blocks.Sources.Constant P_set_local(k=-1e9) annotation (Placement(transformation(extent={{-74,-28},{-54,-8}})));
equation
  connect(P_12.epp_OUT, UCTE.epp) annotation (Line(
      points={{33.4,-26},{36,-26},{36,-28},{40,-28}},
      color={0,135,135},
      thickness=0.5));
  connect(lumpedGrid.epp, P_12.epp_IN) annotation (Line(
      points={{-11,19},{0,19},{0,-26},{14.8,-26}},
      color={0,135,135},
      thickness=0.5));
  connect(Demand.epp, P_12.epp_IN) annotation (Line(
      points={{12.2,12},{0,12},{0,-26},{14.8,-26}},
      color={0,135,135},
      thickness=0.5));
  connect(lumpedGrid.P_tie_is, P_12.P) annotation (Line(points={{-14.5,20.9},{-14.5,30},{40,30},{40,-12},{20.2,-12},{20.2,-18.2}},
                                                                                                                              color={0,0,127}));
  connect(P_load_local.y, Demand.P_el_set) annotation (Line(points={{-53,50},{-53,50},{22,50},{22,23.6}},              color={0,0,127}));
  connect(lumpedGrid.P_tie_set, P_set_tie.y) annotation (Line(points={{-18.5,20.9},{-18.5,30},{-48,30},{-50,30},{-50,16},{-54,16},{-53,16}},
                                                                                                                  color={0,0,127}));
  connect(P_set_local.y, lumpedGrid.P_el_set) annotation (Line(points={{-53,-18},{-42,-18},{-42,24},{-21.5,24},{-21.5,21.9}}, color={0,0,127}));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,100}})),
    experiment(StopTime=200, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(graphics,
         coordinateSystem(extent={{-100,-80},{100,100}})),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(no remarks)</p>
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
</html>"));
end LocalPlantInteractingWithUCTE_withIncident;
