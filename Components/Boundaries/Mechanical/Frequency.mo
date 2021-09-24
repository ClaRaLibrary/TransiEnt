within TransiEnt.Components.Boundaries.Mechanical;
model Frequency "Fixed mechanical frequency boundary"


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

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Boolean useInputConnector = true "Gets parameter from input connector"
  annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(group="Boundary"));
  parameter SI.Frequency f_set_const=1
   annotation(Dialog(group="Boundary", enable = not useInputConnector));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.FrequencyIn f_set if          useInputConnector "Frequency input"     annotation (Placement(transformation(extent={{-140,60},{-100,100}},
          rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,118})));
  TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp annotation (Placement(transformation(extent={{98,-4},{118,16}}), iconTransformation(extent={{82,-16},{118,16}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Units.SI.Frequency f=der(mpp.phi)/2/Modelica.Constants.pi;
  Modelica.Units.SI.Power P_el_set_const=der(mpp.phi)*mpp.tau;

protected
  TransiEnt.Basics.Interfaces.General.FrequencyIn f_internal "Needed to connect to conditional connector for active power";

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

    if not useInputConnector then
    f_internal = f_set_const;

  end if;

  der(mpp.phi) = 2 * Modelica.Constants.pi * f_internal;

  connect(f_internal, f_set);
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Line(points={{2,30},{2,-8}},    color={0,0,0}),
        Line(points={{-56,8},{-40,24},{-18,36},{2,38},{20,36},{36,30},{46,20},{56,
              10},{62,-2}},                color={0,0,0}),
        Polygon(
          points={{-63,-6},{-44,12},{-56,20},{-63,-6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          visible=not useSupport,
          points={{-48,-28},{-28,-8}},
          color={0,0,0}),
        Line(
          visible=not useSupport,
          points={{-28,-28},{-8,-8}},
          color={0,0,0}),
        Line(
          visible=not useSupport,
          points={{-8,-28},{12,-8}},
          color={0,0,0}),
        Line(
          visible=not useSupport,
          points={{12,-28},{32,-8}},
          color={0,0,0}),
        Line(
          visible=not useSupport,
          points={{-28,-8},{32,-8}},
          color={0,0,0})}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Time-dependent angular frequency boundary condition with mechanical interface containing torque and angle.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>RealInput: frequency in [Hz]</p>
<p>Mechanical power port</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">f is the frequency</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_set_const is the constant electric power</span></p>
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
end Frequency;
