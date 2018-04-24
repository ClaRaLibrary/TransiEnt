within TransiEnt.Components.Gas.VolumesValvesFittings.Check;
model CheckThreeWayValve
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

  import TILMedia;
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,
            -100},{-70,-80}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_p1(p_const=1000000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={40,0})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_m_flow(m_flow_const=-1, T_const=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,0})));
  Modelica.Blocks.Sources.Ramp ramp(
    offset=1,
    height=-1,
    duration=80,
    startTime=10)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_p2(p_const=1000000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,-40})));
  ThreeWayValveRealGas_L1_simple threeWayValveRealGas_L1_simple(
      splitRatio_input=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,8}})));
equation
  connect(source_m_flow.gasPort, threeWayValveRealGas_L1_simple.gasPortIn) annotation (Line(
      points={{-30,0},{-20,0},{-10,0}},
      color={255,255,0},
      thickness=1.5));
  connect(threeWayValveRealGas_L1_simple.gasPortOut1, sink_p1.gasPort) annotation (Line(
      points={{10,0},{20,0},{30,0}},
      color={255,255,0},
      thickness=1.5));
  connect(threeWayValveRealGas_L1_simple.gasPortOut2, sink_p2.gasPort) annotation (Line(
      points={{0,-10},{0,-20},{0,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp.y, threeWayValveRealGas_L1_simple.splitRatio_external)
    annotation (Line(points={{-9,30},{0,30},{0,9}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end CheckThreeWayValve;
