within TransiEnt.Grid.Electrical.Noise;
model ResidualNormalDistributed "The typical grid error from inversion is the base. From that supplementary grid errros are modeled via normal distributions"
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
  extends Base.PartialStochasticGridErrorModel(
                                          nout=2);

  outer SimCenter simCenter;
  Modelica.Blocks.Sources.Constant P_PV_n(k=simCenter.generationPark.P_el_n_PV) annotation (Placement(transformation(extent={{-64,30},{-50,44}})));
  Modelica.Blocks.Noise.NormalNoise PZ_Wind_norm(
    mu=0.11/100,
    sigma=0.85/100,
    samplePeriod=3600)
    annotation (Placement(transformation(extent={{-88,66},{-70,82}})));
  Modelica.Blocks.Noise.NormalNoise PZ_PV_norm(
    mu=0,
    sigma=0.85/100,
    samplePeriod=3600)
    annotation (Placement(transformation(extent={{-90,16},{-70,35}})));
  Modelica.Blocks.Noise.NormalNoise PZ_LN_norm(
    mu=0,
    sigma=0.41/100,
    samplePeriod=60) "Load noise (high frequency)"
    annotation (Placement(transformation(extent={{-86,-82},{-66,-60}})));
  Modelica.Blocks.Noise.NormalNoise PZ_LP_norm(
    mu=0.066/100,
    sigma=0.8/100,
    samplePeriod=900) "Load prediction (low frequency)"
    annotation (Placement(transformation(extent={{-88,-27},{-68,-5}})));

  Modelica.Blocks.Sources.Constant P_Wind_n(k=simCenter.generationPark.P_el_n_WindOn + simCenter.generationPark.P_el_n_WindOff) annotation (Placement(transformation(extent={{-64,79},{-50,93}})));
  Modelica.Blocks.Math.Gain PZ_LN(k=simCenter.P_peak_1)
                                                   annotation (Placement(transformation(extent={{-50,-81},{-30,-61}})));
  Modelica.Blocks.Math.Gain PZ_LP(k=simCenter.P_peak_1)
                                           annotation (Placement(transformation(extent={{-56,-27},{-36,-7}})));
  Modelica.Blocks.Math.Sum PZ_L(nin=2) annotation (Placement(transformation(extent={{-22,-50},{-6,-34}})));
  Modelica.Blocks.Math.Product
                           PZ_Wind       annotation (Placement(transformation(extent={{-34,70},{-14,90}})));
  Modelica.Blocks.Math.Product PZ_PV annotation (Placement(transformation(extent={{-32,22},{-14,40}})));
  Modelica.Blocks.Math.Sum P_Z_Grid_1(nin=3) annotation (Placement(transformation(extent={{14,-10},{34,10}})));
  Modelica.Blocks.Math.Feedback P_Z_Grid_2 annotation (Placement(transformation(extent={{55,69},{77,91}})));
  Basics.Tables.GenericDataTable P_Z_UCTE_2012(
    relativepath="strom/PrognosefehlerSimuliertDurchInvertierung_ENTSO-E_60s_2012.txt",
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
    constantfactor=simCenter.P_n_ref_2) "Timeseries generated by inverting the derive grid dynamics model and putting the frequency measurement from 2012 at input" annotation (Placement(transformation(extent={{12,70},{34,90}})));
equation
  connect(PZ_LP_norm.y,PZ_LP. u) annotation (Line(points={{-67,-16},{-64,-16},{-62,-16},{-60,-16},{-60,-17},{-58,-17}},
                                                                                                    color={0,0,127}));
  connect(PZ_LP.y,PZ_L. u[1]) annotation (Line(points={{-35,-17},{-35,-17},{-23.6,-17},{-23.6,-42.8}},
                                                                                              color={0,0,127}));
  connect(PZ_LN.y,PZ_L. u[2]) annotation (Line(points={{-29,-71},{-23.6,-71},{-23.6,-41.2}},     color={0,0,127}));
  connect(PZ_Wind_norm.y,PZ_Wind. u2) annotation (Line(points={{-69.1,74},{-69.1,74},{-36,74}}, color={0,0,127}));
  connect(PZ_PV_norm.y,PZ_PV. u2) annotation (Line(points={{-69,25.5},{-69,25.6},{-33.8,25.6}},              color={0,0,127}));
  connect(P_Z_Grid_1.y, P_Z_Grid_2.u2) annotation (Line(points={{35,0},{66,0},{66,54},{66,71.2}}, color={0,0,127}));
  connect(P_Wind_n.y,PZ_Wind. u1) annotation (Line(points={{-49.3,86},{-42,86},{-36,86}},        color={0,0,127}));
  connect(P_PV_n.y,PZ_PV. u1) annotation (Line(points={{-49.3,37},{-33.8,37},{-33.8,36.4}},              color={0,0,127}));
  connect(P_Z_UCTE_2012.y1, P_Z_Grid_2.u1) annotation (Line(points={{35.1,80},{57.2,80}}, color={0,0,127}));
  connect(PZ_LN_norm.y, PZ_LN.u) annotation (Line(points={{-65,-71},{-46,-71},{-52,-71}}, color={0,0,127}));
  connect(PZ_Wind.y, P_Z_Grid_1.u[1]) annotation (Line(points={{-13,80},{0,80},{0,-1.33333},{12,-1.33333}}, color={0,0,127}));
  connect(PZ_PV.y, P_Z_Grid_1.u[2]) annotation (Line(points={{-13.1,31},{0,31},{0,0},{12,0}}, color={0,0,127}));
  connect(PZ_L.y, P_Z_Grid_1.u[3]) annotation (Line(points={{-5.2,-42},{0,-42},{0,1.33333},{12,1.33333}}, color={0,0,127}));
  connect(P_Z_Grid_1.y, y[1]) annotation (Line(points={{35,0},{70,0},{70,-5},{110,-5}}, color={0,0,127}));
  connect(P_Z_Grid_2.y, y[2]) annotation (Line(points={{75.9,80},{80,80},{80,76},{80,2},{110,2},{110,5}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end ResidualNormalDistributed;
