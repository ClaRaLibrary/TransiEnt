within TransiEnt.Consumer.DemandSideManagement.HeatpumpSystems.Base;
record HeatPumpSystemPropertiesMatrix "Heatpump System properties defined by a real matrix A for automatic pool simulations"
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
  extends TransiEnt.Producer.Heat.Power2Heat.Components.HeatpumpSystemProperties(
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
  parameter Real[nPar] A "Input matrix full of real values";

end HeatPumpSystemPropertiesMatrix;
