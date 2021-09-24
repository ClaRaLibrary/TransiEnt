within TransiEnt.Components.Electrical.Machines.Base;
partial model PartialQuasiStationaryGenerator "Abstract class for quasistationary generators"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  extends TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator(redeclare TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp);

  // _____________________________________________
  //
  //                  Outer
  // _____________________________________________


  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________


  parameter SI.Voltage v_n=simCenter.v_n "Nominal voltage"                 annotation(Dialog(group="General"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  //TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-120,-20},{-90,10}})));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________



  Modelica.Units.SI.ReactivePower Q=epp.Q;
  Modelica.Units.SI.Voltage v_grid(start=v_n) = epp.v annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.ApparentPower S=sign(epp.P)*sqrt(epp.P^2 + epp.Q^2);
  Modelica.Units.SI.PowerFactor cosphi=noEvent(if S > 0 then P/S else 0);

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(graphics),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Partial model of an electric machine using TransiEnt electrical interfaces.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L2E (defined in the CodingConventions)- differential equation</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Mechanical power port mpp</span></p>
<p>Modelica RealInput: E_input &quot;Electric potential&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>S is the apparent power</p>
<p>Q is the reactive power</p>
<p>cosphi is the power factor</p>
<p>v_grid is the voltage of the grid</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Jan-Peter Heckel (jan.heckel@tuhh.de) in June/July 2018</span></p>
</html>"));
end PartialQuasiStationaryGenerator;
