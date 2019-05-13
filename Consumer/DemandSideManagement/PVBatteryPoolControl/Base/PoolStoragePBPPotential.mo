within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Base;
model PoolStoragePBPPotential
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

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer PoolParameter param;
  parameter Integer index "Index of unit within pool";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_potential_PBP "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    // , index(start=index, fixed=true)
  Modelica.Blocks.Routing.Extractor get_P_max_unload_star(nin=param.nSystems, index(start=index, fixed=true)) annotation (Placement(transformation(extent={{-62,-40},{-42,-20}})));
  Modelica.Blocks.Routing.Extractor get_P_max_load_star(nin=param.nSystems, index(start=index, fixed=true)) annotation (Placement(transformation(extent={{-62,-68},{-42,-88}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_is "Input signal connector"
    annotation (Placement(transformation(extent={{-124,12},{-84,52}}), iconTransformation(extent={{-110,26},{-84,52}})));
  Modelica.Blocks.Nonlinear.Limiter P_is_lim(uMax=param.P_el_max_bat) annotation (Placement(transformation(extent={{-62,22},{-42,42}})));
  Modelica.Blocks.Math.Min min
    annotation (Placement(transformation(extent={{-26,-64},{-6,-44}})));
  Modelica.Blocks.Math.Abs P_is_abs "Absolute value" annotation (Placement(transformation(extent={{-22,22},{-2,42}})));
  Modelica.Blocks.Discrete.ZeroOrderHold delta_t_PBP(samplePeriod=param.t_pbp_interval) "communication intervall" annotation (Placement(transformation(extent={{76,-10},{96,10}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{16,-16},{36,4}})));
  Modelica.Blocks.Math.Max max
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Modelica.Blocks.Sources.Constant zero(k=0) annotation (Placement(transformation(extent={{18,18},{38,38}})));
  Modelica.Blocks.Sources.IntegerConstant thisIndex(k=index)
    annotation (Placement(transformation(extent={{-80,-60},{-68,-48}})));

  Modelica.Blocks.Math.Gain gain(k=param.P_el_max_bat) annotation (Placement(transformation(extent={{4,-61},{18,-47}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_max_unload_star[param.nSystems] "Maximum unloading power in p.u" annotation (Placement(transformation(extent={{-126,-50},{-86,-10}}), iconTransformation(extent={{-110,-82},{-84,-56}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn  P_max_load_star[param.nSystems] "Maximum loading power in p.u" annotation (Placement(transformation(extent={{-124,-96},{-84,-56}}), iconTransformation(extent={{-112,-36},{-86,-10}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(P_is, P_is_lim.u) annotation (Line(
      points={{-104,32},{-64,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(get_P_max_unload_star.y, min.u1) annotation (Line(
      points={{-41,-30},{-34,-30},{-34,-48},{-28,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(get_P_max_load_star.y, min.u2) annotation (Line(
      points={{-41,-78},{-34,-78},{-34,-60},{-28,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_is_lim.y, P_is_abs.u) annotation (Line(
      points={{-41,32},{-24,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_potential_PBP, delta_t_PBP.y) annotation (Line(
      points={{110,0},{97,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_is_abs.y, add.u1) annotation (Line(
      points={{-1,32},{6,32},{6,0},{14,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, max.u2) annotation (Line(
      points={{37,-6},{44,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(delta_t_PBP.u, max.y) annotation (Line(
      points={{74,0},{67,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(max.u1, zero.y) annotation (Line(
      points={{44,6},{40,6},{40,28},{39,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thisIndex.y, get_P_max_load_star.index) annotation (Line(points={{-67.4,-54},{-52,-54},{-52,-66}}, color={255,127,0}));
  connect(thisIndex.y, get_P_max_unload_star.index) annotation (Line(points={{-67.4,-54},{-67.4,-54},{-52,-54},{-52,-42}}, color={255,127,0}));
  connect(min.y, gain.u) annotation (Line(points={{-5,-54},{0,-54},{2.6,-54}},        color={0,0,127}));
  connect(gain.y, add.u2) annotation (Line(points={{18.7,-54},{42,-54},{42,-28},{6,-28},{6,-12},{14,-12}},
                                                                                        color={0,0,127}));
  connect(get_P_max_load_star.u, P_max_load_star) annotation (Line(points={{-64,-78},{-76,-78},{-76,-76},{-104,-76}}, color={0,0,127}));
  connect(get_P_max_unload_star.u, P_max_unload_star) annotation (Line(points={{-64,-30},{-106,-30},{-106,-30}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                               Icon(graphics,
                                                    coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_potential_PBP: output for electric power in [W]</p>
<p>P_is: input for electric power in [W]</p>
<p>P_max_unload_star[param.nSystems]: input for electric power in [W]</p>
<p>P_max_load_star[param.nSystems]: input for electric power in [W]</p>
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
end PoolStoragePBPPotential;
