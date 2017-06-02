within TransiEnt.Producer.Electrical.Wind;
model Windpark "Takes a single wind turbine model (replacable) and applies a linear low pass filter to model wind park smoothing effects"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Windparkmodel;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real N=100 "Number of turbines in park";
  parameter SI.Length z_0=0.3 "Roughness length";
  parameter SI.Length h=120 "Hub height of turbines in park";
  parameter SI.Length d=100 "Average distance between turbines in park";
  parameter SI.Velocity v_mean=10 "Mean wind velocity of park site";

  parameter PrimaryEnergyCarrier typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.WindOnshore "Type of primary energy carrier for co2 emissions global statistics"
    annotation (Dialog(group="Statistics"), HideResult = not simCenter.isExpertMode);

  replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.WindOnshore
                                                                                      constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs
                                              "Wind turbine model" annotation (Dialog(group="Statistics"),
      __Dymola_choicesAllMatching=true);

  parameter EnergyResource typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable "Type of energy resource for global model statistics"
    annotation (Dialog(group="Statistics"), HideResult = not simCenter.isExpertMode,
    Placement(transformation(extent=100)));

  replaceable Base.PartialWindTurbine windTurbineModel(redeclare model ProducerCosts = ProducerCosts)                                                                   annotation (choicesAllMatching=true, Placement(transformation(extent={{-68,-20},{-24,24}})));
  Base.LinearizedWindParkFilter WindParkFilter(
    scale_output=true,
    n=N,
    z_0=z_0,
    h=h,
    d=d,
    v_mean=v_mean,
    P_el_start=P_el_start)
                   annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissions(typeOfEnergyCarrier=typeOfPrimaryEnergyCarrier) annotation (Placement(transformation(extent={{-8,-100},{12,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.PowerPlantCost collectCosts(redeclare model PowerPlantCostModel = ProducerCosts, P_n=windTurbineModel.P_el_n*(N - 1) "N-1 because the wind turbine model instance adds to statistics itself") annotation (HideResult=false, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-90})));

  TransiEnt.Components.Boundaries.Electrical.Power parkTerminal(change_sign=true) annotation (Placement(transformation(extent={{86,-10},{66,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{94,-10},{114,10}})));
  Modelica.Blocks.Interfaces.RealInput v_wind annotation (Placement(transformation(extent={{-124,-22},{-84,18}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency turbineTerminal(useInputConnector=true) annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Modelica.Blocks.Sources.RealExpression P_Turbine(y=turbineTerminal.epp.P) annotation (Placement(transformation(extent={{-22,50},{16,70}})));
  Modelica.Blocks.Sources.RealExpression f_grid(y=epp.f) annotation (Placement(transformation(extent={{-44,30},{-22,48}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.ActivePower P_el_is = -epp.P;

  parameter Real P_el_start=0 "Initial value of output (derivatives of y are zero up to nx-1-th derivative)";
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

   collectElectricPower.powerCollector.P=epp.P-windTurbineModel.epp.P;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(modelStatistics.powerCollector[typeOfResource],collectElectricPower.powerCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);
  connect(parkTerminal.epp, epp) annotation (Line(
      points={{86.1,-0.1},{92,0},{104,0}},
      color={0,135,135},
      thickness=0.5));
  connect(v_wind, windTurbineModel.v_wind) annotation (Line(points={{-104,-2},{-92,-2},{-80,-2},{-80,15.42},{-65.58,15.42}}, color={0,0,127}));
  connect(turbineTerminal.epp, windTurbineModel.epp) annotation (Line(
      points={{-14.1,-0.1},{-21.05,-0.1},{-21.05,14.32},{-25.1,14.32}},
      color={0,135,135},
      thickness=0.5));
  connect(P_Turbine.y, WindParkFilter.P_el_WindTurbine) annotation (Line(points={{17.9,60},{24,60},{24,0},{29.4,0}}, color={0,0,127}));
  connect(f_grid.y, turbineTerminal.f_set) annotation (Line(points={{-20.9,39},{-9.4,39},{-9.4,12}}, color={0,0,127}));
  connect(WindParkFilter.P_el_WindPark, parkTerminal.P_el_set) annotation (Line(points={{51,0},{58,0},{58,20},{82,20},{82,12}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">1<b><span style=\"color: #008000;\">. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Applies a third order linear filter to the input. Can be used to filter the power output of a single turbine such that the output is as smooth at it were in a windpark of n turbines. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See Dany (2000) chapter 2.9 and 3.4.3 for details.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The amplitude spectrum is approximated by a third order transfer function. See matlab scripts in</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">\\\\transientee-sources\\matlab\\pd\\Wind\\WindParkFilter\\</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">for more details how this is done.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"></p><p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] G. Dany, &ldquo;Kraftwerksreserve in elektrischen Verbundsystemen mit hohem Windenergieanteil,&rdquo; Rheinisch-Westf&auml;lische Technische Hochschule Aachen, 2000.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on Wedn Apr 14 2016</span></p>
</html>"),
    Icon(graphics={
        Text(
          extent={{-142,-103},{158,-143}},
          lineColor={0,134,134},
          textString="%name")}));
end Windpark;
