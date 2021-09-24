within TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems;
model CHP_Boiler_Storage "CHP unit, thermal storage and gas boiler"


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




  // ___________________________________________________________________________
  //
  //          Imports and Class Hierarchy
  // ___________________________________________________________________________

  extends Base.Systems(
    final DHN=false,
    final el_grid=true,
    final gas_grid=useGasPort,
    medium1=FuelMedium);

  //___________________________________________________________________________
  //
  //                      Parameters
  //___________________________________________________________________________

  parameter Boolean useGasPort=true "True if gas port shall be used" annotation (Dialog(group="System setup"), choices(checkBox=true));

  //CHP
  parameter SI.Power P_el_n_CHP=4000 "Electric power output of CHP" annotation (Dialog(group="CHP"));
  parameter SI.HeatFlowRate Q_flow_n_CHP=6000 "Thermal power output of CHP" annotation (Dialog(group="CHP"));
  parameter Real eta_CHP=0.9 "Total efficiency of the CHP" annotation (Dialog(group="CHP"));

  //Boiler
  parameter Real eta_boiler=0.8 "Efficiency of the boiler" annotation (HideResult=true, Dialog(group="Boiler"));
  parameter SI.Power Q_flow_n_boiler=6000 "Nominal heat output of Boiler" annotation (HideResult=true, Dialog(group="Boiler"));

  //Storage
  parameter SI.Volume V_Storage=0.5 "Volume of heat storage" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Height height=1.3 "Height of heat storage" annotation (HideResult=true, Dialog(group="Storage"));
  final parameter SI.Diameter d=sqrt(V_Storage/height*4/Modelica.Constants.pi) "Diameter of heat storage" annotation (HideResult=true, Dialog(group="Storage"));
  SI.Temperature T_s_max=353.15 "Maximum Temperature of Storage" annotation (HideResult=true, Dialog(group="Storage"));
  SI.Temperature T_s_min=333.15 "Minimum storage temperature" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Temperature T_start=353.15 "Start temperature" annotation (Dialog(group="Storage"));
  parameter Modelica.Units.NonSI.Temperature_degC T_amb=15 "Assumed constant ambient temperature" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "Coefficient of heat Transfer" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.HeatCapacity cp_storage=4180 "Heat capacity of storage medium" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Density rho=977 "Density of storage medium" annotation (HideResult=true, Dialog(group="Storage"));

  //Fuel
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid FuelMedium=simCenter.gasModel1 "Medium to be used for fuel gas" annotation (HideResult=true, Dialog(group="Fluid Definition", enable=useGasPort));
  parameter SI.SpecificEnthalpy HoC_gas=40e6 "Heat of combustion of fuel, will be used if gasport is deactivated in model" annotation (Dialog(group="Fluid Definition", enable=not useGasPort));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L2.HotWaterStorage_constProp_L2 Storage(
    useFluidPorts=false,
    T_s_max=T_s_max,
    T_s_min=T_s_min,
    d=d,
    height=height,
    T_start=T_start,
    T_amb=T_amb,
    k=k,
    rho=rho,
    cp=cp_storage) annotation (Placement(transformation(extent={{58,22},{78,42}})));

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower(useInputConnectorQ=false, useInputConnectorP=true) annotation (Placement(transformation(extent={{-60,68},{-44,84}})));

  Modelica.Blocks.Math.Add addGeneration annotation (Placement(transformation(extent={{30,14},{46,30}})));
  Modelica.Blocks.Math.Add addDemand annotation (Placement(transformation(extent={{12,58},{28,74}})));

  TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.SmallScaleCHP_simple smallScaleCHP_simple(
    useFluidPorts=false,
    useHeatPort=false,
    change_sign=true,
    useGasPort=useGasPort,
    P_el_n=P_el_n_CHP,
    redeclare TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp,
    redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower Power(useInputConnectorQ=false, useCosPhi=false),
    eta_el=P_el_n_CHP/(P_el_n_CHP + Q_flow_n_CHP)*eta_CHP,
    eta_th=Q_flow_n_CHP/(P_el_n_CHP + Q_flow_n_CHP)*eta_CHP) annotation (Placement(transformation(extent={{-2,-18},{18,2}})));

  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler gasBoilerGasAdaptive(
    useFluidPorts=false,
    Q_flow_n=Q_flow_n_boiler,
    eta=eta_boiler,
    useHeatPort=false,
    change_sign=true,
    integrateHeatFlow=false,
    useGasPort=useGasPort) annotation (Placement(transformation(extent={{-36,-46},{-16,-26}})));
  replaceable TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Control.ControlBoilerCHP_modulatingBoiler_HeatLed controller annotation (
    choicesAllMatching=true,
    Dialog(group="System setup"),
    Placement(transformation(extent={{-66,-4},{-46,16}})));

