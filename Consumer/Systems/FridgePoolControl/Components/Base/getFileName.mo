within TransiEnt.Consumer.Systems.FridgePoolControl.Components.Base;
function getFileName


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




  extends Basics.Icons.Function;
  import TransiEnt.Basics.Types;
  input Types.Poolsize poolsize;
  output String filename;
algorithm
  if poolsize == Types.N1 then
    filename:=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Types.PUBLIC_DATA) + "electricity/FridgePool/fridgePool_N1.mat");
  elseif poolsize ==Types.N20 then
    filename:=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Types.PUBLIC_DATA) + "electricity/FridgePool/fridgePool_N20.mat");
  elseif poolsize ==Types.N100 then
    filename:=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Types.PUBLIC_DATA) + "electricity/FridgePool/fridgePool_N100.mat");
  end if;
end getFileName;
