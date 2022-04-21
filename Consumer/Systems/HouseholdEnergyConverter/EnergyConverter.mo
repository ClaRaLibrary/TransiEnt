within TransiEnt.Consumer.Systems.HouseholdEnergyConverter;
model EnergyConverter "Replaceable systems for household technologies based on the energy hub principle."



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
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

 final parameter Boolean DHN=systems.DHN annotation(HideResult=true);
 final parameter Boolean el_grid=systems.el_grid annotation(HideResult=true);
 final parameter Boolean gas_grid=systems.gas_grid annotation(HideResult=true);

  // _____________________________________________
  //
  //          Variables
  // _____________________________________________

  // _____________________________________________
  //
  //          Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp if el_grid annotation (Placement(transformation(extent={{-88,-70},{-68,-50}}), iconTransformation(extent={{-88,-70},{-68,-50}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=simCenter.gasModel1) if gas_grid annotation (Placement(transformation(extent={{68,-70},{88,-50}}), iconTransformation(extent={{70,-68},{88,-50}})));
  TransiEnt.Basics.Interfaces.Combined.HouseholdDemandIn demand annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-9,-9},{9,9}},
        rotation=270,
        origin={1,31})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=simCenter.fluid1) if  DHN annotation (Placement(transformation(extent={{-26,-70},{-6,-50}}), iconTransformation(extent={{-26,-70},{-6,-50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=simCenter.fluid1) if  DHN annotation (Placement(transformation(extent={{8,-70},{28,-50}}), iconTransformation(extent={{8,-70},{28,-50}})));
  replaceable TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems.Boiler systems constrainedby Systems.Base.Systems annotation (choicesAllMatching=true, Placement(transformation(extent={{-10,20},{10,40}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-90,90})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer) annotation (Placement(transformation(extent={{-62,54},{-42,34}})));

equation

   collectHeatingPower.heatFlowCollector.Q_flow=demand.hotWaterPowerDemand+demand.heatingPowerDemand;
   collectElectricPower.powerCollector.P=demand.electricPowerDemand;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.powerCollector[TransiEnt.Basics.Types.TypeOfResource.Consumer],collectElectricPower.powerCollector);
  connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Consumer],collectHeatingPower.heatFlowCollector);

  connect(systems.epp, epp) annotation (Line(
      points={{-8,20.2},{-46,20.2},{-46,-60},{-78,-60}},
      color={0,127,0},
      thickness=0.5));
  connect(systems.waterPortIn, waterPortIn) annotation (Line(
      points={{-2,20.2},{-2,-16.9},{-16,-16.9},{-16,-60}},
      color={175,0,0},
      thickness=0.5));
  connect(systems.waterPortOut, waterPortOut) annotation (Line(
      points={{2,20.2},{2,20.2},{2,-60},{18,-60}},
      color={175,0,0},
      thickness=0.5));
  connect(systems.gasPortIn, gasPortIn) annotation (Line(
      points={{8,20.4},{42,20.4},{42,-60},{78,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(demand, systems.demand) annotation (Line(
      points={{0,100},{0,100},{0,40}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,40},{100,-60}},
          lineColor={0,0,0},
          fillColor={255,198,164},
          fillPattern=FillPattern.Solid)}),                      Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Model based on the energy hub concept to allow for flexible change of technologies that supply a consumer with electricity, heat for space heating and for domestic hot water.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>TransiEnt.Basics.Interfaces.Combined.HouseholdDemandIn <b>demand</b></p>
<p><i>Conditional interfaces depending on the technologies selected:</i></p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort <b>epp - connection to electrical grid</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortIn <b>waterPortIn</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortOut <b>waterPortOut - connection to district heating grid</b></p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn <b>gasPortIn - connection to gas grid</b></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model contains a replaceable technology model with that different predefined technology combinations to supply the consumer can be selected.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end EnergyConverter;
