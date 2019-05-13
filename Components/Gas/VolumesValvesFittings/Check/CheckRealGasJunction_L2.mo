within TransiEnt.Components.Gas.VolumesValvesFittings.Check;
model CheckRealGasJunction_L2
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  import TILMedia;
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,
            -100},{-70,-80}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_p(p_const=1000000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={40,20})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_m_flow(m_flow_const=-1, T_const=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,20})));
  RealGasJunction_L2 realGasJunction_L2_1(
    redeclare model PressureLoss1 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear,
    redeclare model PressureLoss2 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear,
    redeclare model PressureLoss3 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear,
                                          p(
                                          start = 10e5), h(
                                                        start = 28.6e3))
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink_m_flow(
    variable_m_flow=true,
    T_const=373.15,
    xi_const={1,0,0,0,0,0}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-20})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=100,
    height=-2,
    offset=1)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
equation
  connect(source_m_flow.gasPort, realGasJunction_L2_1.gasPort1) annotation (Line(
      points={{-30,20},{-30,20},{-10,20}},
      color={255,255,0},
      thickness=1.5));
  connect(realGasJunction_L2_1.gasPort2, sink_m_flow.gasPort) annotation (Line(
      points={{0,10},{0,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(realGasJunction_L2_1.gasPort3, sink_p.gasPort) annotation (Line(
      points={{10,20},{30,20}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp.y, sink_m_flow.m_flow) annotation (Line(points={{-29,-40},{
          -6,-40},{-6,-32}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-28,54},{32,44}},
          lineColor={28,108,200},
          textString="checked for split and junction operation
checked for pressure losses")}),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the RealGasJunction_L2 model</p>
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
end CheckRealGasJunction_L2;
