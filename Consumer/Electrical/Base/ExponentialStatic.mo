within TransiEnt.Consumer.Electrical.Base;
model ExponentialStatic

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  import Modelica.Fluid.Utilities.regPow;
  extends TransiEnt.Basics.Icons.ExponentialBlock;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Real f_n=simCenter.f_n "Nominal frequency";
  parameter Real v_n=simCenter.v_n "Nominal voltage";
  replaceable parameter TransiEnt.Consumer.Electrical.Characteristics.Constant data constrainedby TransiEnt.Consumer.Electrical.Characteristics.PartialConsumerData "Load characteristic" annotation (choicesAllMatching=true);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.FrequencyIn f "Input for frequency" annotation (Placement(transformation(
          extent={{-122,30},{-82,70}}), iconTransformation(extent={{-100,44},{-68,
            76}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut Delta_P_star "Output for electric power difference" annotation (Placement(
        transformation(extent={{96,32},{124,60}}),  iconTransformation(extent={{92,-62},{112,-42}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Delta_Q_star "Output for heat flow rate difference" annotation (Placement(
        transformation(extent={{96,-68},{120,-44}}),  iconTransformation(extent={{92,50},{112,70}})));
  TransiEnt.Basics.Interfaces.Electrical.VoltageIn v "Input for voltage" annotation (Placement(transformation(
          extent={{-108,-72},{-68,-32}}), iconTransformation(extent={{-100,-64},{-68,-32}})));

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  Delta_P_star = regPow(v/v_n,data.kpu) * (1 + data.kpf*( f -f_n)/f_n) - 1;
  Delta_Q_star = regPow(v/v_n,data.kqu) * (1 + data.kqf*( f -f_n)/f_n) - 1;

  //Comment from Jan-Peter Heckel (jan.heckel@tuhh.de) if V_L is given in (M)W/Hz then:
  //kpf=V_L*50Hz
  //The 50 Hz Multiplication is done by the P_n and Q_n by default

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),        Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Exponential static model to calculate the frequency and voltage dependency of consumer electric load based on reference [1].</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">f: input for frequency in [Hz]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Delta_P_star: output for electric power difference in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Delta_Q_star: output for heat flow rate difference in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">v: input for voltage in [V]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in the check model &quot;TransiEnt.Consumer.Electrical.Base.Check.CheckExponentialStatic&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>[1] IEEE Task Force on Load Representation for Dynamic Performance: Load representation for dynamic performance analysis (of power systems). In: <i>IEEE Transactions on Power Systems</i> Bd. 8 (1993), Nr. 2, S. 472&ndash;482</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 21.04.2017</span></p>
</html>"));
end ExponentialStatic;
