within TransiEnt.Storage.Heat.ElectricWaterHeater_constProp_L4.Check;
model CheckStratifiedElectricWaterHeater_Healy

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



  extends TransiEnt.Basics.Icons.Checkmodel;

  ElectricWaterHeater_constProp_L4 stor(
    A_wall=0.0097*stor.n,
    rho=1000,
    U=0.5,
    h=1.2,
    m=190,
    T_max=273.15 + 63,
    P_0=4.5e3,
    N_heaters=2,
    eta=1,
    v_cf=0.05,
    d=0.46,
    A_top=0.17,
    A_bottom=0.17,
    N_mix=4,
    n=20,
    isTambConst=false,
    T_inflow=273.15 + 22.6,
    i_heater={4,16},
    T_start=vector((273.15 + 64.46)*ones(stor.n, 1))) annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

  Modelica.Blocks.Sources.Pulse    WaterDrawn(
    offset=0,
    amplitude=11.36/60,
    period=3600,
    startTime=0,
    width=3.562/60*100)                            annotation (Placement(transformation(extent={{-94,-52},{-74,-32}})));
  Modelica.Blocks.Sources.BooleanConstant HeaterSwitch2(k=false) annotation (Placement(transformation(extent={{-62,33},{-42,53}})));
  Modelica.Blocks.Sources.Constant Tamb(k=273.15 + 19.7)
                                                  annotation (Placement(transformation(extent={{-74,-5},{-54,15}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{30,-12},{50,8}})));
  Modelica.Blocks.Math.Product TestSchedule annotation (Placement(transformation(extent={{-46,-58},{-26,-38}})));
  Modelica.Blocks.Sources.Step drawend(
    height=-1,
    offset=1,
    startTime=5.5*3600) annotation (Placement(transformation(extent={{-84,-86},{-64,-66}})));
  Modelica.Blocks.Sources.BooleanPulse HeaterSwitch1(period=3600, startTime=0)
    annotation (Placement(transformation(extent={{-38,60},{-18,80}})));
equation
  connect(Tamb.y, stor.Tamb_input) annotation (Line(points={{-53,5},{-8,5},{-8,6.8}},   color={0,0,127}));
  connect(ElectricGrid.epp, stor.epp) annotation (Line(
      points={{30,-2},{24,-2},{24,14},{2,14},{2,9.6}},
      color={0,135,135},
      thickness=0.5));
  connect(drawend.y, TestSchedule.u2) annotation (Line(points={{-63,-76},{-56,-76},{-56,-54},{-48,-54}}, color={0,0,127}));
  connect(WaterDrawn.y, TestSchedule.u1) annotation (Line(points={{-73,-42},{-60,-42},{-54,-42},{-48,-42}}, color={0,0,127}));
  connect(stor.m_flow, TestSchedule.y) annotation (Line(points={{-8.2,0},{-20,0},{-20,-2},{-20,-48},{-25,-48}}, color={0,0,127}));
  connect(HeaterSwitch1.y, stor.u[1]) annotation (Line(points={{-17,70},{-1.4,70},{-1.4,9.5}}, color={255,0,255}));
  connect(HeaterSwitch2.y, stor.u[2]) annotation (Line(points={{-41,43},{-34,43},{-34,44},{-1.4,44},{-1.4,8.5}}, color={255,0,255}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=25200, Interval=60),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
</html>"));
end CheckStratifiedElectricWaterHeater_Healy;
