within TransiEnt.Consumer.Electrical;
model SimpleExponentialElectricConsumerComplex "Exponential voltage dependency, based on ComplexPowerPort"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.ElectricalConsumer;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set if              useInputConnectorP "active power input at nominal frequency" annotation (Placement(transformation(extent={{-140,60},{-100,100}}, rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,116})));
protected
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_internal "Needed to connect to conditional connector for active power";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

public
  outer TransiEnt.SimCenter simCenter;

  //outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter SI.Voltage v_n=simCenter.v_n "Nominal voltage";
  parameter Boolean useInputConnectorP = false "Gets parameter from input connector"
    annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  parameter SI.Power P_el_set_const=0 "Used, if not useInputConnectorP" annotation(Dialog(enable = not useInputConnectorP));
  parameter Boolean useCosPhi=true
    annotation (choices(__Dymola_checkBox=true));
  parameter SI.ReactivePower Q_el_set=0
    annotation (Dialog(enable = not useCosPhi));
  parameter SI.PowerFactor cosphi_set=1
    annotation (Dialog(enable = useCosPhi));
  parameter Real alpha=0 "expontent for active power in load model";
  parameter Real beta=0 "exponent for reactive power in load model";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //                 Variables
  // _____________________________________________

  SI.Voltage v_load(start=v_n) annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Angle delta_load(start=-0.08726646259971647);
  SI.ActivePower P(start=0);
  SI.ReactivePower Q(start=0);

equation

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //use of input connector or fixed parameter value
  if not useInputConnectorP then
    P_internal = P_el_set_const;
  end if;

  //conection between epp and local variables
  epp.v=v_load;
  epp.delta=delta_load;
  epp.P=P;
  epp.Q=Q;

  //equations for local variables
  P=P_internal*(v_load/v_n)^alpha;
  Q=if not useCosPhi then Q_el_set*(v_load/v_n)^beta else P/cosphi_set*sin(acos(cosphi_set));

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(P_internal, P_el_set);

  annotation (defaultComponentName="load", Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                       graphics={
    Line(points={{-44,-30},{38,-30}},
                                  color={192,192,192}),
    Polygon(
      points={{60,-30},{38,-38},{38,-22},{60,-30}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{-2,54},{-10,32},{6,32},{-2,54}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-2,-44},{-2,32}},
                                  color={192,192,192}),
        Line(
          points={{48,36},{46,28},{42,20},{38,12},{30,0},{22,-8},{16,-14},{8,-22},{0,-26},{-4,-28},{-14,-30},{
              -26,-30},{-46,-30}},
          color={0,134,134},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Exponential voltage dependency for usage in other models, e.g. electric boiler</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L1E - Models are based on characteristic lines, gains or efficiencies</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>epp: complex power port</p>
<p>P_el_set: input for electric power in [W] (active power at nominal frequency)</p><p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2019, added to TransiEnt Library in December 2019</span></p>
</html>"));
end SimpleExponentialElectricConsumerComplex;
