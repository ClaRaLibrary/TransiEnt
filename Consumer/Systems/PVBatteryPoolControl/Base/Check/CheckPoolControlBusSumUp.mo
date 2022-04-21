within TransiEnt.Consumer.Systems.PVBatteryPoolControl.Base.Check;
model CheckPoolControlBusSumUp


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

annotation (Diagram(graphics,
                    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                       Icon(graphics,
                                            coordinateSystem(extent={{-100,-100},{100,100}})),
  experiment(
    StopTime=3.1536e+007,
    Interval=900,
    __Dymola_Algorithm="Lsodar"),
  __Dymola_experimentSetupOutput(
    textual=false,
    derivatives=false,
    events=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for PoolControlBusSumUp. See this model for further information: TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Base.PoolControlBusSumUp</p>
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
</html>"));
end CheckPoolControlBusSumUp;
