within TransiEnt.Storage.Heat.HotWaterStorage_L4.Checks;
model Test_FluidVolume_02 "Testing fluid volume"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//
  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-94,74},{-74,94}})));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1;

  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    m_flow_nom=5,
    m_flow_const=1,
    T_const=330) annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    p_const(displayUnit="bar") = 100000,
    T_const=300,
    variable_T=false) annotation (Placement(transformation(extent={{84,-10},{64,10}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperature1 annotation (Placement(transformation(extent={{28,14},{48,34}})));
  Base.Fluid_Volume fluid_Volume(V_const=1, h_start=300000) annotation (Placement(transformation(extent={{-20,20},{12,54}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperature annotation (Placement(transformation(extent={{-60,18},{-40,38}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=
        4180)
    annotation (Placement(transformation(extent={{-38,64},{-18,84}})));
equation

  connect(fluid_Volume.ports[1], source.steam_a) annotation (Line(
      points={{-4,20.34},{-4,0},{-76,0}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fluid_Volume.ports[2], sink.steam_a) annotation (Line(
      points={{-4,20.34},{-4,0},{64,0}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fluid_Volume.ports[2], temperature1.port) annotation (Line(
      points={{-4,20.34},{-4,8},{38,8},{38,14}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fluid_Volume.ports[1], temperature.port) annotation (Line(
      points={{-4,20.34},{-4,6},{-50,6},{-50,18}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fixedHeatFlow.port, fluid_Volume.heatPort) annotation (Line(
      points={{-18,74},{-4,74},{-4,53.32}},
      color={191,0,0},
      smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),        graphics),
    experiment(StopTime=8000, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for FluidVolume with a fixed heat flow </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end Test_FluidVolume_02;
