within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Base;
model PoolControlBusSumUp "Sums up the state information of N units control busses to one single control bus which can then be connected to a controller"
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
  //             Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer PoolParameter param;

  PoolControlBus[param.nSystems] poolControlBus_in annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  PoolControlBus poolControlBus_out annotation (Placement(transformation(extent={{80,-20},{120,20}})));

//  Modelica.Blocks.Math.Sum P_el_set(nin=param.nSystems) annotation (Placement(transformation(extent={{-14,66},{6,86}})));
  Modelica.Blocks.Math.Sum P_potential_pbp[param.nSystems](each final nin=param.nSystems) annotation (Placement(transformation(extent={{-14,34},{6,54}})));
//  Modelica.Blocks.Math.Sum SOC(nin=param.nSystems) annotation (Placement(transformation(extent={{-14,6},{6,26}})));
//  Modelica.Blocks.Math.Sum P_max_unload_star(nin=param.nSystems) annotation (Placement(transformation(extent={{-14,-54},{6,-34}})));
//  Modelica.Blocks.Math.Sum P_max_load_star(nin=param.nSystems) annotation (Placement(transformation(extent={{-14,-24},{6,-4}})));

  Basics.Blocks.RealToVector P_el_set_pbp[param.nSystems](each final nout=param.nSystems, final index=1:param.nSystems) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-4,-20})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  for i in 1:param.nSystems loop
    connect(poolControlBus_in[i].P_potential_pbp, P_potential_pbp[i].u) annotation (Line(
      points={{-99.9,0.1},{-88,0.1},{-68,0.1},{-68,44},{-16,44}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
    connect(poolControlBus_out.P_potential_pbp[i], P_potential_pbp[i].y) annotation (Line(
      points={{100.1,0.1},{100.1,0.1},{62,0.1},{62,44},{7,44}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
    connect(P_el_set_pbp[i].u, poolControlBus_out.P_el_set_pbp[i])  annotation (Line(
     points={{8,-20},{62,-20},{62,0.1},{100.1,0.1}},
     color={255,204,51},
     thickness=0.5), Text(
     string="%first",
     index=-1,
     extent={{-6,3},{-6,3}}));

    connect(P_el_set_pbp[i].y, poolControlBus_in[i].P_el_set_pbp) annotation (Line(
     points={{-15,-20},{-68,-20},{-68,0.1},{-99.9,0.1}},
     color={255,204,51},
     thickness=0.5), Text(
     string="%first",
     index=-1,
     extent={{-6,3},{-6,3}}));

  end for;

    annotation (
              Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                              Line(
          points={{12,36},{-48,36},{-8,-4},{-48,-44},{12,-44}}),
                              Line(
          points={{48,54},{-12,54},{28,14},{-12,-26},{48,-26}}, color={175,175,175})}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This block allows to sum up the state information (primary balancing power offer) of N units (consumers with battery systems) in order to control these units by one global pool controller.</p>
<p>The units each have one pool control bus which contains a vector (for each state variable) with as many components as units presesnt in the pool. They add their state variable to the position of their index in the pool and set all other components of the bus to zero.</p>
<p>This sum up block then adds all components such that the resulting bus contains the state of each unit in each component of the resulting vector.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Technical component without physical effects.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The unit is supposed to add zeros to all components in each vector apart from its own index </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>N PoolControlBus as input (connect to N units, e.g. controllable consumers)</p>
<p>1 PoolControlBus as output (connect to pool controller)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>No equations present</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>No equations present</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>See Purpose of model</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No phyical validation required. For technical validation see: Check.CheckPoolControlBusSumUp</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>None</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model revised, tester and documentation added by Pascal Dubucq (dubucq@tuhh.de) on 24.03.2017</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Arne Doerschlag on 01.09.2014</span></p>
</html>"));
end PoolControlBusSumUp;
