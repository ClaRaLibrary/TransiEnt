within TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics;
record Generic_PQ_Characteristics "(Empty)"
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

  parameter Real PQboundaries[:,3] "Limits of electric power for given thermal power output";
  parameter Real PQ_HeatInput_Matrix[:,10] "Heat input demand for given thermal and electric power setpoint";

  parameter Real k_Q_flow = 1 "Allows to scale Q_flow (= 1/Q_flow_nom for generic pq diagrams)";
  parameter Real k_P_el = 1 "Allows to scale P_el (= P_el_n for use of generic pq diagrams)";

end Generic_PQ_Characteristics;
