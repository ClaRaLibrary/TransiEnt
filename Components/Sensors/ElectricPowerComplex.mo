within TransiEnt.Components.Sensors;
model ElectricPowerComplex "Measure Frequency on ComplexPowerPort"

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

  extends TransiEnt.Basics.Icons.Sensor;

  outer ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter Boolean change_of_sign = false;
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_IN annotation (Placement(transformation(extent={{-102,-10},{-82,10}}), iconTransformation(extent={{-102,-10},{-82,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_OUT annotation (Placement(transformation(extent={{82,-10},{102,10}}), iconTransformation(extent={{84,-10},{104,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P(start=0) "Active Power"
                                                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={34,74}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,86})));
  TransiEnt.Basics.Interfaces.Electrical.ReactivePowerOut Q(start=0) "Reactive Power"
                                                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-58,74}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-82,86})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  epp_IN.f = epp_OUT.f;
  epp_IN.v = epp_OUT.v;
  epp_IN.delta = epp_OUT.delta;
  epp_IN.P + epp_OUT.P = 0;
  epp_IN.Q + epp_OUT.Q = 0;
  Connections.branch(epp_IN.f,epp_OUT.f);

  P = if change_of_sign then -1*epp_OUT.P else epp_OUT.P;
  Q = if change_of_sign then -1*epp_OUT.Q else epp_OUT.Q;

  annotation (defaultConnectionStructurallyInconsistent=true,Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics={Text(
            extent={{-94,74},{-66,52}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="P"),             Text(
            extent={{-64,74},{-36,52}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          textString="Q")}),   Diagram(graphics,
                                       coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Measure active power flow on electric line using ComplexPowerPort</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in June 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model based on model by Pascal Dubucq (dubucq@tuhh.de) from October 2014</span></p>
</html>"));
end ElectricPowerComplex;
