within TransiEnt.Components.Gas.VolumesValvesFittings.Check;
model CheckThreeWayValve
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
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the ThreeWayValve</p>
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
</html>"));
end CheckThreeWayValve;