equation

  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________

  connect(gasPortIn, gasPortIn) annotation (Line(
      points={{80,-96},{78,-96},{78,-96},{80,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(apparentPower.epp, epp) annotation (Line(
      points={{-60,76},{-80,76},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(apparentPower.P_el_set, demand.electricPowerDemand) annotation (Line(points={{-56.8,85.6},{-56.8,90},{-14,90},{-14,84},{4.68,84},{4.68,100.48}}, color={0,0,127}));
  connect(demand.heatingPowerDemand, addDemand.u1) annotation (Line(points={{0,100.48},{0,100.48},{0,70.8},{10.4,70.8}}, color={0,127,127}));
  connect(demand.hotWaterPowerDemand, addDemand.u2) annotation (Line(points={{-4.8,100.48},{-4.8,100.48},{-4.8,61.2},{10.4,61.2}}, color={0,127,127}));
  connect(smallScaleCHP_simple.Q_flow_gen, addGeneration.u2) annotation (Line(
      points={{18.8,-6.6},{18.8,-6},{22,-6},{22,17.2},{28.4,17.2}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(gasPortIn, smallScaleCHP_simple.gasPortIn) annotation (Line(
      points={{80,-96},{80,-64},{34,-64},{34,-12},{18,-12}},
      color={255,255,0},
      thickness=1.5));
  connect(epp, smallScaleCHP_simple.epp) annotation (Line(
      points={{-80,-98},{-80,-76},{40,-76},{40,-15.8},{17.8,-15.8}},
      color={0,127,0},
      thickness=0.5));
  connect(gasBoilerGasAdaptive.Q_flow_gen, addGeneration.u1) annotation (Line(
      points={{-15,-39.2},{-10,-39.2},{-10,26.8},{28.4,26.8}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(gasBoilerGasAdaptive.gasIn, gasPortIn) annotation (Line(
      points={{-25.8,-46},{-24,-46},{-24,-62},{38,-62},{38,-64},{80,-64},{80,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(Storage.SoC, controller.SoC) annotation (Line(points={{69.8,41.6},{70,41.6},{70,56},{-44,56},{-44,58},{-76,58},{-76,6},{-65.8,6}}, color={0,0,127}));
  connect(controller.Q_flow_set_boiler, gasBoilerGasAdaptive.Q_flow_set) annotation (Line(
      points={{-45.5,-1.7},{-34,-1.7},{-34,-18},{-26,-18},{-26,-26}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(controller.Q_flow_set_CHP, smallScaleCHP_simple.Q_flow_set) annotation (Line(
      points={{-45.5,5.9},{-8,5.9},{-8,-8},{-2,-8}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(addGeneration.y, Storage.Q_flow_store) annotation (Line(points={{46.8,22},{46.8,32},{58.6,32}}, color={0,0,127}));
  connect(addDemand.y, Storage.Q_flow_demand) annotation (Line(points={{28.8,66},{88,66},{88,32},{78,32}}, color={0,0,127}));
  annotation (Icon(graphics={
        Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,100},{100,-100}}),
        Rectangle(
          extent={{-78,28},{-40,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,42.0001},{2,-25.9999}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.VerticalCylinder,
          origin={-46.0001,2},
          rotation=-90),
        Bitmap(extent={{-6,30},{84,-88}}, imageSource="iVBORw0KGgoAAAANSUhEUgAAATkAAAE5CAMAAADcP6fDAAAACXBIWXMAABcSAAAXEgFnn9JSAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAYZQTFRFAAAAAAD/Dw//Hx//Ly//Pz8/Pz//T0//X19fX1//b2//f39/j4//n5+fn5//v7+/v7//z8//39//7+//////////////////////////////////////////////////////////////////AAAAAAD/DAwMDgECDwsDDw8PDw//GRkZHQMEHxYHHx8fHx//JiYmLAUGLyELLy8vLy//MzMzOwcJPiwOPz8/Pz//SggLTExMTjcST09PT0//WAoNWVlZXkIWX19fX1//ZmZmZwwPbU0Zb29vb2//cnJydg4SfVgdf39/f3//hQ8UjIyMjWMhj4+Pj4//lBEWmZmZnG4kn5+fn5//ohMYpaWlrHkor6+vr6//sRUbsrKyvIQsv7+/v7//wBYdy48vzMzMzxgfz8/Pz8//25oz3hoh39/f39//66U37Rwk7+/v7+//+7A7/wAA/w8P/x8f/y8v/z8//09P/19f/29v/39//4+P/5+f/6+v/7+//8/P/9/f/+/v////kIefhAAAACR0Uk5TAAAAAAAAAAAAAAAAAAAAAAAAAAAADx8vP09fb3+Pn6+/z9/v4vdPWQAAFjRJREFUeNrtnftf20a2wJvu3b13d7t72638fiBbYxeb2KaAsZ0ACTYFUuwGSLALgdguKaQ2wdA23d32blv951fyQxppJFmPkayHzw/99COTwfpyzpzHnJn54APbSCAYikbjJElStFgSzNNoNBIM+j6YCyQMsbgELmlJkAxBv+eZ+UPRhSStR8hYJOhRaL5gVLWeyepfPBzwGLVQLEFjEmoh4hV6wSg2ahy9eNjtM58vHKdocyQRDbgY2wJtqiRjgTm2ObyxhCzBNoYXdc2c549RtLVCht3ALUzSMxAq5nDF80UpelZCOjjH8MfpmUrSoUYbJOmZCxX1zbl5hJ1duDmNnZ24OYldwGbcRuzm/tStfnaW8Zuj47tQkrazxO063flJ2uZCRWwJLko7QBL2K0IFk7QzJGYvk/XFaMdIMjhXOMernZMUzlZqF0jQzhM75BQR2pGSmHXN2EfSDhVqtulYkKKd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"),
        Rectangle(
          extent={{-9,13},{9,-13}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={175,175,175},
          origin={-21,5},
          rotation=90),
        Rectangle(
          extent={{-16,16},{-10,14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Rectangle(
          extent={{-32,-4},{-26,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Rectangle(
          extent={{-16,-4},{-10,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Text(
          extent={{-30,10},{-10,-2}},
          lineColor={0,0,0},
          fillColor={19,202,77},
          fillPattern=FillPattern.Solid,
          textString="G",
          textStyle={TextStyle.Bold}),
        Rectangle(
          extent={{-62,34},{-58,28}},
          fillColor={215,215,215},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-82,62},{-78,42}},
          fillColor={215,215,215},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-78,46},{-74,42}},
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-72,58},{-68,46}},
          fillColor={255,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-72,62},{-4,58}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0},
          lineColor={0,0,0}),
        Rectangle(
          extent={{-56,38},{-40,34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,128,0}),
        Rectangle(
          extent={{-76,48},{-56,34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{-22,16}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,255},
          lineColor={0,0,0}),
        Rectangle(
          extent={{-34,38},{-30,22}},
          fillColor={255,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-22,52},{-26,20}},
          fillColor={0,0,255},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-22,52},{-4,48}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,255},
          lineColor={0,0,0}),
        Rectangle(
          extent={{-40,46},{-20,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-20,46},{-40,32}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-40,26},{-30,22}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0},
          lineColor={0,0,0}),
        Line(
          points={{-76,48},{-56,34}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-90,24},{-46,22}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,0},
          lineColor={0,0,0})}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of CHP and boiler models to be used in the energyConverter.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>TransiEnt.Basics.Interfaces.Combined.HouseholdDemandIn <b>demand</b></p>
<p><i>Conditional interfaces depending on the technologies selected:</i></p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort <b>epp - connection to electrical grid</b></p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn <b>gasPortIn - connection to gas grid</b></p><p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model contains models for a CHP unit, a thermal storage tank, a gas boiler and a controller for the operation of the CHP unit and the boiler. Different control modes can be selected. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end CHP_Boiler_Storage;
