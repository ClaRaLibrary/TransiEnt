within TransiEnt.Producer.Heat.Heat2Heat.Check;
model TestSubstation_indirect_noStorage_L1



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
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=3e5,
    T_const=70 + 273.15)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-11})));
  Modelica.Blocks.Sources.Ramp Q_demand_RH(
    startTime=3600,
    duration=900,
    height=-2e3,
    offset=10e3) annotation (Placement(transformation(extent={{-66,30},{-40,56}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-62,80},{-42,100}})));
  TransiEnt.Producer.Heat.Heat2Heat.Substation_indirect_noStorage_L1 substation_indirect_noStorage_L1_1 annotation (Placement(transformation(extent={{-20,16},{8,36}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(
    medium=simCenter.fluid1,
    p_const=4e5,
    T_const=90 + 273.15)  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-11})));
  Modelica.Blocks.Sources.Ramp Q_demand_DHW(
    startTime=3600,
    duration=50,
    height=20e3,
    offset=0e3) annotation (Placement(transformation(extent={{66,30},{40,56}})));

equation
  connect(substation_indirect_noStorage_L1_1.waterPortOut, sink.steam_a) annotation (Line(
      points={{0.1,15.9},{0.1,-11},{60,-11}},
      color={175,0,0},
      thickness=0.5));
  connect(sink1.steam_a, substation_indirect_noStorage_L1_1.waterPortIn) annotation (Line(
      points={{-60,-11},{-12,-11},{-12,16}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Q_demand_RH.y, substation_indirect_noStorage_L1_1.Q_demand_RH) annotation (Line(points={{-38.7,43},{-17,43},{-17,35}}, color={0,0,127}));
  connect(substation_indirect_noStorage_L1_1.Q_demand_DHW, Q_demand_DHW.y) annotation (Line(points={{5,35},{5,43},{38.7,43}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                                                   Text(
          extent={{-82,-36},{-26,-56}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="look at 
- mass flow rate
- T_in and T_out of the Substation Model")}),                                                       experiment(
      StopTime=10000,
      Interval=60,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for Substation_indirect_noStorage_L1</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
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
</html>"));
end TestSubstation_indirect_noStorage_L1;
