within TransiEnt.Components.Electrical.Machines.Base;
partial model PartialActivePowerGenerator "Most abstract base class for all electric machine models based on active power and frequency"

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

  extends TransiEnt.Basics.Icons.MachineRL;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (choicesAllMatching=true, Dialog(group="Replaceable Components"),Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{94,-8},{108,6}})));
  TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp annotation (Placement(transformation(extent={{-112,-12},{-88,12}}), iconTransformation(extent={{-112,-12},{-88,12}})));
    Modelica.Blocks.Interfaces.RealInput E_input( final quantity="ElectricPotential", final unit="V") "Control input" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,104}),iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={-3,99})));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  Modelica.SIunits.ActivePower P = epp.P;
  Modelica.SIunits.ActivePower P_el_is = -epp.P "Actual active power output";
  Modelica.SIunits.Frequency f_grid(start=simCenter.f_n)= epp.f;
  Modelica.SIunits.AngularVelocity omega= der(mpp.phi);


  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Partial model of an electric machine using TransiEnt electrical interfaces.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L2E (defined in the CodingConventions) - differential equation </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Mechanical power port mpp</p>
<p>Active power port epp</p>
<p>Modelica RealInput: E_input &quot;Electric potential&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P is the active power</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_is is the actual electric power output</span></p>
<p>f_grid is the frequency of the grid</p>
<p>omega is the angular velocity</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) in October 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Jan-Peter Heckel (jan.heckel@tuhh.de) in June/July 2018</span></p>
</html>"));
end PartialActivePowerGenerator;
