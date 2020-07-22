within TransiEnt.Producer.Gas.Electrolyzer.Controller;
model MinMaxController "Control minimum and maximum electric power of electrolyzer"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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
  parameter SI.ActivePower P_el_max=3*P_el_n "Maximum power of electrolyzer";
  parameter SI.ActivePower P_el_min=0.02*P_el_n "Minimum power of electrolyzer";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  //SI.ActivePower P_el_set_internal "Internal set value of P_el which has already been limited to 0 or P_el_min";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set  annotation (Placement(transformation(extent={{-130,-20},{-90,20}}), iconTransformation(extent={{-130,-20},{-90,20}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el_ely annotation (Placement(transformation(extent={{98,-10},{118,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  Modelica.Blocks.Logical.Switch switch annotation (Placement(transformation(extent={{-10,2},{10,-18}})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{-48,-42},{-28,-22}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=P_el_set < P_el_min) annotation (Placement(transformation(extent={{-68,-22},
            {-26,-2}})));
public
  Modelica.Blocks.Math.Min min
    annotation (Placement(transformation(extent={{30,-12},{50,8}})));
protected
  Modelica.Blocks.Sources.Constant const1(k=P_el_max)
                                              annotation (Placement(transformation(extent={{-10,12},
            {10,32}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //P_el_set_internal=if P_el_set<P_el_min then 0 else P_el_set;
  //P_el_ely=min(P_el_max,P_el_set_internal);

  connect(const.y,switch. u1) annotation (Line(points={{-27,-32},{-20,-32},{-20,-16},{-12,-16}},
                                                                                           color={0,0,127}));
  connect(booleanExpression1.y, switch.u2) annotation (Line(points={{-23.9,-12},
          {-20,-12},{-20,-8},{-12,-8}},                                                                       color={255,0,255}));
  connect(P_el_set, switch.u3) annotation (Line(points={{-110,0},{-20,0},{-12,0}}, color={0,0,127}));
  connect(switch.y, min.u2)
    annotation (Line(points={{11,-8},{28,-8}}, color={0,0,127}));
  connect(const1.y, min.u1)
    annotation (Line(points={{11,22},{18,22},{18,4},{28,4}}, color={0,0,127}));
  connect(P_el_ely, min.y)
    annotation (Line(points={{108,0},{51,0},{51,-2}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
  Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a controller to limit the electric power of the electrolyzer to its maximum and minimum power. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>P_el_set: set value for the electric power </p>
<p>P_el_ely: limited electric power for the electrolyzer </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in April 2016<br> </p>
</html>"),                                                                     Icon(graphics,
                                                                                    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end MinMaxController;
