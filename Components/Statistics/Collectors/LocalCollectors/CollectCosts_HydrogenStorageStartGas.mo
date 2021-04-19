within TransiEnt.Components.Statistics.Collectors.LocalCollectors;
model CollectCosts_HydrogenStorageStartGas "Cost collector for a the start gas of a hydrogen storage"

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

  extends TransiEnt.Components.Statistics.Collectors.LocalCollectors.PartialCollectCosts(redeclare final replaceable model CostRecordGeneral = ConfigurationData.GeneralCostSpecs.Empty);
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.SpecificEnergy GCV_H2=141.8e6 "Gross calorific value of hydrogen";
  final parameter SI.Mass mass_H2_start(fixed=false) "Start value of the hydrogen mass";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Efficiency eta_ely=0.75 "Electrolyzer efficiency with which the start gas is produced" annotation(Dialog(group="Fundamental Definitions"));

  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free "Specific variable cost per electric energy in EUR/MWh" annotation (Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //              Variable Declarations
  // _____________________________________________

  SI.Mass mass_H2=1e4 "Hydrogen mass" annotation (Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

initial equation
  mass_H2_start=mass_H2;
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Calculation of investment costs
  C_inv=if calculateCost then mass_H2_start*GCV_H2/eta_ely*Cspec_demAndRev_el else 0;

  //Calculation of O&M costs
  dynamic_C_OM=0;

  //Calculation of demand-related costs and revenue
  dynamic_C_demand=0;
  dynamic_C_revenue=0;

  //Calculation of other costs
  dynamic_C_other=if calculateCost then C_other_fix else 0;

  annotation (
    defaultConnectionStructurallyInconsistent=true,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics={
        Text(
          extent={{-40,80},{40,52}},
          lineColor={0,0,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          textString="mass_H2"),
        Text(
          extent={{-58,-38},{60,-80}},
          lineColor={0,0,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          textString="Costs Cavern
Start Gas")}),                   Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}})),
            Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks) Equations from Verein Deutscher Ingenieure e.V.: VDI 2067-1: Wirtschaftlichkeit gebaeudetechnischer
Anlagen. Grundlagen und Kostenberechnung. Berlin, September 2012</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Carsten Bode (c.bode@tuhh.de) on 15.02.2017</span></p>
</html>"));
end CollectCosts_HydrogenStorageStartGas;
