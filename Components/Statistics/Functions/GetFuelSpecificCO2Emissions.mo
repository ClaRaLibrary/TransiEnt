within TransiEnt.Components.Statistics.Functions;
model GetFuelSpecificCO2Emissions "Reference values for CO2 emissions according to FfE ,2010)"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.Model;

  import Fuel = TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier;

  parameter Fuel typeOfPrimaryEnergyCarrier; //Based on type of primary energy carrier

  outer TransiEnt.SimCenter simCenter;

  final parameter TransiEnt.Basics.Units.MassOfCDEperEnergy m_flow_CDE_per_Energy=if typeOfPrimaryEnergyCarrier == Fuel.BrownCoal then simCenter.FuelSpecEmis_BrownCoal elseif typeOfPrimaryEnergyCarrier == Fuel.BlackCoal then simCenter.FuelSpecEmis_HardCoal elseif typeOfPrimaryEnergyCarrier == Fuel.NaturalGas then simCenter.FuelSpecEmis_NaturalGas elseif typeOfPrimaryEnergyCarrier == Fuel.WindOnshore then simCenter.FuelSpecEmis_WindOnshore elseif typeOfPrimaryEnergyCarrier == Fuel.WindOffshore then simCenter.FuelSpecEmis_WindOffshore elseif typeOfPrimaryEnergyCarrier == Fuel.Solar then simCenter.FuelSpecEmis_Photovoltaic elseif typeOfPrimaryEnergyCarrier == Fuel.Hydro then simCenter.FuelSpecEmis_Hydro elseif typeOfPrimaryEnergyCarrier == Fuel.Nuclear then simCenter.FuelSpecEmis_Nuclear elseif typeOfPrimaryEnergyCarrier == Fuel.Oil then simCenter.FuelSpecEmis_HeavyFuelOil elseif typeOfPrimaryEnergyCarrier == Fuel.DistrictHeating then 0 elseif typeOfPrimaryEnergyCarrier == Fuel.Electricity
       then 0 elseif typeOfPrimaryEnergyCarrier == Fuel.Biomass then simCenter.FuelSpecEmis_Biomass elseif typeOfPrimaryEnergyCarrier == Fuel.Garbage then simCenter.FuelSpecEmis_Garbage else 0 "CO2 emissions in kg per J of fuel";

end GetFuelSpecificCO2Emissions;
