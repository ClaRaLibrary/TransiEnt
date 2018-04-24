within TransiEnt.Consumer.DemandSideManagement.HeatpumpSystems;
model simulateUnit "Simulation of one heat pump system unit, parameterized by a vector of 24 parameters and replaceable system configurations"
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
  extends TransiEnt.Basics.Icons.Example;

  replaceable Base.BivalentHeatpumpSystem HeatPumpSystem(redeclare Base.HeatPumpSystemPropertiesMatrix params(A={8500.00,4336.56,0.50,0.80,3.80,0.98,19.50,63.14,25.50,20.00,63.00,26.00,-5.00,1.00,33.00,19.00,20.00,180.00,180.00,13292620.28,114.12,3.00,2.00,3.00})) annotation (Placement(transformation(extent={{-16,-10},{22,16}})), choicesAllMatching=true);
   inner TransiEnt.SimCenter simCenter(redeclare Components.Boundaries.Ambient.AmbientConditions ambientConditions(redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperature))
                                       annotation (Placement(transformation(extent={{-90,100},{-70,80}})));
   inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-50,100},{-70,80}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-152,-103},{148,-143}},
          lineColor={0,134,134},
          textString="%name")}),                                 Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Interval=900,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(events=false));
end simulateUnit;
