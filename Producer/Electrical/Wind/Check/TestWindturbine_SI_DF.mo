within TransiEnt.Producer.Electrical.Wind.Check;
model TestWindturbine_SI_DF "Validation WTG with delta f SI control"
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
  TransiEnt.Producer.Electrical.Wind.Windturbine_SI_DF WTG_1(
    controllerType_p=Modelica.Blocks.Types.SimpleController.PID,
    use_v_wind_input=true,
    use_inertia=true,
    P_el_n=3.6e6,
    D_Rotor=100,
    J=12e6,
    turbineCharacteristics=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.VariableWTG_WU(),
    operationRanges=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.WindSpeedOperationRanges(),
    deadbandFilter(greaterThreshold1(threshold=0)),
    beta_start=0,
    v_wind_start=9,
    integratePower=false)
                    annotation (Placement(transformation(extent={{-28,8},{-8,32}})));

  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid(useInputConnector=true) annotation (Placement(transformation(extent={{66,14},{86,34}})));

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},
            {-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},
            {-40,100}})));
  Modelica.Blocks.Sources.Constant Wind_konst(k=9)
    annotation (Placement(transformation(extent={{-70,14},{-50,34}})));
  Modelica.Blocks.Sources.Ramp frequenz(
    duration=10,
    offset=50,
    startTime=10,
    height=-1)
    annotation (Placement(transformation(extent={{34,46},{54,66}})));
  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation
  connect(WTG_1.epp, ElectricGrid.epp) annotation (Line(
      points={{-9,25},{0,25},{0,24},{66,24}},
      color={0,135,135},
      thickness=0.5));
  connect(Wind_konst.y, WTG_1.v_wind) annotation (Line(points={{-49,24},{-26.9,24},{-26.9,24.1}}, color={0,0,127}));
  connect(frequenz.y, ElectricGrid.f_set) annotation (Line(points={{55,56},{70.6,56},{70.6,36}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestWindturbine_SI_DF.mat";

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
    experiment(StopTime=100, Interval=1),
    __Dymola_experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{22,4},{88,-38}},
          lineColor={28,108,200},
          textString="Vergleich mit GE WindINERTIA

Powershaping:
K=12
T_L=T_W=1")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for wind turbines with delta f control</p>
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
end TestWindturbine_SI_DF;
