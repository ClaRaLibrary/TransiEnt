within TransiEnt.Producer.Electrical.Photovoltaics.Check;
model Check_PhotovoltaicPlant

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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
  inner TransiEnt.SimCenter simCenter(redeclare
      TransiEnt.Components.Boundaries.Ambient.AmbientConditions_Hamburg_TMY
      ambientConditions)
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency
    ElectricGrid1
    annotation (Placement(transformation(extent={{42,-10},{62,10}})));
  PhotovoltaicPlant photovoltaicPlant
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
public
  function plotResult

    constant String resultFileName="Check_PhotovoltaicPlant.mat";

    output String resultFile;

  algorithm
    clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)),
      "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
    resultFile := TransiEnt.Basics.Functions.fullPathName(
      Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)
       + "/" + resultFileName);
    removePlots();
    createPlot(
        id=1,
        position={809,0,791,695},
        y={"photovoltaicPlant.epp.P"},
        range={0.0,300.0,9995000.0,10105000.0},
        grid=true,
        colors={{238,46,47}},
        filename=resultFile);
    resultFile := "Successfully plotted results for file: " + resultFile;

  end plotResult;
equation
  connect(photovoltaicPlant.epp, ElectricGrid1.epp) annotation (Line(
      points={{-20,0},{42,0},{42,0}},
      color={0,135,135},
      thickness=0.5));
  annotation (
    Diagram(graphics, coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=3.1536e+007, Interval=3600),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for photovoltaic plants with a constant frequency</p>
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
end Check_PhotovoltaicPlant;
