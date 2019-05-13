within TransiEnt.Components.Electrical.Machines;
model LinearSynchronousMachineComplex "ComplexPowerPort: Linear generator model with constant efficiency"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  import TransiEnt;
  extends TransiEnt.Components.Electrical.Machines.Base.PartialQuasiStationaryGeneratorComplex;



 // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Efficiency eta=1 "Total efficiency" annotation(Dialog(group="Physical constraints"));




  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________


  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________



equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if OwnFrequency==true then
  epp.P - D_cage * der(theta)= if mpp.tau>0 then -(mpp.tau * omega * eta) else -(mpp.tau*omega/eta);
  else
  epp.P = if noEvent(mpp.tau>0) then -(mpp.tau * omega * eta) else -(mpp.tau*omega/eta);
  end if;

  v_grid=v_n;

  theta=delta_lsm;



  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Linear model of a synchronous machine with constant efficiency. Mechanical connection is stiff.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>L1E - only active power flow and frequency, voltage fixed and reactive power can be distributed without restriction</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Constant efficiency </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Mechanical connection is stiff</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Only for active power frequency dynamics</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp (ComplexPowerPort) </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Mechanical power port mpp</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: electric potential in [V]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For numerical reasons, do not connect this machine directly to tranformer or resistor/reactance. Use line instead.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Set IsSlack to true for slack-bus version</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Tested in the check model &quot;TransiEnt.Components.Electrical.Machines.Check.CheckLinearSynchronousMachineComplex&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in March 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Based on model by Pascal Dubucq (dubucq@tuhh.de) from October 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified to new interface ComplexPowerPort when created</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model made more modular (extension of partial class and one version for Slack and PU-Bus) in June/July 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised (own Frequency) in October/November 2018</span></p>
</html>"));
end LinearSynchronousMachineComplex;
