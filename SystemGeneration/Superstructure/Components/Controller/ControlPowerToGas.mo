within TransiEnt.SystemGeneration.Superstructure.Components.Controller;
model ControlPowerToGas

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

  extends TransiEnt.SystemGeneration.Superstructure.Components.Controller.Base.ControlPowerToGas_Base;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real P_el_n=1;
  parameter Real eta_n=1;
  parameter Boolean typeIsMethanation=true;
  parameter Boolean typeIsWOStorage=false;
  parameter Boolean y_start_hysteresis3=false;
  parameter Integer DifferentTypesOfPowerToGasPlants;
  parameter Boolean useHydrogenFromPtGInPowerPlants;
  parameter Integer usageOfWasteHeatOfPtG;
  parameter Boolean CO2NeededForPowerToGas;
  parameter Modelica.Units.SI.Pressure p_gasGrid_desired=simCenter.p_amb_const + simCenter.p_eff_2 "desired gas grid pressure in region";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Blocks.LimPID PID_GasGrid(
    initOption=503,
    y_min=0,
    Tau_d=0.1,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    k=1e-2,
    y_max=if not typeIsMethanation then P_el_n*eta_n/(141.79e6 - 219972)*5 else P_el_n*eta_n/(141.79e6 - 219972)*1.5,
    Tau_i=5,
    y_start=1e-3) if DifferentTypesOfPowerToGasPlants >= 1 and not typeIsWOStorage annotation (Placement(transformation(extent={{-10,44},{10,64}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=p_gasGrid_desired) if DifferentTypesOfPowerToGasPlants >= 1 and not typeIsWOStorage annotation (Placement(transformation(extent={{-56,46},{-40,64}})));
  TransiEnt.Basics.Blocks.LimPID PID_GasGrid1(
    y_min=0,
    initOption=503,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Tau_i=0.05,
    Tau_d=1,
    y_max=P_el_n*eta_n/(141.79e6 - 219972)*10,
    y_start=0) if useHydrogenFromPtGInPowerPlants == true annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Modelica.Blocks.Sources.RealExpression m_flow_set_PtG_noStorage(y=P_el_n*eta_n/(141.79e6 - 219972)*3) if DifferentTypesOfPowerToGasPlants >= 1 and typeIsWOStorage annotation (Placement(transformation(extent={{-10,98},{10,116}})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=-1) if useHydrogenFromPtGInPowerPlants == true annotation (Placement(transformation(extent={{-28,-14},{-20,-6}})));
  Modelica.Blocks.Math.Add3 P_el_set_PtG(k1=-1) if DifferentTypesOfPowerToGasPlants >= 1 annotation (Placement(transformation(extent={{-10,8},{10,28}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis3(
    uLow=165e5,
    uHigh=170e5,
    pre_y_start=y_start_hysteresis3) if DifferentTypesOfPowerToGasPlants >= 1 and useHydrogenFromPtGInPowerPlants annotation (Placement(transformation(extent={{-60,78},{-40,98}})));
  Modelica.Blocks.Logical.Switch switch3 if DifferentTypesOfPowerToGasPlants >= 1 and not typeIsWOStorage and useHydrogenFromPtGInPowerPlants annotation (Placement(transformation(extent={{-10,98},{10,78}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(
    uMax=P_el_n,
    uMin=0,
    strict=true) if DifferentTypesOfPowerToGasPlants >= 1 annotation (Placement(transformation(extent={{26,8},{46,28}})));
  Modelica.Blocks.Sources.RealExpression realExpression if DifferentTypesOfPowerToGasPlants >= 1 and useHydrogenFromPtGInPowerPlants annotation (Placement(transformation(rotation=0, extent={{-58,100},{-38,120}})));
  Modelica.Blocks.Sources.RealExpression zero_co2Capture_Pel(y=0) if not (CO2NeededForPowerToGas) annotation (Placement(transformation(extent={{-74,16},{-52,36}})));
  Modelica.Blocks.Sources.RealExpression zero_wasteHeatPel(y=0) if not (usageOfWasteHeatOfPtG == 2) annotation (Placement(transformation(extent={{-74,-2},{-52,20}})));
  Modelica.Blocks.Math.Gain co2System_CaptureFromAir_Q(k=1) if CO2NeededForPowerToGas annotation (Placement(transformation(extent={{40,-30},{24,-14}})));
  Modelica.Blocks.Math.Gain powerToGas_wasteHeat_P_el(k=1) if usageOfWasteHeatOfPtG == 2 annotation (Placement(transformation(extent={{40,-72},{24,-56}})));
  Modelica.Blocks.Math.Gain powerPlantSystem_m_flowGas(k=-1) if useHydrogenFromPtGInPowerPlants == true annotation (Placement(transformation(extent={{40,-52},{24,-36}})));
  Modelica.Blocks.Math.Gain bypassSwitch3(k=1) if DifferentTypesOfPowerToGasPlants >= 1 and not typeIsWOStorage and not (useHydrogenFromPtGInPowerPlants) annotation (Placement(transformation(extent={{26,44},{46,64}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=if simCenter.gasModel1.nc == 1 then 1 else gasComposition_vol[simCenter.gasModel1.nc]) annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  final parameter Modelica.Units.SI.MolarMass M_i[max(simCenter.gasModel1.nc, 1)]=if simCenter.gasModel1.nc == 1 then {-1} else TILMedia.VLEFluidFunctions.molarMass_n(simCenter.gasModel1, 0:simCenter.gasModel1.nc - 1);
  Modelica.Units.SI.VolumeFraction[max(simCenter.gasModel1.nc, 1)] gasComposition_vol;
  Modelica.Units.SI.MassFraction[max(simCenter.gasModel1.nc, 1)] gasComposition_mass;

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if simCenter.gasModel1.nc == 1 then
    gasComposition_mass = {1};
    gasComposition_vol = {1};
  else
    gasComposition_mass = cat(
            1,
            gasComposition,
            {1 - sum(gasComposition)});
    gasComposition_vol = gasComposition_mass ./ M_i/sum(gasComposition_mass ./ M_i);
  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(controlBus.co2System_CaptureFromAir_Q, co2System_CaptureFromAir_Q.u) annotation (Line(
      points={{100,0},{64,0},{64,-22},{41.6,-22}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.powerToGas_wasteHeat_P_el, powerToGas_wasteHeat_P_el.u) annotation (Line(
      points={{100,0},{64,0},{64,-64},{41.6,-64}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.powerPlantSystem_m_flowGas, powerPlantSystem_m_flowGas.u) annotation (Line(
      points={{100,0},{64,0},{64,-44},{41.6,-44}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realExpression2.y, PID_GasGrid.u_s) annotation (Line(points={{-39.2,55},{-12,55},{-12,54}}, color={0,0,127}));
  connect(realExpression5.y, PID_GasGrid1.u_s) annotation (Line(points={{-19.6,-10},{-12,-10}}, color={0,0,127}));
  connect(hysteresis3.y, switch3.u2) annotation (Line(points={{-39,88},{-12,88}}, color={255,0,255}));
  connect(PID_GasGrid.y, switch3.u1) annotation (Line(points={{11,54},{18,54},{18,72},{-28,72},{-28,80},{-12,80}}, color={0,0,127}));
  connect(u2, P_el_set_PtG.u2) annotation (Line(points={{-110,0},{-78,0},{-78,18},{-12,18}}, color={0,0,127}));
  connect(p_gas_region, PID_GasGrid.u_m) annotation (Line(points={{-110,60},{-80,60},{-80,36},{0.1,36},{0.1,42}}, color={0,0,127}));
  connect(switch3.u3, realExpression.y) annotation (Line(points={{-12,96},{-24,96},{-24,110},{-37,110}}, color={0,0,127}));
  connect(P_el_set_PtG.u1, zero_co2Capture_Pel.y) annotation (Line(points={{-12,26},{-50.9,26}}, color={0,0,127}));
  connect(P_el_set_PtG.u3, zero_wasteHeatPel.y) annotation (Line(points={{-12,10},{-38,10},{-38,9},{-50.9,9}}, color={0,0,127}));
  connect(P_el_set_PtG.y, limiter.u) annotation (Line(points={{11,18},{24,18}}, color={0,0,127}));
  connect(controlBus.powerToGas_plant1_m_flowFeedInH2, PID_GasGrid1.y) annotation (Line(
      points={{100,0},{64,0},{64,-10},{11,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(controlBus.powerToGas_P_el_set, limiter.y) annotation (Line(
      points={{100,0},{64,0},{64,18},{47,18}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.powerToGas_hydrogenFraction_input, realExpression1.y) annotation (Line(
      points={{100,0},{64,0},{64,-80},{41,-80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(co2System_CaptureFromAir_Q.y, P_el_set_PtG.u1) annotation (Line(points={{23.2,-22},{-32,-22},{-32,26},{-12,26}}, color={0,0,127}));
  connect(powerToGas_wasteHeat_P_el.y, P_el_set_PtG.u3) annotation (Line(points={{23.2,-64},{-38,-64},{-38,10},{-12,10}}, color={0,0,127}));
  connect(PID_GasGrid1.u_m, powerPlantSystem_m_flowGas.y) annotation (Line(points={{0.1,-22},{0.1,-44},{23.2,-44}}, color={0,0,127}));
  connect(PID_GasGrid.y, bypassSwitch3.u) annotation (Line(points={{11,54},{24,54}}, color={0,0,127}));
  connect(controlBus.powerToGas_plant1_p_feedIn, hysteresis3.u) annotation (Line(
      points={{100,0},{64,0},{64,120},{-68,120},{-68,88},{-62,88}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.powerToGas_m_flowFeedIn, switch3.y) annotation (Line(
      points={{100,0},{64,0},{64,88},{11,88}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(controlBus.powerToGas_m_flowFeedIn, m_flow_set_PtG_noStorage.y) annotation (Line(
      points={{100,0},{64,0},{64,107},{11,107}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(controlBus.powerToGas_m_flowFeedIn, bypassSwitch3.y) annotation (Line(
      points={{100,0},{64,0},{64,54},{47,54}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-80},{100,120}}), graphics={Text(
                extent={{-82,8},{-50,4}},
                lineColor={28,108,200},
                lineThickness=0.5,
                textString="Control PowerToGasStorage")}),
    Icon(coordinateSystem(extent={{-100,-80},{100,120}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller for mass flows of hydrogen and SNG of PtG-plants in superstructure. </p>
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
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
</html>"));
end ControlPowerToGas;
