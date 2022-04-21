within TransiEnt.Grid.Electrical.LumpedPowerGrid.Check;
model TestLumpedGrid_PrimaryResponse
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

  LumpedGrid lumpedGrid annotation (Placement(transformation(extent={{-30,-2},{-10,18}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantFrequency_L1_1(useInputConnector=true) annotation (Placement(transformation(extent={{22,-2},{42,18}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    k=1,
    T=5,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=50) annotation (Placement(transformation(extent={{22,34},{42,54}})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,50; 3600,50; 43000,50.2; 53000,50.2; 100000,49.8; 110000,49.8])
    annotation (Placement(transformation(extent={{-8,34},{12,54}})));
  inner SimCenter            simCenter(         thres=1e-9,
    useThresh=true,
    Td=450,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    P_n_ref_1=4e9)
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner ModelStatistics           modelStatistics
    annotation (Placement(transformation(extent={{-80,100},{-60,80}})));
equation
  connect(firstOrder.y,constantFrequency_L1_1. f_set) annotation (Line(points={{43,44},{50,44},{50,28},{26.6,28},{26.6,20}},color={0,0,127}));
  connect(timeTable1.y,firstOrder. u) annotation (Line(points={{13,44},{16.5,44},{20,44}}, color={0,0,127}));
  connect(lumpedGrid.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{-10,8},{8,8},{8,8},{22,8}},
      color={0,135,135},
      thickness=0.5));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(no remarks)</p>
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
end TestLumpedGrid_PrimaryResponse;
