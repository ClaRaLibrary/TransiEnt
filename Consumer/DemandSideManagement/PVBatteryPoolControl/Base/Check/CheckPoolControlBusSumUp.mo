within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Base.Check;
model CheckPoolControlBusSumUp
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
extends TransiEnt.Basics.Icons.Checkmodel;

model Unit "Unit model just for this tester"
  extends TransiEnt.Basics.Icons.Model;
  Base.PoolControlBus bus;
  Modelica.Blocks.Interfaces.RealInput value=index*10;
  Modelica.Blocks.Interfaces.RealInput dummyValue=0;
  parameter Integer index;
    outer PoolParameter param;
equation
  for i in 1:param.nSystems loop
    if i == index then
      connect(bus.P_potential_pbp[index], value);
    else
      connect(bus.P_potential_pbp[i], dummyValue);
    end if;
  end for;
end Unit;

model Controller "Controller model just for this tester"
  extends TransiEnt.Basics.Icons.Controller;
  Modelica.Blocks.Interfaces.RealInput setpoint=1;
  Base.PoolControlBus bus;
    outer PoolParameter param;
equation
  for i in 1:param.nSystems loop
    connect(bus.P_el_set_pbp[i], setpoint);
  end for;

end Controller;

parameter Integer nUnits = 10;
Unit unit[nUnits](index=1:nUnits) annotation (Placement(transformation(extent={{-52,-18},{-12,18}})));
Controller ctrl annotation (Placement(transformation(extent={{34,-16},{74,20}})));
  inner PoolParameter param(nSystems=nUnits);

  PoolControlBusSumUp      MultiSumUp annotation (Placement(transformation(extent={{4,-10},{24,10}})));
equation
  for i in 1:nUnits loop
    connect(unit[i].bus, MultiSumUp.poolControlBus_in[i]) annotation (Line(points={{-12,0},{-2,0},{-2,-0.98},{6.6,-0.98}}, color={0,0,127}));
  end for;
  connect(MultiSumUp.poolControlBus_out, ctrl.bus);

annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                       Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  experiment(
    StopTime=3.1536e+007,
    Interval=900,
    __Dymola_Algorithm="Lsodar"),
  __Dymola_experimentSetupOutput(
    textual=false,
    derivatives=false,
    events=false));
end CheckPoolControlBusSumUp;
