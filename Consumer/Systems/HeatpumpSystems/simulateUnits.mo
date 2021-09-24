within TransiEnt.Consumer.Systems.HeatpumpSystems;
function simulateUnits "Function that allows to simulate N uncoordinated heat pump systems in series using parameter values from a N x 24 mat file"

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




  input TransiEnt.Basics.Types.Poolsize N=100 annotation (Dialog=true, choicesAllMatching);

  final parameter Real A[N,24]=readMatrix(
      Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.PUBLIC_DATA) + "electricity/HeatpumpSystemPool/" + "heatpumpSystem_N" + String(N) + ".mat",
      "A",
      N,
      24);

     parameter String resultFileName = "HPS_BivTest";

     constant Real tend=31622400;
     constant Real dt=900;
protected
          String simulationCall;
public
                 output Boolean
          success;

algorithm
 for i in 1:size(A,1) loop
  Modelica.Utilities.Streams.print(">> Starting Simulation of unit with Q_flow_n_Heatpump=" + String(A[i,1]));

  simulationCall:="TransiEnt.Consumer.DemandSideManagement.HeatpumpSystems.simulateUnit(HeatPumpSystem(params(A={";

  //print component vector & values
  for j in 1:size(A,2)-1 loop
    simulationCall:=simulationCall + String(A[i, j]) + ",";
  end for;
  simulationCall:=simulationCall + String(A[i, size(A,2)]);
  simulationCall:=simulationCall + "})))";

  Modelica.Utilities.Streams.print(simulationCall);
  success:=DymolaCommands.SimulatorAPI.simulateModel(simulationCall, stopTime=tend,outputInterval=dt, tolerance=1e-005, resultFile=resultFileName + "_"+String(i));

 end for;
 annotation(__Dymola_interactive=true);
end simulateUnits;
