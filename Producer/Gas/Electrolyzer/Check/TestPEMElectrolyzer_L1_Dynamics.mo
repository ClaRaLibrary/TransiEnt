within TransiEnt.Producer.Gas.Electrolyzer.Check;
model TestPEMElectrolyzer_L1_Dynamics "Tester for a PEM electrolyzer"
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
  import TransiEnt;
  import SI = Modelica.SIunits;

//protected
  function plotResult

  constant String resultFileName = "TestPEMElectrolyzer_L1_Dynamics.mat";

  output String resultFile;

  algorithm
    clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
    resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
    removePlots(false);
    createPlot(id=1, position={0, 0, 1563, 749}, y={"electrolyzer_0thOrder.dynamics.H_flow_H2", "electrolyzer_1stOrder.dynamics.H_flow_H2","electrolyzer_2ndOrder.dynamics.H_flow_H2"},range={0.0,52.0,-100000.0,1100000.0},erase=false,grid=true,filename=resultFile,colors={{28,108,200},{238,46,47},{0,140,72}});
  end plotResult;

public
  parameter SI.Power P_el_n=1e6 "Nominal electrical power of the electrolyzer";
  parameter SI.Power P_el_min=0.05*P_el_n "Minimal electrical power of the electrolyzer";
  parameter SI.Power P_el_max=1.0*P_el_n "Maximal electrical power of the electrolyzer";
  parameter SI.Temperature T_out=273.15+15 "Temperature of the produced hydrogen";
  parameter SI.Efficiency eta_n=0.75 "Nominal efficiency of the electrolyzer";
  parameter SI.Pressure p_out=50e5 "Pressure of the produced hydrogen";

  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer_0thOrder(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    usePowerPort=true,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Electrolyzer_2035,
    Cspec_demAndRev_el=simCenter.Cspec_demAndRev_el_70_150_GWh,
    Cspec_demAndRev_other=simCenter.Cspec_demAndRev_other_water) annotation (Placement(transformation(extent={{0,20},{20,40}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid_0thOrder annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,30})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_0thOrder(p_const=p_out) annotation (Placement(transformation(extent={{60,20},{40,40}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer_1stOrder(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    usePowerPort=true,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics1stOrder,
    redeclare model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Electrolyzer_2035,
    Cspec_demAndRev_el=simCenter.Cspec_demAndRev_el_70_150_GWh,
    Cspec_demAndRev_other=simCenter.Cspec_demAndRev_other_water) annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid_1stOrder annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-10})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_1stOrder(p_const=p_out) annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel1, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3)
                                                                       annotation (Placement(transformation(extent={{70,80},{90,100}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer_2ndOrder(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    usePowerPort=true,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics2ndOrder,
    redeclare model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Electrolyzer_2035,
    Cspec_demAndRev_el=simCenter.Cspec_demAndRev_el_70_150_GWh,
    Cspec_demAndRev_other=simCenter.Cspec_demAndRev_other_water) annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid_2ndOrder annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-50})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_2ndOrder(p_const=p_out) annotation (Placement(transformation(extent={{60,-60},{40,-40}})));
  Modelica.Blocks.Sources.Step step(
    offset=0,
    height=P_el_max - P_el_min,
    startTime=10)                   annotation (Placement(transformation(extent={{-100,42},{-80,62}})));
  Modelica.Blocks.Sources.Step step1(              height=-(P_el_max - P_el_min), startTime=30)
                                     annotation (Placement(transformation(extent={{-100,12},{-80,32}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=2) annotation (Placement(transformation(extent={{-60,44},{-48,56}})));
  inner TransiEnt.ModelStatistics                                         modelStatisticsDetailed annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(ElectricGrid_1stOrder.epp, electrolyzer_1stOrder.epp) annotation (Line(
      points={{-20,-10},{0,-10},{0,-10}},
      color={0,135,135},
      thickness=0.5));
  connect(ElectricGrid_2ndOrder.epp, electrolyzer_2ndOrder.epp) annotation (Line(
      points={{-20,-50},{0,-50},{0,-50}},
      color={0,135,135},
      thickness=0.5));
  connect(multiSum.y, electrolyzer_1stOrder.P_el_set) annotation (Line(points={{-46.98,50},{-10,50},{-10,2},{6,2}},        color={0,0,127}));
  connect(electrolyzer_2ndOrder.P_el_set, multiSum.y) annotation (Line(points={{6,-38},{-10,-38},{-10,50},{-46.98,50}},    color={0,0,127}));
  connect(sink_1stOrder.gasPort, electrolyzer_1stOrder.gasPortOut) annotation (Line(
      points={{40,-10},{20,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(sink_2ndOrder.gasPort, electrolyzer_2ndOrder.gasPortOut) annotation (Line(
      points={{40,-50},{40,-50},{20,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(step.y, multiSum.u[1]) annotation (Line(points={{-79,52},{-70,52},{-70,52.1},{-60,52.1}}, color={0,0,127}));
  connect(step1.y, multiSum.u[2]) annotation (Line(points={{-79,22},{-70,22},{-70,48},{-64,48},{-60,48},{-60,47.9}},
                                                                                                 color={0,0,127}));
  connect(ElectricGrid_0thOrder.epp, electrolyzer_0thOrder.epp) annotation (Line(
      points={{-20,30},{0,30},{0,30}},
      color={0,135,135},
      thickness=0.5));
  connect(electrolyzer_2ndOrder.P_el_set, multiSum.y) annotation (Line(points={{6,-38},{-10,-38},{-10,50},{-46.98,50}},    color={0,0,127}));
  connect(electrolyzer_0thOrder.P_el_set, multiSum.y) annotation (Line(points={{6,42},{6,42},{-10,42},{-10,50},{-46.98,50}},
                                                                                                               color={0,0,127}));
  connect(sink_0thOrder.gasPort, electrolyzer_0thOrder.gasPortOut) annotation (Line(
      points={{40,30},{30,30},{20,30}},
      color={255,255,0},
      thickness=1.5));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{0,92},{72,62}},
          lineColor={0,140,72},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="P_el_n=1 MW
P_el_min=0.05 MW
P_el_max=1 MW
eta_n=0.75
T_out=15 C
p_out=50 bar
costs for electrolyzers in 2035
with electricity price 103.3 EUR/MWh")}),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(executeCall=TransiEnt.Components.Convertor.Power2Gas.Check.TestPEMElectrolyzer_L1_Dynamics.plotResult() "Plot example results"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for PEMElectrolyzer_L1_Dynamics</p>
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
end TestPEMElectrolyzer_L1_Dynamics;
