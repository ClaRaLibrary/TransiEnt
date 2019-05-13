within TransiEnt.Basics.Blocks.Check;
model TestDiscretizePrediction "Model for testing the DiscretizePrediction model"
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
    extends Icons.Checkmodel;

  Modelica.Blocks.Sources.Cosine P_load(
    freqHz=1/86400,
    startTime=0,
    amplitude=400e6,
    offset=1.8e9,
    phase(displayUnit="rad") = Modelica.Constants.pi) annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  Modelica.Blocks.Sources.Cosine P_pred_1h(
    freqHz=1/86400,
    startTime=0,
    amplitude=400e6,
    offset=1.8e9,
    phase=2*Modelica.Constants.pi*(0.5 + 1/24)) "1 hour ahead"
                                                           annotation (Placement(transformation(extent={{-30,22},{-10,42}})));
  Grid.Electrical.EconomicDispatch.DiscretizePrediction discretizePrediction annotation (Placement(transformation(extent={{0,-16},{20,4}})));
equation
  connect(discretizePrediction.P_is, P_load.y) annotation (Line(points={{-2,-6},{-15,-6}},color={0,0,127}));
  connect(discretizePrediction.P_prediction, P_pred_1h.y) annotation (Line(points={{10,6},{12,6},{12,32},{-9,32}}, color={0,0,127}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Interval=900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for DiscretizePrediction</p>
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
</html>"));
end TestDiscretizePrediction;
