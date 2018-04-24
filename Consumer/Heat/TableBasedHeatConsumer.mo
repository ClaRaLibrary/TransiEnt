within TransiEnt.Consumer.Heat;
model TableBasedHeatConsumer "Table based heat consumer without mass flow influence"

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

//Imports
  extends PartialHeatConsumer;

  //Outer components
  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  //Parameters
  parameter SI.Pressure p_drop=simCenter.p_n[2] - simCenter.p_n[1];
  parameter Boolean change_of_sign=false "Change sign of output signal relative to table data" annotation (choices(__Dymola_checkBox=true));
  parameter Real constantfactor=1.0 "Multiply output with constant factor";

  replaceable TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatBoundary(change_sign=true, use_Q_flow_in=true) constrainedby TransiEnt.Components.Boundaries.Heat.Base.PartialHeatBoundary annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={2,0})));

  //variables
  Modelica.SIunits.HeatFlowRate Q_flow_dem;
  Modelica.SIunits.Heat Q_dem;

  //Components
  replaceable TransiEnt.Basics.Tables.GenericDataTable consumerDataTable constrainedby TransiEnt.Basics.Tables.GenericDataTable(final change_of_sign=change_of_sign, final constantfactor=constantfactor) annotation (choicesAllMatching=true, Placement(transformation(extent={{66,-8},{46,12}})));

equation

    connect(heatBoundary.fluidPortIn, fluidPortIn) annotation (Line(
      points={{-7.8,7.4},{-36.9,7.4},{-36.9,20},{-98,20}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(heatBoundary.fluidPortOut, fluidPortOut) annotation (Line(
      points={{-7.8,-8.6},{-35.9,-8.6},{-35.9,-20},{-98,-20}},
      color={175,0,0},
      smooth=Smooth.None));

   Q_flow_dem=-1*consumerDataTable.y1;
   der(Q_dem)=Q_flow_dem;

   //Connect statements
  connect(consumerDataTable.y1, heatBoundary.Q_flow_prescribed) annotation (Line(
      points={{45,2},{28,2},{28,7},{11.2,7}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
        graphics), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end TableBasedHeatConsumer;
