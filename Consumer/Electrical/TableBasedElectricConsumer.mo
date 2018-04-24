within TransiEnt.Consumer.Electrical;
model TableBasedElectricConsumer "Demand based on table data"
  import TransiEnt;

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

  extends TransiEnt.Consumer.Electrical.Base.PartialElectricConsumer_L1(collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer));

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Boolean change_of_sign=false "Change sign of output signal relative to table data"
                                                         annotation (choices(__Dymola_checkBox=true));
  parameter Real constantfactor=1.0 "Multiply output with constant factor";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable TransiEnt.Basics.Tables.GenericDataTable consumerDataTable constrainedby TransiEnt.Basics.Tables.GenericDataTable(
    final change_of_sign=change_of_sign,
    constantfactor=constantfactor,
    sign_changer(each k=if change_of_sign then -1*constantfactor else constantfactor)) annotation (choicesAllMatching=true, Placement(transformation(extent={{24,-64},{44,-44}})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(consumerDataTable.y1, partialElectricBoundary.P_el_set)
    annotation (Line(
      points={{45,-54},{60,-54},{60,-68},{61,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Demand&nbsp;based&nbsp;on&nbsp;table&nbsp;data.</p>
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
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-52,60},{-2,-60}},
          lineColor={255,255,255},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Line(points={{-52,-60},{-52,60},{48,60},{48,-60},{-52,-60},{-52,-30},{48,-30},{48,0},{-52,0},{-52,30},{48,30},{48,60},{-2,60},{-2,-61}},
            color={0,0,0})}));
end TableBasedElectricConsumer;
