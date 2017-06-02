within TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Components.Base;
function getFileName
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
  extends Basics.Icons.Function;
  import TransiEnt.Basics.Types;
  input Types.Poolsize poolsize;
  output String filename;
algorithm
  if poolsize == Types.N1 then
    filename:=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Types.PUBLIC_DATA) + "fridgePool_N1.mat");
  elseif poolsize ==Types.N20 then
    filename:="fridgePool_N20.mat";
  elseif poolsize ==Types.N100 then
    filename:="fridgePool_N100.mat";
  end if;
end getFileName;