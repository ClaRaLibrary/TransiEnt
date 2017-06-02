within TransiEnt.Basics.Functions;
function GetPowerTiming
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

    extends Icons.Function;
  input Integer NumberChanges = 10;
  input SI.Time Timing[NumberChanges] = fill(0,NumberChanges);
  input SI.ActivePower P_max = 10000;
  input SI.Energy IntervalEnergy = 1e6;
  output SI.ActivePower PowerTiming[NumberChanges];
protected
  SI.Energy EnergyTiming[NumberChanges];
  SI.Energy RestEnergy;

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
end GetPowerTiming;
