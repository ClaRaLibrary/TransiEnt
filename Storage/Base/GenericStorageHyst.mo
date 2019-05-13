within TransiEnt.Storage.Base;
model GenericStorageHyst "Highly adaptable but non-physical model for all kinds of energy storages with hysteresis if storage is full (recommended for storage with losses)"

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

  extends GenericStorage_base;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Real relDeltaEnergyHystFull=0.001 "Relative energy change for the hysteresis to determine if storage is full";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.Hysteresis isStorageFull(
    uHigh=params.E_max,
    uLow=params.E_max - relDeltaEnergyHystFull*(params.E_max - params.E_min))
                                                                          annotation (Placement(transformation(extent={{-32,-14},{-19,0}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(E_is.y, isStorageFull.u) annotation (Line(points={{-46,-18},{-42,-18},{-42,-7},{-33.3,-7}}, color={0,0,127}));
  connect(isStorageFull.y, FullAndCharging.u2) annotation (Line(points={{-18.35,-7},{-13.175,-7},{-13.175,-6.6},{-6.3,-6.6}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                   Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Highly&nbsp;adaptable&nbsp;but&nbsp;non-physical&nbsp;model&nbsp;for&nbsp;all&nbsp;kinds&nbsp;of&nbsp;energy&nbsp;storages. Has a hysteresis for when the storage is full. Recommended for storage models with losses.</p>
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
<p>Model extended from base class by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
<p>Model adapted by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), April 2018: added first order plant dynamics block which can be deactivated</p>
</html>"));
end GenericStorageHyst;
