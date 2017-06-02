within TransiEnt.Grid.Gas;
model StatCycleGasGridHamburg

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

   import TransiEnt;
   extends TransiEnt.Basics.Icons.ModelStaticCycle;
   outer TransiEnt.SimCenter simCenter;

   parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Natural gas medium to be used";
   parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_H2=simCenter.gasModel3 "Hydrogen medium to be used";

   parameter SI.Pressure p_source=simCenter.p_eff_2+simCenter.p_amb_const "|Sources|Natural Gas|Absolute pressure";
   parameter SI.SpecificEnthalpy h_source=785411 "|Sources|Natural Gas|Specific enthalpy";
   parameter SI.MassFraction xi_source[medium.nc - 1]=
                                                    medium.xi_default "|Sources|Natural Gas|Mass specific composition";

   parameter SI.MassFlowRate m_flow_feedIn_Tornesch=0.019 "|Sources|Feed-In Station|Mass flow rate";
   parameter SI.Temperature T_feedIn_Tornesch=simCenter.T_ground "|Sources|Feed-In Station|Specific enthalpy";
   parameter SI.MassFraction xi_feedIn_Tornesch[medium_H2.nc - 1]=
                                                             zeros(medium_H2.nc-1) "|Sources|Feed-In Station|Mass specific composition";

   parameter SI.MassFlowRate m_flow_feedIn_Leversen=0.019 "|Sources|Feed-In Station|Mass flow rate";
   parameter SI.Temperature T_feedIn_Leversen=simCenter.T_ground "|Sources|Feed-In Station|Specific enthalpy";
   parameter SI.MassFraction xi_feedIn_Leversen[medium_H2.nc - 1]=
                                                             zeros(medium_H2.nc-1) "|Sources|Feed-In Station|Mass specific composition";

   parameter SI.MassFlowRate m_flow_feedIn_Reitbrook=0.019 "|Sources|Feed-In Station|Mass flow rate";
   parameter SI.Temperature T_feedIn_Reitbrook=simCenter.T_ground "|Sources|Feed-In Station|Specific enthalpy";
   parameter SI.MassFraction xi_feedIn_Reitbrook[medium_H2.nc - 1]=
                                                              zeros(medium_H2.nc-1) "|Sources|Feed-In Station|Mass specific composition";

   parameter SI.MassFlowRate m_flow_Harburg=141 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_Altona=141 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_Eimsbuettel=141 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_HHNord=141 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_Wandsbek=141 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_HHMitte=141 "|Districts|Sinks|Mass flow rate";
   parameter SI.MassFlowRate m_flow_Bergedorf=141 "|Districts|Sinks|Mass flow rate";

   parameter SI.Pressure Delta_p_nom_Harburg=0.58e5*3.77 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Altona=0.58e5*5.15 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Eimsbuettel=0.58e5*2.74 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_HHNord=0.58e5*10.56 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Wandsbek=0.58e5*4.7 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_HHMitte=0.58e5*9.48 "|Districts|Pipes|Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Bergedorf=0.58e5*6.77 "|Districts|Pipes|Nominal pressure loss";

   parameter SI.MassFlowRate m_flow_nom_Harburg=116/10 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Altona=116/10 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Eimsbuettel=116/10 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_HHNord=116/10 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Wandsbek=116/10 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_HHMitte=116/10 "|Districts|Pipes|Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Bergedorf=116/10 "|Districts|Pipes|Nominal mass flow rate";

   parameter SI.Pressure Delta_p_nom_Ringline=(0.32e5)*8.85 "|Ringline||Nominal Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline1=(0.32e5)*9.25 "|Ringline||Nominal Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline2=(0.32e5)*11.4 "|Ringline||Nominal Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline3=(0.32e5)*5.7 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline4=(0.32e5)*9.2 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline5=(0.32e5)*4.6 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline6=(0.32e5)*11.6 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline7=(0.32e5)*10.85 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Ringline8=(0.32e5)*6 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Leversen=(0.32e5)*2 "|Ringline||Nominal pressure loss";
   parameter SI.Pressure Delta_p_nom_Tornesch=(0.32e5)*10 "|Ringline||Nominal pressure loss";

   parameter SI.MassFlowRate m_flow_nom_Ringline=147/10 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline1=141/10 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline2=122/10 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline3=28.5/10 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline4=178/10 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline5=145/10 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline6=50/10 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline7=155/10 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Ringline8=305/10 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Leversen=288/10 "|Ringline||Nominal mass flow rate";
   parameter SI.MassFlowRate m_flow_nom_Tornesch=257/10 "|Ringline||Nominal mass flow rate";

  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe_Leversen(
    Delta_p_nom=Delta_p_nom_Leversen,
    medium=medium,
    m_flow_nom=m_flow_nom_Leversen) annotation (Placement(transformation(extent={{-110,-78},{-90,-70}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe_Tornesch(
    Delta_p_nom=Delta_p_nom_Tornesch,
    medium=medium,
    m_flow_nom=m_flow_nom_Tornesch) annotation (Placement(transformation(extent={{-116,126},{-96,134}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline(
    Delta_p_nom=Delta_p_nom_Ringline,
    m_flow_nom=m_flow_nom_Ringline,
    medium=medium) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=90,
        origin={-82,-34})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline1(
    Delta_p_nom=Delta_p_nom_Ringline1,
    m_flow_nom=m_flow_nom_Ringline1,
    medium=medium) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=90,
        origin={-38,-34})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline2(
    Delta_p_nom=Delta_p_nom_Ringline2,
    m_flow_nom=m_flow_nom_Ringline2,
    medium=medium) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=90,
        origin={-70,14})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline3(
    Delta_p_nom=Delta_p_nom_Ringline3,
    m_flow_nom=m_flow_nom_Ringline3,
    medium=medium) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=270,
        origin={-70,66})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline4(
    Delta_p_nom=Delta_p_nom_Ringline4,
    m_flow_nom=m_flow_nom_Ringline4,
    medium=medium) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=270,
        origin={-70,106})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline5(
    Delta_p_nom=Delta_p_nom_Ringline5,
    m_flow_nom=m_flow_nom_Ringline5,
    medium=medium) annotation (Placement(transformation(extent={{-36,126},{-16,134}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow Ringline6(
    Delta_p_nom=Delta_p_nom_Ringline6,
    m_flow_nom=m_flow_nom_Ringline6,
    medium=medium) annotation (Placement(transformation(extent={{36,126},{56,134}})));
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
    medium=medium) annotation (Placement(transformation(
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
  TransiEnt.Grid.Gas.StaticCycles.Split split3(medium=medium) annotation (Placement(transformation(
        extent={{5,3},{-5,-3}},
        rotation=270,
        origin={-68,85})));
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
    m_flow_nom=m_flow_nom_Harburg) annotation (Placement(transformation(extent={{-20,-24},{0,-4}})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer Altona(
    Delta_p_nom=Delta_p_nom_Altona,
    m_flow=m_flow_Altona,
    medium=medium,
    m_flow_nom=m_flow_nom_Altona) annotation (Placement(transformation(extent={{-50,37},{-30,57}})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer Eimsbuettel(
    Delta_p_nom=Delta_p_nom_Eimsbuettel,
    m_flow=m_flow_Eimsbuettel,
    medium=medium,
    m_flow_nom=m_flow_nom_Eimsbuettel) annotation (Placement(transformation(extent={{-50,75},{-30,95}})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer HHNord(
    Delta_p_nom=Delta_p_nom_HHNord,
    m_flow=m_flow_HHNord,
    medium=medium,
    m_flow_nom=m_flow_nom_HHNord) annotation (Placement(transformation(extent={{18,92},{38,112}})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer Bergedorf(
    Delta_p_nom=Delta_p_nom_Bergedorf,
    m_flow=m_flow_Bergedorf,
    medium=medium,
    m_flow_nom=m_flow_nom_Bergedorf) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={76,-62})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer HHMitte(
    Delta_p_nom=Delta_p_nom_HHMitte,
    m_flow=m_flow_HHMitte,
    medium=medium,
    m_flow_nom=m_flow_nom_HHMitte) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,20})));
  TransiEnt.Grid.Gas.StaticCycles.Consumer Wandsbek(
    Delta_p_nom=Delta_p_nom_Wandsbek,
    m_flow=m_flow_Wandsbek,
    medium=medium,
    m_flow_nom=m_flow_nom_Wandsbek) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={76,84})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer1 mix1(medium=medium) annotation (Placement(transformation(extent={{88,125},{98,131}})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer1 mix2(medium=medium) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=180,
        origin={-70,-7})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer1 mix3(medium=medium) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={-68,47})));
  TransiEnt.Grid.Gas.StaticCycles.Valve_cutFlow valve_cutFlow1(medium=medium) annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=90,
        origin={110,103})));
  TransiEnt.Grid.Gas.StaticCycles.Valve_cutFlow valve_cutFlow3(medium=medium) annotation (Placement(transformation(
        extent={{-5,-2},{5,2}},
        rotation=180,
        origin={-53,-9})));
  TransiEnt.Grid.Gas.StaticCycles.Valve_cutFlow valve_cutFlow2(medium=medium) annotation (Placement(transformation(
        extent={{-5,-3},{5,3}},
        rotation=90,
        origin={-70,33})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer2 mixH2_Tornesch(medium=medium) annotation (Placement(transformation(
        extent={{10,6},{-10,-6}},
        rotation=180,
        origin={-140,126})));
  TransiEnt.Grid.Gas.StaticCycles.Source_blue source_H2_Tornesch(
    m_flow=m_flow_feedIn_Tornesch,
    xi=xi_feedIn_Tornesch,
    T=T_feedIn_Tornesch,
    medium=medium_H2) annotation (Placement(transformation(
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
    medium=medium_H2) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-132,-114})));
  TransiEnt.Grid.Gas.StaticCycles.Source_blue source_H2_Reitbrook(
    m_flow=m_flow_feedIn_Reitbrook,
    xi=xi_feedIn_Reitbrook,
    T=T_feedIn_Reitbrook,
    medium=medium_H2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={140,-102})));
  TransiEnt.Grid.Gas.StaticCycles.Adapter_H2toNG h2toNG_Leversen(mediumOut=medium, mediumIn=medium_H2) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-132,-96})));
  TransiEnt.Grid.Gas.StaticCycles.Adapter_H2toNG h2toNG_Tornesch(mediumOut=medium, mediumIn=medium_H2) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-140,110})));
  TransiEnt.Grid.Gas.StaticCycles.Adapter_H2toNG h2toNG_Reitbrook(mediumIn=medium_H2, mediumOut=medium) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={140,-84})));
