within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl;
model PVBatteryPool "Pool of households with PV Batteries and Poolcontroller"
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
  //                 Parameters
  // _____________________________________________

   parameter Integer nSystems=param.nSystems "Number of systems in pool";
   parameter Integer nLoadProfiles=nSystems "Number of load profiles in input vector";
   parameter Integer nPVProfiles=nSystems "Number of PV production profiles in input vector";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  PVBatteryConsumer.PVBatteryHousehold[param.nSystems] house(
    each nSystems=param.nSystems,
    each nLoadProfiles=nLoadProfiles,
    each nPVProfiles=nPVProfiles,
    iSystem=1:param.nSystems,
    iLoadProfile=1:nPVProfiles,
    iPVProfile=1:nPVProfiles)
      annotation (Placement(transformation(extent={{-29,-16},{24,38}})));

  Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{-106,-7},{-92,8}})));
  Controller.PoolController poolController annotation (Placement(transformation(extent={{79,-15},{99,5}})));

  Base.PoolControlBusSumUp controlBusConsolidator annotation (Placement(transformation(extent={{48,-16},{67,6}})));
  Modelica.Blocks.Interfaces.RealInput P_el_load[nLoadProfiles] "Connector of Real input signals" annotation (Placement(transformation(extent={{-124,58},{-84,98}})));
  Modelica.Blocks.Interfaces.RealInput P_el_PV[nPVProfiles] "Connector of Real input signals" annotation (Placement(transformation(extent={{-124,18},{-84,58}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  for i in 1:nSystems loop
    connect(house[i].epp, epp) annotation (Line(
        points={{-29,0.2},{-50,0.2},{-50,0.5},{-99,0.5}},
        color={0,135,135},
        thickness=0.5));
    connect(controlBusConsolidator.poolControlBus_in[i], house[i].poolControlBus) annotation (Line(
        points={{48,-5},{30,-5},{30,-4.66},{24.53,-4.66}},
        color={255,204,51},
        thickness=0.5));
    connect(house[i].P_el_PV, P_el_PV) annotation (Line(points={{-29.53,21.8},{-52,21.8},{-52,38},{-104,38}}, color={0,0,127}));
    connect(house[i].P_el_load, P_el_load) annotation (Line(points={{-29.53,32.6},{-44,32.6},{-44,78},{-104,78}}, color={0,0,127}));
  end for;

  connect(controlBusConsolidator.poolControlBus_out, poolController.poolControlBus) annotation (Line(
      points={{67,-5},{79,-5}},
      color={255,204,51},
      thickness=0.5));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{-20,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(points={{-60,82},{-66,76},{-66,76}}, color={0,0,127}),
        Line(points={{-58,82},{-64,76},{-64,76}}, color={0,0,127}),
        Line(points={{-64,41},{-70,35},{-70,35}}, color={0,0,127}),
        Line(points={{-62,41},{-68,35},{-68,35}}, color={0,0,127}),
        Line(points={{-66,4},{-72,-2},{-72,-2}}, color={0,127,127}),
        Line(points={{-64,4},{-70,-2},{-70,-2}}, color={0,127,127}),
        Line(points={{38,-2},{32,-8},{32,-8}}, color={249,195,0}),
        Line(points={{40,-2},{34,-8},{34,-8}}, color={249,195,0})}),
                                          Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-94,82},{-22,44}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="x"),
        Text(
          extent={{-42,88},{128,34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%nSystems"),
        Polygon(
          points={{-66,-10},{64,-10},{-2,54},{-66,-10}},
          lineColor={0,134,134},
          smooth=Smooth.None,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,-32},{-8,-54}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,8},{40,-60}},
          lineColor={0,134,134},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,-14},{28,-24}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end PVBatteryPool;
