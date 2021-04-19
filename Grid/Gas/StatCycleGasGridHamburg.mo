within TransiEnt.Grid.Gas;
model StatCycleGasGridHamburg

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

   import TransiEnt;
   import SI = Modelica.SIunits;
   extends TransiEnt.Basics.Icons.ModelStaticCycle;
   outer TransiEnt.SimCenter simCenter;

   parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used";
   parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_H2=simCenter.gasModel3 "Medium to be used";
   parameter Boolean quadraticPressureLoss=false "Nominal point pressure loss; set to true for quadratic coefficient";
   parameter SI.MassFlowRate m_flow_nom_unscaled= 33.23048206 "Nominal mass flow rate Reitbrook";
   parameter SI.MassFlowRate m_flow_nom= simCenter.f_gasDemand*m_flow_nom_unscaled "Nominal mass flow rate Hamburg";
   parameter SI.MassFlowRate m_flow_unscaled= 26.64515586 "Mass flow rate Reitbrook";
   parameter SI.MassFlowRate m_flow= simCenter.f_gasDemand*m_flow_unscaled "Mass flow rate Hamburg";
   parameter Real f_Rei=0.4300196919 "Share of gas mass coming from Reitbrook";
   parameter Real f_Lev=0.271845032 "Share of gas mass coming from Leversen";
   parameter Real f_Tor=0.298135276 "Share of gas mass coming from Tornesch";

   parameter SI.Pressure p_source=simCenter.p_eff_2 + simCenter.p_amb_const "|Sources|Natural Gas|Absolute pressure";
   parameter SI.SpecificEnthalpy h_source=-1849.95 "|Sources|Natural Gas|Specific enthalpy";
   parameter SI.MassFraction xi_source[medium.nc - 1]=medium.xi_default "|Sources|Natural Gas|Mass specific composition";

   parameter SI.MassFlowRate m_flow_feedIn_Tornesch=0.0 "|Sources|Feed-In Station|Mass flow rate";
   parameter SI.Temperature T_feedIn_Tornesch=simCenter.T_ground "|Sources|Feed-In Station|Temperature";
   parameter SI.MassFraction xi_feedIn_Tornesch[medium_H2.nc - 1]=zeros(medium_H2.nc - 1) "|Sources|Feed-In Station|Mass specific composition";

   parameter SI.MassFlowRate m_flow_feedIn_Leversen=0.0 "|Sources|Feed-In Station|Mass flow rate";
   parameter SI.Temperature T_feedIn_Leversen=simCenter.T_ground "|Sources|Feed-In Station|Temperature";
   parameter SI.MassFraction xi_feedIn_Leversen[medium_H2.nc - 1]=zeros(medium_H2.nc - 1) "|Sources|Feed-In Station|Mass specific composition";

   parameter SI.MassFlowRate m_flow_feedIn_Reitbrook=0.0 "|Sources|Feed-In Station|Mass flow rate";
   parameter SI.Temperature T_feedIn_Reitbrook=simCenter.T_ground "|Sources|Feed-In Station|Temperature";
   parameter SI.MassFraction xi_feedIn_Reitbrook[medium_H2.nc - 1]=zeros(medium_H2.nc - 1) "|Sources|Feed-In Station|Mass specific composition";

   parameter SI.MassFlowRate m_flow_Harburg=m_flow/7 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_Altona=m_flow/7 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_Eimsbuettel=m_flow/7 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_HHNord=m_flow/7 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_Wandsbek=m_flow/7 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_HHMitte=m_flow/7 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_Bergedorf=m_flow/7 "|Districts|Sinks|Mass flow rate";
   parameter Real splitRatioHarburg=0.5 "|Districts||Ratio of inlet1.m_flow/outlet.m_flow";
   parameter Real splitRatioEimsbuettel=0.5 "|Districts||Ratio of inlet1.m_flow/outlet.m_flow";
   parameter Real splitRatioWandsbek=0.5 "|Districts||Ratio of inlet1.m_flow/outlet.m_flow";

   parameter SI.Pressure Delta_p_nom_Harburg=58*3774 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Altona=58*5152 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Eimsbuettel=58*2739 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_HHNord=58*10564 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Wandsbek=58*4075 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_HHMitte=58*9480 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Bergedorf=58*6770 "|Districts|Pipes|Nominal pressure loss";

   parameter SI.MassFlowRate m_flow_nom_Harburg=m_flow_nom/7 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Altona=m_flow_nom/7 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Eimsbuettel=m_flow_nom/7 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_HHNord=m_flow_nom/7 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Wandsbek=m_flow_nom/7 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_HHMitte=m_flow_nom/7 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Bergedorf=m_flow_nom/7 "|Districts|Pipes|Nominal mass flow rate";

   parameter SI.Pressure Delta_p_nom_Ringline=32*9989 "|Ringline||Nominal Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline1=32*10204 "|Ringline||Nominal Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline2=32*11847 "|Ringline||Nominal Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline3=32*7286 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline4=32*10879 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline5=32*4421 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline6=32*11961 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline7=32*10915 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline8=32*13932 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Leversen=32*2353 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Tornesch=32*16710 "|Ringline||Nominal pressure loss";

   parameter SI.MassFlowRate m_flow_nom_Ringline=14.7 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline1=14.1 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline2=12.2 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline3=2.85 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline4=17.8 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline5=14.5 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline6=5 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline7=15.5 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline8=f_Rei*m_flow_nom-m_flow_nom_Bergedorf "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Leversen=f_Lev*m_flow_nom "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Tornesch=f_Tor*m_flow_nom "|Ringline||Nominal mass flow rate";

  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe_Leversen(
    Delta_p_nom=Delta_p_nom_Leversen,
    medium=medium,
    m_flow_nom=m_flow_nom_Leversen,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{-110,-78},{-90,-70}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe_Tornesch(
    Delta_p_nom=Delta_p_nom_Tornesch,
    medium=medium,
    m_flow_nom=m_flow_nom_Tornesch,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{-116,126},{-96,134}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline(
    Delta_p_nom=Delta_p_nom_Ringline,
    m_flow_nom=m_flow_nom_Ringline,
    medium=medium,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=90,
        origin={-82,-34})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline1(
    Delta_p_nom=Delta_p_nom_Ringline1,
    m_flow_nom=m_flow_nom_Ringline1,
    medium=medium,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=90,
        origin={-38,-34})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline2(
    Delta_p_nom=Delta_p_nom_Ringline2,
    m_flow_nom=m_flow_nom_Ringline2,
    medium=medium,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=90,
        origin={-70,14})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline3(
    Delta_p_nom=Delta_p_nom_Ringline3,
    m_flow_nom=m_flow_nom_Ringline3,
    medium=medium,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{10,-4},{-10,4}},
        rotation=270,
        origin={-70,54})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline4(
    Delta_p_nom=Delta_p_nom_Ringline4,
    m_flow_nom=m_flow_nom_Ringline4,
    medium=medium,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=270,
        origin={-70,112})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline5(
    Delta_p_nom=Delta_p_nom_Ringline5,
    m_flow_nom=m_flow_nom_Ringline5,
    medium=medium,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{-36,126},{-16,134}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline6(
    Delta_p_nom=Delta_p_nom_Ringline6,
    m_flow_nom=m_flow_nom_Ringline6,
    medium=medium,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{36,126},{56,134}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline7(
    Delta_p_nom=Delta_p_nom_Ringline7,
    m_flow_nom=m_flow_nom_Ringline7,
    medium=medium) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=90,
        origin={110,58})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline8(
    Delta_p_nom=Delta_p_nom_Ringline8,
    m_flow_nom=m_flow_nom_Ringline8,
    medium=medium,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=90,
        origin={110,-14})));
  TransiEnt.Grid.Gas.StaticCycles.Source_yellow GTS_Leversen(
    p=p_source,
    xi=xi_source,
    medium=medium,
    h=h_source) annotation (Placement(transformation(extent={{-176,-84},{-156,-64}})));
  TransiEnt.Grid.Gas.StaticCycles.Source_yellow GTS_Tornesch(
    p=p_source,
    xi=xi_source,
    medium=medium,
    h=h_source) annotation (Placement(transformation(extent={{-178,120},{-158,140}})));
  TransiEnt.Grid.Gas.StaticCycles.Source_yellow GTS_Reitbrook(
    p=p_source,
    xi=xi_source,
    medium=medium,
    h=h_source) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={170,-62})));
  TransiEnt.Grid.Gas.StaticCycles.Split split(medium=medium) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={-80,-61})));
  TransiEnt.Grid.Gas.StaticCycles.Split split1(medium=medium) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={-36,-14})));
  TransiEnt.Grid.Gas.StaticCycles.Split split2(medium=medium) annotation (Placement(transformation(
        extent={{-5,3},{5,-3}},
        rotation=180,
        origin={-70,128})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer1 split3(medium=medium, splitRatio=splitRatioEimsbuettel) annotation (Placement(transformation(
        extent={{5,3},{-5,-3}},
        rotation=270,
        origin={-68,73})));
  TransiEnt.Grid.Gas.StaticCycles.Split split4(medium=medium) annotation (Placement(transformation(
        extent={{-5,3},{5,-3}},
        rotation=180,
        origin={11,128})));
  TransiEnt.Grid.Gas.StaticCycles.Split split5(medium=medium) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=180,
        origin={110,-60})));
  TransiEnt.Grid.Gas.StaticCycles.Split split6(medium=medium) annotation (Placement(transformation(
        extent={{5,3},{-5,-3}},
        rotation=90,
        origin={108,20})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer Harburg(
    Delta_p_nom=Delta_p_nom_Harburg,
    m_flow=m_flow_Harburg,
    medium=medium,
    m_flow_nom=m_flow_nom_Harburg,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{-20,-24},{0,-4}})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer Altona(
    Delta_p_nom=Delta_p_nom_Altona,
    m_flow=m_flow_Altona,
    medium=medium,
    m_flow_nom=m_flow_nom_Altona,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{-50,25},{-30,45}})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer Eimsbuettel(
    Delta_p_nom=Delta_p_nom_Eimsbuettel,
    m_flow=m_flow_Eimsbuettel,
    medium=medium,
    m_flow_nom=m_flow_nom_Eimsbuettel,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{-50,63},{-30,83}})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer HHNord(
    Delta_p_nom=Delta_p_nom_HHNord,
    m_flow=m_flow_HHNord,
    medium=medium,
    m_flow_nom=m_flow_nom_HHNord,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{18,92},{38,112}})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer Bergedorf(
    Delta_p_nom=Delta_p_nom_Bergedorf,
    m_flow=m_flow_Bergedorf,
    medium=medium,
    m_flow_nom=m_flow_nom_Bergedorf,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={76,-62})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer HHMitte(
    Delta_p_nom=Delta_p_nom_HHMitte,
    m_flow=m_flow_HHMitte,
    medium=medium,
    m_flow_nom=m_flow_nom_HHMitte,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,20})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer Wandsbek(
    Delta_p_nom=Delta_p_nom_Wandsbek,
    m_flow=m_flow_Wandsbek,
    medium=medium,
    m_flow_nom=m_flow_nom_Wandsbek,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={76,84})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer1 mix1(medium=medium, splitRatio=splitRatioWandsbek) annotation (Placement(transformation(extent={{88,125},{98,131}})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer1 mix2(medium=medium, splitRatio=splitRatioHarburg) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=180,
        origin={-70,-7})));
  TransiEnt.Grid.Gas.StaticCycles.Split mix3(medium=medium) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={-68,35})));
  TransiEnt.Grid.Gas.StaticCycles.Valve_cutFlow valve_cutFlow1(medium=medium) annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=90,
        origin={110,103})));
  TransiEnt.Grid.Gas.StaticCycles.Valve_cutFlow valve_cutFlow3(medium=medium) annotation (Placement(transformation(
        extent={{-5,-2},{5,2}},
        rotation=180,
        origin={-53,-9})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer2 mixH2_Tornesch(medium=medium) annotation (Placement(transformation(
        extent={{10,6},{-10,-6}},
        rotation=180,
        origin={-140,126})));
  TransiEnt.Grid.Gas.StaticCycles.Source_blue source_H2_Tornesch(
    m_flow=m_flow_feedIn_Tornesch,
    xi=xi_feedIn_Tornesch,
    T=T_feedIn_Tornesch,
    medium=medium_H2)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-140,96})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer2 mixH2_Leversen(medium=medium) annotation (Placement(transformation(
        extent={{10,6},{-10,-6}},
        rotation=180,
        origin={-132,-78})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer2 mixH2_Reitbrook(medium=medium) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=0,
        origin={140,-66})));
  TransiEnt.Grid.Gas.StaticCycles.Source_blue source_H2_Leversen(
    m_flow=m_flow_feedIn_Leversen,
    xi=xi_feedIn_Leversen,
    T=T_feedIn_Leversen,
    medium=medium_H2)
                   annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-132,-112})));
  TransiEnt.Grid.Gas.StaticCycles.Source_blue source_H2_Reitbrook(
    m_flow=m_flow_feedIn_Reitbrook,
    xi=xi_feedIn_Reitbrook,
    T=T_feedIn_Reitbrook,
    medium=medium_H2)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={140,-104})));
  TransiEnt.Grid.Gas.StaticCycles.Valve_cutFlow valve_cutFlow2(medium=medium) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={-70,91})));
  TransiEnt.Grid.Gas.StaticCycles.Adapter_H2toNG h2toNG_Leversen(mediumOut=medium, mediumIn=medium_H2) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-132,-96})));
  TransiEnt.Grid.Gas.StaticCycles.Adapter_H2toNG h2toNG_Tornesch(mediumOut=medium, mediumIn=medium_H2) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-140,112})));
  TransiEnt.Grid.Gas.StaticCycles.Adapter_H2toNG h2toNG_Reitbrook(mediumIn=medium_H2, mediumOut=medium) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={140,-84})));
