within TransiEnt.Producer.Electrical.Wind;
model PowerCurveWindPlant "Wind plant model based on v-P-Power Curve. Can be scaled to model windparks "

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.Windmodel;
  extends TransiEnt.Producer.Electrical.Wind.Base.PartialWindTurbine(P_el_n=
                                                                           8e6);

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Real efficiency=1 "effiency factor for losses due to availability, wires and screening";
  parameter TransiEnt.Producer.Electrical.Wind.Characteristics.GenericPowerCurve PowerCurveChar=Characteristics.VestasV164_8000kW() annotation (Dialog(group="Physical Constraints"), __Dymola_choicesAllMatching=true);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real FLH "Full Load hours";
  SI.ActivePower P_el;

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

    //Power-Curve characteristics

    //Power-Curve
    Modelica.Blocks.Tables.CombiTable1Ds PowerCurve(
    columns={2},
    table=PowerCurveChar.PowerCurve,
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2)
                                                                      annotation (Placement(transformation(extent={{-28,-26},{-8,-6}})));

    Modelica.Blocks.Math.Gain P_mech(k=P_el_n/PowerCurveChar.P_el_n)  annotation (Placement(transformation(extent={{0,-26},{20,-6}})));

    Modelica.Blocks.Logical.Hysteresis isOperating(uLow=PowerCurveChar.cut_backin,
      uHigh=PowerCurveChar.cut_out + 0.001)
    annotation (Placement(transformation(extent={{-34,10},{-2,42}})));

  replaceable TransiEnt.Components.Boundaries.Electrical.Power powerBoundary constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (Dialog(group="Replaceable Components"),choices(choice(redeclare TransiEnt.Components.Boundaries.Electrical.Power powerBoundary "PowerBoundary for ActivePowerPort"),choice( redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "Power Boundary for ComplexPowerPort")), Dialog(group="Physical Constraints"), Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={26,78})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=P_el) annotation (Placement(transformation(extent={{-40,64},{-20,84}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Power output with storm control
  if noEvent(isOperating.y == true) then
    P_el=0;
  elseif noEvent(isOperating.y == false and integer(PowerCurve.y[1])==0 and v_windHub>10) then
    P_el=-efficiency*P_el_n;
    else
   P_el=-efficiency*PowerCurve.y[1]*P_el_n/Modelica.Math.Vectors.norm(PowerCurve.table[:,2],Modelica.Constants.inf);
  end if;

  is_running = isOperating.y;
  eta = eta_total;

  PowerCurve.u=v_windHub;
  isOperating.u=v_windHub;

  FLH=-collectElectricPower.E/P_el_n/3600;
  connect(PowerCurve.y[1], P_mech.u) annotation (Line(points={{-7,-16},{-4.5,-16},{-2,-16}}, color={0,0,127}));
  connect(powerBoundary.epp, epp) annotation (Line(
      points={{36,78},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression.y,powerBoundary. P_el_set) annotation (Line(points={{-19,74},{-10,74},{-10,96},{32,96},{32,90}},
                                                                                                          color={0,0,127}));
  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Electrical power port can be chosen</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<h4><span style=\"color: #008000\">7.1. Simulation of aggregated wind park</span></h4>
<p><br>This model is based on the model WindTurbine_L0. A nominal power for a wind park can be entered such that the output power is scaled up as followed:</p>
<p><br><img src=\"modelica://TransiEnt/Images/equations/equation-zQ5fsIcr.png\" alt=\"P_out=P_Windturbine*(P_nominalWindPark/P_nominalWindturbine)\"/></p>
<p><br>with:</p>
<p><br><img src=\"modelica://TransiEnt/Images/equations/equation-sOWfsyOy.png\" alt=\"P_out\"/>= Output power of wind park</p>
<p><br><img src=\"modelica://TransiEnt/Images/equations/equation-8tRSr2ev.png\" alt=\"P_Windturbine\"/>=Output power of single wind turbine</p>
<p><br><img src=\"modelica://TransiEnt/Images/equations/equation-2vr1pL67.png\" alt=\"P_nominalWindPark\"/>=Nominal Power of wind park</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-c7n8yXpk.png\" alt=\"P_nominalWindturbine\"/>=Nominal Power of wind turbine</p>
<h4><span style=\"color: #008000\">7.2. Calculation of wind velocity for different hub high</span></h4>
<p>Wind velocity in hub height can be calculated from velocity data and height of the measurement [1]:</p>
<p><br><img src=\"modelica://TransiEnt/Images/equations/equation-7l05rubu.png\" alt=\"v_H=v_data * (ln(H/z_o)/ln(H_ref/z_o))

\"/></p>
<p>with:</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-kzWujPzO.png\" alt=\"v_H\"/>=wind velocity at high H (hub height)</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-1NnVsHcN.png\" alt=\"v_data\"/>=wind veleocity at high of data</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-LYEbqqQ2.png\" alt=\"H\"/>=height of hub</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-kaHptFnX.png\" alt=\"H_ref\"/>=reference height of data</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-Rp63ZkgC.png\" alt=\"z_o\"/>=Roughness lenght</p>
<h4><span style=\"color: #008000\">7.3. Roughness length</span></h4>
<p>The roughness length <img src=\"modelica://TransiEnt/Images/equations/equation-zVJxk5zJ.png\" alt=\"z_o\"/> takes into account the different surface roughnesses. Wind velocity over flat surfaces (e.g. water) increases faster with the height than over rough surfaces (e.g. cities).</p>
<p>Different roughness lengths are [1]:</p>
<p><img src=\"modelica://TransiEnt/Images/RoughnessLenght.JPG\"/></p>
<h4><span style=\"color: #008000\">7.4. Calculation of Power via specific power curve</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">The Power (epp.P) ist calculated via a specific power curve. The parameter for this curve are taken from a table in a record. Some characteristic power curves from different manufactures are given. If one wants to use a power curve from another wind turbines the values can be entered oneselfs. Therefore in the parameters section in the subsection PowerCurveChar the different output power values for different wind velocities need to be entered.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>[1] Hau, Erich: Wind Turbines : Fundamentals, Technologies, Application, Economics. Berlin Heidelberg: Springer Science &amp; Business Media, 2013 - ISBN: 978-3-642-27150-2</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
</html>"), Diagram(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})));
end PowerCurveWindPlant;
