within TransiEnt.Producer.Electrical.Wind.Check;
model Test_WTG_SI_df_dt "Validation of WTG with df/dt SI control"
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
  Modelica.Blocks.Sources.Ramp frequenz(
    duration=10,
    height=-1,
    offset=50,
    startTime=10)
    annotation (Placement(transformation(extent={{34,44},{54,64}})));
  TransiEnt.Producer.Electrical.Wind.Windturbine_SI_dfdt WTG_1(
    controllerType_p=Modelica.Blocks.Types.SimpleController.PID,
    yMax_p=30,
    use_v_wind_input=true,
    operationRanges=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.WindSpeedOperationRanges(),
    turbineCharacteristics=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.MOD2(),
    Rotor(turbineCharacteristics=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.VariableWTG_WU()),
    pitchController(PitchController(y_start=9, initType=Modelica.Blocks.Types.InitPID.InitialState)),
    Ti_p=12,
    Td_p=3,
    k_p=0.8e-5,
    beta_start=0,
    v_wind_start=9,
    use_inertia=true,
    P_el_n=3300000,
    integratePower=false)
                    annotation (Placement(transformation(extent={{-2,6},{18,28}})));

  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid(useInputConnector=true) annotation (Placement(transformation(extent={{58,12},{78,32}})));
  Modelica.Blocks.Sources.Constant Wind_konst(k=9)
    annotation (Placement(transformation(extent={{-70,12},{-50,32}})));

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},
            {-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},
            {-40,100}})));
  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation
  connect(WTG_1.epp, ElectricGrid.epp) annotation (Line(
      points={{17,23},{30,23},{30,22},{58,22}},
      color={0,135,135},
      thickness=0.5));
  connect(frequenz.y, ElectricGrid.f_set) annotation (
      Line(points={{55,54},{62.6,54},{62.6,34}}, color={0,0,127}));
  connect(Wind_konst.y, WTG_1.v_wind) annotation (Line(points={{-49,22},{-34,22},{-0.9,22},{-0.9,22.1}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "Test_WTG_SI_df_dt.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 681}, y={"WTG_1.epp.f"}, range={0.0, 100.0, 48.800000000000004, 50.2}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 338}, y={"WTG_1.P_el_is"}, range={0.0, 100.0, 1200000.0, 2200000.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (
    experiment(StopTime=100, __Dymola_NumberOfIntervals=1000),
    __Dymola_experimentSetupOutput,
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for wind turbines with  df/dt SI control</p>
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
end Test_WTG_SI_df_dt;
