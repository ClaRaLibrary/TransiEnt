within TransiEnt.Components.Boundaries.Electrical.ApparentPower;
model PowerVoltage "Sets power and voltage for ApparentPowerPort"

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


  extends TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary(redeclare TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp);
  extends TransiEnt.Basics.Icons.ElectricSource;

   // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Boolean Use_input_connector_P = true "Gets parameter from input connector"
   annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(group="Boundary"));

  parameter SI.ActivePower P_boundary=20e3 annotation (Dialog(group="Boundary", enable =  not Use_input_connector_P));

 parameter Boolean Use_input_connector_v = true "Gets parameter from input connector"
   annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(group="Boundary"));

   parameter SI.Voltage v_boundary=110e3 annotation (Dialog(group="Boundary", enable = not Use_input_connector_v));


  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set if              Use_input_connector_P "Active Power input" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-54,120})));

  TransiEnt.Basics.Interfaces.Electrical.VoltageIn v_set if                  Use_input_connector_v "Voltage input"
                              annotation (Placement(transformation(extent={{-20,-20},
            {20,20}},
          rotation=270,
        origin={60,120}),
                       iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,120})));


    // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

   //  Modelica.SIunits.ActivePower Q = epp.Q;
   //  Modelica.SIunits.ApparentPower S;

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________
protected
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_internal "Needed to connect to conditional connector for frequency";
  TransiEnt.Basics.Interfaces.Electrical.VoltageIn v_internal "Needed to connect to conditional connector for voltage";

 // Modelica.Blocks.Interfaces.RealInput f_set
 //   "active power input"                                         annotation (Placement(transformation(extent={{-140,60},{-100,100}},
 //         rotation=0), iconTransformation(
 //       extent={{20,-20},{-20,20}},
 //       rotation=270,
 //       origin={-52,-120})));
 // Modelica.Blocks.Interfaces.RealInput v_set
 //   "reactive power input"                                       annotation (Placement(transformation(extent={{-140,22},
 //           {-100,62}},
 //         rotation=0), iconTransformation(
 //       extent={{20,-20},{-20,20}},
 //       rotation=270,
 //       origin={68,-120})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

    if not Use_input_connector_P then
    P_internal = P_boundary;
  end if;

  if not Use_input_connector_v then
    v_internal = v_boundary;

  end if;
  epp.P = -P_internal;
  epp.v = v_internal;
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_internal, P_el_set);
  connect(v_internal, v_set);

  annotation (defaultComponentName="PU_Boundary", Diagram(graphics,
                                                          coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Time-dependent power and voltage boundary condition </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp (ApparentPowerPort)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: electric Power in W</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: voltage in V</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>v_set is a voltage </p>
<p>P_el_set is an active power</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Based on model by Pascal Dubucq (dubucq@tuhh.de) from October 2014</span></p>
</html>"));
end PowerVoltage;
