within TransiEnt.Producer.Heat.Power2Heat.Heatpump;
record HeatpumpSystemProperties "Heat pump system scenario"


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




  extends TransiEnt.Basics.Icons.Record;

  // installed heat producer properties
  parameter SI.HeatFlowRate Q_flow_n_heatpump = 5.4e3;
  parameter SI.HeatFlowRate Q_flow_n_peakunit = 5.4e3;
  parameter SI.Volume V_stor_dhw = 0.4;
  parameter SI.Volume V_stor_fh = 0.7;

  // efficiencies
  parameter Real COP_n_heatpump = 3.7 "COP at nominal conditions";
  parameter Real eta_peakunit = 0.98 "COP of peak unit";

  // initialization
  parameter SI.Temperature T_room_start = T_room_set;
  parameter SI.Temperature T_stor_dhw_start = T_stor_dhw_set;
  parameter SI.Temperature T_stor_fh_start = T_stor_fh_set;
  parameter TransiEnt.Basics.Types.DoubleSetpointControllerStatus PLInitStatus=TransiEnt.Basics.Types.off "Used only, if peak load two point control model";
  parameter TransiEnt.Basics.Types.OnOffRelaisStatus HPInitStatus=TransiEnt.Basics.Types.on_ready "Used only if time relais model";

  // controller parameters
  parameter SI.Temperature T_room_set = 273.15+20;
  parameter SI.Temperature T_stor_dhw_set = 273.15+53;
  parameter SI.Temperature T_stor_fh_set = 273.15+35;
  parameter SI.Temperature T_bivalent = 273.15-8 "Temperature where bivalent system switches between peak and base load unit";
  parameter SI.TemperatureDifference DTdb_heatpump = 2 "Deadband of heatpump controller hysteresis";
  parameter Real T_ref_degC = -12;
  parameter Real T_feed_ref_degC = 33;
  parameter Real T_lim_degC = 19 "Heating limit in degC";
  parameter Real T_feed_lim_degC = 20;
  parameter SI.Time t_min_on_heatpump = 360 "Minimum uptime";
  parameter SI.Time t_min_off_heatpump = t_min_on_heatpump "Minimum downtime";

  //parameter SI.TemperatureDifference DTdb_peakload = 2 "Deadband of peakload controller hysteresis";

  // consumer properties
  parameter Modelica.Units.SI.HeatCapacity C_room=3.97e7 "Heat capacity of storage (= cp*m)";
  parameter Modelica.Units.SI.ThermalConductance G_loss=102 "Constant thermal conductance of material";
  parameter TransiEnt.Basics.Types.HotWaterProfile HowWaterDrawProfile=TransiEnt.Basics.Types.HotWaterProfile_threePersonBath annotation (__Dymola_editText=false);

  annotation (defaultComponentName="params", Icon(graphics,
                                                  coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                                                        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Record for heat pump system scenario</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4.Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
</html>"));
end HeatpumpSystemProperties;
