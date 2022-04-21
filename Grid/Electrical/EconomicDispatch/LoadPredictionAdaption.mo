within TransiEnt.Grid.Electrical.EconomicDispatch;
model LoadPredictionAdaption "Adaption of power point setpoints in case of load prediction errors according to Albrecht1997"



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





  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

 extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Time T_lpa=900 "Time constant of lpa block";
  parameter SI.Power P_lpa_init=0 "Initial value of lpa power";

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  Modelica.Blocks.Math.MultiSum multiSum1(nu=2) annotation (Placement(transformation(extent={{28,-6},{40,6}})));
  Modelica.Blocks.Continuous.TransferFunction H_lpa(
    b={1},
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=P_lpa_init,
    a={T_lpa,0})
               annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
  Modelica.Blocks.Math.Feedback feedback1 annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_load_is annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_load_pred annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(feedback1.y,H_lpa. u) annotation (Line(points={{-53,0},{-46,0},{-40,0}},       color={0,0,127}));
  connect(multiSum1.y,feedback1. u2) annotation (Line(points={{41.02,0},{64,0},{64,-34},{-62,-34},{-62,-8}},               color={0,0,127}));
  connect(H_lpa.y, multiSum1.u[1]) annotation (Line(points={{-17,0},{-6,0},{-6,2.1},{28,2.1}},
                                                                                             color={0,0,127}));
  connect(P_load_is, feedback1.u1) annotation (Line(points={{-120,0},{-96,0},{-70,0}}, color={0,0,127}));
  connect(P_load_pred, multiSum1.u[2]) annotation (Line(points={{0,120},{0,120},{0,8},{0,-2.1},{28,-2.1}}, color={0,0,127}));
  connect(multiSum1.y, y) annotation (Line(points={{41.02,0},{110,0},{110,0}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)),
                                                                         Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-68,88},{-76,66},{-60,66},{-68,88}}),
      Line(points={{-68,76},{-68,-92}},
        color={192,192,192}),
      Line(origin={15.333,-10.667}, points = {{-83.333,34.667},{24.667,34.667},{42.667,-71.333}}, color={0,127,127}, smooth=Smooth.Bezier),
      Rectangle(lineColor={160,160,164},
        fillColor={255,255,255},
        fillPattern=FillPattern.Backward,
        extent={{-68,-82},{34,6}}),
      Line(points={{-90,-82},{82,-82}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90,-82},{68,-74},{68,-90},{90,-82}})}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model adapts to power setpoints in case of load prediction errors</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_load_is: input for electric power in [W]</p>
<p>P_load_pred: input for electric power in [W]</p>
<p>y: Modelica RealOutput</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Grid.Electrical.EconomicDispatch.Check.TestLoadPredictionAdaption&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Vorrausschauende optimale Steuer-und Regelstrategien zur Verbesserung der Kraftwerksführung [ISBN: 3-18-361608-4 ] Albrecht, Jens; 1997 </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end LoadPredictionAdaption;
