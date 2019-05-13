within TransiEnt.Producer.Gas.Electrolyzer.Controller;
model OverloadControllerAdvanced "Control operation of electrolyzer with overload behaviour"

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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.ActivePower P_el_n=1e6 "Nominal power of electrolyzer";
  parameter SI.ActivePower P_el_min=0.02 "Minimum relative power of electrolyzer";
  parameter Real P_rel_1=1.5 "Relative load at which overheating start - e.g.'1.5' means overheating starts at 150% of P_el_n";
  parameter Real P_rel_2=1.75 "Relative load point 2 for definition of overheating characteristic";
  parameter Real P_rel_3=2.25 "Relative load point 3 (maximum possible load) for definition of overheating characteristic";
  parameter Real P_rel_cooldown=1 "Maximum possible relative load if electrolyseur must be cooled down";
  parameter Modelica.SIunits.Time t_1(displayUnit="h")=360000 "Maximum possible duration in overload operation with relative load P_rel_1";
  parameter Modelica.SIunits.Time t_2(displayUnit="h")=10800 "Maximum possible duration in overload operation with relative load P_rel_2";
  parameter Modelica.SIunits.Time t_3(displayUnit="h")=900 "Maximum possible duration in overload operation with relative load P_rel_3";
  parameter Modelica.SIunits.Time t_cooldown(displayUnit="h")=3600 "Time needed for cooling down if electrolyzer was overheated";
  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real overloadLevel;
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set annotation (Placement(transformation(extent={{-130,-20},{-90,20}}), iconTransformation(extent={{-130,-20},{-90,20}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el_ely annotation (Placement(transformation(extent={{98,-10},{118,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.Hysteresis hysteresis_coolingDown(
    uLow=0,
    pre_y_start=false,
    uHigh=t_3) annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Blocks.Sources.RealExpression Input_overload_hysteresis(y=overloadLevel) annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

   if P_el_ely>P_rel_1*P_el_n and P_el_ely<=P_rel_2*P_el_n then
     der(overloadLevel)=(t_3/t_2-t_3/t_1)/(P_rel_2-P_rel_1)*(P_el_ely/P_el_n)+(t_3/t_1-(t_3/t_2-t_3/t_1)/(P_rel_2-P_rel_1)*P_rel_1);
   elseif P_el_ely>P_rel_2*P_el_n then
     der(overloadLevel)=(1-t_3/t_2)/(P_rel_3-P_rel_2)*(P_el_ely/P_el_n)+(t_3/t_2-(1-t_3/t_2)/(P_rel_3-P_rel_2)*P_rel_2);
   elseif P_el_ely<=P_rel_1*P_el_n and overloadLevel>0 and P_el_ely>P_el_n then
     der(overloadLevel)=0;
   elseif P_el_ely<=P_rel_cooldown*P_el_n and overloadLevel>0 then
     der(overloadLevel)=-t_3/t_cooldown;
   else
     der(overloadLevel)=0;
   end if;

   if P_el_set<=P_rel_3*P_el_n and hysteresis_coolingDown.y==false and P_el_set>P_el_min*P_el_n then
     P_el_ely=P_el_set;
   elseif P_el_set>P_rel_3*P_el_n and hysteresis_coolingDown.y==false and P_el_set>P_el_min*P_el_n then
     P_el_ely=P_rel_3*P_el_n;
   elseif P_el_set>P_rel_cooldown and hysteresis_coolingDown.y==true and P_el_set>P_el_min*P_el_n then
     P_el_ely=P_rel_cooldown*P_el_n;
   elseif P_el_set<=P_rel_cooldown and hysteresis_coolingDown.y==true and P_el_set>P_el_min*P_el_n then
     P_el_ely=P_el_set;
   else
     P_el_ely=0;
   end if;

  connect(Input_overload_hysteresis.y, hysteresis_coolingDown.u) annotation (Line(points={{-15,0},{-15,0},{8,0}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Controller for electrolyzer considering overheating of electrolyzer</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model defines the electrical power for an electrolizer (P_el_ely) depending on the electrical set value (P_el_set). Hereby an overload operation is possible. The maximum duration in overload operation can be defined for three different operation points.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Input P_el_set: Defines avaible elektrical power</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Output P_el_ely: Defines electrical power for electrolizer </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">Variables:</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">overloadlevel: meassures the time in overload operation</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">hysteresis_coolingDown.y: if true: electrolyzer must be cooled down; if false: overload operation is possible</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The parameter P_rel_1 defines one relative load point in overload operation. Via the parameter t_1 the maximum time in overload operation at this point can be set. The same applies for the relative load point P_rel_2 and P_rel_3 with the respective times t_2 and t_3 whereby P_rel_3&gt;P_rel_2&gt;P_rel_1 and t_3&lt;t_2&lt;t_1. In between those points the maximum time in overload operation is lineraly interpolated. The blue line in the following image illustrates this characteristic.</span></p>
<p><img src=\"modelica://TransiEnt/Images/OverloadControllerElectrolysis.png\"/></p>
<p>The duration in overload ist meassured via the variable overloadlevel which derivative depends on the defined maximum overload times at the three operation points as illustrated in the image in red. The value of the variable overloadlevel is needed for the definition of the electical power of the electrolizer P_el_ely. As soon as the variable overloadlevel has the value t_1 the maximum overload operation time is reached and the power for the electrolizer must be reduced up to the maximum relativ power P_rel_cooldown. For values P_el_ely/P_el_n&lt;P_rel_cooldown the electrolizers cools down which means the derivative of overloadlevel is negative as long as overloadlevel&gt;0. This is why for P_el_ely/P_el_n&lt;P_rel_cooldown two possible derivates of the variable overloadlevel exist. </p>
<p>Operation in overload after overheating is only possible once the variable overloadlevel reaches the value 0. This means that P_el_ely is equal to P_el_set in as long as P_el_set&lt;P_rel_3*P_el_n and the electrolizer must not be cooled down. If the electrolizer must be cooled down the maximum achievable power is P_el_ely=P_rel_cooldown*P_el_n whereby P_rel_cooldown&lt;P_rel_1.</p>
<p>For relative operation points in between P_rel_cooldown and P_rel_1 the derivate of overloadlevel has the value 0 which means that the elctrolyseur does neither heat up nor cool down.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) on 07.02.2017</span></p>
</html>"));
end OverloadControllerAdvanced;
