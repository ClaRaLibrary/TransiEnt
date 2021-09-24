within TransiEnt.Storage.Heat.PackedBedStorage_L4.Check;
model TestPackedBedStorage



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

  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________


  PackedBedStorage_L4 storageUnit(
    d_v_m=0.02,
    redeclare model PackedBedGeometry = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedGeometry.BlockShapedUnit (
        length=20,
        height=10,
        width=20),
    redeclare model ColdAirGeometry = Basics.StorageAirVolumeGeometry.TruncatedPyramid (
        height=2,
        width_2=2,
        length_2=2,
        width_1=20,
        length_1=10),
    redeclare model HotAirGeometry = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.StorageAirVolumeGeometry.TruncatedPyramid (
        height=2,
        width_2=2,
        length_2=2,
        width_1=20,
        length_1=10),
    redeclare model medium_rock = TransiEnt.Basics.Media.Solids.Basalt,
    redeclare model medium_pipe = TransiEnt.Producer.Gas.BiogasPlant.MaterialValues.Materials.StainlessSteel,
    redeclare model Insulation_bed = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (
        length=20,
        circumference=200,
        thickness=1,
        redeclare model medium = TransiEnt.Basics.Media.Solids.AeratedConcrete),
    redeclare model Insulation_hot = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer,
    redeclare model Insulation_cold = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer,
    redeclare model PressureLossPB = Basics.PackedBedPressureLoss.MacDonald,
    redeclare model PressureLossHotAir = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L2 (Delta_p_nom=100),
    redeclare model PressureLossColdAir = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L2 (Delta_p_nom=100),
    redeclare model HeatTransferPB2Wall = Basics.HeatTransfer.PackedBedToWall.PB2Wall_Ideal,
    redeclare model HeatTransferAir2Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    redeclare model HeatTransferAir2PB = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    redeclare model HeatTransferPB2Air = Basics.HeatTransfer.PackedBedToAir.PB2Air_Adiabat,
    redeclare model ThermalConductivityPB = Basics.EffectiveThermalConductivity.ZehnerBauerSchluender,
    linearInit=false,
    T_start_bed=293.15*ones(storageUnit.N_cv),
    T_ref=273.15 + 20,
    T_c=273.15 + 600,
    T_d=273.15 + 20,
    T_stop_c=273.15 + 150,
    T_stop_d=273.15 + 450,
    T_nom=273.15 + 600,
    m_flow_nom=50,
    Delta_p_nom_bed=1000,
    N_cv=20) annotation (Placement(transformation(extent={{-12,-12},{12,12}})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1
                                    valveHotSide4(openingInputIsActive=true, redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1000))
                     annotation (Placement(transformation(extent={{9,6},{-9,-6}},
        rotation=270,
        origin={-46,19})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1
                                    valveHotSide6(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1000), openingInputIsActive=true)
                     annotation (Placement(transformation(extent={{10,6},{-10,-6}},
        rotation=90,
        origin={40,-18})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi gasSinkHotSide(xi_const={0,0,0,0,0.7812,0.2096,0,0,0})     annotation (Placement(transformation(
        extent={{-9,-10},{9,10}},
        rotation=270,
        origin={-46,49})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi
                                     gasSinkCoolSide(xi_const={0,0,0,0,0.7812,0.2096,0,0,0})
              annotation (Placement(transformation(
        extent={{-9,-10},{9,10}},
        rotation=90,
        origin={40,-47})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow gasSourceHotSide(
    variable_m_flow=true,
    variable_T=true,
    xi_const={0,0,0,0,0.7812,0.2096,0,0,0})
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-46,-42})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow gasSourceCoolSide(
    variable_m_flow=true,
    variable_T=true,
    xi_const={0,0,0,0,0.7812,0.2096,0,0,0})
                     annotation (Placement(transformation(
        extent={{-9,-12},{9,12}},
        rotation=270,
        origin={40,39})));
  inner TransiEnt.SimCenter
                        simCenter(redeclare TILMedia.GasTypes.MoistAirMixture airModel, redeclare TILMedia.GasTypes.MoistAirMixture flueGasModel) annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.CombiTimeTable TestCycle(
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    table=[0,873.15,0,0,298.15,0,0,0,0.0; 1000,873.15,0,0,298.15,0,0,0,0.0; 1240,873.15,50,1,298.15,0,0,1,1; 73240,873.15,50,1,298.15,0,0,1,1; 73480,873.15,0,0,298.15,0,0,0,0; 73720,873.15,0,0,298.15,50,1,-1,1; 127720,873.15,0,0,298.15,50,1,-1,1; 127960,873.15,0,0,298.15,0,0,0,0; 128200,873.15,0,0,298.15,0,0,0,0; 128440,873.15,50,1,298.15,0,0,1,1; 200400,873.15,50,1,298.15,0,0,1,1; 200640,873.15,0,0,298.15,0,0,0,0; 243840,873.15,0,0,298.15,0,0,0,0; 244080,873.15,0,0,298.15,50,1,-1,1; 316000,873.15,0,0,298.15,50,1,-1,1]) "|y1: T charge |y2: m_flow charge| y3: valve open charge  |y4: T discharge |y5: m_flow discharge |y6: valve open discharge|y7: operation (-1= discharge  0= neutral 1= charge)|y8: operation 1= charge or discharge 0 = neutral" annotation (Placement(transformation(extent={{-12,-70},{8,-90}})));
  Modelica.Blocks.Routing.RealPassThrough Plug[8] "|y1: T charge |y2: m_flow charge| y3: valve open charge  |y4: T discharge |y5: m_flow discharge |y6: valve open discharge|y7: operation (-1= discharge  0= neutral 1= charge)|y8: operation 1= charge or discharge 0 = neutral" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={30,-80})));


  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________


equation

  connect(valveHotSide4.inlet,storageUnit. HotAirPort) annotation (Line(
      points={{-46,10},{-46,0},{-12,0}},
      color={118,106,98},
      thickness=0.5));
  connect(valveHotSide6.inlet,storageUnit. ColdAirPort) annotation (Line(
      points={{40,-8},{40,0},{12,0}},
      color={118,106,98},
      thickness=0.5));
  connect(gasSinkHotSide.gas_a, valveHotSide4.outlet) annotation (Line(
      points={{-46,40},{-46,28}},
      color={118,106,98},
      thickness=0.5));
  connect(gasSinkCoolSide.gas_a, valveHotSide6.outlet) annotation (Line(
      points={{40,-38},{40,-28}},
      color={118,106,98},
      thickness=0.5));
  connect(Plug[1].y, gasSourceHotSide.T) annotation (Line(points={{41,-80},{60,-80},{60,-60},{-46,-60},{-46,-52}},
                                                                                                                 color={0,0,127}));
  connect(Plug[2].y, gasSourceHotSide.m_flow) annotation (Line(points={{41,-80},{60,-80},{60,-60},{-48,-60},{-48,-52},{-52,-52}}, color={0,0,127}));
  connect(Plug[4].y, gasSourceCoolSide.T) annotation (Line(points={{41,-80},{60,-80},{60,60},{40,60},{40,48}},
                                                                                                             color={0,0,127}));
  connect(Plug[5].y, gasSourceCoolSide.m_flow) annotation (Line(points={{41,-80},{60,-80},{60,60},{47.2,60},{47.2,48}},
                                                                                                                      color={0,0,127}));
  connect(Plug[3].y, valveHotSide6.opening_in) annotation (Line(points={{41,-80},{60,-80},{60,-18},{49,-18}},
                                                                                                            color={0,0,127}));
  connect(Plug[6].y, valveHotSide4.opening_in) annotation (Line(points={{41,-80},{60,-80},{60,60},{-60,60},{-60,19},{-55,19}},
                                                                                                                             color={0,0,127}));
  connect(gasSourceCoolSide.gas_a,storageUnit. ColdAirPort) annotation (Line(
      points={{40,30},{40,0},{12,0}},
      color={118,106,98},
      thickness=0.5));
  connect(gasSourceHotSide.gas_a,storageUnit. HotAirPort) annotation (Line(
      points={{-46,-32},{-46,0},{-12,0}},
      color={118,106,98},
      thickness=0.5));
  connect(TestCycle.y, Plug.u) annotation (Line(points={{9,-80},{18,-80}},   color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, initialScale=0.1,
        extent={{-100,-100},{120,100}})),
                                Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{120,100}}), graphics={ Text(
          extent={{76,88},{148,26}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Check the summary values of the storage unit,
such as the state of charge and heat + pressure losses..")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Check model for packed bed thermal energy storage</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Johannes Brunnemann (XRG Simulation GmbH) for the FES research project, March 2021</p>
</html>"),
    experiment(
      StopTime=316000,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=true,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestPackedBedStorage;
