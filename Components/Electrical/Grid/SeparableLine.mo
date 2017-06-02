within TransiEnt.Components.Electrical.Grid;
model SeparableLine "Transmission line with constant loss of active power from connection epp_1 to epp_2 and option to separate two grids"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Base.PartialLine;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Real loss_in_percent=0;

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________
  SI.ActivePower P_abs_loss = epp_1.P + epp_2.P;
  SI.Frequency f_grid(stateSelect=StateSelect.default) = epp_1.f;
  SI.Frequency delta_f_grid(displayUnit="mHz") = (f_grid - simCenter.f_n);
   outer TransiEnt.SimCenter simCenter;
  Modelica.Blocks.Interfaces.BooleanInput isConnected annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

 if isConnected then
 epp_1.f = epp_2.f;
 epp_1.P + epp_2.P * (1+loss_in_percent/100) = 0;     // loss is always from generation side to consumer side:
 else
 epp_1.f = simCenter.f_n;
 epp_2.P = 0;     // loss is always from generation side to consumer side:
 end if;

 annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Text(
          extent={{-66,90},{22,4}},
          lineColor={255,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,134,134},
          textString="%eta %%"),
        Bitmap(
          extent={{-62,111},{90,-69}},
          imageSource="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",
          fileName="modelica://TransiEnt/Images/loss.png")}),
                                Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple line model using Transient electrical interfaces with constant power loss specified in percent.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">LoD 1 - only active power and frequency.</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end SeparableLine;
