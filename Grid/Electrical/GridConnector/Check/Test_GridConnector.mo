within TransiEnt.Grid.Electrical.GridConnector.Check;
model Test_GridConnector


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

  inner SimCenter simCenter annotation (Placement(transformation(extent={{60,80},{80,100}})));

  GridConnector transmissionGrid_ConnectionMatrix(
    nNodes=4,
    connectMatrix=[0,1,1,1; 0,0,0,2; 0,0,0,0; 0,0,0,0],
    transmissionLineRecord={TransiEnt.Grid.Electrical.GridConnector.Components.TransmissionLineRecord(
        from=1,
        to=2,
        hasTransformers=true),TransiEnt.Grid.Electrical.GridConnector.Components.TransmissionLineRecord(
        from=1,
        to=3,
        hasTransformers=true,
        voltageLevel=380e5),TransiEnt.Grid.Electrical.GridConnector.Components.TransmissionLineRecord(from=1, to=4),TransiEnt.Grid.Electrical.GridConnector.Components.TransmissionLineRecord(
        from=2,
        to=4,
        ChooseVoltageLevel=2,
        l=1000*5,
        MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
        hasTransformers=true,
        voltageLevel=30e3),TransiEnt.Grid.Electrical.GridConnector.Components.TransmissionLineRecord(
        from=2,
        to=4,
        ChooseVoltageLevel=2,
        l=1000*20,
        MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L2,
        hasTransformers=true,
        voltageLevel=30e3)}) annotation (Placement(transformation(extent={{-20,-20},{-60,20}})));
  Consumer.Electrical.SimpleExponentialElectricConsumerComplex Load[transmissionGrid_ConnectionMatrix.nNodes - 1](useInputConnectorP=false, P_el_set_const=1e9) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={40,0})));

  TransiEnt.Components.Boundaries.Electrical.ComplexPower.SlackBoundary slackBoundary annotation (Placement(transformation(extent={{20,40},{40,60}})));
equation
  connect(slackBoundary.epp, transmissionGrid_ConnectionMatrix.epp[1]) annotation (Line(
      points={{20,50},{0,50},{0,0},{-20,0},{-20,-1.5}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionGrid_ConnectionMatrix.epp[2], Load[1].epp) annotation (Line(
      points={{-20,-0.5},{0,-0.5},{0,0},{20,0}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionGrid_ConnectionMatrix.epp[3], Load[2].epp) annotation (Line(
      points={{-20,0.5},{0,0.5},{0,0},{20,0}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionGrid_ConnectionMatrix.epp[4], Load[3].epp) annotation (Line(
      points={{-20,1.5},{-20,0},{20,0}},
      color={28,108,200},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Test_GridConnector;
