within TransiEnt.Components.Heat.Grid;
model IdealizedExpansionVessel "Expansion vessel with constant pressure and variable temperature"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  import TransiEnt;
  extends TransiEnt.Basics.Icons.ExpansionVessel;

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid  Medium = simCenter.fluid1 "Medium model" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  constant Modelica.SIunits.Temperature T_const=323.15 "Temperature of medium";
  parameter Modelica.SIunits.Pressure p=simCenter.p_n[1] "Pressure to hold";

  // _____________________________________________
  //
  //           Variable Declearation
  // _____________________________________________
 Modelica.SIunits.Temperature T_Fluid "Temperature";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPort(Medium=Medium) annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
   TILMedia.VLEFluid_ph vleFluid(p=waterPort.p, h=inStream(waterPort.h_outflow),xi=inStream(waterPort.xi_outflow),
    vleFluidType=Medium);

  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi sink(variable_T=true, redeclare ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryConditions(p_const=p)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,0})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  T_Fluid = vleFluid.T;
  sink.T=T_Fluid;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(sink.fluidPortIn,waterPort)  annotation (Line(
      points={{-1.83187e-15,-10},{-1.83187e-15,-50.9},{0,-50.9},{0,-100}},
      color={175,0,0},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics),
        Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Ideal model to hold a constant pressure in a hydraulic system. Volume of expansion vessel is considered infinite.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Purely technical component without physical modeling. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPort - port for the medium </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Tobias Ramm (tobias.ramm@tuhh.de), Jun 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Lisa Andresen (andresen@tuhh.de), Dec 2015</span></p>
</html>"));
end IdealizedExpansionVessel;