equation
  connect(split.outlet2, Ringline1.inlet) annotation (Line(points={{-76.6,-61},{-38,-61},{-38,-42.3}},                   color={0,0,0}));
  connect(split.outlet1, Ringline.inlet) annotation (Line(points={{-82,-55.6},{-82,-46},{-82,-42.3}},                     color={0,0,0}));
  connect(Ringline1.outlet, split1.inlet) annotation (Line(points={{-38,-23.8},{-38.05,-23.8},{-38.05,-18.6},{-38,-18.6}},   color={0,0,0}));
  connect(pipe_Tornesch.outlet, split2.inlet) annotation (Line(points={{-95.8,130},{-84,130},{-74.6,130}},                                    color={0,0,0}));
  connect(split2.outlet2, Ringline4.inlet) annotation (Line(points={{-70,124.6},{-70,114.3}},                           color={0,0,0}));
  connect(split2.outlet1, Ringline5.inlet) annotation (Line(points={{-64.6,130},{-46.7,130},{-34.3,130}},             color={0,0,0}));
  connect(split3.inlet, Ringline4.outlet) annotation (Line(points={{-70,89.6},{-70,91.5},{-70,95.8}},                  color={0,0,0}));
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
  connect(mix3.inlet1, Ringline3.outlet) annotation (Line(points={{-70,51.6},{-70,52.7},{-70,55.8}},                color={0,0,0}));
  connect(mix3.outlet, Altona.steamSignal_yellow) annotation (Line(points={{-64.6,47},{-49,47}},                         color={0,0,0}));
  connect(valve_cutFlow2.outlet, mix3.inlet2) annotation (Line(points={{-70,38.4},{-70,42.4}},          color={0,0,0}));
  connect(Ringline2.outlet, valve_cutFlow2.inlet) annotation (Line(points={{-70,24.2},{-70,26.1},{-69.76,26.1},{-69.76,28.4}},     color={0,0,0}));
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
  connect(split3.outlet2, Eimsbuettel.steamSignal_yellow) annotation (Line(points={{-64.6,85},{-64.6,85},{-49,85}}, color={0,0,0}));
  connect(split3.outlet1, Ringline3.inlet) annotation (Line(points={{-70,79.6},{-70,74.3}}, color={0,0,0}));
  connect(split6.outlet1, Ringline7.inlet) annotation (Line(points={{110,25.4},{110,25.4},{110,49.7}}, color={0,0,0}));
  connect(split6.outlet2, HHMitte.steamSignal_yellow) annotation (Line(points={{104.6,20},{89,20}}, color={0,0,0}));
  connect(mixH2_Leversen.inlet2, h2toNG_Leversen.outlet) annotation (Line(points={{-132,-83.2},{-132,-89.4}}, color={0,0,0}));
  connect(source_H2_Leversen.outlet, h2toNG_Leversen.inlet) annotation (Line(points={{-132,-107.4},{-132,-101.1}}, color={0,0,0}));
  connect(mixH2_Tornesch.inlet2, h2toNG_Tornesch.outlet) annotation (Line(points={{-140,120.8},{-140,120.8},{-140,116.6}}, color={0,0,0}));
  connect(mixH2_Reitbrook.inlet2, h2toNG_Reitbrook.outlet) annotation (Line(points={{140,-71.2},{140,-77.4}}, color={0,0,0}));
  connect(source_H2_Reitbrook.outlet, h2toNG_Reitbrook.inlet) annotation (Line(points={{140,-95.4},{140,-89.1}}, color={0,0,0}));
  connect(source_H2_Tornesch.outlet, h2toNG_Tornesch.inlet) annotation (Line(points={{-140,102.6},{-140,102.6},{-140,104.9}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,140}})), Icon(coordinateSystem(extent={{-180,-120},{180,140}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Open-loop high pressure gas ring grid of Hamburg in static cycle.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
<p>Created by Tom Lindemann (tom.lindemann@tuhh.de), Mar 2016</p>
<p>Revised and edited by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end StatCycleGasGridHamburg;
