within TransiEnt.Consumer.Systems.PVBatteryPoolControl.PVBatteryConsumer;
model PVBatteryHousehold "Household with pv, household and battery management systeem"


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





  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer Base.PoolParameter param;

   // _____________________________________________
   //
   //             Visible Parameters
   // _____________________________________________

   parameter Integer nSystems=param.nSystems "Number of systems in pool";
   parameter Integer nLoadProfiles=nSystems "Number of load profiles in input vector";
   parameter Integer nPVProfiles=nSystems "Number of PV production profiles in input vector";

   parameter Integer iSystem(min=1, max=nSystems)=1 "Index of unit in pool";
   parameter Integer iLoadProfile(min=1, max=nLoadProfiles)=1 "Index of units load profile in input vecotr";
   parameter Integer iPVProfile(min=1, max=nPVProfiles)=1  "Index of units PV production profile in input vecotr";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Controller.BatteryManagementSystem batteryManagement(index=iSystem)
                                                       annotation (Placement(transformation(extent={{56,13},{84,41}})));

  PoolControlledBatterySystem battery(index=iSystem, batterySystem(StorageModelParams=Storage.Electrical.Specifications.LithiumIon(
          E_start=param.SOC_start*param.E_max_bat,
          E_max=param.E_max_bat,
          E_min=param.SOC_min*param.E_max_bat,
          P_max_unload=param.P_el_max_bat,
          P_max_load=param.P_el_max_bat,
          eta_unload=param.eta_max,
          eta_load=param.eta_max,
          selfDischargeRate=0))) annotation (Placement(transformation(extent={{20,-98},{-5,-72}})));
  Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}), iconTransformation(extent={{-110,-50},{-90,-30}})));

  Modelica.Blocks.Sources.IntegerConstant indexLoad(k=iLoadProfile)
    annotation (Placement(transformation(extent={{-64,60},{-52,72}})));

  Modelica.Blocks.Sources.IntegerConstant indexPV(k=iPVProfile)
    annotation (Placement(transformation(extent={{-62,22},{-50,34}})));

  Base.PoolControlBus poolControlBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,10}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={102,-58})));

  Modelica.Blocks.Routing.Extractor extractLoadProfile(nin=nLoadProfiles, index(start=iLoadProfile, fixed=true)) annotation (Placement(transformation(extent={{-48,70},{-28,90}})));
  Modelica.Blocks.Routing.Extractor extractPVProfile(nin=nPVProfiles,index(start=iPVProfile, fixed=true)) annotation (Placement(transformation(extent={{-48,30},{-28,50}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_load[nLoadProfiles] "Connector of Real input signals" annotation (Placement(transformation(extent={{-122,60},{-82,100}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_PV[nPVProfiles] "Connector of Real input signals" annotation (Placement(transformation(extent={{-122,20},{-82,60}})));
  Components.Boundaries.Electrical.ActivePower.Power load(change_sign=false) annotation (Placement(transformation(
        extent={{-13,-12},{13,12}},
        rotation=0,
        origin={28,-40})));
  Producer.Electrical.Photovoltaics.PhotovoltaicProfilePlant photovoltaicSystem(powerBoundary(change_sign=true), P_el_n=param.P_el_PV_peak) annotation (Placement(transformation(extent={{18,-24},{-4,-2}})));
  Components.Sensors.ElectricFrequency electricFrequency(isDeltaMeasurement=true) annotation (Placement(transformation(extent={{-22,7},{-2,27}})));
  Modelica.Blocks.Math.Feedback P_el_surplus "Suplus power (> 0 means more PV than load)" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={42,60})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(poolControlBus, batteryManagement.poolControlBus) annotation (Line(
      points={{100,10},{88,10},{88,29.52},{86.8,29.52}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(indexLoad.y, extractLoadProfile.index) annotation (Line(
      points={{-51.4,66},{-38,66},{-38,68}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(indexPV.y, extractPVProfile.index) annotation (Line(
      points={{-49.4,28},{-38,28}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(extractLoadProfile.u, P_el_load) annotation (Line(
      points={{-50,80},{-102,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extractPVProfile.u, P_el_PV) annotation (Line(
      points={{-50,40},{-102,40}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(load.epp, epp) annotation (Line(
      points={{15,-40},{15,-40},{-100,-40}},
      color={0,135,135},
      thickness=0.5));
  connect(photovoltaicSystem.epp, epp) annotation (Line(
      points={{-2.9,-5.3},{-26,-5.3},{-26,-40},{-100,-40}},
      color={0,135,135},
      thickness=0.5));
  connect(battery.epp, epp) annotation (Line(
      points={{-5,-90.2},{-26,-90.2},{-26,-40},{-100,-40}},
      color={0,135,135},
      thickness=0.5));
  connect(battery.poolControlBus, poolControlBus) annotation (Line(
      points={{7.5,-72.26},{7.5,-71},{8,-71},{8,-67},{88,-67},{88,10},{100,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(epp, electricFrequency.epp) annotation (Line(
      points={{-100,-40},{-100,-40},{-28,-40},{-26,-40},{-26,17},{-22,17}},
      color={0,135,135},
      thickness=0.5));
  connect(P_el_surplus.y, batteryManagement.P_surplus) annotation (Line(points={{51,60},{56.28,60},{56.28,41}}, color={0,0,127}));
  connect(extractLoadProfile.y, load.P_el_set) annotation (Line(points={{-27,80},{20.2,80},{20.2,-25.6}},
                                                                                                       color={0,0,127}));
  connect(electricFrequency.f, batteryManagement.delta_f) annotation (Line(points={{-1.6,17},{32,17},{32,17.48},{57.12,17.48}},
                                                                                                                             color={0,0,127}));
  connect(extractPVProfile.y, P_el_surplus.u1) annotation (Line(points={{-27,40},{-10,40},{8,40},{8,60},{34,60}}, color={0,0,127}));
  connect(extractLoadProfile.y, P_el_surplus.u2) annotation (Line(points={{-27,80},{6,80},{42,80},{42,68}}, color={0,0,127}));
  connect(extractPVProfile.y, photovoltaicSystem.P_el_set) annotation (Line(points={{-27,40},{-11,40},{9,40},{9,18},{8.65,18},{8.65,-2.11}}, color={0,0,127}));
  annotation (
    defaultComponentName="Households",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics={
        Rectangle(
          extent={{-64,-36},{-40,-82}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-6,-26},{124,-26},{58,38},{-6,-26}},
          lineColor={0,134,134},
          smooth=Smooth.None,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,-8},{100,-76}},
          lineColor={0,134,134},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{76,-30},{88,-40}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,-48},{52,-70}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,38},{-6,-24},{-12,-20},{50,42},{56,38}},
          lineColor={85,85,255},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-38,68},{-10,42}},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-72,-62},{-32,-90}},
          lineColor={0,0,255},
          textString="-"),
        Rectangle(
          extent={{-56,-34},{-48,-36}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-62,-34},{-40,-52}},
          lineColor={0,0,255},
          textString="+"),
        Polygon(
          points={{30,34},{42,24},{6,-12},{-6,-4},{30,34}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{22,22},{30,16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{16,16},{24,10}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{10,10},{18,4}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{4,4},{12,-2}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{28,28},{36,22}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-52,-34},{-52,-30},{48,-30}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-52,-82},{-52,-90},{-18,-90},{-18,-42},{48,-42}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{36,18},{36,-30}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{26,8},{26,-44}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{34,-32},{38,-28}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{24,-44},{28,-40}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{48,-28},{64,-44}},
          lineColor={0,0,255},
          lineThickness=1,
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Line(
          points={{50,-34},{54,-30},{58,-38},{62,-34},{62,-34}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          thickness=1),
        Line(
          points={{50,-38},{54,-34},{58,-42},{62,-38},{62,-38}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          thickness=1)}),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp: electric power port</p>
<p>poolControlBus</p>
<p>P_el_load[nLoadProfiles]: input for electric power in [W] ( connector for input signals)</p>
<p>P_el_PV[nPVProfiles]: input for electric power in [W] ( connector for input signals)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end PVBatteryHousehold;
