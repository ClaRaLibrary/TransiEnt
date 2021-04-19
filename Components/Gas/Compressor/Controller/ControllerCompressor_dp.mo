within TransiEnt.Components.Gas.Compressor.Controller;
model ControllerCompressor_dp "Controller to control the pressure difference of a compressor"

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

  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Boolean p_paramBefore=true "true if the pressure before the compressor is given by a parameter, false if it is given by an input"
                                                                                                    annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean p_paramAfter=false "true if the pressure after the compressor is given by a parameter, false if it is given by an input"
                                                                                                    annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Pressure p_beforeCompParam=30e5 "Pressure before the compressor" annotation(Dialog(group="Fundamental Definitions",enable=p_paramBefore));
  parameter SI.Pressure p_afterCompParam=50e5 "Pressure after the compressor" annotation(Dialog(group="Fundamental Definitions",enable=p_paramAfter));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.PressureIn p_beforeCompIn if not p_paramBefore "Pressure before the compressor"                                  annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,0})));
  TransiEnt.Basics.Interfaces.General.PressureIn p_afterCompIn if not p_paramAfter "Pressure after the compressor"                                 annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=0,
        origin={100,0})));
  TransiEnt.Basics.Interfaces.General.PressureDifferenceOut Delta_p "Pressure difference of the compressor"                            annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));

protected
  Modelica.Blocks.Sources.Constant p_beforeCompConst(k=p_beforeCompParam) if
                                                             p_paramBefore annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Constant p_afterCompConst(k=p_afterCompParam) if
                                                            p_paramAfter annotation (Placement(transformation(extent={{100,20},{80,40}})));

  TransiEnt.Basics.Interfaces.General.PressureOut p_beforeComp annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TransiEnt.Basics.Interfaces.General.PressureOut p_afterComp annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  Delta_p=p_afterComp-p_beforeComp;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(p_beforeCompIn, p_beforeComp) annotation (Line(points={{-100,0},{-78,0},{-50,0}}, color={0,0,127}));
  connect(p_beforeCompConst.y, p_beforeComp) annotation (Line(points={{-79,30},{-68,30},{-68,0},{-50,0}}, color={0,0,127}));
  connect(p_afterComp, p_afterCompIn) annotation (Line(points={{50,0},{100,0}}, color={0,0,127}));
  connect(p_afterCompConst.y, p_afterComp) annotation (Line(points={{79,30},{68,30},{68,0},{50,0}}, color={0,0,127}));
  connect(p_beforeComp, p_beforeComp) annotation (Line(points={{-50,0},{-52,0},{-50,0}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This controller gives the desired pressure difference to a compressor. The desired or given pressures before and after the compressor can be given by parameters or inputs. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The desired pressure difference is calculated given the parameters and/or inputs and given to the compressor without time delay etc. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>p_beforeCompIn: input for the pressure before the compressor in Pa</p>
<p>p_afterCompIn: input for the pressure after the compressor in Pa</p>
<p>Delta_p: pressure difference over the compressor in Pa</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016</p>
</html>"));
end ControllerCompressor_dp;
