within TransiEnt.Basics.Functions;
function getPrimaryEnergyCarrierFromHeat "Maps the enum 'primaryEnergyCarrierHeat' to 'primaryEnergyCarrier'"

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
  import HeatType = TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat;
  import GeneralType = TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier;
  input HeatType heatType;
  output GeneralType generalType;
algorithm
  if heatType == HeatType.NaturalGas then
    generalType :=GeneralType.NaturalGas;
  elseif heatType ==HeatType.DistrictHeating then
    generalType :=GeneralType.DistrictHeating;
  elseif heatType ==HeatType.Oil then
    generalType :=GeneralType.Oil;
  elseif heatType ==HeatType.Electricity then
    generalType :=GeneralType.Electricity;
  elseif heatType ==HeatType.Solar then
    generalType :=GeneralType.Solar;
  elseif heatType ==HeatType.Biomass then
    generalType :=GeneralType.Biomass;
  elseif heatType ==HeatType.Garbage then
    generalType :=GeneralType.Garbage;
  else
    generalType :=GeneralType.Others;
  end if;

end getPrimaryEnergyCarrierFromHeat;
