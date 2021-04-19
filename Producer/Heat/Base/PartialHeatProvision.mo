within TransiEnt.Producer.Heat.Base;
partial model PartialHeatProvision
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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
  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Boolean useFluidCoolantPort=false "choose if fluid port for coolant shall be used" annotation (Dialog(enable=not useHeatPort,group="Coolant"));
  parameter Boolean useHeatPort=false "choose if heat port for coolant shall be used" annotation (Dialog(enable=not useFluidCoolantPort,group="Coolant"));
  parameter Boolean externalMassFlowControl=false "choose if coolant mass flow is defined by input" annotation (Dialog(enable=useFluidCoolantPort and (not useVariableCoolantOutputTemperature), group="Coolant"));
  parameter Boolean useVariableCoolantOutputTemperature=false "choose if temperature of cooland output shall be defined by input" annotation (Dialog(enable=useFluidCoolantPort, group="Coolant"));
  parameter SI.Temperature T_out_coolant_target=500+273.15 "output temperature of coolant - will be limited by temperature which is technically feasible" annotation (Dialog(enable=useFluidCoolantPort,group="Coolant"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=simCenter.fluid1) if useFluidCoolantPort
                                                                                            annotation (Placement(transformation(extent={{90,-100},{110,-80}})));
  Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=simCenter.fluid1) if useFluidCoolantPort
                                                                                              annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat if useHeatPort annotation (Placement(transformation(extent={{90,-76},{110,-56}})));

  Basics.Interfaces.General.TemperatureIn T_set_coolant_out if useVariableCoolantOutputTemperature annotation (Placement(transformation(extent={{140,50},{100,90}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  Components.Boundaries.Heat.Heatflow_L1                             heatFlow_externalMassFlowControl(use_T_out_limit=true, useVariableToutlimit=true) if  useFluidCoolantPort and externalMassFlowControl   annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=90,
        origin={69,-65})));
  Modelica.Blocks.Sources.RealExpression Q_flow_positive(y=Q_flow_heatprovision) if
                                                                        useHeatPort or useFluidCoolantPort annotation (Placement(transformation(extent={{48,-84},{60,-72}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow if useHeatPort annotation (Placement(transformation(extent={{82,-70},{90,-62}})));
  Components.Boundaries.Heat.Heatflow_L1_idContrMFlow_temp           heatflow_L1_idContrMFlow_temp(use_varTemp=true) if useFluidCoolantPort and (not externalMassFlowControl)   annotation (Placement(transformation(extent={{5,5},{-5,-5}},
        rotation=-90,
        origin={69,-51})));
  Modelica.Blocks.Sources.RealExpression realExpression8(y=T_out_coolant) if (not useVariableCoolantOutputTemperature) annotation (Placement(transformation(extent={{44,-68},{56,-56}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  SI.HeatFlowRate Q_flow_heatprovision;
  SI.Temperature T_out_coolant=min(T_out_coolant_target,T_out_coolant_max);
  SI.Temperature T_out_coolant_max;

  // _____________________________________________
  //
  //              Private Functions
  // _____________________________________________
  //   function plotResult
  //   constant String resultFileName = "InsertModelNameHere.mat";
  //   algorithm
  //     TransiEnt.Basics.Functions.plotResult(resultFileName);
  //     createPlot(...); // obtain content by calling function plotSetup() in the commands window
  //     //add ,filename=resultFileName at the end of first createPlot command
  //   end plotResult;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

if useFluidCoolantPort then
  if externalMassFlowControl then
    connect(heatFlow_externalMassFlowControl.fluidPortIn,fluidPortIn)  annotation (Line(
        points={{74,-68},{82,-68},{82,-90},{100,-90}},
        color={175,0,0},
        thickness=0.5));
    connect(fluidPortOut,heatFlow_externalMassFlowControl. fluidPortOut) annotation (Line(
        points={{100,-40},{82,-40},{82,-62},{74,-62}},
        color={175,0,0},
        thickness=0.5));
    connect(heatFlow_externalMassFlowControl.Q_flow_prescribed,Q_flow_positive. y) annotation (Line(
        points={{65,-68},{64,-68},{64,-78},{60.6,-78}},
        color={175,0,0},
        pattern=LinePattern.Dash));
     if useVariableCoolantOutputTemperature then
       connect(T_set_coolant_out, heatFlow_externalMassFlowControl.T_out_limit_prescribed) annotation (Line(points={{120,70},{62,70},{62,-70},{69,-70}},
                                                                                                                                                color={0,0,127}));
     else
       connect(heatFlow_externalMassFlowControl.T_out_limit_prescribed, realExpression8.y) annotation (Line(points={{69,-70},{62,-70},{62,-62},{56.6,-62}}, color={0,0,127}));
     end if;
  else
    connect(heatflow_L1_idContrMFlow_temp.fluidPortIn, fluidPortIn) annotation (Line(
        points={{74,-53},{82,-53},{82,-90},{100,-90}},
        color={175,0,0},
        thickness=0.5));
    connect(heatflow_L1_idContrMFlow_temp.fluidPortOut, fluidPortOut) annotation (Line(
        points={{74,-49},{82,-49},{82,-40},{100,-40}},
        color={175,0,0},
        thickness=0.5));
    connect(heatflow_L1_idContrMFlow_temp.Q_flow_set, Q_flow_positive.y) annotation (Line(
        points={{69,-46},{68,-46},{68,-44},{60.6,-44},{60.6,-78}},
        color={175,0,0},
        pattern=LinePattern.Dash));
    if useVariableCoolantOutputTemperature then
      connect(T_set_coolant_out, heatflow_L1_idContrMFlow_temp.T_out_set) annotation (Line(points={{120,70},{62,70},{62,-50},{64,-50},{64,-51}},
                                                                                                                               color={0,0,127}));
    else
      connect(heatflow_L1_idContrMFlow_temp.T_out_set, realExpression8.y) annotation (Line(points={{64,-51},{58,-51},{58,-62},{56.6,-62}}, color={0,0,127}));
    end if;
  end if;
end if;
  connect(heat,prescribedHeatFlow. port) annotation (Line(points={{100,-66},{90,-66}},       color={191,0,0}));
  connect(prescribedHeatFlow.Q_flow,Q_flow_positive. y) annotation (Line(points={{82,-66},{78,-66},{78,-78},{60.6,-78}},
                                                                                                                     color={0,0,127}));

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
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
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Jun 2019</p>
</html>"));
end PartialHeatProvision;
