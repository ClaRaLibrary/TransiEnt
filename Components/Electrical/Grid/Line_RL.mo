within TransiEnt.Components.Electrical.Grid;
model Line_RL
  "Transmission line model with consideration of resistance (R) and inductive reactance (L) per unit length"


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
  outer TransiEnt.SimCenter simCenter;

protected
  parameter TransiEnt.Basics.Units.SpecificResistance r=CableData[1]
    "Losses from cable resistance per unit lenght";
  parameter TransiEnt.Basics.Units.SpecificResistance x_L=CableData[2]
    "inductive reactance per unit lenght";
  parameter Real CableData[4]=
      TransiEnt.Components.Electrical.Grid.Base.getLVCableData(CableType)
    "saves the cabledata of the selected cable";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
public
  parameter TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes
    CableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K4
    "type of cable";
  parameter SI.Length l=100 "Length of the cable";
  parameter Real v_n=400 "Nominal grid voltage";

  parameter Boolean simpleModel=false
    "Ignore phase shift angle of connected loads" annotation (
    Evaluate=true,
    HideResult=true,
    choices(__Dymola_checkBox=true));

  // _____________________________________________
  //
  //             Variables
  // _____________________________________________

  SI.ApparentPower S1=sqrt(epp_p.P^2 + epp_p.Q^2);
  SI.ApparentPower S2=sqrt(epp_n.P^2 + epp_n.Q^2);
  SI.ActivePower P_loss(start=1) = epp_n.P + epp_p.P;
  SI.ReactivePower Q_loss(start=1) = epp_n.Q + epp_p.Q;
  SI.Angle phi_v;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp_p
    annotation (Placement(transformation(extent={{-110,-8},{-90,12}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp_n
    annotation (Placement(transformation(extent={{90,-8},{110,12}})));


equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________


  epp_p.f = epp_n.f;
  phi_v = 0.5*Modelica.Constants.pi - atan2(epp_p.Q, epp_p.P) - atan(r/x_L);

  if simpleModel then
    S1^2*x_L*l = Q_loss*v_n^2;
    r*Q_loss = x_L*P_loss;
    epp_n.v^2 = epp_p.v^2 + (1/epp_p.v*S1*l*sqrt(r^2 + x_L^2))^2 - 2*S1*l*sqrt(r^2 + x_L^2)*cos(phi_v);
  else
    S1^2*x_L*l = Q_loss*epp_p.v^2;
    r*Q_loss = x_L*P_loss;
    S1*epp_n.v = S2*epp_p.v;
  end if;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(
          points={{-100,0},{100,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-80,6},{80,-6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-16},{100,-52}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="L = %l"),
        Text(
          extent={{-144,56},{156,16}},
          lineColor={0,0,0},
          textString="%CableType"),
        Text(
          extent={{-202,94},{196,56}},
          lineColor={0,0,0},
          textString="%name")}),
    defaultComponentName="Cable",
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple model of a cable with consideration of resistance and inductive reactance per unit length. Computes losses and voltage drop depend on typical cable types and specified length.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L3E (defined in the CodingConventions) - Quasi-Stationary model of transmission line as a concentrated element. Active- and (inductive) reactive power (losses) are regarded. Cable capacitance is neglected. When checkbox simpleModel is activated: calculation based on nominal grid voltage instead of actual voltage at power ports.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Limited by length due to neglecting of cable capacitance, esp. at medium and high voltage. When checkbox simpleModel is activated: limited by voltage drops of about 20 % of nominal grid voltage.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two ApparentPowerPort for each terminal.</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Saba Al-Sader during the project IntegraNet in 2017.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Julian Urbansky, Fraunhofer UMSICHT, in 2021.</span></p>

</html>"));
end Line_RL;