equation
  connect(split.outlet2, Ringline1.inlet) annotation (Line(points={{-76.6,-61},{-38,-61},{-38,-42.3}},                   color={0,0,0}));
  connect(split.outlet1, Ringline.inlet) annotation (Line(points={{-82,-55.6},{-82,-46},{-82,-42.3}},                     color={0,0,0}));
  connect(Ringline1.outlet, split1.inlet) annotation (Line(points={{-38,-23.8},{-38.05,-23.8},{-38.05,-18.6},{-38,-18.6}},   color={0,0,0}));
  connect(pipe_Tornesch.outlet, split2.inlet) annotation (Line(points={{-95.8,130},{-84,130},{-74.6,130}},                                    color={0,0,0}));
  connect(split2.outlet2, Ringline4.inlet) annotation (Line(points={{-70,124.6},{-70,120.3}},                           color={0,0,0}));
  connect(split2.outlet1, Ringline5.inlet) annotation (Line(points={{-64.6,130},{-46.7,130},{-34.3,130}},             color={0,0,0}));
  connect(Ringline5.outlet, split4.inlet) annotation (Line(points={{-15.8,130},{-6.9,130},{6.4,130}},                color={0,0,0}));
  connect(split4.outlet1, Ringline6.inlet) annotation (Line(points={{16.4,130},{23.3,130},{37.7,130}},           color={0,0,0}));
  connect(Ringline8.outlet, split6.inlet) annotation (Line(points={{110,-3.8},{110,15.4}},                           color={0,0,0}));
  connect(split5.outlet2, Ringline8.inlet) annotation (Line(points={{110,-56.6},{110,-22.3}},                         color={0,0,0}));
  connect(split1.outlet2, Harburg.steamSignal_yellow) annotation (Line(points={{-32.6,-14},{-28,-14},{-19,-14}},                 color={0,0,0}));
  connect(HHNord.steamSignal_yellow, split4.outlet2) annotation (Line(points={{19,102},{11,102},{11,124.6}},        color={0,0,0}));
  connect(mix2.inlet2, valve_cutFlow3.outlet) annotation (Line(points={{-65.4,-9},{-62,-9},{-58.4,-9}},              color={0,0,0}));
  connect(split1.outlet1, valve_cutFlow3.inlet) annotation (Line(points={{-38,-8.6},{-48,-8.6},{-48,-8.84},{-48.4,-8.84}},   color={0,0,0}));
  connect(Ringline.outlet, mix2.inlet1) annotation (Line(points={{-82,-23.8},{-82,-8.9},{-74.6,-8.9},{-74.6,-9}},        color={0,0,0}));
  connect(mix2.outlet, Ringline2.inlet) annotation (Line(points={{-70,-3.6},{-70,5.7}},                                color={0,0,0}));
  connect(Ringline6.outlet, mix1.inlet1) annotation (Line(points={{56.2,130},{63.1,130},{88.4,130}},            color={0,0,0}));
  connect(mix1.outlet, Wandsbek.steamSignal_yellow) annotation (Line(points={{93,124.6},{93,83.7},{85,83.7},{85,84}},    color={0,0,0}));
  connect(Ringline7.outlet, valve_cutFlow1.inlet) annotation (Line(points={{110,68.2},{110,78.1},{110.24,78.1},{110.24,98.4}}, color={0,0,0}));
  connect(valve_cutFlow1.outlet, mix1.inlet2) annotation (Line(points={{110,108.4},{110,130.3},{97.6,130.3},{97.6,130}},
                                                                                                                   color={0,0,0}));
  connect(split5.outlet1, Bergedorf.steamSignal_yellow) annotation (Line(points={{104.6,-62},{85,-62}},                          color={0,0,0}));
  connect(pipe_Leversen.outlet, split.inlet) annotation (Line(points={{-89.8,-74},{-89.8,-74},{-82,-74},{-82,-65.6}},         color={0,0,0}));
  connect(GTS_Tornesch.outlet, mixH2_Tornesch.inlet1) annotation (Line(points={{-161.1,130},{-149.2,130}}, color={0,0,0}));
  connect(mixH2_Tornesch.outlet, pipe_Tornesch.inlet) annotation (Line(points={{-129.2,130},{-129.2,130},{-114.3,130}},          color={0,0,0}));
  connect(GTS_Leversen.outlet, mixH2_Leversen.inlet1) annotation (Line(points={{-159.1,-74},{-159.1,-74.05},{-141.2,-74.05},{-141.2,-74}}, color={0,0,0}));
  connect(mixH2_Leversen.outlet, pipe_Leversen.inlet) annotation (Line(points={{-121.2,-74},{-114,-74},{-108.3,-74}},   color={0,0,0}));
  connect(mixH2_Reitbrook.outlet, split5.inlet) annotation (Line(points={{129.2,-62},{129.2,-62},{114.6,-62}},                     color={0,0,0}));
  connect(mixH2_Reitbrook.inlet1, GTS_Reitbrook.outlet) annotation (Line(points={{149.2,-62},{149.2,-62},{163.1,-62}}, color={0,0,0}));
  connect(split6.outlet1, Ringline7.inlet) annotation (Line(points={{110,25.4},{110,25.4},{110,49.7}}, color={0,0,0}));
  connect(split6.outlet2, HHMitte.steamSignal_yellow) annotation (Line(points={{104.6,20},{89,20}}, color={0,0,0}));
  connect(Ringline3.outlet, split3.inlet1) annotation (Line(points={{-70,64.2},{-70,68.4}}, color={0,0,0}));
  connect(split3.outlet, Eimsbuettel.steamSignal_yellow) annotation (Line(points={{-64.6,73},{-57.3,73},{-49,73}}, color={0,0,0}));
  connect(mix3.outlet2, Altona.steamSignal_yellow) annotation (Line(points={{-64.6,35},{-57.3,35},{-49,35}},            color={0,0,0}));
  connect(mix3.outlet1, Ringline3.inlet) annotation (Line(points={{-70,40.4},{-70,45.7}},            color={0,0,0}));
  connect(Ringline2.outlet, mix3.inlet) annotation (Line(points={{-70,24.2},{-70,30.4}},            color={0,0,0}));
  connect(Ringline4.outlet, valve_cutFlow2.inlet) annotation (Line(points={{-70,101.8},{-70,95.6},{-69.76,95.6}}, color={0,0,0}));
  connect(valve_cutFlow2.outlet, split3.inlet2) annotation (Line(points={{-70,85.6},{-70,77.6}}, color={0,0,0}));
  connect(mixH2_Leversen.inlet2,h2toNG_Leversen. outlet) annotation (Line(points={{-132,-83.2},{-132,-82},{-132,-89.4}},   color={0,0,0}));
  connect(source_H2_Leversen.outlet,h2toNG_Leversen. inlet) annotation (Line(points={{-132,-105.4},{-132,-102},{-132,-101.1}},
                                                                                                                   color={0,0,0}));
  connect(source_H2_Tornesch.outlet,h2toNG_Tornesch. inlet) annotation (Line(points={{-140,102.6},{-140,106.9}},              color={0,0,0}));
  connect(mixH2_Tornesch.inlet2,h2toNG_Tornesch. outlet) annotation (Line(points={{-140,120.8},{-140,118.6}}, color={0,0,0}));
  connect(source_H2_Reitbrook.outlet,h2toNG_Reitbrook. inlet) annotation (Line(points={{140,-97.4},{140,-92},{140,-89.1}},
                                                                                                                 color={0,0,0}));
  connect(mixH2_Reitbrook.inlet2,h2toNG_Reitbrook. outlet) annotation (Line(points={{140,-71.2},{140,-77.4}}, color={0,0,0}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,140}})), Icon(graphics,
                                                                                                         coordinateSystem(extent={{-180,-120},{180,140}})));
end StatCycleGasGridHamburg;
