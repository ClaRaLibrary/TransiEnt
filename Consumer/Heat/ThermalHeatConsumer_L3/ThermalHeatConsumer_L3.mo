within TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3;
model ThermalHeatConsumer_L3

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
  extends TransiEnt.Basics.Icons.Consumer;
  outer TransiEnt.SimCenter simCenter;
  import SI = Modelica.SIunits;

      // ____________________________________________
      //
      //        Constants and Parameters
      // _____________________________________________

   // Geometry
        parameter SI.Length B=8.2 "Width of Building" annotation (Dialog( group="Geometry"));
        parameter SI.Length L=12.3 "Length of Building"
                                                       annotation (Dialog( group="Geometry"));
        parameter SI.Length H=2.59 "Height of Building"
                                                       annotation (Dialog( group="Geometry"));
        final parameter SI.Volume V=H*B*L;
        parameter SI.Area A[3]={L*B+2*L*H+B*H,L*B,B*H} "Base Area of Building"
                                                                              annotation (Dialog( group="Geometry"));
        parameter Real til[3]={Modelica.Constants.pi/2,Modelica.Constants.pi,Modelica.Constants.pi/2} "Tilt of Walls"
                                                                                                                     annotation (Dialog( group="Geometry"));
        parameter Modelica.SIunits.Area A_Window[4] = {6.28,3.87,5.816,0} "Total Window Area for Walls Facing South, West, North, East"
                                                                                                                                       annotation (Dialog( group="Geometry"));
        final parameter Modelica.SIunits.Area A_Win=A_Window[1]+A_Window[2]+A_Window[3]+A_Window[4];

   // Thermal Properties
        parameter SI.HeatCapacity C=19e6 "Heat Capacity of Inner Walls"
                                                                       annotation (Dialog( group="Thermal Properties"));
        parameter SI.CoefficientOfHeatTransfer h_int=7.69 "Interior Heat Transfer Coefficient"
                                                                                              annotation (Dialog( group="Thermal Properties"));
        parameter SI.CoefficientOfHeatTransfer h_ext=25 "Exterior Heat Transfer Coefficient"
                                                                                            annotation (Dialog( group="Thermal Properties"));
        parameter Modelica.SIunits.Temperature T_start=273.15 + 22 "Start Temperature of Room Air" annotation (Dialog(group="Thermal Properties"));
        constant Modelica.SIunits.Temperature T_start_medium=273.15 + 22 "Start Temperature of Room Air" annotation (Dialog(group="Thermal Properties"));
        parameter Real k_Win=3.4 "Total Thermal Transmission Coefficient of Window (incl. outer and interior heat transfer coefficient"
                                                                                                                                       annotation (Dialog( group="Thermal Properties"));
        parameter Real tau_diff=0.6 "Transmittance of Window for Diffuse Radiation"
                                                                                   annotation (Dialog( group="Thermal Properties"));
        parameter Real tau_dir=0.6 "Transmittance of Window for Direct Radiation"
                                                                                 annotation (Dialog( group="Thermal Properties"));
        parameter Real abs=0.05 "Absorbance of Window for Solar Radiation"
                                                                          annotation (Dialog( group="Thermal Properties"));

   // Ventilation Parameters
        parameter Real ACR=0.5  "Air Change Rate"
                                                 annotation (Dialog( group="Ventilation"));
        parameter Real HR=0  "Heat Regeneration" annotation (Dialog( group="Ventilation"));
        parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*1.2*6/3600 "Nominal Mass Flow Rate for Numerical Reasons (see Buildings.Examples.Tutorial.Boiler.System1 for more Information)"
                                                                                                                                                                                                   annotation (Dialog( group="Ventilation"));

      // _____________________________________________
      //
      //             Variable Declarations
      // _____________________________________________

       SI.Temperature T_amb=simCenter.T_amb_var+273.15 "Ambient temperature in K";

      // _____________________________________________
      //
      //                  Interfaces
      // _____________________________________________

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_HeatDemand annotation (Placement(transformation(extent={{-126,66},{-106,86}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_internalGains annotation (Placement(transformation(extent={{-126,-40},{-106,-20}})));

      // _____________________________________________
      //
      //           Instances of other Classes
      // _____________________________________________

     // Walls
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=C, T(start=T_start)) annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-20,68})));

     // Exterior Walls
  replaceable Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matLayExt  "Structure of Exterior Wall" annotation (Dialog( group="Wall structure"),choicesAllMatching=true, Placement(transformation(extent={{14,-78},{26,-66}})));

  Buildings.ThermalZones.Detailed.Constructions.Construction Wall(
    layers=matLayExt,
    A=A[1] - A_Win,
    til=til[1],
    steadyStateInitial=true) annotation (Placement(transformation(extent={{24,-10},{-36,50}})));

     // Floor
  replaceable Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matLayFlo "Structure of Floor" annotation (Dialog( group="Wall structure"),choicesAllMatching=true,Placement(transformation(extent={{56,-78},{68,-66}})));

  Buildings.ThermalZones.Detailed.Constructions.Construction Ground(
    layers=matLayFlo,
    A=A[2],
    til=til[2],
    steadyStateInitial=true) annotation (Placement(transformation(extent={{24,-46},{-36,14}})));

     // Roof
  replaceable Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matLayRoof "Structure of Roof" annotation (
    Dialog(group="Wall structure"),
    choicesAllMatching=true,
    Placement(transformation(extent={{34,-78},{46,-66}})));

  Buildings.ThermalZones.Detailed.Constructions.Construction Roof(
    layers=matLayRoof,
    A=A[3],
    til=til[3],
    steadyStateInitial=true) annotation (Placement(transformation(extent={{24,-80},{-36,-20}})));

     // Window
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor3(G=A_Win*k_Win)  annotation (Placement(transformation(extent={{-62,-74},{-42,-54}})));
  Base.SolarRadiation solarRadiation(
    A=A,
    tau_diff=tau_diff,
    tau_dir_glas=tau_dir,
    abs=abs,
    A_Win=A_Window) annotation (Placement(transformation(extent={{-110,-16},{-90,4}})));

     // Air Volume
  package MediumA=Buildings.Media.Air (T_default=T_start_medium);
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=T_start,
    m_flow_nominal=mA_flow_nominal,
    V=V) annotation (Placement(transformation(extent={{-80,52},{-100,72}})));
  Base.Ventilation ventilation(
    h=H,
    AXR=ACR/3600,
    A=A[2],
    T_outside=T_amb) annotation (Placement(transformation(extent={{-98,14},{-80,32}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation (Placement(transformation(extent={{8,-8},{-8,8}},rotation=90,origin={-108,40})));

     // Temperature Boundaries
  TransiEnt.Components.Boundaries.Ambient.UndergroundTemperature undergroundTemperature annotation (Placement(transformation(extent={{80,-68},{94,-54}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation (Placement(transformation(extent={{80,-6},{60,14}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature prescribedTemperature1(T=T_amb - 273.15) annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature prescribedTemperature2(T=T_amb - 273.15) annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature prescribedTemperature3(T=T_amb - 273.15)
                                                                                           annotation (Placement(transformation(extent={{0,-74},{-20,-54}})));

     // Convective Elements
  Modelica.Thermal.HeatTransfer.Components.Convection con(Gc=(A[1] - A_Win)*h_int) annotation (Placement(transformation(extent={{-44,30},{-64,50}})));
  Modelica.Thermal.HeatTransfer.Components.Convection con1(Gc=A[3]*0.1)   annotation (Placement(transformation(extent={{-44,-40},{-64,-20}})));
  Modelica.Thermal.HeatTransfer.Components.Convection con2(Gc=A[2]*h_int) annotation (Placement(transformation(extent={{-44,-6},{-64,14}})));
  Modelica.Thermal.HeatTransfer.Components.Convection con3(Gc=(A[1] - A_Win)*h_ext) annotation (Placement(transformation(extent={{32,30},{52,50}})));
  Modelica.Thermal.HeatTransfer.Components.Convection con4(Gc=10000000) annotation (Placement(transformation(extent={{32,-6},{52,14}})));
  Modelica.Thermal.HeatTransfer.Components.Convection con5(Gc=A[3]*0.1)   annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Modelica.Thermal.HeatTransfer.Components.Convection con6(Gc=100*h_int) annotation (Placement(transformation(extent={{-44,58},{-64,78}})));

  Buildings.ThermalZones.Detailed.BaseClasses.SkyRadiationExchange skyRadiationExchange(
    n=1,
    A={A[1] - A_Win},
    vieFacSky={0.5},
    absIR={0.9},
    TBlaSky=273.15 - 10,
    TOut=T_amb) annotation (Placement(transformation(extent={{60,60},{40,80}})));
  Modelica.Blocks.Interfaces.RealOutput T_room annotation (Placement(transformation(extent={{-116,2},{-136,22}})));

equation

      // _____________________________________________
      //
      //               Connect Statements
      // _____________________________________________
  connect(con3.fluid, prescribedTemperature1.port) annotation (Line(points={{52,40},{60,40}},         color={191,0,0}));
  connect(con.fluid, vol.heatPort) annotation (Line(points={{-64,40},{-80,40},{-80,62}},
                                                                                     color={191,0,0}));
  connect(con2.fluid, vol.heatPort) annotation (Line(points={{-64,4},{-80,4},{-80,62}},   color={191,0,0}));
  connect(con1.fluid, vol.heatPort) annotation (Line(points={{-64,-30},{-80,-30},{-80,62}},                     color={191,0,0}));
  connect(Roof.opa_a, con5.solid) annotation (Line(points={{24,-30},{30,-30}}, color={191,0,0}));
  connect(con4.solid, Ground.opa_a) annotation (Line(points={{32,4},{24,4}},           color={191,0,0}));
  connect(Wall.opa_a, con3.solid) annotation (Line(points={{24,40},{32,40}},                         color={191,0,0}));
  connect(Wall.opa_b, con.solid) annotation (Line(points={{-36.2,40},{-44,40}},                   color={191,0,0}));
  connect(con2.solid, Ground.opa_b) annotation (Line(points={{-44,4},{-36.2,4}},              color={191,0,0}));
  connect(con1.solid, Roof.opa_b) annotation (Line(points={{-44,-30},{-36.2,-30}}, color={191,0,0}));
  connect(prescribedTemperature.port, con4.fluid) annotation (Line(points={{60,4},{52,4}},           color={191,0,0}));
  connect(prescribedTemperature.T, undergroundTemperature.T_underground) annotation (Line(points={{82,4},{93.58,4},{93.58,-61}},   color={0,0,127}));
  connect(prescribedTemperature2.port, con5.fluid) annotation (Line(points={{60,-30},{50,-30}},                            color={191,0,0}));
  connect(thermalConductor3.port_a, vol.heatPort) annotation (Line(points={{-62,-64},{-80,-64},{-80,62}},                  color={191,0,0}));
  connect(solarRadiation.window,thermalConductor3. port_a) annotation (Line(points={{-90.2,1.8},{-86,1.8},{-86,2},{-80,2},{-80,-64},{-62,-64}},
                                                                                                                                 color={191,0,0}));
  connect(temperatureSensor.T, ventilation.T_room) annotation (Line(points={{-108,32},{-108,21.02},{-98.72,21.02}}, color={0,0,127}));
  connect(temperatureSensor.port, vol.heatPort) annotation (Line(points={{-108,48},{-80,48},{-80,62}},       color={191,0,0}));
  connect(ventilation.port_a, vol.heatPort) annotation (Line(points={{-80,23},{-80,-18},{-80,62},{-80,62}},          color={191,0,0}));
  connect(con6.fluid, vol.heatPort) annotation (Line(points={{-64,68},{-80,68},{-80,62}},   color={191,0,0}));
  connect(heatCapacitor.port,con6. solid) annotation (Line(points={{-30,68},{-44,68}},                         color={191,0,0}));
  connect(vol.heatPort, port_HeatDemand) annotation (Line(points={{-80,62},{-80,76},{-116,76}},
                                                                                            color={191,0,0}));
  connect(solarRadiation.wall, Wall.opa_b) annotation (Line(points={{-90.2,-1.6},{-80,-1.6},{-80,24},{-36.2,24},{-36.2,40}},
                                                                                                     color={191,0,0}));
  connect(solarRadiation.ground, Ground.opa_b) annotation (Line(points={{-90,-6},{-80,-6},{-80,24},{-36,24},{-36,4},{-36.2,4}},
                                                                                                                           color={191,0,0}));
  connect(solarRadiation.roof, Roof.opa_b) annotation (Line(points={{-90.2,-12},{-36,-12},{-36,-30},{-36.2,-30}}, color={191,0,0}));
  connect(port_internalGains, vol.heatPort) annotation (Line(points={{-116,-30},{-80,-30},{-80,62}},
                                                                                                 color={191,0,0}));
  connect(thermalConductor3.port_b, prescribedTemperature3.port) annotation (Line(points={{-42,-64},{-20,-64}}, color={191,0,0}));
  connect(skyRadiationExchange.port[1], Wall.opa_a) annotation (Line(points={{40,70},{24,70},{24,40}},                   color={191,0,0}));
  connect(temperatureSensor.T, T_room) annotation (Line(points={{-108,32},{-110,32},{-110,12},{-126,12}}, color={0,0,127}));
  connect(port_HeatDemand, port_HeatDemand) annotation (Line(points={{-116,76},{-116,76}}, color={191,0,0}));
                                                                                                                                                                                        annotation (Placement(transformation(extent={{8,-74},{-12,-54}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-80},{100,80}}), graphics={
        Rectangle(
          extent={{-36,44},{36,22}},
          lineColor={162,29,33},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Line(points={{36,34},{48,34},{48,-26},{8,-26}}, color={162,29,33}),
        Line(points={{8,-6},{8,-48}}, color={162,29,33}),
        Line(points={{-8,-6},{-8,-48}}, color={162,29,33}),
        Line(points={{-8,-26},{-52,-26}}, color={162,29,33}),
        Line(points={{-54,34},{-36,34}}, color={162,29,33})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-80},{100,80}})),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008c48\">1. Purpose of model</span></h4>
<p>Low order model of a thermal heat consumer.</p>
<h4><span style=\"color: #008c48\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p><span style=\"font-family: sans-serif;\">The heat exchange with the environment is considered at a low resolution by aggregating the heat transfer through the walls and windows, the heat capacity and the heat gains and losses through solar irradiance, ventilation and internal sources each in one instance.</span></p>
<h4><span style=\"color: #008c48\">3. Limits of validity </span></h4>
<p>- No heat transfer inside consumer, transfered heat is directly connected to the consumer capacity</p>
<p>- Lumped capacity and heat transfer</p>
<h4><span style=\"color: #008c48\">4. Interfaces</span></h4>
<p>HeatPorts for Internal Gains and HeatDemand</p>
<h4><span style=\"color: #008c48\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008c48\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008c48\">7. Remarks for Usage</span></h4>
<p>This model uses instances of models from the <u><b>Buildings Library</b></u> developed by the Lawrence Berkeley National Laboratory. The library can be downloaded at <a href=\"https://simulationresearch.lbl.gov/modelica/download.html\">https://simulationresearch.lbl.gov/modelica/download.html</a>. </p>
<h4><span style=\"color: #008c48\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Consumer.Heat.Check.TestThermalHeatConsumer&quot;</p>
<h4><span style=\"color: #008c48\">9. References</span></h4>
<p>Michael Wetter, Wangda Zuo, Thierry S. Nouidui &amp; Xiufeng Pang (2014) Modelica Buildings library, Journal of Building Performance Simulation, 7:4, 253-270, DOI: <a href=\"https://doi.org/10.1080/19401493.2013.765506\">10.1080/19401493.2013.765506 </a></p>
<p><span style=\"font-family: sans-serif;\">Senkel, A. (2017) Vergleich verschiedener Arten der W&auml;rmeverbrauchsmodellierung in Modelica. Master Thesis. Hamburg University of Technology.</span></p>
<h4><span style=\"color: #008c48\">10. Version History</span></h4>
<p>Model created by Anne Senkel (anne.senkel@tuhh.de) September 2017</p>
</html>"));
end ThermalHeatConsumer_L3;
