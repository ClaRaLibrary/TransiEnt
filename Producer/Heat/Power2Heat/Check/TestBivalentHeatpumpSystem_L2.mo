within TransiEnt.Producer.Heat.Power2Heat.Check;
model TestBivalentHeatpumpSystem_L2 "Model for testing BivalentHeatpumpSystem_L2"
  import TransiEnt;
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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
  inner SimCenter simCenter(ambientConditions(redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperature))
                            annotation (Placement(transformation(extent={{-98,80},{-78,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=1.2e5,
    T_const=45 + 273.15)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={44,31})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    variable_m_flow=false,
    T_const=35 + 273,
    m_flow_const=hps.params.Q_flow_n_heatpump/(4.2e3*20))
                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={46,-22})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency electricGrid(useInputConnector=false) annotation (Placement(transformation(extent={{32,62},{52,82}})));
  TransiEnt.Producer.Heat.Power2Heat.BivalentHeatpumpSystem hps(
    T_out(unitOption=1),
    Heatpump(heatFlowBoundary(change_sign=true)),
    params(
      t_min_off_heatpump=300,
      T_feed_ref_degC=45,
      T_bivalent=265.15,
      DTdb_heatpump=5,
      t_min_on_heatpump=300)) annotation (Placement(transformation(extent={{-12,-6},{8,14}})));
  Modelica.Blocks.Sources.Ramp T_feed_set(
    offset=35 + 273.15,
    startTime=0,
    duration=80000,
    height=5) annotation (Placement(transformation(extent={{-62,-6},{-42,14}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-78,80},{-58,100}})));
equation
  connect(hps.inlet, source.steam_a) annotation (Line(
      points={{8,-1},{46,-1},{46,-12}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(hps.outlet, sink.steam_a) annotation (Line(
      points={{8,9},{44,9},{44,21}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(electricGrid.epp, hps.epp) annotation (Line(
      points={{32,72},{32,72},{8,72},{8,12}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(T_feed_set.y, hps.T_feed_set) annotation (Line(
      points={{-41,4},{-26,4},{-26,4.2},{-12,4.2}},
      color={0,0,127},
      smooth=Smooth.None));
public
function plotResult

  constant String resultFileName = "TestBivalentHeatpumpSystem_L2.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=1, position={0, 0, 1541, 851}, y={"hps.Heatpump.feedback.y", "hps.Heatpump.Controller.uLow", "hps.Heatpump.Controller.uHigh"}, range={0.0, 50000.0, -20.0, 5.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFileName);
  createPlot(id=1, position={0, 0, 1541, 209}, y={"hps.Heatpump.Q_flow.y"}, range={0.0, 50000.0, -2000.0, 6000.0}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFileName);
  createPlot(id=1, position={0, 0, 1541, 209}, y={"T_feed_set.y", "hps.T_out.T"}, range={0.0, 50000.0, 305.0, 330.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}},filename=resultFileName);
  createPlot(id=1, position={0, 0, 1541, 209}, y={"hps.COP"}, range={0.0, 50000.0, 1.5, 1.6}, grid=true, subPlot=4, colors={{28,108,200}},filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), experiment(StopTime=86400, __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for BivalentHeatPumpSystem_L2</p>
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
end TestBivalentHeatpumpSystem_L2;
