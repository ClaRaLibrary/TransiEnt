within TransiEnt.Consumer.Heat.SpaceHeating;
model RoomFloorHeating "Room model with floor heating system"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // final parameters
  final parameter Modelica.SIunits.Length l = geometry.a*geometry.b/heatingsystem.distance_pipes "Length of the pipes of the heating floor";
  final parameter Modelica.SIunits.Volume V_floor=geometry.a*geometry.b*heatingsystem.h_floorFill-Modelica.Constants.pi*heatingsystem.d_pipe^2*l "Volume of floor material with a high temperature";
  final parameter Modelica.SIunits.HeatCapacity C_eff = 50*3600*geometry.V_room "DIN EN 12831 Appendix NA, p. 32 for medium buildingmass";
  final parameter Modelica.SIunits.ThermalConductance K_eff = (geometry.A_ext*thermodynamics.U_ext+geometry.A_roof*thermodynamics.U_roof)+0.34*geometry.V_room*thermodynamics.n_min "DIN EN 12831 Appendix NA, p. 32 for medium buildingmass";
  final parameter Modelica.SIunits.Time tau_eff = C_eff/K_eff "apprximate building time constant";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable parameter Base.RoomGeometry geometry=Base.RoomGeometry() constrainedby Base.RoomGeometry "Room geometry" annotation (choicesAllMatching=true);
  replaceable parameter Base.ThermodynamicProperties thermodynamics=Base.ThermodynamicProperties() constrainedby Base.ThermodynamicProperties "Thermodynamic properties of room"
                                                                                                    annotation (choicesAllMatching=true);
  replaceable parameter Base.FloorHeatingSystem heatingsystem=Base.FloorHeatingSystem() constrainedby Base.FloorHeatingSystem "Floor heating system parameters" annotation (choicesAllMatching=true);
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium in heating system" annotation(choicesAllMatching=true);
  parameter Boolean use_T_amb_input = false "Use external input connector to set individual ambient temperatur";

  final parameter SI.HeatFlowRate Q_flow_heating_n=70*geometry.A_floor;
  parameter SI.TemperatureDifference Delta_T_floorHeating_n=9;
  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterIn(Medium=medium) annotation (Placement(transformation(extent={{80,80},{100,100}}), iconTransformation(extent={{80,80},{100,100}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterOut(Medium=medium) annotation (Placement(transformation(extent={{80,-100},{100,-80}}), iconTransformation(extent={{80,-100},{100,-80}})));

   TransiEnt.Basics.Interfaces.General.TemperatureIn T_Amb if use_T_amb_input "Ambient Temperature"
    annotation (Placement(transformation(extent={{-116,28},{-92,52}}), iconTransformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={3,99})));
  TransiEnt.Basics.Interfaces.General.TemperatureOut T_Room "Room Temperature"
    annotation (Placement(transformation(extent={{-90,-50},{-110,-30}})));

protected
        TransiEnt.Basics.Interfaces.General.TemperatureIn T_amb_internal;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph waterInState(
    computeVLEAdditionalProperties=false,
    computeVLETransportProperties=false,
    computeTransportProperties=false,
    p=waterIn.p,
    h=inStream(waterIn.h_outflow),
    redeclare TILMedia.VLEFluidTypes.TILMedia_Water vleFluidType) annotation (Placement(transformation(extent={{56,76},{82,100}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT waterOutState(
    redeclare TILMedia.VLEFluidTypes.TILMedia_Water vleFluidType,
    p=waterOut.p,
    T=T_waterOut) annotation (Placement(transformation(extent={{52,-100},{72,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  //Energy and Heatflow
  Modelica.SIunits.HeatFlowRate Q_flow_WaterIn "with ingoing massflow arriving power";
  Modelica.SIunits.HeatFlowRate Q_flow_WaterOut "with outgoing massflow leaving power";
  Modelica.SIunits.HeatFlowRate Q_flow_groundsurface_to_room "heat flow from the surface of tho floor to the room";
  Modelica.SIunits.HeatFlowRate Q_flow_externalWall_to_environement "heat flow from the wall to the environement";
  Modelica.SIunits.HeatFlowRate Q_flow_room_to_externalWall "heat flow from the room to the external wall";
  Modelica.SIunits.HeatFlowRate Q_flow_room_to_internalWall "heat flow from the room to the internal walls";
  Modelica.SIunits.HeatFlowRate Q_flow_loss_vent "lost heat flow due to minimal needed air exchange";
  Modelica.SIunits.HeatFlowRate Q_flow_intSources "heat flow due to internal heat sources";

  Modelica.SIunits.InternalEnergy U_room "internal energy of the air in the room";
  Modelica.SIunits.InternalEnergy U_floor "internal energy of the floor";
  Modelica.SIunits.InternalEnergy U_extWall "internal energy of the external Walls";
  Modelica.SIunits.InternalEnergy U_intWall "internal energy of the internal Walls";

  Modelica.SIunits.Heat Q_needed(stateSelect=StateSelect.prefer, start=0, fixed=true);
  Modelica.SIunits.HeatFlowRate Q_flow_needed;
  Real need_of_thermal_heat(unit="J/(m2)",displayUnit="kWh/(m2)") "Area specific need for heat";

  Modelica.SIunits.HeatFlowRate Q_flow_heating;

  // Temperatures
  Modelica.SIunits.Temperature T_room( stateSelect=StateSelect.prefer, start = 273.15+20, fixed = true) annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.SIunits.Temperature T_floor(stateSelect=StateSelect.prefer,  start = 273.15+20, fixed= true) annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.SIunits.Temperature T_waterOut;
  Modelica.SIunits.Temperature T_wallInside(stateSelect=StateSelect.prefer, start=273.15+20, fixed=true) annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.SIunits.Temperature T_wallOutside;
  Modelica.SIunits.Temperature T_wallInternal(stateSelect=StateSelect.prefer, start=(273.15+20+273.15+20)/2, fixed=true) annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.SIunits.TemperatureDifference Delta_T_floorHeating;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //
  // *******  Temperatures *******
  //

   T_Room=T_room;

   connect(T_amb_internal, T_Amb);
   if not use_T_amb_input then
     T_amb_internal = simCenter.T_amb_var+273.15;
   end if;

  //
  // *******  Internal heat sources *******
  //
  if noEvent(T_amb_internal<288.15) then
  Q_flow_intSources=thermodynamics.q_i*geometry.A_eff;
  else
    Q_flow_intSources =0;
  end if;

  //
  // *******  balance equations of the floor *******
  //

  // heat flow from the surface of the ground to the room
    Q_flow_groundsurface_to_room = thermodynamics.alpha_groundsurface*geometry.A_floor*(T_floor-T_room);

  // Energy stored in floor
     U_floor=V_floor*heatingsystem.rho_floor*heatingsystem.cp_floor*T_floor;

  // Energy balance of the floor
     der(U_floor)=Q_flow_WaterIn+Q_flow_WaterOut-Q_flow_groundsurface_to_room;

  //massbalance
     waterIn.m_flow + waterOut.m_flow =0;

  //impulse balance
     waterIn.p-waterOut.p=heatingsystem.dp;

  //energy balance
     waterOut.h_outflow = waterOutState.h;
     waterIn.h_outflow = Q_flow_WaterIn/abs(waterIn.m_flow);

  //Heatflowrate for balance control
  //     Q_flow_WaterIn=waterIn.m_flow*waterInState.cp*waterInState.T;
     Q_flow_WaterIn=waterIn.m_flow*inStream(waterIn.h_outflow);
     //     Q_flow_WaterOut=waterOut.m_flow*waterOutState.cp*waterOutState.T;
     Q_flow_WaterOut=waterOut.m_flow*waterOut.h_outflow;

  // Calcualation of temperature of outgoinig waterflow
    T_waterOut= max(waterInState.T-Delta_T_floorHeating, T_amb_internal);

  //
  // *******  energy balance of the external walls *******--
  //

    // Heat flow from the room to the walls
   Q_flow_room_to_externalWall = thermodynamics.alpha_roomWall*(geometry.A_ext+geometry.A_roof)*(T_room-T_wallInside);

   // Heat flow from the external wall to the environement
   Q_flow_externalWall_to_environement = thermodynamics.alpha_wallAmbiance*(geometry.A_ext+geometry.A_roof)*(T_wallOutside-T_amb_internal);

   Q_flow_externalWall_to_environement = (geometry.A_ext*thermodynamics.U_ext+geometry.A_roof*thermodynamics.U_roof)*(T_room-T_amb_internal);

   //Energy stored in external walls
    U_extWall=(geometry.A_ext+geometry.A_roof)*geometry.d_wall*thermodynamics.cp_ext *(T_wallInside+T_wallOutside)/2;

   //Energy balance in the external wall
   der(U_extWall)=Q_flow_room_to_externalWall-Q_flow_externalWall_to_environement;

   //
   // *******  energy balance of the internal walls *******
   //

   // Heat flow from the room to the walls and the ceiling

   Q_flow_room_to_internalWall = thermodynamics.alpha_roomWall*(geometry.A_int+geometry.A_roof)*(T_room-T_wallInternal);

   //Energy stored in internal wall
   U_intWall=(geometry.A_int*geometry.d_wallInt+geometry.A_roof*geometry.d_ceiling) *thermodynamics.cp_int*T_wallInternal;

   //Energy balance in the internal wall
   der(U_intWall)=Q_flow_room_to_internalWall;

   //
   // *******  Heat loss due to ventilation *******
   //

   Q_flow_loss_vent = 0.34*thermodynamics.n_min*geometry.V_room*(T_room-T_amb_internal);

   //
   // *******  energy balance of the room *******
   //

   //Energy stored in the air of the room
   U_room=geometry.V_room*thermodynamics.rho_air*thermodynamics.cp_air*T_room;

   //Energy balance of the air of the room
   der( U_room)=Q_flow_groundsurface_to_room+Q_flow_intSources-Q_flow_loss_vent-Q_flow_room_to_internalWall-Q_flow_room_to_externalWall;

   //
   // *******  Diagnostic variables *******
   //
   Q_flow_heating=(Q_flow_WaterIn+Q_flow_WaterOut);
   Q_flow_needed=(Q_flow_WaterIn+Q_flow_WaterOut);
   Delta_T_floorHeating=Delta_T_floorHeating_n * Q_flow_heating / Q_flow_heating_n;

   der( Q_needed)=Q_flow_needed;
   need_of_thermal_heat = Q_needed/geometry.A_eff;
  annotation (defaultComponentName="RoomFloorHeating", Diagram(graphics,
                                                               coordinateSystem(preserveAspectRatio=false, extent={{-100,            -100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics={
        Rectangle(
          extent={{-66,50},{70,-54}},
          lineColor={135,135,135},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,36},{58,-42}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-28,0},{10,1.07126e-015}},
          color={0,127,127},
          origin={2,-34},
          rotation=90,
          thickness=0.5),
        Line(
          points={{-28,0},{-18,6}},
          color={0,127,127},
          origin={8,-6},
          rotation=90,
          thickness=0.5),
        Line(
          points={{28,0},{18,6}},
          color={0,127,127},
          origin={2,-52},
          rotation=90,
          thickness=0.5)}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Room model with floor heating system.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>waterIn: FluidPort&Igrave;n</p>
<p>waterOut: FluidPortOut</p>
<p>T_Amb if use_T_amb_input: input for temperature in [K]</p>
<p>T_room_act: output for temperature in [K]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end RoomFloorHeating;
