within TransiEnt.SystemGeneration.GridConstructor.Base;
partial model PartialTechnologies


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

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // Every  parameter activates(=1) or deactivates(=0) a certain technology in an extended Systems model.
  // The assignment of the booleans to the specific technologies is carried out in the respective Systems model
  // Approach is needed for the possibility of vector assignment in the Grid_Constructor model

  parameter Boolean useGasPort=true "True if gas port shall be used";

  parameter Boolean onlyElectric=false;

  parameter Integer El_Consumer=1 annotation (HideResult=true, choices(__Dymola_checkBox=true));
  // El_Consumer existant in Systems

  parameter Integer PV=0 annotation (HideResult=true, choices(__Dymola_checkBox=true));
  // PV existant in Systems

  parameter Integer CHP=0 annotation (HideResult=true, choices(__Dymola_checkBox=true));
  // CHP existant in Systems

  parameter Integer Boiler=1 annotation (HideResult=true, choices(__Dymola_checkBox=true));
  // Simple Gas Boiler existant in Systems

  parameter Integer HeatPump=1 annotation (HideResult=true, choices(__Dymola_checkBox=true));
  // Heat pump system (heat pump + thermal storage + controller) existant in Systems

  parameter Integer DHN=0 annotation (HideResult=true, choices(__Dymola_checkBox=true));
  // Substation for district heating existant in Systems

  parameter Integer NSH=1 annotation (HideResult=true, choices(__Dymola_checkBox=true));
  // Night storage heating present in Systems

  parameter Integer ST=1 annotation (HideResult=true, choices(__Dymola_checkBox=true));
  // Solar thermal system (solar heating + thermal storage + boiler) existant in Systems

  parameter Integer Oil=1 annotation (HideResult=true, choices(__Dymola_checkBox=true));

  parameter Integer Biomass=1 annotation (HideResult=true, choices(__Dymola_checkBox=true));

  parameter TransiEnt.Basics.Types.FuelType fuel_ST=TransiEnt.Basics.Types.FuelType.Gas "choice of fuel";

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

  // Switch off physical connectors which are not needed (e.g. no gas consuming technologies --> No gas connection to the grid is needed -->  Gas Port is switched off)
  // Approach is needed to allow for a successful compilation of the simulation

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp if El_Consumer == 1 or PV == 1 annotation (Placement(transformation(extent={{-90,-108},{-70,-88}})));

  // Real-Input Ports for load profile data

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn el_Demand annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={-60,94}), iconTransformation(
        extent={{-16,-14},{16,14}},
        rotation=270,
        origin={-62,92})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn q_Demand annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={0,94})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn q_Demand_water annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={60,94})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=simCenter.fluid1) if DHN == 1 annotation (Placement(transformation(extent={{-30,-108},{-10,-88}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=simCenter.fluid1) if DHN == 1 annotation (Placement(transformation(extent={{10,-108},{30,-88}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasIn_grid(Medium=simCenter.gasModel1) if useGasPort and Boiler == 1 or useGasPort and CHP == 1 or useGasPort and ST == 1 and fuel_ST == TransiEnt.Basics.Types.FuelType.Gas annotation (Placement(transformation(extent={{70,-106},{90,-86}})));

equation

  annotation (
    HideResult=true,
    choices(__Dymola_checkBox=true),
    Placement(transformation(extent={{-30,-108},{-10,-88}})),
    Placement(transformation(extent={{10,-108},{30,-88}})),
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,82},{100,-96}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName="systems",
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Base Class of the Systems models for the GridConstructor</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created during IntegraNet I </span></p>
</html>"));
end PartialTechnologies;
