within TransiEnt.Producer.Heat.SolarThermal;
model SolarThermal_L0 "Table-based solar thermal module with collecting statistics"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
    extends TransiEnt.Basics.Icons.SolarThermalCollector;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid Medium = simCenter.fluid1 "Medium in the component";
  parameter Modelica.SIunits.PressureDifference  p_drop= 1e5 "Nominal pressure drop";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_n= 750e3 "Nominal heat flow rate (cost calculation)";

  parameter Real scaleData = 600/1054 "Scaling factor" annotation(Dialog(group="Data"));
  parameter String relativepath = "/heat/SolarThermalHeatFlow_900s.txt" "Path for table data relative to source directory"
                                                                                                    annotation(Evaluate=true, HideResult=true, Dialog(enable=not use_absolute_path, group="Data"));
  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.ModelStatistics modelStatistics;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=Medium) annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}), iconTransformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=Medium) annotation (Placement(transformation(extent={{94,-70},{114,-50}}), iconTransformation(extent={{-110,-10},{-90,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  Components.Boundaries.Heat.Heatflow_L1 prescribedHeatflow_L1(p_drop=p_drop) annotation (Placement(transformation(extent={{-29,-60},{29,-4}})));

  TransiEnt.Basics.Tables.GenericDataTable solarThermalData(
    change_of_sign=true,
    relativepath=relativepath,
    constantfactor=scaleData) annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Renewable) annotation (Placement(transformation(extent={{-100,100},{-80,80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost simpleEconomicsModel_Heater(
    Q_flow_n=Q_flow_n,
    Q_flow_is=heatFlowRateOut,
    Q_flow_fuel_is=0,
    m_flow_CDE_is=0,
    redeclare model HeatingPlantCostModel = Components.Statistics.ConfigurationData.PowerProducerCostSpecs.Biomass (
        Cspec_inv_der_E=0,
        factor_OM=0,
        Cspec_OM_W_el=0,
        Cspec_fuel=0,
        m_flow_CDEspec_fuel=0),
    consumes_H_flow=false,
    produces_m_flow_CDE=false)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,90})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut heatFlowRateOut "negative" annotation (Placement(transformation(extent={{58,68},{78,88}}), iconTransformation(extent={{58,68},{78,88}})));
  Modelica.Blocks.Math.Gain changeSign(k=-1) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,24})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsHeat collectGwpEmissions(typeOfEnergyCarrierHeat=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.Solar) annotation (Placement(transformation(extent={{-80,100},{-60,80}})));
protected
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Solar);
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
 // Statistics
 // Heating power Q_flow has to be negative
 collectHeatingPower.heatFlowCollector.Q_flow= heatFlowRateOut;

 // Emissions
 collectGwpEmissions.gwpCollector.m_flow_cde=-fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*heatFlowRateOut;

 connect(modelStatistics.costsCollector,simpleEconomicsModel_Heater.costsCollector);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Renewable],collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.gwpCollectorHeat[TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Solar],collectGwpEmissions.gwpCollector);

  connect(solarThermalData.y1, heatFlowRateOut) annotation (Line(points={{-59,50},{-30,50},{0,50},{0,78},{68,78}},  color={0,0,127}));
  connect(changeSign.y, prescribedHeatflow_L1.Q_flow_prescribed) annotation (Line(points={{-20,13},{-20,-9.6},{-17.4,-9.6}},   color={0,0,127}));
  connect(changeSign.u,solarThermalData. y1) annotation (Line(points={{-20,36},{-20,50},{-59,50}}, color={0,0,127}));
  connect(prescribedHeatflow_L1.fluidPortOut, waterPortOut) annotation (Line(
      points={{17.4,-60},{104,-60},{104,-60}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatflow_L1.fluidPortIn, waterPortIn) annotation (Line(
      points={{-17.4,-60},{-62,-60},{-62,-60},{-100,-60}},
      color={175,0,0},
      smooth=Smooth.None));

  annotation (defaultComponentName="solarThermal",Diagram(graphics,
                                                          coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Ideal table based solar thermal model. Heat is directly given on medlium. No heat transfer or dynamic behaviour considered. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Producer.Heat.SolarThermal.Check.TestSolarThermal_L0&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Arne Koeppen (arne.koeppen@tuhh.de) June 2014</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Tobias Ramm (tobias.ramm@tuhh.de) November 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Lisa Andresen (andresen@tuhh.de) December 2015</span></p>
</html>"),
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end SolarThermal_L0;
