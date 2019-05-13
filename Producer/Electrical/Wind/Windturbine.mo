within TransiEnt.Producer.Electrical.Wind;
model Windturbine "Pitch controlled wind turbine model based on cp-lambda characteristic"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  import TransiEnt;
  extends TransiEnt.Producer.Electrical.Wind.Base.PartialWindTurbine(P_el_n=3.5e6);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Velocity v_wind_small = 0.1 "Wind velocity considered as negligible" annotation (Dialog(tab="Wind Turbine Data"));
  parameter Real J = 12e6 "Moment of inertia of entire plant" annotation (Dialog(tab="Wind Turbine Data"));
  final parameter SI.Length D_Rotor=Rotor.D "Rotor diameter of wind turbine" annotation (Dialog(tab="Wind Turbine Data"));
  parameter TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.BetzCoefficientApproximation turbineCharacteristics=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.MOD2() "Characteristic behaviour of betz factor" annotation (choicesAllMatching=true, Dialog(tab="Wind Turbine Data"));
  parameter TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.WindSpeedOperationRanges operationRanges=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.ExampleTurbineRanges() "Wind speed operation ranges" annotation (choicesAllMatching=true, Dialog(tab="Wind Turbine Data"));
  parameter Modelica.Blocks.Types.SimpleController controllerType_p=.Modelica.Blocks.Types.SimpleController.PID "Type of controller"
                                                                                                    annotation (Dialog(tab="Controller", group="Pitch"),choicesAllMatching=true);
  parameter Real k_p=5e-5 "Gain of controller" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter SI.Time Ti_p=14 "Integral time constant of controller" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter SI.Time Td_p=3.5 "Derivative time constant of controller" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter Real yMax_p=30 "Upper limit of PI controlled beta setpoint" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter Real yMin_p=0 "Lower limit of output" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter Real beta_start "Setpoint for pitch angle" annotation (Dialog(tab="Wind Turbine Data"));
  parameter SI.Velocity v_wind_start=10 "Setpoint for wind speed" annotation (Dialog(tab="Wind Turbine Data"));

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  final parameter SI.AngularVelocity omega_n=Rotor.lambda_opt*v_fullload*2/Rotor.D "Nominal angular velocity of rotor";
  final parameter SI.AngularVelocity omega_start=if v_wind_start > 12 then omega_n else if (v_wind_start > 4 and v_wind_start < 12) then (Rotor.lambda_opt/Rotor.D*2*v_wind_start) else 1e-3;
  final parameter Real v_fullload = (8*P_el_n/(Rotor.rho*Modelica.Constants.pi*Rotor.D^2*Rotor.cp_opt))^(1/3);

