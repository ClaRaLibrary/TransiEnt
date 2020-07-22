within TransiEnt.Components.Statistics.Collectors.LocalCollectors;
model CollectGwpEmissionsElectric

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

  import TransiEnt;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  constant Boolean is_setter=true "just for change of icon.." annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  //parameter Boolean is_setter=true "just for change of icon.." annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  parameter Boolean integrateCDE=simCenter.integrateCDE "true if CDE should be integrated";
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier typeOfEnergyCarrier=PrimaryEnergyCarrier.Others "Select the kind of resource"
    annotation (choices(
      choice=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BrownCoal "Brown Coal",
      choice=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal "Black Coal",
      choice=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas "Natural Gas",
      choice=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.WindOnshore "Onshore Wind",
      choice=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.WindOffshore "Offshore Wind",
      choice=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Solar "Solar",
      choice=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Hydro "Hydro",
      choice=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Nuclear "Nuclear",
      choice=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Oil "Oil",
      choice=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Others "All other or unknown"), Dialog(enable=is_setter));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.GwpEmissionCollector gwpCollector annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
protected
  TransiEnt.Basics.Units.MassOfCDE m_CDE(
    start=0,
    fixed=true,
    stateSelect=StateSelect.never);
equation

  if integrateCDE then
    der(m_CDE)=gwpCollector.m_flow_cde;
  else
    m_CDE=0;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={200,200,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,98},{100,132}},
          lineColor={62,62,62},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          textString="%name"),           Polygon(
          points={{-10,70},{-10,-8},{-46,-8},{4,-76},{46,-8},{12,-8},{12,70},{8,70},{-10,70}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-14,68},{-14,-10},{-50,-10},{0,-78},{42,-10},{8,-10},{8,68},{4,68},{-14,68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
                                 Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>model for collecting gwp emissions</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end CollectGwpEmissionsElectric;
