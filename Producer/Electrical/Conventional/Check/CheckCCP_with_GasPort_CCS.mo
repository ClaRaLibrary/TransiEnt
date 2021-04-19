within TransiEnt.Producer.Electrical.Conventional.Check;
model CheckCCP_with_GasPort_CCS
    import TransiEnt;
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Grid.Electrical.Base.ExampleGenerationPark generationPark)
                                      annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantPotentialVariableBoundary(useInputConnector=false) annotation (Placement(transformation(extent={{70,14},{90,34}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi annotation (Placement(transformation(extent={{88,-10},{68,10}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  TransiEnt.Producer.Electrical.Conventional.CCP_with_Gasport cCP_with_Gasport(
    isSecondaryControlActive=false,
    P_el_n=1000e6,
    MinimumDownTime(displayUnit="s") = 19000,
    eta_total=0.615,
    EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.CCGTButtler(),
    CCS_Characteristics=TransiEnt.Producer.Electrical.Base.CCS.CCP_PCC())
                                                                        annotation (Placement(transformation(extent={{-8,-16},{12,4}})));
  TransiEnt.Producer.Electrical.Conventional.CCP_with_Gasport cCP_with_Gasport1(
    isSecondaryControlActive=false,
    P_el_n=1000e6,
    MinimumDownTime(displayUnit="s") = 19000,
    eta_total=0.615,
    EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.CCGTButtler(),
    CCS_Characteristics=TransiEnt.Producer.Electrical.Base.CCS.CCP_PCC(),
    CO2_Deposition_Rate=0.5,
    P_init_set=870e6) annotation (Placement(transformation(extent={{-8,-54},{12,-34}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=1.5e4,
    duration=20e4,
    height=0,
    offset=-1e9)            annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  TransiEnt.Producer.Electrical.Conventional.CCP_with_Gasport cCP_with_Gasport2(
    isSecondaryControlActive=false,
    P_el_n=1000e6,
    MinimumDownTime(displayUnit="s") = 19000,
    eta_total=0.615,
    EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.CCGTButtler(),
    CCS_Characteristics=TransiEnt.Producer.Electrical.Base.CCS.CCP_PCC(),
    CO2_Deposition_Rate=0.9,
    P_init_set=870e6) annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi1
                                                                         annotation (Placement(transformation(extent={{44,38},{24,58}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=10000) annotation (Placement(transformation(extent={{-80,-54},{-60,-34}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(cCP_with_Gasport.epp, constantPotentialVariableBoundary.epp) annotation (Line(
      points={{11,1},{34,1},{34,24},{70,24}},
      color={0,135,135},
      thickness=0.5));
  connect(cCP_with_Gasport.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{12,-10},{48,-10},{48,0},{68,0}},
      color={255,255,0},
      thickness=1.5));
  connect(cCP_with_Gasport1.epp, constantPotentialVariableBoundary.epp) annotation (Line(
      points={{11,-37},{34,-37},{34,24},{70,24}},
      color={0,135,135},
      thickness=0.5));
  connect(cCP_with_Gasport1.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{12,-48},{48,-48},{48,0},{68,0}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp.y, cCP_with_Gasport.P_el_set) annotation (Line(points={{-59,-10},{-40,-10},{-40,6},{0.5,6},{0.5,3.9}},   color={0,0,127}));
  connect(ramp.y, cCP_with_Gasport1.P_el_set) annotation (Line(points={{-59,-10},{-40,-10},{-40,-34.1},{0.5,-34.1}}, color={0,0,127}));
  connect(cCP_with_Gasport2.epp, constantPotentialVariableBoundary.epp) annotation (Line(
      points={{11,-73},{34,-73},{34,24},{70,24}},
      color={0,135,135},
      thickness=0.5));
  connect(cCP_with_Gasport2.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{12,-84},{48,-84},{48,0},{68,0}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp.y, cCP_with_Gasport2.P_el_set) annotation (Line(points={{-59,-10},{-40,-10},{-40,-70.1},{0.5,-70.1}},  color={0,0,127}));
  connect(cCP_with_Gasport.gasPortOut_CDE, boundary_pTxi1.gasPort) annotation (Line(
      points={{12,-2},{24,-2},{24,48}},
      color={255,255,0},
      thickness=1.5));
  connect(cCP_with_Gasport1.gasPortOut_CDE, boundary_pTxi1.gasPort) annotation (Line(
      points={{12,-40},{24,-40},{24,48}},
      color={255,255,0},
      thickness=1.5));
  connect(cCP_with_Gasport2.gasPortOut_CDE, boundary_pTxi1.gasPort) annotation (Line(
      points={{12,-76},{24,-76},{24,48}},
      color={255,255,0},
      thickness=1.5));
  connect(booleanPulse.y, cCP_with_Gasport1.useCCS) annotation (Line(points={{-59,-44},{-10,-44}}, color={255,0,255}));
  connect(booleanConstant.y, cCP_with_Gasport2.useCCS) annotation (Line(points={{-59,-80},{-10,-80}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=360000, Interval=60));
end CheckCCP_with_GasPort_CCS;
