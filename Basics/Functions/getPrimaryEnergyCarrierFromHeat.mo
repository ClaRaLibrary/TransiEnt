within TransiEnt.Basics.Functions;
function getPrimaryEnergyCarrierFromHeat "Maps the enum 'primaryEnergyCarrierHeat' to 'primaryEnergyCarrier'"



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
  import HeatType = TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat;
  import GeneralType = TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input HeatType heatType;
  output GeneralType generalType;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

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
</html>"));
end getPrimaryEnergyCarrierFromHeat;
