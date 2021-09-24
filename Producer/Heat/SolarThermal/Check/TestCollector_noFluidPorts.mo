within TransiEnt.Producer.Heat.SolarThermal.Check;
model TestCollector_noFluidPorts


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
  inner TransiEnt.SimCenter simCenter(ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY
        globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY
        directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY
        diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Berlin_3600s_2012
        temperature,
      redeclare
        TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012
        wind),
    integrateHeatFlow=true,
    calculateCost=true,
    integrateCDE=true)
    annotation (Placement(transformation(extent={{-84,78},{-64,98}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-54,78},{-34,98}})));
  TransiEnt.Producer.Heat.SolarThermal.SolarCollector_L1_constProp solarCollector(
    Q_flow_n=2e3,
    area=2.33,
    eta_0=0.793,
    a1=4.04,
    a2=0.0182,
    c_eff=5000,
    G_min=controller.G_min,
    useFluidPorts=false,
    redeclare model Skymodel = TransiEnt.Producer.Heat.SolarThermal.Base.Skymodel_isotropicDiffuse) annotation (Placement(transformation(extent={{-18,-76},{2,-56}})));
  TransiEnt.Producer.Heat.SolarThermal.Control.ControllerPumpSolarCollectorTandG controller(
    G_min=150,
    eta_mech=0.98,
    T=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1000,
    initType_PID=Modelica.Blocks.Types.Init.InitialOutput,
    y_start_PID=10,
    T_set=358.15,
    m_flow_min=0.0047,
    Delta_p=15000,
    rho_m=1000,
    P_drive_min(k=controller.m_flow_min)) annotation (Placement(transformation(extent={{50,0},{80,24}})));
  Modelica.Blocks.Sources.RealExpression Temp_stor(y=20 + 273.15) annotation (Placement(transformation(extent={{-72,-38},{-52,-18}})));
equation
  connect(controller.G_total, solarCollector.G) annotation (Line(points={{52,5},{0,5},{0,-57}}, color={0,0,127}));
  connect(solarCollector.T_out, controller.T_out) annotation (Line(points={{-2,-57},{-2,10},{52,10}}, color={0,0,127}));
  connect(controller.T_stor, Temp_stor.y) annotation (Line(points={{52,0},{-40,0},{-40,-28},{-51,-28}}, color={0,0,127}));
  connect(controller.T_in, Temp_stor.y) annotation (Line(points={{52,14.4},{-44,14.4},{-44,-28},{-51,-28}}, color={0,0,127}));
  connect(controller.P_drive, solarCollector.m_flow) annotation (Line(
      points={{52,18},{-18,18},{-18,-56.9},{-17.3,-56.9}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(Temp_stor.y, solarCollector.T_inflow) annotation (Line(points={{-51,-28},{-14.9,-28},{-14.9,-55.9}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-22,76},{84,68}},
          textColor={28,108,200},
          fontSize=10,
          horizontalAlignment=TextAlignment.Left,
          textString="Look at:
- solarCollector.m_flow
- solarCollector.Q_flow_collector
- solarCollector.T_out
")}),
    experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for Collector with disabled fluid ports </p>
<p>CheckModel&nbsp;analogous&nbsp;to&nbsp;TransiEnt.Producer.Heat.SolarThermal.Check.TestCollectorFluidCycle to&nbsp;compare&nbsp;solarCollector_energybased&nbsp;with&nbsp;TransiEnt&nbsp;model&nbsp;for&nbsp;SolarCollector_L1</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestCollector_noFluidPorts;
