within TransiEnt.Storage.Heat.HotWaterStorage_L2.Check;
model Check_HotWaterStorage_L2 "Minimal test model for stratified hot water storage L1 model"
  import TransiEnt;


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
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow SourceConsumerSide(
    m_flow_const=0.2,
    variable_m_flow=true,
    T_const=20 + 273.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,-60})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow SourceHeatingSide(
    variable_m_flow=false,
    T_const=80 + 273.15,
    variable_T=true,
    m_flow_const=0.3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-54,-10})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi SinkHeatingSide(h_const=1000e3, p_const=1e5) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-58,-60})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi SinkConsumerSide(h_const=1000e3, p_const=1e5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={48,-24})));
Modelica.Blocks.Sources.Step T_gen(
    startTime=4*3600,
    height=10,
    offset=273.15 + 80)    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Step MassFlowStep(
    height=-0.02,
    offset=0.2,
    startTime=15*3600) annotation (Placement(transformation(extent={{96,-8},{76,12}})));
  TransiEnt.Storage.Heat.HotWaterStorage_L2.HotWaterStorage_L2 Storage annotation (Placement(transformation(extent={{-24,-64},{28,-20}})));
equation
  connect(T_gen.y, SourceHeatingSide.T) annotation (Line(
      points={{-79,-10},{-66,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MassFlowStep.y, SourceConsumerSide.m_flow) annotation (Line(
      points={{75,2},{68,2},{68,-54},{62,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Storage.GenOut, SinkHeatingSide.steam_a) annotation (Line(
      points={{-14.64,-60.04},{-14.64,-60.1},{-48,-60.1},{-48,-60}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Storage.ConOut, SinkConsumerSide.steam_a) annotation (Line(
      points={{20.2,-23.96},{32,-23.96},{32,-24},{38,-24}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Storage.GenIn, SourceHeatingSide.steam_a) annotation (Line(
      points={{-14.12,-24.4},{-14,-24.4},{-14,-10},{-44,-10}},
      color={175,0,0},
      thickness=0.5));
  connect(Storage.ConIn, SourceConsumerSide.steam_a) annotation (Line(
      points={{16.56,-59.6},{40,-59.6},{40,-60}},
      color={175,0,0},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics={Text(
          extent={{-32,86},{56,44}},
          lineColor={0,0,255},
          textString="Look at:
Storage.ConOut_State.T
Storage.ConIn_State.T
Storage.T_stor

Storage.m_flow_con")}),
      experiment(StopTime=86400),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Tester for HotWaterStorage_L2</span></p>
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
end Check_HotWaterStorage_L2;
