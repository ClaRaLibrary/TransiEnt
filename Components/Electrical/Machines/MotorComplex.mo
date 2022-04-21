within TransiEnt.Components.Electrical.Machines;
model MotorComplex "simple electrical motor model for unspecified motor type"


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

extends TransiEnt.Basics.Icons.MachineRL;


  // _____________________________________________
  //
  //                  Outer
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;



 // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.PowerFactor cosphi=0.8 "Constant Power Factor of machine";
  parameter Modelica.Units.SI.Efficiency eta=1 "effiency of machine";
  parameter SI.Voltage v_n=simCenter.v_n;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{94,-8},{108,6}})));
  TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp annotation (Placement(transformation(extent={{-108,-8},{-88,12}}), iconTransformation(extent={{-112,-12},{-88,12}})));


  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  Modelica.Units.SI.ComplexPower S;
  Modelica.Units.SI.AngularFrequency omega;
  Modelica.Units.SI.Voltage V_is(start=v_n) annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.Angle delta_is(start=-0.08726646259971647);
  Modelica.Units.SI.Power P_mech=der(mpp.phi)*mpp.tau;


equation


  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________


  epp.P = if mpp.tau>0 then - (mpp.tau * omega * eta) else - (mpp.tau * omega * 1/eta);

  omega=2*Modelica.Constants.pi*epp.f;

  epp.f =Modelica.Units.Conversions.to_Hz(der(mpp.phi));

  S.re=epp.P;

  S.im=epp.Q;

  epp.P=Modelica.ComplexMath.abs(S)*cosphi;

  epp.v=V_is;

  epp.delta=delta_is;




  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Most simple model for a motor for use with the ComplexPowerPort</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>L1E: Models are based on characteristic lines, gains or efficiencies.</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Mechanical connection is stiff</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Constant effiency</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Constant power factor</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">no phyiscal insight of motor</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp (ComplexPowerPort)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Mechanical power port mpp</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Tested in the check model &quot;TransiEnt.Components.Electrical.Machines.Check.CheckMotorComplex&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no references)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in April 2018 </span></p>
</html>"));
end MotorComplex;
