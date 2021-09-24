within TransiEnt.Grid.Electrical.EconomicDispatch;
model ControllerMeritOrderSimple "Simple Merit Order Controller"


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import      Modelica.Units.SI;
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Integer N_stor=size(storageOrder,1) "Number of storages";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer storageOrder[:]={1,2} "Order of storages";
  parameter SI.Time T[N_stor]=fill(0,N_stor) "Time Constant";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_consDirect "Direct power consumption" annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=0,
        origin={100,80})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_prod "Power production" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,80})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el_storage_desired[N_stor] "Desired electric power of n storage units" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110}),   iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_storage_actual[N_stor] "Actual electric power of n-1 storage units" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,0})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Blocks.FirstOrder firstOrder[N_stor](Tau=T) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-70})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Power P_el_storage_desired_beforeT[N_stor]=firstOrder.u;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  P_el_storage_desired_beforeT[storageOrder[1]]=P_el_prod-P_el_consDirect;
  for i in 2:size(storageOrder,1) loop
    P_el_storage_desired_beforeT[storageOrder[i]]=P_el_storage_desired_beforeT[storageOrder[i-1]]-P_el_storage_actual[storageOrder[i-1]];
  end for;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(firstOrder.y, P_el_storage_desired) annotation (Line(points={{0,-81},{0,-81},{0,-110}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-100,-20},{100,20}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={238,46,47},
          textString="%storageOrder")}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This controller controls the eletric energy flows into and out of different storage or conversion technologies in a given merit order.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The residual load is calculated and fed to the first technology. Its actual power is looped back to the controller and the residual load is calculated which is given to the next technology and so on.</p>
<p>To smooth the curves, time constants for each technology can be set.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_el_consDirect: directly consumed power</p>
<p>P_el_prod: produced power</p>
<p>P_el_storage_desired: desired power for each technology</p>
<p>P_el_storage_actual: actual power of each technology</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Jun 2019</p>
</html>"));
end ControllerMeritOrderSimple;
