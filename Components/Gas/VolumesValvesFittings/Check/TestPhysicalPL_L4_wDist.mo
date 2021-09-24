within TransiEnt.Components.Gas.VolumesValvesFittings.Check;
model TestPhysicalPL_L4_wDist


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi(p_const=8000000) annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow(m_flow_const=50) annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth pipe(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    length=50e3,
    diameter_i=0.6,
    N_cv=2,
    showExpertSummary=true,
    redeclare model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4 (
        numberOfMFlowDist={2},
        t_dist_start=1/2*86400,
        t_dist_end=86400)) annotation (Placement(transformation(extent={{-14,-6},{14,6}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth pipe1(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    length=50e3,
    diameter_i=0.4,
    N_cv=1,
    showExpertSummary=true,
    redeclare model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4) annotation (Placement(transformation(extent={{-14,-26},{14,-14}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth junction(volume=10) annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth junction1(volume=10) annotation (Placement(transformation(extent={{22,-10},{42,10}})));
  inner TransiEnt.SimCenter simCenter(useConstCompInGasComp=true, initOptionGasPipes=210) annotation (Placement(transformation(extent={{-88,40},{-68,60}})));
equation
  connect(junction.gasPort3, pipe.gasPortIn) annotation (Line(
      points={{-22,0},{-18,0},{-18,0},{-14,0}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_pTxi.gasPort, junction.gasPort1) annotation (Line(
      points={{-50,0},{-42,0}},
      color={255,255,0},
      thickness=1.5));
  connect(junction.gasPort2, pipe1.gasPortIn) annotation (Line(
      points={{-32,-10},{-32,-20},{-14,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(junction1.gasPort3, boundary_Txim_flow.gasPort) annotation (Line(
      points={{42,0},{50,0}},
      color={255,255,0},
      thickness=1.5));
  connect(junction1.gasPort2, pipe1.gasPortOut) annotation (Line(
      points={{32,-10},{32,-20},{14,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe.gasPortOut, junction1.gasPort1) annotation (Line(
      points={{14,0},{18,0},{18,0},{22,0}},
      color={255,255,0},
      thickness=1.5));
  annotation (experiment(
      StopTime=172800,
      Interval=900,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test model for the physical pressure loss model with a disturbance.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no elements)</p>
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
<p>Model created by Carsten Bode (c.bode@tuhh.de), Apr 2021</p>
</html>"),
    Diagram(graphics={Text(
          extent={{-20,22},{20,10}},
          textColor={28,108,200},
          textString="Disturbance from 
12h until 24h")}),
    __Dymola_experimentFlags,
      Evaluate=false);
end TestPhysicalPL_L4_wDist;
