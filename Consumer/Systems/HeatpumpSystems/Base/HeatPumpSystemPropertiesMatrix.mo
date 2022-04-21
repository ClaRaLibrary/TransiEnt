within TransiEnt.Consumer.Systems.HeatpumpSystems.Base;
record HeatPumpSystemPropertiesMatrix "Heatpump System properties defined by a real matrix A for automatic pool simulations"


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




  extends TransiEnt.Producer.Heat.Power2Heat.Heatpump.HeatpumpSystemProperties(
    Q_flow_n_heatpump=A[1],
    Q_flow_n_peakunit=A[2],
    V_stor_dhw=A[3],
    V_stor_fh=A[4],
    COP_n_heatpump=A[5],
    eta_peakunit=A[6],
    T_room_start=273.15 + A[7],
    T_stor_dhw_start=273.15 + A[8],
    T_stor_fh_start=273.15 + A[9],
    T_room_set=273.15 + A[10],
    T_stor_dhw_set=273.15 + A[11],
    T_stor_fh_set=273.15 + A[12],
    T_bivalent=273.15 + A[13],
    DTdb_heatpump=A[14],
    T_ref_degC=-12,
    T_feed_ref_degC=A[15],
    T_lim_degC=A[16],
    T_feed_lim_degC=A[17],
    t_min_on_heatpump=A[18],
    t_min_off_heatpump=A[19],
    C_room=A[20],
    G_loss=A[21],
    HowWaterDrawProfile=integer(A[22]),
    HPInitStatus=integer(A[23]),
    PLInitStatus=integer(A[24]));

  final constant Integer nPar=24;
  parameter Real[nPar] A "Input Matrix for Heat Pump Properties";

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>record for heat pump system</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) 2014</p>
</html>"));
end HeatPumpSystemPropertiesMatrix;
