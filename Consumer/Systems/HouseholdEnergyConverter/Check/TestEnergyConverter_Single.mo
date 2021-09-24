within TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Check;
model TestEnergyConverter_Single


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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





  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter(
    redeclare Basics.Tables.HeatGrid.HeatingCurves.HeatingCurveEnergieverbundWilhelmsburgMitte heatingCurve,                                              useHomotopy=true,
    redeclare TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_3600s_TMY temperature,
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_3600s_TMY wind)) annotation (Placement(transformation(extent={{-108,100},{-88,120}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  TransiEnt.Basics.Tables.Combined.HouseholdConsumption householdConsumer1(redeclare
  TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables demand_combined)
    annotation (Placement(transformation(extent={{-16,22},{14,48}})));
  TransiEnt.Consumer.Systems.HouseholdEnergyConverter.EnergyConverter EC_boiler(redeclare Systems.Boiler systems) annotation (Placement(transformation(extent={{-18,-14},{16,18}})));

  Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage           apparentPower(Use_input_connector_f=false, Use_input_connector_v=false)
                                                                 annotation (Placement(transformation(extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-33,-89})));
  Components.Electrical.Grid.PiModel           Cable(l=5) annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-33,-65})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           gasSource annotation (Placement(transformation(extent={{52,-64},{36,-48}})));
equation

  connect(apparentPower.epp,Cable. epp_p) annotation (Line(
      points={{-33,-82},{-32.965,-82},{-32.965,-72},{-33,-72}},
      color={0,127,0},
      thickness=0.5));
  connect(EC_boiler.epp, Cable.epp_n) annotation (Line(
      points={{-14.26,-7.6},{-14.26,-8},{-14,-8},{-14,-34},{-33,-34},{-33,-58}},
      color={0,127,0},
      thickness=0.5));
  connect(householdConsumer1.demand, EC_boiler.demand) annotation (Line(
      points={{-0.7,29.54},{-0.7,17.06},{-0.83,17.06},{-0.83,6.96}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(EC_boiler.gasPortIn, gasSource.gasPort) annotation (Line(
      points={{12.43,-7.44},{12.43,-18},{12,-18},{12,-30},{24,-30},{24,-56},{36,-56}},
      color={255,255,0},
      thickness=1.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}}), graphics={Text(
          extent={{-30,98},{80,52}},
          textColor={28,108,200},
          textString="Look at: EC_boiler.demand[], EC_boiler.boiler.Q_flow_set,
 EC_boiler.epp.P, EC_boiler.gasIn.m_flow")}),
    experiment(
      StopTime=1864000,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test model for the EnergyConverter.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>(none)</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2019</span></p>
</html>"));
end TestEnergyConverter_Single;
