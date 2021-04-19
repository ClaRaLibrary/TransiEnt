within TransiEnt.Basics.Blocks;
block DeadZoneLinear "Provide a region of zero output"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Modelica.Blocks.Interfaces.SISO;
  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

  parameter Integer typeTransition=1 "Type of transition from dead zone to rest" annotation(choices(choice=1 "Step", choice=2 "3rd order polynomial"));
  parameter Boolean use_noEvent=true "true if noEvent() should be used";
  parameter Real uMaxSmooth(start=2) "Upper limit of smooth zone" annotation(Dialog(enable=typeTransition==2));
  parameter Real uMax(start=1) "Upper limit of dead zone";
  parameter Real uMin=-uMax "Lower limit of dead zone";
  parameter Real uMinSmooth=-uMaxSmooth "Lower limit of smooth zone" annotation(Dialog(enable=typeTransition==2));
  parameter Boolean deadZoneAtInit = true "= false, if dead zone is ignored during initializiation (i.e., y=u)";

  // _____________________________________________
  //
  //            Characteristic equations
  // _____________________________________________

equation

  assert(uMax >= uMin, "DeadZone: Limits must be consistent. However, uMax (=" + String(uMax) +
                       ") < uMin (=" + String(uMin) + ")");

  if initial() and not deadZoneAtInit then
     y = u;
  elseif typeTransition==1 and use_noEvent then
     y = noEvent(smooth(1,if u > uMax then u else if u < uMin then u else 0));
  elseif typeTransition==2 and use_noEvent then
     y = noEvent(smooth(1,
       if u > uMaxSmooth or u < uMinSmooth then u
       elseif u < uMax and u > uMin then 0
       elseif u < uMaxSmooth and u > uMax then ((uMax + uMaxSmooth)/((uMax - uMaxSmooth)*(uMax^2 - 2*uMax*uMaxSmooth + uMaxSmooth^2)))*u^3 + (-(2*(uMax^2 + uMax*uMaxSmooth + uMaxSmooth^2))/((uMax - uMaxSmooth)*(uMax^2 - 2*uMax*uMaxSmooth + uMaxSmooth^2)))*u^2 + ((uMax*(uMax^2 + uMax*uMaxSmooth + 4*uMaxSmooth^2))/((uMax - uMaxSmooth)*(uMax^2 - 2*uMax*uMaxSmooth + uMaxSmooth^2)))*u + (-(2*uMax^2*uMaxSmooth^2)/((uMax - uMaxSmooth)*(uMax^2 - 2*uMax*uMaxSmooth + uMaxSmooth^2)))
       else ((uMin + uMinSmooth)/((uMin - uMinSmooth)*(uMin^2 - 2*uMin*uMinSmooth + uMinSmooth^2)))*u^3 + (-(2*(uMin^2 + uMin*uMinSmooth + uMinSmooth^2))/((uMin - uMinSmooth)*(uMin^2 - 2*uMin*uMinSmooth + uMinSmooth^2)))*u^2 + ((uMin*(uMin^2 + uMin*uMinSmooth + 4*uMinSmooth^2))/((uMin - uMinSmooth)*(uMin^2 - 2*uMin*uMinSmooth + uMinSmooth^2)))*u + (-(2*uMin^2*uMinSmooth^2)/((uMin - uMinSmooth)*(uMin^2 - 2*uMin*uMinSmooth + uMinSmooth^2)))));
  elseif typeTransition==1 and not use_noEvent then
     y = smooth(1,if u > uMax then u else if u < uMin then u else 0);
  else
     y = smooth(1,
       if u > uMaxSmooth or u < uMinSmooth then u
       elseif u < uMax and u > uMin then 0
       elseif u < uMaxSmooth and u > uMax then ((uMax + uMaxSmooth)/((uMax - uMaxSmooth)*(uMax^2 - 2*uMax*uMaxSmooth + uMaxSmooth^2)))*u^3 + (-(2*(uMax^2 + uMax*uMaxSmooth + uMaxSmooth^2))/((uMax - uMaxSmooth)*(uMax^2 - 2*uMax*uMaxSmooth + uMaxSmooth^2)))*u^2 + ((uMax*(uMax^2 + uMax*uMaxSmooth + 4*uMaxSmooth^2))/((uMax - uMaxSmooth)*(uMax^2 - 2*uMax*uMaxSmooth + uMaxSmooth^2)))*u + (-(2*uMax^2*uMaxSmooth^2)/((uMax - uMaxSmooth)*(uMax^2 - 2*uMax*uMaxSmooth + uMaxSmooth^2)))
       else ((uMin + uMinSmooth)/((uMin - uMinSmooth)*(uMin^2 - 2*uMin*uMinSmooth + uMinSmooth^2)))*u^3 + (-(2*(uMin^2 + uMin*uMinSmooth + uMinSmooth^2))/((uMin - uMinSmooth)*(uMin^2 - 2*uMin*uMinSmooth + uMinSmooth^2)))*u^2 + ((uMin*(uMin^2 + uMin*uMinSmooth + 4*uMinSmooth^2))/((uMin - uMinSmooth)*(uMin^2 - 2*uMin*uMinSmooth + uMinSmooth^2)))*u + (-(2*uMin^2*uMinSmooth^2)/((uMin - uMinSmooth)*(uMin^2 - 2*uMin*uMinSmooth + uMinSmooth^2))));
  end if;

  // _____________________________________________
  //
  //            Connect Statements
  // _____________________________________________

  annotation (
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The DeadZone block defines a region of zero output. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">If the input is within uMin ... uMax, the output is zero. Outside of this zone, the output is a linear function of the input with a slope of 1. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For smooth transition (typeTransition=2), a third order polynomial is used between uMinSmooth and uMin and uMax and uMaxSmooth, respectively. Events can be avoided by switching use_noEvent to true (might lead to chattering).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in checkmodel &quot;TestDeadZoneLinear&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de), Aug 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Carsten Bode (c.bode@tuhh.de), Mar 2019 (added smooth transition and noEvent)</span></p>
</html>"),
    Icon(coordinateSystem(
    preserveAspectRatio=false,
    extent={{-100,-100},{100,100}},
    grid={1,1}), graphics={
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Polygon(
      points={{90,0},{68,-8},{68,8},{90,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-13,-12},{-13,0},{12,0},{12,13}}, color={0,0,0}),
        Line(
          points={{12,13},{55,63}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-56,-62},{-13,-12}},
          color={0,0,0},
          smooth=Smooth.None)}),
    Diagram(coordinateSystem(
    preserveAspectRatio=false,
    extent={{-100,-100},{100,100}},
    grid={1,1}), graphics={
    Line(points={{0,-60},{0,50}}, color={192,192,192}),
    Polygon(
      points={{0,60},{-5,50},{5,50},{0,60}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-76,0},{74,0}}, color={192,192,192}),
    Polygon(
      points={{84,0},{74,-5},{74,5},{84,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{62,-7},{88,-25}},
      lineColor={128,128,128},
      textString="u"),
    Text(
      extent={{-36,72},{-5,50}},
      lineColor={128,128,128},
      textString="y"),
    Text(
      extent={{-51,1},{-28,19}},
      lineColor={128,128,128},
      textString="uMin"),
    Text(
      extent={{27,21},{52,5}},
      lineColor={128,128,128},
      textString="uMax")}));
end DeadZoneLinear;
