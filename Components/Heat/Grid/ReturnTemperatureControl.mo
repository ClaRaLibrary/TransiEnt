within TransiEnt.Components.Heat.Grid;
model ReturnTemperatureControl "Pump controlled for target return temperature"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  import TransiEnt;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid Medium = simCenter.fluid1 "Medium in the component";
  parameter Boolean use_heatingCurve=true "By default tries to adjust power according to T_return";
  parameter SI.Temperature T_target=363.15 "Target temperature at inlet"  annotation(Dialog(enable=not use_heatingCurve));

  parameter Modelica.Blocks.Types.SimpleController controllerType=.Modelica.Blocks.Types.SimpleController.PID "Type of controller";
  parameter SI.Power P_min=40 "Minimum power of pump";
  parameter SI.Power P_max=999999 "Maximum power of pump";
  parameter Real k=10 "Gain of controller";
  parameter SI.Time Ti=10 "Time constant of Integrator block";
  parameter SI.Time Td=10 "Time constant of Derivative block";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Temperature T_return = returnTemperatureSensor.T;
  SI.PressureDifference Delta_p=pump.Delta_p;
  SI.Power P_drive_pump = pump.P_drive;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=Medium) "fluidport supply on consumer side" annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=Medium) "fluidport return on consumer side" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
protected
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pump(
    medium=Medium,
    eta_mech=1,
    showData=false) annotation (Placement(transformation(extent={{22,10},{42,-10}})));

protected
  ClaRa.Components.Sensors.SensorVLE_L1_T returnTemperatureSensor(medium=Medium) annotation (Placement(transformation(extent={{-14,-52},{6,-32}})));
  Modelica.Blocks.Continuous.LimPID PID(
    limitsAtInit=true,
    k=k,
    yMin=P_min,
    y_start=P_min,
    initType=Modelica.Blocks.Types.InitPID.NoInit,
    controllerType=controllerType,
    Ti=Ti,
    Td=Td,
    yMax=P_max)                                    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={32,-40})));

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
   if use_heatingCurve then
     PID.u_s = simCenter.heatingCurve.T_return;
   else
     PID.u_s = T_target;
   end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(PID.y, pump.P_drive)           annotation (Line(
      points={{32,-29},{32,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(waterPortIn,waterPortIn)  annotation (Line(
      points={{-100,0},{-100,0}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(pump.inlet,waterPortIn)  annotation (Line(
      points={{22,0},{-100,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pump.outlet,waterPortOut)  annotation (Line(
      points={{42,0},{100,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(returnTemperatureSensor.port,waterPortIn)  annotation (Line(
      points={{-4,-52},{-52,-52},{-52,0},{-100,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PID.u_m, returnTemperatureSensor.T) annotation (Line(
      points={{20,-40},{12,-40},{12,-42},{7,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255}),
                              Line(
          points={{0,100},{100,2},{0,-100}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Control return temperature in heat grids.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
<p>Model created by Lisa Andresen (andresen@tuhh.de), Dec 2014</p>
</html>"));
end ReturnTemperatureControl;