public
  SI.ActivePower P_el_is = -epp.P;
  Boolean is_running(start=true, fixed=true) "For continuous plants always true, for discontinous depending on state";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

 TransiEnt.Components.Electrical.Machines.VariableSpeedActivePowerGenerator Generator(changeSign=true)  annotation (Placement(transformation(extent={{18,-22},{46,8}})));
  Base.WindturbineRotor Rotor(
    beta_start=beta_start,
    turbineCharacteristics=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.VariableWTG_WU(),
    v_fullLoad=operationRanges.v_fullLoad,
    P_el_n=P_el_n) annotation (Placement(transformation(extent={{-40,-18},{-20,2}})));
  Modelica.Blocks.Sources.RealExpression v_wind1(y=max(v_wind_small, v_wind_internal))
                                                                   annotation (Placement(transformation(extent={{-72,-18},{-56,2}})));
  TransiEnt.Producer.Electrical.Wind.Controller.PitchController pitchController(
    turbine=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.ExampleTurbineRanges(),
    k=k_p,
    Ti=Ti_p,
    yMax=yMax_p,
    yMin=yMin_p,
    controllerTypePitchCtrl=controllerType_p,
    v_wind=v_wind1.y,
    Td=Td_p,
    beta_start=beta_start) annotation (Placement(transformation(extent={{-68,44},{-44,66}})));
  Modelica.Blocks.Sources.RealExpression omega_is(y=Rotor.omega)
    annotation (Placement(transformation(extent={{-30,46},{-2,64}})));

  Modelica.Blocks.Sources.RealExpression P_is(y=P_el_is)    annotation (Placement(transformation(extent={{-100,22},
            {-84,42}})));
  Modelica.Blocks.Sources.Constant P_set(k=P_el_n) annotation (Placement(transformation(extent={{-98,62},{-84,76}})));

  TransiEnt.Producer.Electrical.Wind.Controller.TorqueController torqueController(
    v_wind=v_wind1.y,
    k_turbine=Rotor.k_turbine,
    J=Inertia.J,
    lambdaOpt=Rotor.lambda_opt,
    rho=Rotor.rho,
    radius=Rotor.D/2,
    cp_opt=Rotor.cp_opt,
    v_cutIn=operationRanges.v_cutIn,
    tau_n=P_el_n/omega_n) annotation (Placement(transformation(rotation=0, extent={{12,54},{32,74}})));
  Modelica.Blocks.Sources.RealExpression wind_fullload(y=operationRanges.v_fullLoad)
    annotation (Placement(transformation(extent={{-30,62},{-2,80}})));

  TransiEnt.Components.Mechanical.ConstantInertia Inertia(
    omega(start=omega_start),
    nSubgrid=1,
    J=J) annotation (choicesAllMatching=true, Placement(transformation(extent={{-14,-21},{10,8}})));
 TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter    annotation (Placement(transformation(
        extent={{-10,-10.5},{10,10.5}},
        rotation=-90,
        origin={62.5,18})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________


equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  is_running=not pitchController.halt.active;
  eta = Rotor.cp * Generator.eta;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(Generator.epp, epp) annotation (Line(
      points={{46.14,-7.15},{80,-7.15},{80,78},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(v_wind1.y, Rotor.v_wind) annotation (Line(points={{-55.2,-8},{-39.4,-8},
          {-39.4,-8.2}},  color={0,0,127}));
  connect(omega_is.y, torqueController.omega_is) annotation (Line(points={{-0.6,55},
          {4,55},{4,58},{12,58}},     color={0,0,127}));

  connect(P_set.y, pitchController.u_s) annotation (Line(points={{-83.3,69},{-80,69},{-80,68},{-80,50},{-80,48},{-68,48}},
                                                            color={0,0,127}));
  connect(P_is.y, pitchController.u_m) annotation (Line(points={{-83.2,32},{-82,
          32},{-82,62},{-68,62}}, color={0,0,127}));
  connect(wind_fullload.y, torqueController.wind_fullload) annotation (Line(
        points={{-0.6,71},{8,71},{8,70},{12,70}}, color={0,0,127}));
  connect(Rotor.flange, Inertia.mpp_a) annotation (Line(points={{-19.8,-8},{-16,-8},{-16,-6.5},{-14,-6.5}}, color={0,0,0}));
  connect(Inertia.mpp_b, Generator.mpp) annotation (Line(points={{10,-6.5},{14,-6.5},{14,-7},{18,-7}},         color={95,95,95}));
  connect(torqueController.y, Generator.tau_set) annotation (Line(points={{33.6,64},{33.6,64},{42,64},{42,28},{18.98,28},{18.98,-16.75}},
                                                                                                                                  color={0,0,127}));
  connect(pitchController.beta_set, Rotor.beta_set) annotation (Line(points={{-46.4,48.2},{-44,48.2},{-44,30},{-30,30},{-30,1.6}}, color={0,0,127}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{62.5,28},{64,28},{64,54},{80,54},{80,78},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(Exciter.y, Generator.E_input) annotation (Line(points={{62.5,7.4},{46.25,7.4},{46.25,7.85},{31.58,7.85}}, color={0,0,127}));
    annotation (
              Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                                                     Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Pitch controlled WTG </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quasistationary model for real power simulation only.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>epp: choice of power port</p>
<p>v_wind: input for velocity in m/s</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Define nominal power and starting wind speed before use.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no reference)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Rebekka Denninger (rebekka.denninger@tuhh.de) on June 21 2016</span></p>
</html>"));
end Windturbine;
