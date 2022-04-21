within TransiEnt.Consumer.Gas.Check;
model Test_GasDemandProfiler



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


  TransiEnt.Consumer.Gas.GasDemandProfiler gasDemand(
    NCV_in=0,
    GCV_in=0,
    Q_a(displayUnit="TWh") = 0.56*23e9*3.6e6,
    gasDemand_base_a=0,
    mFlowOut=true) annotation (Placement(transformation(extent={{-22,46},{28,96}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_Fuhlsbuettel_172800s_2012 temperatureHH_2d annotation (Placement(transformation(extent={{-94,-6},{-74,14}})));
  TransiEnt.Consumer.Gas.GasDemandProfiler gasDemand1(
    NCV_in=0,
    GCV_in=0,
    gasDemand_base_a=1.838698E+16,
    Q_a(displayUnit="TWh") = 0.56*23e9*3.6e6) annotation (Placement(transformation(extent={{-22,-20},{28,28}})));
  TransiEnt.Consumer.Gas.GasDemandProfiler gasDemand2(
    NCV_in=0,
    GCV_in=0,
    gasDemand_base_a=1.838698E+16,
    Q_a(displayUnit="TWh") = 0.56*23e9*3.6e6,
    variableBaseDemand=true) annotation (Placement(transformation(extent={{-24,-90},{28,-40}})));
equation
  connect(temperatureHH_2d.y1, gasDemand1.T_amb) annotation (Line(points={{-73,4},{-23,4}}, color={0,0,127}));
  connect(temperatureHH_2d.y1, gasDemand.T_amb) annotation (Line(points={{-73,4},{-50,4},{-50,71},{-23,71}}, color={0,0,127}));
  connect(temperatureHH_2d.y1, gasDemand2.T_amb) annotation (Line(points={{-73,4},{-50,4},{-50,-65},{-25.04,-65}}, color={0,0,127}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=3.1536e+007,
      Interval=900,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput(events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for GasDemandProfiler.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
<p>Created by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end Test_GasDemandProfiler;
