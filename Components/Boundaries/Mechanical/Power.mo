within TransiEnt.Components.Boundaries.Mechanical;
model Power "Fixed mechanical power boundary"



//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

 parameter Boolean change_sign = false annotation(choices(__Dymola_checkBox=true));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Basics.Interfaces.General.MechanicalPowerPort mpp annotation (Placement(transformation(extent={{98,-4},{118,16}}), iconTransformation(extent={{82,-16},{118,16}})));

  Modelica.Blocks.Interfaces.RealInput P_mech_set(  final quantity= "Power", final unit="W", displayUnit="W")    annotation (Placement(transformation(extent={{-140,60},{-100,100}},
          rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,118})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Power P_mech_is = -P_mech_set "Mechanical power";
  SI.Torque tau_is(  start=0) = mpp.tau;
  SI.Angle phi_is(start=0, fixed=true)=mpp.phi;

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  mpp.tau * der(mpp.phi) = if change_sign then -P_mech_set else P_mech_set;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Line(points={{4,32},{4,-6}},    color={0,0,0}),
        Line(points={{-54,12},{-38,26},{-16,38},{4,40},{22,38},{38,32},{48,22},
              {58,12},{64,0}},             color={0,0,0}),
        Polygon(
          points={{-61,-4},{-42,14},{-54,22},{-61,-4}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          visible=not useSupport,
          points={{-46,-26},{-26,-6}},
          color={0,0,0}),
        Line(
          visible=not useSupport,
          points={{-26,-26},{-6,-6}},
          color={0,0,0}),
        Line(
          visible=not useSupport,
          points={{-6,-26},{14,-6}},
          color={0,0,0}),
        Line(
          visible=not useSupport,
          points={{14,-26},{34,-6}},
          color={0,0,0}),
        Line(
          visible=not useSupport,
          points={{-26,-6},{34,-6}},
          color={0,0,0})}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Prescribed time-dependent power boundary condition with mechanical interface containing torque and angle.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>RealInput: mechanic power in [W]</p>
<p>Mechanical power port</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>P_mech_is is the mechanical power</p>
<p>tau_is is the torque</p>
<p>phi_is is an angle</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end Power;
