﻿within TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3;
model HeatTransfer_EN442 "EN4442_2"
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

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L2;

  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.TubeType_L2;
  extends ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.ShellType_L2;
  import SM = ClaRa.Basics.Functions.Stepsmoother;
  import SZT = ClaRa.Basics.Functions.SmoothZeroTransition;

  outer ClaRa.Basics.Records.IComBase_L2 iCom;
  outer ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry geo;

  parameter Real n=1/3 "Exponent for Radiators according to EN4442_2";
  parameter Modelica.SIunits.Temperature T_mean_supply=273.15 + 60;
  parameter Modelica.SIunits.TemperatureDifference DT_nom=20;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nom=500;
  parameter Modelica.SIunits.Temperature T_air_nom=295.15;
  parameter Modelica.SIunits.TemperatureDifference Delta_T_mean_n=((T_mean_supply - DT_nom) - T_air_nom)^n;
  final parameter Real UA=Q_flow_nom/Delta_T_mean_n "UA value at nominal condition";
  parameter Integer heatSurfaceAlloc=1 "To be considered heat transfer area" annotation (dialog(enable=false, tab="Expert Setting"), choices(
      choice=1 "Lateral surface",
      choice=2 "Inner heat transfer surface",
      choice=3 "Selection to be extended"));

equation

  heat.Q_flow = UA*(heat.T - iCom.T_bulk)*Buildings.Utilities.Math.Functions.regNonZeroPower(
    x=(heat.T - iCom.T_bulk),
    n=n - 1,
    delta=0.05);
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model for Heat Transfer according to DIN EN 442-2.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>A detailed description of the calculation can be find in DIN EN 442-2.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>UA...Constant of Modell</p>
<p>n...Exponent according to 442-2</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p><span style=\"font-family: Courier New;\">Q_flow&nbsp;=&nbsp;UA* ∆T^n</span></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><span style=\"font-family: sans-serif;\">DIN EN 442-2:2014 </span>- Radiatoren und Konvektoren Beuth Verlag, Berlin,2014. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Anne Senkel (anne.senkel@tuhh.de), January 2020</p>
</html>"));
end HeatTransfer_EN442;
