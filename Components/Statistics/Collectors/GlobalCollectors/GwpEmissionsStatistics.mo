within TransiEnt.Components.Statistics.Collectors.GlobalCollectors;
model GwpEmissionsStatistics

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

  import TransiEnt.Basics.Types;
  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Boolean integrateCDE=simCenter.integrateCDE "true if CDE should be integrated";
  parameter Integer nTypes = Types.nTypeOfPrimaryEnergyCarrier annotation(HideResult=true);
  parameter Integer nTypesHeat = Types.nTypeOfPrimaryEnergyCarrierHeat annotation(HideResult=true);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput  gwpCollector[nTypes] annotation (HideResult=true,
      Placement(transformation(extent={{-10,-108},{10,-88}}),
        iconTransformation(extent={{-16,-16},{16,16}},
        rotation=90,
        origin={0,-87})));

  Modelica.Blocks.Interfaces.RealInput gwpCollectorHeat[nTypesHeat] annotation (HideResult=true, Placement(transformation(extent={{36,-108},{56,
            -88}}), iconTransformation(extent={{-16,-16},{16,16}},
        rotation=90,
        origin={0,-87})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  TransiEnt.Basics.Units.MassOfCDE m_CDE[nTypes](
    each start=0,
    each fixed=true,
    stateSelect=StateSelect.never) annotation (HideResult=simCenter.expertMode);
  TransiEnt.Basics.Units.MassOfCDE m_CDE_heat[nTypesHeat](
    each start=0,
    each fixed=true,
    stateSelect=StateSelect.never) annotation (HideResult=simCenter.expertMode);

  // Visible Variables: Total mass
  SI.Mass m_CDE_total = sum(m_CDE) + sum(m_CDE_heat);
  SI.Mass m_CDE_heat_total = sum(m_CDE_heat);
  SI.Mass m_CDE_electricity_total = sum(m_CDE);

  // Visible Variables: Mass for Electricity Generation
  TransiEnt.Basics.Units.MassFlowOfCDE m_flow_CDE_total_electricity=sum(gwpCollector);
  TransiEnt.Basics.Units.MassOfCDE m_CDE_browncoal=m_CDE[PrimaryEnergyCarrier.BrownCoal];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_blackcoal=m_CDE[PrimaryEnergyCarrier.BlackCoal];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_naturalgas=m_CDE[PrimaryEnergyCarrier.NaturalGas];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_windonshore=m_CDE[PrimaryEnergyCarrier.WindOnshore];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_windoffshroe=m_CDE[PrimaryEnergyCarrier.WindOffshore];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_solar=m_CDE[PrimaryEnergyCarrier.Solar];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_hydro=m_CDE[PrimaryEnergyCarrier.Hydro];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_nuclear=m_CDE[PrimaryEnergyCarrier.Nuclear];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_oil=m_CDE[PrimaryEnergyCarrier.Oil];

  // Visible Variables: Mass for Heat Generation
  TransiEnt.Basics.Units.MassFlowOfCDE m_flow_CDE_total_heat=sum(gwpCollectorHeat);
  TransiEnt.Basics.Units.MassOfCDE m_CDE_Gas_heat=m_CDE_heat[PrimaryEnergyCarrierHeat.NaturalGas];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_DistrictHeating_heat=m_CDE_heat[PrimaryEnergyCarrierHeat.DistrictHeating];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_Oil_heat=m_CDE_heat[PrimaryEnergyCarrierHeat.Oil];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_Electricity_heat=m_CDE_heat[PrimaryEnergyCarrierHeat.Electricity];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_Solar_heat=m_CDE_heat[PrimaryEnergyCarrierHeat.Solar];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_Biomass_heat=m_CDE_heat[PrimaryEnergyCarrierHeat.Biomass];
  TransiEnt.Basics.Units.MassOfCDE m_CDE_Others_heat=m_CDE_heat[PrimaryEnergyCarrierHeat.Others];

equation
  if integrateCDE then
   der(m_CDE)=gwpCollector;
   der(m_CDE_heat)=gwpCollectorHeat;
  else
    m_CDE=zeros(nTypes);
    m_CDE_heat=zeros(nTypesHeat);
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={200,200,200},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-7,19},{-7,-5},{-23,-5},{3,-33},{27,-5},{11,-5},{11,19},{1,19},
              {-7,19}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={3,-37},
          rotation=180),
        Ellipse(
          extent={{-34,80},{32,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),               Ellipse(
                    visible=not is_setter,
          extent={{-4,69},{-14,59}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),               Ellipse(
                    visible=not is_setter,
          extent={{14,69},{4,59}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),               Ellipse(
                    visible=not is_setter,
          extent={{-16,51},{-26,41}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),               Ellipse(
                    visible=not is_setter,
          extent={{12,29},{2,39}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),               Ellipse(
                    visible=not is_setter,
          extent={{26,51},{16,41}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),               Ellipse(
                    visible=not is_setter,
          extent={{-4,33},{-14,23}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),               Ellipse(
                    visible=not is_setter,
          extent={{4,53},{-6,43}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-68,146},{68,102}},
          lineColor={0,0,0},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
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
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end GwpEmissionsStatistics;
