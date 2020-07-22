within TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel;
model MethanationThreeStages "three staged methanation reactor with intermediate cooling"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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
  import TransiEnt;

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.MethanationThreeStages;
  import SI = Modelica.SIunits;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Boolean SteadyState=true;
  parameter Real RecycleRate;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal "nominal mass flow";
  parameter Modelica.SIunits.Pressure Delta_p_nominal_reactor_block "pressure loss in reactor block for nominal mass flow";
  parameter Modelica.SIunits.Pressure Delta_p_nominal_HEX=5e-6 "pressure loss in heat exchanger for nominal mass flow";
  parameter Modelica.SIunits.Temperature T_ambient=300 "constant ambient temperature";
  parameter Modelica.SIunits.HeatCapacity mCp_Nenn=1.75e6 "nominal heat capacity of reactor block for nominal mass flow 1kg/s";
  parameter Modelica.SIunits.Temperature T_HEX_out=573.15;
  parameter Modelica.SIunits.Temperature T_reactor_start;
  parameter Boolean useHomotopy=true "True, if homotopy method is used during initialisation";
  parameter Boolean deactivateTwoPhaseRegionForRealGas=true "Deactivate calculation of two phase region - needs to be 'false', if condensate heat of product gas calculation is important for coolant calculation" annotation (Evaluate=true);

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=Medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0), iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=Medium) annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=0)));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=coolingFluid) annotation (Placement(transformation(extent={{30,88},{50,108}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=coolingFluid) annotation (Placement(transformation(extent={{-50,90},{-30,110}})));

  TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.MethanatorBlock_equilibrium_L2 Block1(
    mCp_Nenn=mCp_Nenn,
    T_ambient=T_ambient,
    SteadyState=SteadyState,
    m_flow_nominal=m_flow_nominal*(1 + RecycleRate),
    Delta_p_nominal=Delta_p_nominal_reactor_block,
    T_reactor_start=T_reactor_start,
    useHomotopy=useHomotopy) annotation (Placement(transformation(extent={{-58,32},{-44,46}})));
  TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.MethanatorBlock_equilibrium_L2 Block2(
    mCp_Nenn=mCp_Nenn,
    T_ambient=T_ambient,
    SteadyState=SteadyState,
    m_flow_nominal=m_flow_nominal,
    Delta_p_nominal=Delta_p_nominal_reactor_block,
    T_reactor_start=T_reactor_start,
    useHomotopy=useHomotopy) annotation (Placement(transformation(extent={{-8,-8},{8,8}})));
  TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.MethanatorBlock_equilibrium_L2 Block3(
    mCp_Nenn=mCp_Nenn,
    T_ambient=T_ambient,
    SteadyState=SteadyState,
    m_flow_nominal=m_flow_nominal,
    Delta_p_nominal=Delta_p_nominal_reactor_block,
    T_reactor_start=T_reactor_start,
    useHomotopy=useHomotopy) annotation (Placement(transformation(extent={{40,-8},{56,8}})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOneFluidIdeal_L1
                                                                 hEXIdealVLETwoFluids_L1_3(mediumRealGas=Medium,  mediumFluid=coolingFluid,
    Delta_p_realGas=Delta_p_nominal_HEX,
    T_out_fixed=T_HEX_out)        annotation (Placement(transformation(extent={{18,-6},{32,6}})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOneFluidIdeal_L1
                                                                 hEXIdealVLETwoFluids_L1_2(mediumRealGas=Medium,  mediumFluid=coolingFluid,
    Delta_p_realGas=Delta_p_nominal_HEX,
    T_out_fixed=T_HEX_out)    annotation (Placement(transformation(
        extent={{6,-7},{-6,7}},
        rotation=90,
        origin={-31,14})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOneFluidIdeal_L1
                                                                 hEXIdealVLETwoFluids_L1_1(mediumRealGas=Medium,  mediumFluid=coolingFluid,
    Delta_p_realGas=Delta_p_nominal_HEX,
    Delta_p_fluid=0,
    T_out_fixed=T_HEX_out)    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-70,14})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOneFluidIdeal_L1
                                                                 hEXIdealVLETwoFluids_L1_4(mediumRealGas=Medium,  mediumFluid=coolingFluid,
    Delta_p_realGas=Delta_p_nominal_HEX,
    T_out_fixed=293.15,
    deactivateTwoPhaseRegionForRealGas=deactivateTwoPhaseRegionForRealGas)
                           annotation (Placement(transformation(extent={{64,6},{76,-6}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.ThreeWayValveRealGas_L1_simple threeWayValveRealGas_L1_simple(medium=Medium, splitRatio_fixed=RecycleRate/(1 + RecycleRate))
                                                                                                                              annotation (Placement(transformation(
        extent={{-3,3},{3,-3}},
        rotation=-90,
        origin={-31,1})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT gasOut_properties(
    vleFluidType=Medium,
    p=gasPortOut.p,
    T=hEXIdealVLETwoFluids_L1_4.T_out_fixed,
    xi=gasPortOut.xi_outflow,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{76,-44},{90,-30}})));
  TransiEnt.Components.Gas.GasCleaning.Dryer_L1
              dryer_L1_1(medium_gas=Medium, medium_water=coolingFluid)
                           annotation (Placement(transformation(extent={{82,-2},{86,2}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT gasOut_properties_norm(
    vleFluidType=Medium,
    xi=gasPortOut.xi_outflow,
    deactivateTwoPhaseRegion=true,
    p=101325,
    T=273.15) annotation (Placement(transformation(extent={{74,-64},{88,-50}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT gasIn_properties_norm1(
    vleFluidType=Medium,
    deactivateTwoPhaseRegion=true,
    xi=inStream(gasPortIn.xi_outflow),
    p=101325,
    T=273.15) annotation (Placement(transformation(extent={{-88,-50},{-74,-36}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(medium=coolingFluid) annotation (Placement(transformation(
        extent={{-2.5,-1.5},{2.5,1.5}},
        rotation=-90,
        origin={83.5,9.5})));
  // _____________________________________________
  //
  //                Medium declaration
  // _____________________________________________

 parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var Medium "Medium model";
 parameter TILMedia.VLEFluidTypes.BaseVLEFluid coolingFluid=simCenter.fluid1 "Medium which is cooling or heating medium1";

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________
//
   Real LHV_input;
   Real LHV_output;
   Real HHV_input;
   Real HHV_output;
   Real efficiency_LHV;
   Real efficiency_HHV;

  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor2 annotation (Placement(transformation(extent={{84,40},{98,54}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor1 annotation (Placement(transformation(extent={{74,-20},{88,-6}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor3 annotation (Placement(transformation(extent={{18,20},{32,34}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor4 annotation (Placement(transformation(extent={{-44,46},{-30,60}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor5 annotation (Placement(transformation(extent={{-106,36},{-92,50}})));
equation
   LHV_output=(13.7*gasOut_properties.xi[1]+33.3*gasOut_properties.xi[4]+2.8*gasOut_properties.xi[5])*3.6e6;
   HHV_output=(55.498*gasOut_properties.xi[1]+141.8*gasOut_properties.xi[4]+10.103*gasOut_properties.xi[5])*10^6;
   LHV_input=(13.7*inStream(gasPortIn.xi_outflow[1]) + 33.3*inStream(gasPortIn.xi_outflow[4]) + 2.8*inStream(gasPortIn.xi_outflow[5]))*3.6e6;
   HHV_input=(55.498*inStream(gasPortIn.xi_outflow[1]) + 141.8*inStream(gasPortIn.xi_outflow[4]) + 10.103*inStream(gasPortIn.xi_outflow[5]))*10^6;

  if gasPortIn.m_flow*LHV_input < 0.01 then
     efficiency_LHV=0;
     efficiency_HHV=0;
   else
    efficiency_LHV*(gasPortIn.m_flow*LHV_input) = (-gasPortOut.m_flow*LHV_output);
    efficiency_HHV*(gasPortIn.m_flow*HHV_input) = (-gasPortOut.m_flow*HHV_output);
   end if;

  connect(threeWayValveRealGas_L1_simple.gasPortOut2, Block2.gasPortIn) annotation (Line(
      points={{-28,1},{-28,0},{-8,0},{-8,0.32}},
      color={255,255,0},
      thickness=1.5));
  connect(gasPortIn, hEXIdealVLETwoFluids_L1_1.gasPortIn) annotation (Line(
      points={{-100,0},{-70,0},{-70,8}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXIdealVLETwoFluids_L1_1.gasPortOut, Block1.gasPortIn) annotation (Line(
      points={{-70,20},{-70,39.28},{-58,39.28}},
      color={255,255,0},
      thickness=1.5));
  connect(threeWayValveRealGas_L1_simple.gasPortOut1, hEXIdealVLETwoFluids_L1_1.gasPortIn) annotation (Line(
      points={{-31.3333,-2},{-30,-2},{-30,-18},{-70,-18},{-70,8}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXIdealVLETwoFluids_L1_2.gasPortOut, threeWayValveRealGas_L1_simple.gasPortIn) annotation (Line(
      points={{-31,8},{-31.3333,8},{-31.3333,4}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXIdealVLETwoFluids_L1_1.fluidPortIn, hEXIdealVLETwoFluids_L1_2.fluidPortOut) annotation (Line(
      points={{-64,14},{-38,14}},
      color={175,0,0},
      thickness=0.5));
  connect(Block1.gasPortOut, hEXIdealVLETwoFluids_L1_2.gasPortIn) annotation (Line(
      points={{-44,39.14},{-31,39.14},{-31,20}},
      color={255,255,0},
      thickness=1.5));
  connect(Block2.gasPortOut, hEXIdealVLETwoFluids_L1_3.gasPortIn) annotation (Line(
      points={{8,0.16},{14,0.16},{14,0},{18,0}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXIdealVLETwoFluids_L1_3.gasPortOut, Block3.gasPortIn) annotation (Line(
      points={{32,0},{38,0},{38,0.32},{40,0.32}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXIdealVLETwoFluids_L1_2.fluidPortIn, hEXIdealVLETwoFluids_L1_3.fluidPortOut) annotation (Line(
      points={{-24,14},{25,14},{25,6}},
      color={175,0,0},
      thickness=0.5));
  connect(hEXIdealVLETwoFluids_L1_3.fluidPortIn, hEXIdealVLETwoFluids_L1_4.fluidPortOut) annotation (Line(
      points={{25,-6},{26,-6},{26,-26},{70,-26},{70,-6}},
      color={175,0,0},
      thickness=0.5));
  connect(hEXIdealVLETwoFluids_L1_1.fluidPortOut, fluidPortOut) annotation (Line(
      points={{-76,14},{-80,14},{-80,66},{-40,66},{-40,100}},
      color={175,0,0},
      thickness=0.5));
  connect(fluidPortIn, hEXIdealVLETwoFluids_L1_4.fluidPortIn) annotation (Line(
      points={{40,98},{40,66},{70,66},{70,6}},
      color={175,0,0},
      thickness=0.5));
  connect(Block3.gasPortOut, hEXIdealVLETwoFluids_L1_4.gasPortIn) annotation (Line(
      points={{56,0.16},{62,0.16},{62,0},{64,0}},
      color={255,255,0},
      thickness=1.5));
  connect(dryer_L1_1.gasPortOut, gasPortOut) annotation (Line(
      points={{86,0},{100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(dryer_L1_1.fluidPortOut, boundaryVLE_pTxi.steam_a) annotation (Line(
      points={{84,2},{84,7},{83.5,7}},
      color={175,0,0},
      thickness=0.5));
  connect(hEXIdealVLETwoFluids_L1_4.gasPortOut, dryer_L1_1.gasPortIn) annotation (Line(
      points={{76,0},{82,0}},
      color={255,255,0},
      thickness=1.5));
  connect(hEXIdealVLETwoFluids_L1_4.fluidPortIn, temperatureSensor2.port) annotation (Line(
      points={{70,6},{70,28},{91,28},{91,40}},
      color={175,0,0},
      thickness=0.5));
  connect(hEXIdealVLETwoFluids_L1_4.fluidPortOut, temperatureSensor1.port) annotation (Line(
      points={{70,-6},{70,-20},{81,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(hEXIdealVLETwoFluids_L1_3.fluidPortOut, temperatureSensor3.port) annotation (Line(
      points={{25,6},{24,6},{24,20},{25,20}},
      color={175,0,0},
      thickness=0.5));
  connect(hEXIdealVLETwoFluids_L1_2.fluidPortOut, temperatureSensor4.port) annotation (Line(
      points={{-38,14},{-38,46},{-37,46}},
      color={175,0,0},
      thickness=0.5));
  connect(hEXIdealVLETwoFluids_L1_1.fluidPortOut, temperatureSensor5.port) annotation (Line(
      points={{-76,14},{-88,14},{-88,36},{-99,36}},
      color={175,0,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model represents a three staged methanation reactor with intermediate cooling and a recirculation at the first reactor block</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The detail of this model is the same as the detail of the single reactor blocks. The heat exchanger are simplified heat exchangers with a fixed output temperature. A detailed description is found in [1].</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">gaPortsIn: input of process gas</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">gasPortOut: output of process gas</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortIn: input of cooling fluid (e.g. water)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortOut: output of cooling fluid (e.g. water)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The recycle ratio defines the ratio of process gas that is recycled.</span></p><p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>The predefined parameter values come from a calibration with an input pressure of 25 bar and an input composition of 84.4884&percnt; CO2 and 15.5116&percnt; H2 which represents the composition for an ideal methanation. Herefore the recycle rate is calibrated to a value of 1.6, such that the hydrogen share in the product gas is always below 5 mol-&percnt; which is the maximum share according to the DVGW G 260/262 which regulated the conditions for the integration of gas into the natural gas grid in Germany.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Validated in [1] with data from [2].</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Sch&uuml;lting, Oliver - Vergleich von Power-to-Gas-Speichern mit Ziel der R&uuml;ckverstromung unter derzeit g&uuml;ltigen technischen Restriktionen (Masterarbeit), Technische Universit&auml;t Hamburg - Institut f&uuml;r Energietechnik, 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[2] Harms, Hans - Methanisierung kohlenmonoxidreicher Gase beim Energie-Transport, Chem.-Ing.-Tech, 1980</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Nov 2019</span></p>
</html>"));
end MethanationThreeStages;
