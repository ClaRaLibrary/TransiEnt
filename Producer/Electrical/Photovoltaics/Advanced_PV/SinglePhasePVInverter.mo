within TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV;
model SinglePhasePVInverter "Simple PV inverter"


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





  //_______________________________________________________________________

  // This solar inverter model considers:
  //  - power factor
  //  - efficiency
  //  - Percentage of PV peak power at which power is cut
  //
  //_______________________________________________________________________

  // _____________________________________________
  //
  //             Parameters
  // _____________________________________________



  parameter SI.Efficiency eta=0.97 "Efficiency of the inverter";
  parameter SI.PowerFactor cosphi=0.9 "Operating power factor of the inverter";
  parameter Integer behavior=-1 annotation (
    Evaluate=true,
    HideResult=true,
    choices(
      __Dymola_radioButtons=true,
      choice=1 "inductive",
      choice=-1 "capacitive"));
  // 1 if inductive, -1 if capacitive
  parameter SI.ActivePower P_n=5000 "Rated power of the inverter";
  parameter SI.ActivePower P_PV=2000 "Installed peak power of the PV plant";
  parameter Real Threshold=0.7 "Percentage of peak power at which power is cut";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp_DC annotation (
      Placement(transformation(extent={{-108,-10},{-88,10}}),
        iconTransformation(extent={{-108,-10},{-88,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp_AC
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  // _____________________________________________
  //
  //                 Variables
  // _____________________________________________

equation

  epp_DC.f = 0;
  epp_AC.Q = abs(epp_AC.P/cosphi)*sin(behavior*acos(cosphi));

  // Output power from the inverter considering the efficiency
  if (epp_DC.P < P_n) then
    min(Threshold*P_PV, eta*epp_DC.P) = -epp_AC.P;
  else
    min(Threshold*P_PV, P_n) = -epp_AC.P;
  end if;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-96,86},{96,-84}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{96,86},{-96,-84}}, color={28,108,200}),
        Text(
          extent={{16,-12},{64,-68}},
          lineColor={28,108,200},
          textString="AC"),
        Text(
          extent={{-64,66},{-16,10}},
          lineColor={28,108,200},
          textString="DC")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple PV Inverter model for calculating the AC active and reactive power output.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L1E (defined in the CodingConventions) - This model considers the efficiency of the converter as constant quotient P_AC/P_DC, the power factor and the percentage of PV peak power at which power is cut.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Input: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">epp_DC</span></b> for DC power port </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Output: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">epp_AC</span></b> for AC power port</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See parameter and variable descriptions in the code.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Tested in check models TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.DNIDHI_Input.Check.Check_PVModule and TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.GHI_Input.PVModule.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Julian Urbansky, Fraunhofer UMSICHT, in September 2021.</span></p>
</html>"));
end SinglePhasePVInverter;
