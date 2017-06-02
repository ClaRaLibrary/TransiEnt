within TransiEnt.Storage.Heat.HeatStorage_Stratified;
model StratifiedHotWaterStorageElectric_L3
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

  extends StratifiedHotWaterStorage_L3(     HeaPortsGeometry(
        height_port={Geometry.height}), ConductanceTop(width=0.2));
  extends TransiEnt.Basics.Icons.ThermalStorage_Electrical;

  Basics.HeatingElectrode heatingElectrode
    annotation (Placement(transformation(extent={{-28,58},{-48,78}})));
  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp annotation (Placement(transformation(extent={{-94,90},{-74,110}})));
equation
  connect(heatingElectrode.heat, heatPorts[1]) annotation (Line(
      points={{-29.4,68},{-14,68},{-14,86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatingElectrode.epp, epp) annotation (Line(
      points={{-38,76.8},{-38,88},{-84,88},{-84,100}},
      color={0,127,0},
      smooth=Smooth.None));
annotation (Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b> </p>
<p>One dimensional fluid storage model with stratification. Intention of the model is to represent a hot water storage in a bigger system with more accurate outflow temoeratures compared to a zero dimensional storage model. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L3: Storage is diveded in layered volumes. Each volume is ideally stirred. Between the fluid volumes heat conduction and boyancy are considered. </p><p>Heat losses to the ambient are simplified as heat conduction through top, side wall and bottom.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The storage model includes just a vertical temperature distribution. No horizontal temperature distribution is modeled. Mixing effects due to the velocity of the fluid at inlets an outlets are not modelled. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<h5>Heat</h5>
<p>heatLosses: ambient temperature and the collected heat flow to the ambient through top, side wall and bottom</p><p>heatPorts(optinal): temperature of connected fluid volume and heat flow to or from the fluid volume </p>
<h5>Fluid</h5>
<p>inletCHP: fluid connection from CHP, fluid flows to the storage </p><p>outletCHP: fluid connection to CHP, fluid flows from the storage </p><p>inletGrid: fluid connection from heating grid, fluid flows to the storage</p><p>outletGrid: fluid connection to heating Grid, fluid flows from the storage</p><p>inletSolar (optional): fluid connection from solar thermie, fluid flows depending on the temperature to different storage layers </p><p>outletSolar (optional): fluid connection to Solar thermie system, fluid flows from solar thermie to the storage</p><p>addPorts (optional): a various number of fluid connections to other components for example chiler. </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p><br>Just parameters and of the main model are described. Further explanations are in the sub models. medium: medium in the hot water storage. Has to be one phase fluid from the TILMedia library</p><p><br>nSeg: number of vertical layered fluid segments</p><p><br>maxTemperature_allowed: maximum allowed temperatur inside the storage</p><p><br>minTemperature_allowed: minimum allowed temperatur inside the storage</p><p><br>Use_Solar(Boolean): if true the ports inletSolar and outletSolar are active</p><p><br>Use_HeatPorts(Boolean): if true heatPorts is active</p><p><br>nHeatPorts: number of heat ports</p><p><br>nAdditionalFluidPorts: number of additional fluid ports </p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Energy and mass or volume balance inside every volume segment. Heat losses due to one dimensional thermal conductance through top, bottom and side wall. Thermal conductance between volume segments. Modeled boyancy introducing heat flow from lower to higher segment if the lower segemnt has a higher temperature. Direct fluid connection between the volumes. </p>
<p>(There is an image missing here that has someday been in path: Sketchbook/tr/Thermal/Images/waermespeicher_modell_eng.png) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The allowed minimum number of volume segements is two. The higher the number of segments the higher the number of equations. </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Validated with measurements and reference Simulation. </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Ramm (tobias.ramm@tuhh.de) on Fri Mar 20 2015</p>
<p>Revised and edited by Lisa Andresen (andresen@tuhh.de), Jun 2015</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end StratifiedHotWaterStorageElectric_L3;
