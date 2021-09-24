within TransiEnt.Storage.Base;
model GenericStorage "Highly adaptable but non-physical model for all kinds of energy storages (recommended for storage without losses)"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  extends GenericStorage_base;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.GreaterEqualThreshold isStorageFull(threshold=params.E_max) annotation (Placement(transformation(extent={{-32,-14},{-19,0}})));

  Modelica.Blocks.Logical.LessEqualThreshold isStorageEmpty(threshold=params.E_min)
                                                                               annotation (Placement(transformation(extent={{-33,-35},{-20,-22}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(E_is.y, isStorageFull.u) annotation (Line(points={{-46,-20},{-42,-20},{-42,-7},{-33.3,-7}}, color={0,0,127}));
  connect(isStorageFull.y, FullAndCharging.u2) annotation (Line(points={{-18.35,-7},{-12.175,-7},{-12.175,-6.6},{-8.3,-6.6}}, color={255,0,255}));
  connect(E_is.y, isStorageEmpty.u) annotation (Line(points={{-46,-20},{-40,-20},{-40,-28.5},{-34.3,-28.5}}, color={0,0,127}));
  connect(EmptyAndDischarging.u2, isStorageEmpty.y) annotation (Line(points={{-9.3,-28.6},{-14,-28.6},{-14,-28.5},{-19.35,-28.5}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                   Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Highly adaptable but non-physical model for all kinds of energy storages.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_set: input for electric power in [W] -Grid side setpoint power (Positive = load request, negative = unload request) [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_is: output for electric power in [W]- Grid side power (Positive = loading, negative = unloading) [W]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Boolean parameter use_PowerRateLimiter can deactive block &apos;PowerRateLimiter&apos;. This might lead to faster calculation results if power rate limitation is not needed.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">PlantDynamics: Set T_plant to 0 in StorageParameters to deactivate first order block</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Storage.Base.Check.TestGenericStorage&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model adapted by Lisa Andresen (andresen@tuhh.de), Jan 2017</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model adapted by Oliver Schülting (oliver.schuelting@tuhh.de), Jun 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Extended from base class by Carsten Bode (c.bode@tuhh.de), Nov 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model adapted by Oliver Schülting (oliver.schuelting@tuhh.de), April 2018: added first order plant dynamics block which can be deactivated</span></p>
</html>"));
end GenericStorage;
