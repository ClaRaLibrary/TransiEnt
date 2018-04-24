within TransiEnt.Producer.Heat.HeaterCooler.Check;
model TestSupplementaryHeater_L0

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  extends Basics.Icons.Checkmodel;
  inner SimCenter simCenter(redeclare TransiEnt.Basics.Tables.HeatGrid.HeatingCurves.ConstantSupplyTemperature heatingCurve(T_supply_const=353.15), redeclare Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1)
                                                                                                    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
   inner ModelStatistics           modelStatistics
     annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource(
    m_flow_const=0.1,
    m_flow_nom=0,
    p_nom=1000,
    variable_m_flow=false,
    variable_h=false,
    h_const=400e3) annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi massFlowSink(
    variable_p=false,
    h_const=400e3,
    p_const(displayUnit="bar") = 100000,
    Delta_p=100,
    m_flow_nom=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={52,0})));
  HeaterCooler.SupplementaryHeater_L2 supplementaryHeater(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional, switch(start=true, fixed=true)) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource(m(start=100), p_const=simCenter.p_amb_const + simCenter.p_eff_1) annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={0,50})));
equation
  connect(massFlowSource.steam_a, supplementaryHeater.waterPortOut) annotation (Line(
      points={{-54,0},{-10,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(supplementaryHeater.waterPortIn, massFlowSink.steam_a) annotation (Line(
      points={{10,0},{42,0}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gasSource.gasPort, supplementaryHeater.gasPortIn) annotation (Line(
      points={{0,38},{0,9.8}},
      color={255,255,0},
      thickness=0.75));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end TestSupplementaryHeater_L0;
