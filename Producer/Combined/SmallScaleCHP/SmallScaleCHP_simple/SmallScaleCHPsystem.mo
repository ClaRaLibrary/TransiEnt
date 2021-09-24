within TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple;
model SmallScaleCHPsystem


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




  extends TransiEnt.Basics.Icons.CHP;
  outer TransiEnt.SimCenter simCenter;

  // __________________________________________________________________________
  //
  //                  Parameters
  // ___________________________________________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid FuelMedium=simCenter.gasModel1 "Medium to be used for fuel gas" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.SpecificEnthalpy HoC_fuel=40e6 "heat of combustion of fuel used" annotation (Dialog(group="Configuration", enable=useConstantHoC), choices(
      choice=simCenter.HeatingValue_natGas "Natural gas",
      choice=simCenter.HeatingValue_LightOil "Oil",
      choice=simCenter.HeatingValue_Wood "Wood pellets"));
  parameter Boolean useGasPort=true "True if gas port shall be used" annotation (Dialog(group="Configuration"),choices(checkBox=true));


  //Storage
  parameter SI.Temperature T_s_max=363.15 "Maximum storage temperature" annotation (Dialog(group="Storage Parameters"));
  parameter SI.Temperature T_s_min=303.15 "Minimum storage temperature" annotation (Dialog(group="Storage Parameters"));
  parameter SI.Temperature T_start=353.15 "Start temperature" annotation (Dialog(group="Storage Parameters"));
  parameter SI.Volume V_Storage=0.5 "Volume of the storage" annotation (Dialog(group="Storage Parameters"));
  parameter SI.Height height=1.3 "Height of heat storage" annotation (Dialog(group="Storage Parameters"));
  final parameter SI.Diameter d=sqrt(4*V_Storage/Modelica.Constants.pi/height) "Diameter of heat storage" annotation (Dialog(group="Storage Parameters"));
  parameter Modelica.Units.NonSI.Temperature_degC T_amb=15 "Assumed constant temperature in tank installation room" annotation (Dialog(group="Storage Parameters"));
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "Coefficient of heat transfer" annotation (Dialog(group="Storage Parameters"));

  //CHP
  parameter SI.Power Q_flow_n_CHP=4000 "Heat output of CHP" annotation (Dialog(group="CHP Parameters"));
  parameter SI.Power P_n_CHP=8000 "Electric power output of CHP" annotation (Dialog(group="CHP Parameters"));
  parameter SI.Efficiency eta_el=0.3 "Constant electric efficiency of the CHP" annotation (Dialog(group="CHP Parameters"));
  parameter SI.Efficiency eta_th=0.6 "Constant thermal efficiency of the CHP" annotation (Dialog(group="CHP Parameters"));

  //Boiler
  parameter SI.Efficiency eta_boiler=1.05 "Boiler's overall efficiency" annotation (Dialog(group="Boiler Parameters"));
  parameter SI.HeatFlowRate Q_flow_n_boiler=20000 "Nominal heating power of the gas boiler" annotation (Dialog(group="Boiler Parameters"));

  replaceable connector PowerPortModel = Basics.Interfaces.Electrical.ActivePowerPort constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort  "Choice of power port" annotation (choicesAllMatching=true, Dialog(group="Replaceable Components"));
  replaceable model PowerBoundaryModel = Components.Boundaries.Electrical.ActivePower.Power constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (choices(choice=TransiEnt.Components.Boundaries.Electrical.ActivePower.Power "Active Power Boundary", choice=TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower(useInputConnectorQ=false, useCosPhi=false) "Apparent Power Boundary"), Dialog(group="Replaceable Components"));

  // __________________________________________________________________________
  //
  //                   Variables
  // ___________________________________________________________________________

  // __________________________________________________________________________
  //
  //                   Complex Components
  // ___________________________________________________________________________

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L2.HotWaterStorage_constProp_L2 Storage(
    useFluidPorts=false,
    T_amb=T_amb,
    k=k,
    T_s_max=T_s_max,
    T_s_min=T_s_min,
    T_start=T_start,
    height=height,
    d=d) annotation (Placement(transformation(extent={{58,22},{78,42}})));

  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{30,14},{46,30}})));

  // __________________________________________________________________________
  //
  //                   Interfaces
  // ___________________________________________________________________________

  PowerPortModel epp annotation (
     choicesAllMatching=true,
     Dialog(group="Replaceable Components"),
     Placement(transformation(extent={{90,-90},{110,-70}})));

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=FuelMedium) if useGasPort annotation (Placement(transformation(extent={{68,-116},{88,-96}}), iconTransformation(extent={{66,-118},{88,-96}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_Demand annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-13,-13},{13,13}},
        rotation=270,
        origin={1,97})));

  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler gasBoiler1(
    useFluidPorts=false,
    useHeatPort=false,
    eta=eta_boiler,
    Q_flow_n=Q_flow_n_boiler,
    useGasPort=useGasPort,
    change_sign=true,
    gasMedium=FuelMedium,
    HoC_fuel=HoC_fuel) annotation (Placement(transformation(extent={{-36,-46},{-16,-26}})));

  TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.SmallScaleCHP_simple smallScaleCHP_simple(
    mediumGas=FuelMedium,
    useGasPort=useGasPort,
    useFluidPorts=false,
    useHeatPort=false,
    change_sign=true,
    P_el_n=P_n_CHP,
    eta_el=eta_el,
    eta_th=eta_th,
    HoC_fuel=HoC_fuel,
    redeclare model PowerBoundaryModel = PowerBoundaryModel,
    redeclare connector PowerPortModel = PowerPortModel)           annotation (Placement(transformation(extent={{-12,-16},{8,4}})));


  replaceable TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Control.ControlBoilerCHP_modulatingBoiler_HeatLed controller constrainedby TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Control.Base.ControlBoilerCHP_Base(Q_n_CHP=Q_flow_n_CHP, Q_n_Boiler=Q_flow_n_boiler) annotation (
    choicesAllMatching=true,
    Dialog(group="Configuration"),
    Placement(transformation(extent={{-76,-18},{-56,2}})));


