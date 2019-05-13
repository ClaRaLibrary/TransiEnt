within TransiEnt.Producer.Electrical.Others.Check;
model TestPumpedStoragePlant_Gradients
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

  function plotResult

    constant String resultFileName = "TestPumpedStoragePlant_Gradients.mat";

    output String resultFile;
  protected
              Boolean ok;

  algorithm
    clearlog();
    assert(not Modelica.Utilities.Strings.isEmpty(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
    resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
    ok:=simulateModel("TransiEnt.Producer.Electrical.Others.Check.TestPumpedStoragePlant_Gradients", stopTime=30000, numberOfIntervals=0, outputInterval=60, method="dassl", resultFile=resultFileName);
    removePlots();
    createPlot(id=1, position={733, 0, 715, 842}, y={"PS.epp.P", "sched.y"}, range={0.0, 30000.0, -80000000.0, 60000000.0}, grid=true, filename=resultFileName, colors={{28,108,200}, {238,46,47}});

    if ok then
      resultFile := "Successfully plotted results for file: " + resultFile;
    else
      resultFile := "An error occured, see Message Window for details";
      showMessageWindow(true);
    end if;

  end plotResult;

  TransiEnt.Components.Boundaries.Electrical.Frequency Grid(useInputConnector=false) annotation (Placement(transformation(extent={{30,-15},{50,5}})));
  inner TransiEnt.SimCenter simCenter(Td=0.01, thres=1e-9)
                                      annotation (Placement(transformation(extent={{-90,80},
            {-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},
            {-40,100}})));
  Modelica.Blocks.Sources.Step sched(startTime=1e3, height=-PS.P_el_n) annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  PumpedStoragePlant PS(
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    P_init_set=0,
    t_startup=60,
    P_grad_max_star=simCenter.generationPark.P_grad_max_star_PS) annotation (Placement(transformation(extent={{-22,-21},{-2,-1}})));
equation

  connect(PS.epp, Grid.epp) annotation (Line(
      points={{-3,-4},{30,-4},{30,-5}},
      color={0,135,135},
      thickness=0.5));
  connect(sched.y, PS.P_el_set) annotation (Line(points={{-29,10},{-13.5,10},{-13.5,-1.1}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{22,92},{62,38}},
          lineColor={0,0,0},
          textString="Look at:
PS.epp.P
sched.y

=> The startup 
time is 60s, 
the max. gradient 
is 1/60s ")}),
    experiment(
      StopTime=1500,
      Interval=10,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(executeCall=TransiEnt.Producer.Electrical.Others.Check.TestPumpedStoragePlant_Gradients.run() "Run example"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for pumped storage plants</p>
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
end TestPumpedStoragePlant_Gradients;
