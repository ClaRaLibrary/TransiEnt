within TransiEnt.Storage.Heat.Check;
model CheckHeatStorage_L0
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

  inner TransiEnt.SimCenter simCenter(heatingCurve(T_supply_const=338.15))
                                      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  TransiEnt.Storage.Heat.HeatStorage_L2 storage(
    m_flow_nom=1000,
    T_max=393.15,
    temperatureGenIn(unitOption=2),
    temperatureGenOut(unitOption=2),
    temperatureGridOut(unitOption=2),
    temperatureGridIn(unitOption=2),
    T_start=75) annotation (Placement(transformation(extent={{-26,-22},{26,26}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    T_const=40 + 273,
    m_flow_const=10,
    variable_m_flow=false)
                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={38,-18})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={54,22})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source1(
    T_const=95 + 273,
    variable_m_flow=false,
    variable_T=true,
    m_flow_const=10)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-38,22})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-44,-18})));
  Modelica.Blocks.Sources.Constant T_stor_set(k=65 + 273.15)
                                                  annotation (Placement(transformation(extent={{-96,-24},{-76,-4}})));
  Modelica.Blocks.Continuous.LimPID PI(
    yMax=95,
    yMin=20,
    k=1e4,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
                                       annotation (Placement(transformation(extent={{-80,18},{-60,38}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureGridOut(medium=simCenter.fluid1, unitOption=1) annotation (Placement(transformation(extent={{16,30},{36,50}})));
  Modelica.Thermal.HeatTransfer.Celsius.FromKelvin T_stor_set_degC annotation (Placement(transformation(extent={{-62,-66},{-42,-46}})));
equation
  connect(storage.fpGridIn, source.steam_a) annotation (Line(
      points={{13.52,-17.2},{20.76,-17.2},{20.76,-18},{28,-18}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(storage.fpGridOut, sink.steam_a) annotation (Line(
      points={{16.12,21.68},{21.06,21.68},{21.06,22},{44,22}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));

  connect(sink1.steam_a, storage.fpGenOut) annotation (Line(
      points={{-34,-18},{-16.64,-18},{-16.64,-17.68}},
      color={0,131,169},
      thickness=0.5));
  connect(storage.fpGenIn, source1.steam_a) annotation (Line(
      points={{-16.12,21.2},{-28,21.2},{-28,22}},
      color={175,0,0},
      thickness=0.5));
  connect(storage.fpGridOut, temperatureGridOut.port) annotation (Line(
      points={{16.12,21.68},{26,21.68},{26,30}},
      color={175,0,0},
      thickness=0.5));
  connect(T_stor_set.y, T_stor_set_degC.Kelvin) annotation (Line(points={{-75,-14},{-70,-14},{-70,-56},{-64,-56}}, color={0,0,127}));
  connect(T_stor_set.y, PI.u_s) annotation (Line(points={{-75,-14},{-70,-14},{-70,6},{-94,6},{-94,28},{-82,28}}, color={0,0,127}));
  connect(PI.u_m, storage.T_stor_out) annotation (Line(points={{-70,16},{-70,10},{-88,10},{-88,48},{0,48},{0,24.08}}, color={0,0,127}));
  connect(PI.y, source1.T) annotation (Line(points={{-59,28},{-54,28},{-54,22},{-50,22}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput,
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end CheckHeatStorage_L0;