equation

  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________

  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________

  connect(gasPortIn, gasBoiler1.gasIn) annotation (Line(
      points={{78,-106},{52,-106},{52,-94},{-25.8,-94},{-25.8,-46}},
      color={255,255,0},
      thickness=1.5));
  connect(add.y, Storage.Q_flow_store) annotation (Line(points={{46.8,22},{52,22},{52,32},{58.6,32}}, color={0,0,127}));
  connect(Storage.Q_flow_demand, Q_Demand) annotation (Line(
      points={{78,32},{82,32},{82,82},{0,82},{0,100}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(Storage.SoC, controller.SoC) annotation (Line(points={{69.8,41.6},{69.8,60},{-90,60},{-90,-8},{-75.8,-8}}, color={0,0,127}));
  connect(controller.Q_flow_set_CHP, smallScaleCHP_simple.Q_flow_set) annotation (Line(
      points={{-55.5,-8.1},{-12,-8.1},{-12,-6}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(controller.Q_flow_set_boiler, add.u1) annotation (Line(
      points={{-55.5,-15.7},{-24,-15.7},{-24,26.8},{28.4,26.8}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(smallScaleCHP_simple.Q_flow_gen, add.u2) annotation (Line(
      points={{8.8,-4.6},{24,-4.6},{24,17.2},{28.4,17.2}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(smallScaleCHP_simple.gasPortIn, gasPortIn) annotation (Line(
      points={{8,-10},{40,-10},{40,-12},{78,-12},{78,-106}},
      color={255,255,0},
      thickness=1.5));
  connect(smallScaleCHP_simple.epp, epp) annotation (Line(
      points={{7.8,-13.8},{20,-13.8},{20,-22},{32,-22},{32,-72},{100,-72},{100,-80}},
      color={0,127,0},
      thickness=0.5));
  connect(controller.Q_flow_set_boiler, gasBoiler1.Q_flow_set) annotation (Line(
      points={{-55.5,-15.7},{-26,-15.7},{-26,-26}},
      color={175,0,0},
      pattern=LinePattern.Dash));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of storage tank, CHP unit, boiler and controller model into one system model with a connection to the electrical and gas grid.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_demand</p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp</p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>All components use energy based modeling without consideration of heat transfer media. </p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Model created by Anne Hagemeier, Fraunhofer UMSICHT, 2018</p>
</html>"));
end SmallScaleCHPsystem;
