within TransiEnt.Storage.Heat.HotWaterStorage_L4.Base;
model HeatingElectrode "Simple Heating Electrode with constant efficency"
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

  // Vorzeichenkonvention angepasst und zustzliche Abbruchbedingung 26.08.2015
  // Leistung limitiert 26.08.2015

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.Model;

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________
 parameter Real P_max= 2e6;
 parameter Real eta(min=0,max=1) = 0.95 "Constant efficency";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heat
    annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp annotation (Placement(transformation(extent={{-10,78},{10,98}}), iconTransformation(extent={{-10,78},{10,98}})));

  // _____________________________________________
  //
  //               Models
  // _____________________________________________
public
  outer TransiEnt.SimCenter simCenter;

  ClaRa.Components.BoundaryConditions.PrescribedHeatFlowScalar HeatFlow
    annotation (Placement(transformation(extent={{-48,-10},{-68,10}})));

  TransiEnt.Components.Sensors.ElectricReactivePower powerOnEPP annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={60,42})));

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage constantPotentialVariableBoundary(Use_input_connector_f=false, Use_input_connector_v=false) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={61,11})));

  Modelica.Blocks.Math.Gain efficency(k=-eta) "efficency of heating"
    annotation (Placement(transformation(extent={{22,-8},{6,8}})));

  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=0, uMin=-P_max*eta)
    annotation (Placement(transformation(extent={{-10,-10},{-30,10}})));

  // _____________________________________________
  //
  //                Equations
  // _____________________________________________
equation
  assert(eta<=1,"The efficency of the heating electrode can't be higher than 1.");
  assert(eta>0,"The efficency of the heating electrode has to be hgher than 0.");
  assert(heat.Q_flow>=0,"The electrode is just for heating.");

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(HeatFlow.port, heat) annotation (Line(
      points={{-68,0},{-86,0}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(epp,powerOnEPP. epp_IN) annotation (Line(
      points={{0,88},{0,60},{60,60},{60,51.2}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(powerOnEPP.epp_OUT, constantPotentialVariableBoundary.epp)
    annotation (Line(
      points={{60,32.6},{60.93,32.6},{60.93,18.07}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(efficency.u, powerOnEPP.P) annotation (Line(
      points={{23.6,0},{44,0},{44,45.8},{52.2,45.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limiter.u, efficency.y)
    annotation (Line(points={{-8,0},{5.2,0}}, color={0,0,127}));
  connect(limiter.y, HeatFlow.Q_flow)
    annotation (Line(points={{-31,0},{-48,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Ellipse(
          extent={{-42,-44},{40,-86}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-42,58},{40,-68}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Ellipse(
          extent={{-42,80},{40,38}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Line(
          points={{0,80},{0,18},{-28,12}},
          color={0,127,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,18},{30,12}},
          color={0,127,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,18},{0,6}},
          color={0,127,0},
          smooth=Smooth.None,
          thickness=0.5),
        Rectangle(
          extent={{-30,12},{-26,-32}},
          lineColor={0,127,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,127,0}),
        Rectangle(
          extent={{-2,6},{2,-38}},
          lineColor={0,127,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,127,0}),
        Rectangle(
          extent={{28,12},{32,-32}},
          lineColor={0,127,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,127,0})}),                      Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple model for electrical heating.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Purely technical component without physical modeling.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Purely technical component without physical modeling. The model has a constant efficency.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp: gets the electric power for heating </p><p>heat: heat flow for heating purpose</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>eta: defines the efficency. The efficency has to be a value between zero and one. The efficency is constant during a simulation</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Ramm (tobias.ramm@tuhh.de) on Fri Mar 20 2015</p>
<p>Revised and edited by Lisa Andresen (andresen@tuhh.de), Jun 2015</p>
</html>"),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end HeatingElectrode;
