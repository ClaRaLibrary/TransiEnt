within TransiEnt.Producer.Heat.Power2Heat;
model BivalentHeatpumpSystem "Heatpump system with bivalent control, floor heating and lumped heat storage"
  import TransiEnt;
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

  extends TransiEnt.Producer.Heat.Power2Heat.Base.PartialHeatPumpSystemModel(params(HPInitStatus=2), final nStor=0);

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fluid Definition"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn inlet(Medium=medium) annotation (Placement(transformation(extent={{90,-58},{110,-38}}), iconTransformation(extent={{90,-60},{110,-40}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut outlet(Medium=medium) annotation (Placement(transformation(extent={{90,42},{110,62}}), iconTransformation(extent={{90,40},{110,60}})));
  Modelica.Blocks.Interfaces.RealInput T_feed_set "Setpoint for feed water temperature" annotation (Placement(transformation(extent={{-120,-18},{-80,22}})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{90,78},{110,98}}), iconTransformation(extent={{88,68},{112,92}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Components.Sensors.SensorVLE_L1_T T_in(medium=medium) annotation (Placement(transformation(extent={{52,-50},{38,-36}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_out(medium=medium) annotation (Placement(transformation(extent={{60,66},{46,80}})));
  TransiEnt.Producer.Heat.Power2Heat.Components.HeatpumpFluidPorts Heatpump(
    Delta_T_db=params.DTdb_heatpump,
    Q_flow_n=params.Q_flow_n_heatpump,
    COP_n=params.COP_n_heatpump,
    T_bivalent=params.T_bivalent,
    heatFlowBoundary(
      m_flow_nom=params.Q_flow_n_heatpump/(4.2e3*20),
      h_nom=4.2e3*40,
      C=4.2e3*1/1000*1000),
    delta_p=1000,
    T_heatingLimit=params.T_lim_degC + 273.15) annotation (Placement(transformation(extent={{-38,-32},{10,14}})));
  Modelica.Blocks.Sources.BooleanExpression isPeakload(y=(273.15 + simCenter.T_amb_var) < params.T_bivalent) annotation (Placement(transformation(extent={{-39,22},{-19,42}})));
  Modelica.Blocks.Sources.Constant zero(k=0) annotation (Placement(transformation(extent={{-34,15},{-24,25}})));
  Modelica.Blocks.Logical.Switch Q_flow_peakload annotation (Placement(transformation(extent={{-4,25},{10,39}})));
  ElectricBoiler Peakload(
    Q_flow_n=params.Q_flow_n_peakunit,
    eta=params.eta_peakunit,
    redeclare TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary,
    usePowerPort=true) annotation (Placement(transformation(extent={{32,22},{52,42}})));

  Modelica.Blocks.Sources.RealExpression Q_flow_set_peakload(y=inlet.m_flow*(inStream(inlet.h_outflow) - outlet.h_outflow)) annotation (Placement(transformation(extent={{-39,42},{-19,62}})));
equation
   // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

   // Characteritic equatuions for inherited variables
   P_el = Heatpump.epp.P + Peakload.epp.P;
   P_el_n = Heatpump.P_el_n + Peakload.P_el_n;
   Q_flow_demand =Q_flow_gen;
   Q_flow_max = params.Q_flow_n_peakunit + Heatpump.COP.y*Heatpump.P_el_n;
   Q_flow_gen = Heatpump.Q_flow.y + Q_flow_peakload.y;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(T_in.port, inlet) annotation (Line(
      points={{45,-50},{100,-50},{100,-48}},
      color={0,131,169},
      thickness=0.5));
  connect(T_in.port, Heatpump.waterIn) annotation (Line(
      points={{45,-50},{10.24,-50},{10.24,-22.57}},
      color={0,131,169},
      thickness=0.5));
  connect(zero.y,Q_flow_peakload. u3) annotation (Line(points={{-23.5,20},{-23.5,20},{-10,20},{-10,26.4},{-5.4,26.4}},
                                                                                              color={0,0,127}));
  connect(isPeakload.y, Q_flow_peakload.u2) annotation (Line(points={{-18,32},{-5.4,32}}, color={255,0,255}));
  connect(Heatpump.waterOut, Peakload.fluidPortIn) annotation (Line(
      points={{10.48,0.2},{32.2,0.2},{32.2,32}},
      color={175,0,0},
      thickness=0.5));
  connect(Peakload.fluidPortOut, outlet) annotation (Line(
      points={{52,32},{52,52},{100,52}},
      color={175,0,0},
      thickness=0.5));
  connect(Q_flow_peakload.y, Peakload.Q_flow_set) annotation (Line(points={{10.7,32},{22,32},{22,44},{34,44},{42,44},{42,42}},
                                                                                                               color={0,0,127}));
  connect(Peakload.fluidPortOut, T_out.port) annotation (Line(
      points={{52,32},{52,66},{53,66}},
      color={175,0,0},
      thickness=0.5));
  connect(Heatpump.u_set,T_feed_set)  annotation (Line(points={{-38.96,-9},{-44,-9},{-44,-10},{-50,-10},{-50,2},{-100,2}}, color={0,0,127}));
  connect(Peakload.epp, epp) annotation (Line(
      points={{42,22},{42,10},{70,10},{70,88},{100,88}},
      color={0,135,135},
      thickness=0.5));
  connect(Heatpump.epp, epp) annotation (Line(
      points={{10,9.4},{40,9.4},{40,10},{70,10},{70,88},{100,88}},
      color={0,135,135},
      thickness=0.5));
  connect(T_out.T, Heatpump.u_meas) annotation (Line(points={{45.3,73},{45.3,73},{-56,73},{-56,-53},{-14,-53},{-14,-34.76}}, color={0,0,127}));
  connect(Q_flow_set_peakload.y, Q_flow_peakload.u1) annotation (Line(points={{-18,52},{-12,52},{-12,37.6},{-5.4,37.6}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model contains a bivalent controlled heatpump system with floor heating and lumped heat storage.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortIn: Fluid Inlet</p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortOut: Fluid Outlet</p>
<p>Modelica.Blocks.Interfaces.RealInput: T_feed_set (Setpoint for feed water temperature)</p>
<p>TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort: epp</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>P_el = Heatpump.epp.P + Peakload.epp.P</p>
<p>P_el_n = Heatpump.P_el_n + Peakload.P_el_n</p>
<p>Q_flow_demand =T_feed_set</p>
<p>Q_flow_max = params.Q_flow_n_peakunit + Heatpump.COP.y*Heatpump.P_el_n</p>
<p>Q_flow_gen = Heatpump.Q_flow.y + Q_flow_peakload.y</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end BivalentHeatpumpSystem;
