within TransiEnt.Storage.Gas.Check;
model TestUndergroundGasStoragePressureLoss_L2
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

  parameter Integer N_cv=1;

  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel1)     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-90})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,30})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
  Modelica.Blocks.Sources.TimeTable timeTable_source(table=[0,-100; 10000,0; 20000,0])
                                                                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={6,60})));
  Modelica.Blocks.Sources.TimeTable timeTable_sink(table=[0,0; 10000,0; 20000,100])
                                                                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-6,-60})));
  TransiEnt.Storage.Gas.UndergroundGasStoragePressureLoss_L2 cavern(pipeOut(
      h_nom=4.23152e6*ones(N_cv),
      m_flow_nom=1000,
      N_cv=N_cv,
      h_start=4.23152e6*ones(N_cv)), pipeIn(
      m_flow_nom=1000,
      h_nom=4.23152e6*ones(N_cv),
      N_cv=N_cv,
      h_start=4.23152e6*ones(N_cv)),
    storage(V_geo=500000))           annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source1(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,30})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink1(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-30})));
  UndergroundGasStoragePressureLossHeatTransfer_L2 cavern_wHT(pipeOut(
      m_flow_nom=1000,
      h_nom=4.23152e6*ones(N_cv),
      h_start=4.23152e6*ones(N_cv),
      N_cv=N_cv), pipeIn(
      m_flow_nom=1000,
      h_nom=4.23152e6*ones(N_cv),
      h_start=4.23152e6*ones(N_cv),
      N_cv=N_cv),
    storage(V_geo=500000))
                          annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(source.m_flow, timeTable_source.y) annotation (Line(points={{6,42},{6,49}}, color={0,0,127}));
  connect(cavern.gasPortIn, source.gasPort) annotation (Line(
      points={{0,4.9},{0,20}},
      color={255,255,0},
      thickness=1.5));
  connect(cavern.gasPortOut, sink.gasPort) annotation (Line(
      points={{0,-6.3},{0,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(sink.m_flow, timeTable_sink.y) annotation (Line(points={{-6,-42},{-6,-49}}, color={0,0,127}));
  connect(cavern_wHT.gasPortIn, source1.gasPort) annotation (Line(
      points={{30,4.9},{30,20}},
      color={255,255,0},
      thickness=1.5));
  connect(cavern_wHT.gasPortOut, sink1.gasPort) annotation (Line(
      points={{30,-6.3},{30,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(timeTable_source.y, source1.m_flow) annotation (Line(points={{6,49},{6,49},{6,46},{36,46},{36,42}}, color={0,0,127}));
  connect(sink1.m_flow, timeTable_sink.y) annotation (Line(points={{24,-42},{24,-46},{-6,-46},{-6,-49}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-60,-100},{40,80}}), graphics={Text(
          extent={{-56,66},{-28,56}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="look at:
-storage pressure
-pipe inlet pressure
-pipe outlet pressure")}),
    experiment(StopTime=20000),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-60,-100},{40,80}})),
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
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Sep 2016</p>
</html>"));
end TestUndergroundGasStoragePressureLoss_L2;
