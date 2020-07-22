within TransiEnt.Components.Electrical.Grid;
model PiModelComplex "pi-Modell of a cable for ComplexPowerPort"

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


  extends TransiEnt.Components.Electrical.Grid.Base.PartialTwoPortAdmittanceComplex(
                                                                          Y_11(
                                                                        re =    R*p/(R^2+X^2),im =    p*B/2-p*X/(R^2+X^2)), Y_12(
                                                                                                                           re =    -R*p/(R^2+X^2),im =    p*X/(R^2+X^2)));
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________


protected
  parameter TransiEnt.Basics.Units.SpecificResistance r=if ChooseVoltageLevel==4 then r_custom else CableData[1];
  parameter TransiEnt.Basics.Units.SpecificReactance x=if ChooseVoltageLevel==4 then x_custom else CableData[2];
  parameter TransiEnt.Basics.Units.SpecificCapacitance c=if ChooseVoltageLevel==4 then c_custom else CableData[3];
  parameter SI.Current i_r=if ChooseVoltageLevel==4 then i_r_custom else CableData[4];

  parameter Real CableData[4]=if ChooseVoltageLevel==1 then TransiEnt.Components.Electrical.Grid.Base.getLVCableData(
                                                  LVCableType) elseif ChooseVoltageLevel==2 then TransiEnt.Components.Electrical.Grid.Base.getMVCableData(
                                                  MVCableType) else TransiEnt.Components.Electrical.Grid.Base.getHVCableData(
                                                  HVCableType) "Saves the cabledata of the selected cable";
  parameter String VoltageLevelString= if ChooseVoltageLevel==1 then "LV" elseif ChooseVoltageLevel==2 then "MV" else "HV" "Saves the cabledata of the selected cable";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

public
  parameter Integer ChooseVoltageLevel=1 "Choose Voltage Level" annotation(Dialog(group="Fundamental Definitions"),choices(__Dymola_radioButtons=true, choice=1 "Low Voltage", choice=2 "Medium Voltage", choice=3 "High Voltage", choice=4 "Custom Data"));

  parameter Real p = 1 "Number of parallel lines" annotation(Dialog(group="Fundamental Definitions"));
  parameter TransiEnt.Basics.Units.SpecificResistance r_custom=0.06e-3 "Resistance load per unit length" annotation(Dialog(group="cable properties",enable=if ChooseVoltageLevel==4 then true else false));
  parameter TransiEnt.Basics.Units.SpecificReactance x_custom=0.301e-3 "Reactance load per unit length" annotation(Dialog(group="cable properties",enable=if ChooseVoltageLevel==4 then true else false));
  parameter TransiEnt.Basics.Units.SpecificCapacitance c_custom=0.0125e-9 "Capacitance load per unit length" annotation(Dialog(group="cable properties",enable=if ChooseVoltageLevel==4 then true else false));
  parameter SI.Current i_r_custom=1290 "Rated current" annotation(Dialog(group="cable properties",enable=if ChooseVoltageLevel==4 then true else false));
  parameter TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1 "Type of low voltage cable" annotation (
    Evaluate=true,
    HideResult=true,
    Dialog(group="cable properties",enable = if ChooseVoltageLevel==1 then true else false));
  parameter TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1 "Type of Medium voltage cable" annotation (
    Evaluate=true,
    HideResult=true,
    Dialog(group="cable properties",enable = if ChooseVoltageLevel==2 then true else false));
  parameter TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L1 "Type of high voltage cable" annotation (
  Evaluate=true,
  HideResult=true,
  Dialog(group="cable properties", enable = if ChooseVoltageLevel==3 then true else false));
  parameter SI.Length l = 1 "Cable Length" annotation(Evaluate=true, Dialog(group = "cable properties"));

  final parameter SI.Resistance R=r*l;
  final parameter SI.Reactance X=x*l;
  final parameter SI.Capacitance C=c*l;
  final parameter Modelica.SIunits.Susceptance B=2*Modelica.Constants.pi*simCenter.f_n*C;
//   final parameter SI.ComplexAdmittance Y_11(re=R*p/(R^2+X^2),im=p*B/2-p*X/(R^2+X^2));
//   final parameter SI.ComplexAdmittance Y_12(re=-R*p/(R^2+X^2),im=p*X/(R^2+X^2));
//   final parameter SI.ComplexAdmittance Y_21=Y_12;
//   final parameter SI.ComplexAdmittance Y_22=Y_11;


 annotation(Icon(coordinateSystem(preserveAspectRatio=false,   extent={{-100,
            -100},{100,100}}),                                                                                                    graphics={  Line(points = {{-100,0},{100,0}}, color = {0,0,0}, smooth = Smooth.None),Rectangle(extent = {{-80,6},{80,-6}}, lineColor = {0,0,0}, fillColor = {0,0,0},
            fillPattern =                                                                                                   FillPattern.Solid),Text(extent = {{-100,-16},{100,-52}}, lineColor = {0,0,0}, fillColor = {0,0,255},
            fillPattern =                                                                                                   FillPattern.Solid, textString = "L = %l"),Text(extent={{
              -144,56},{156,16}},                                                                                                    lineColor=
              {0,0,0},
               textString=VoltageLevelString),
        Text(
          extent={{-202,94},{196,56}},
          lineColor={0,0,0},
          textString="%name")}),defaultComponentName = "transmissionLine",
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Advanced line model using two-port equation. Computes losses and voltage drop dependent of typical cable types and specified length.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L3E (defined in the CodingConventions), Quasi-Stationary model of transmission line with concentrated elements. Active- and reactive power (losses) are regarded. Electrical Pi-network.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quasi-stationary model, model of line with concentrated elements, limited by the wavelength of the 50 Hz oscillation </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two ComplexPowerPort for each terminal of the transmission line</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Boolean input for switching</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>U is uses for voltages</p>
<p>P is used for active powers</p>
<p>S is used for apparent powers</p>
<p>I is used for electric currents</p>
<p>Q is used for reactive powers</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two-Port Equations</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Use these model in normal cases</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Parameters for the type of line are divided in the three voltage levels</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] M. Schaefer, KIT, URL: https://www.zml.kit.edu/downloads/Elektrische_Energieuebertragung_Leseprobe_Kapitel_2.pdf, 2018</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in March 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model made more modular by Jan-Peter Heckel (jan.heckel@tuhh.de) in May 2019</span></p>
</html>"));
end PiModelComplex;
