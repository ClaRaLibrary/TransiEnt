within TransiEnt.Basics.Functions;
function GetPowerTiming


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

  extends Icons.Function;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input Integer NumberChanges = 10;
  input SI.Time Timing[NumberChanges] = fill(0,NumberChanges);
  input SI.ActivePower P_max = 10000;
  input SI.Energy IntervalEnergy = 1e6;
  output SI.ActivePower PowerTiming[NumberChanges];

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  SI.Energy EnergyTiming[NumberChanges];
  SI.Energy RestEnergy;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

algorithm
    RestEnergy := IntervalEnergy;
    EnergyTiming := fill(0,NumberChanges);
    PowerTiming := fill(0,NumberChanges);
    for z in 1:NumberChanges - 1 loop
      if (RestEnergy / (NumberChanges - z + 1) > (P_max * Timing[z])) then
        EnergyTiming[z] := P_max * Timing[z];
      else
        EnergyTiming[z] := RestEnergy / (NumberChanges - z + 1);
      end if;
      PowerTiming[z] := EnergyTiming[z] / Timing[z];
      RestEnergy := RestEnergy - EnergyTiming[z];
    end for;
    EnergyTiming[NumberChanges] := RestEnergy;
    PowerTiming[NumberChanges] := EnergyTiming[NumberChanges] / Timing[NumberChanges];
    RestEnergy := RestEnergy - EnergyTiming[NumberChanges];

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de), Jul 2014</p>
</html>"));
end GetPowerTiming;
