within TransiEnt.Producer.Electrical.Wind;
model Windturbine_SI_DF "Pitch controlled WTG with delta F Synthetic Inertia"


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
  extends TransiEnt.Producer.Electrical.Wind.Base.PartialWindTurbine(P_el_n);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter SI.Velocity v_wind_small = 0.1 "Wind velocity considered as negligible" annotation (Dialog(tab="Wind Turbine Data"));
  parameter SI.Length D_Rotor=100 "Rotor diameter of wind turbine" annotation (Dialog(tab="Wind Turbine Data"));
  parameter Real J=12e6 "Moment of inertia of entire plant" annotation (Dialog(tab="Wind Turbine Data"));
  parameter TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.BetzCoefficientApproximation turbineCharacteristics=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.MOD2() "Characteristic behaviour of betz factor" annotation (choicesAllMatching=true, Dialog(tab="Wind Turbine Data"));
  parameter TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.WindSpeedOperationRanges operationRanges=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.ExampleTurbineRanges() "Wind speed operation ranges" annotation (choicesAllMatching=true, Dialog(tab="Wind Turbine Data"));
  parameter Modelica.Blocks.Types.SimpleController controllerType_p=.Modelica.Blocks.Types.SimpleController.PI "Type of controller"
                                                                                                    annotation (Dialog(tab="Controller", group="Pitch"),choicesAllMatching=true);
  parameter Real k_p=2e-5 "Gain of controller" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter SI.Time Ti_p=12 "Integral time constant of controller" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter SI.Time Td_p=3 "Derivative time constant of controller" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter Real yMax_p=30 "Upper limit of PI controlled beta setpoint" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter Real yMin_p=0 "Lower limit of output" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter Real beta_start "Setpoint for pitch angle" annotation (Dialog(tab="Wind Turbine Data"));
  parameter Real v_wind_start "Setpoint for wind speed" annotation (Dialog(tab="Wind Turbine Data"));

  parameter Boolean use_inertia= false "activate synthetic inertia";
  parameter Boolean integratePower=false "True if power shall be integrated";

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  final parameter SI.AngularVelocity omega_start=if v_wind_start > 12 then omega_n else if (v_wind_start > 4 and v_wind_start < 12) then (Rotor.lambda_opt/Rotor.D*2*v_wind_start) else 1e-3;
  final parameter Real v_fullload = (8*P_el_n
                                            /(Rotor.rho*Modelica.Constants.pi*Rotor.D^2*Rotor.cp_opt))^(1/3);
  final parameter SI.AngularVelocity omega_n=Rotor.lambda_opt*v_fullload*2/Rotor.D;

protected
  TransiEnt.Basics.Interfaces.General.FrequencyIn f_internal "Needed to connect to conditional connector";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
public
  Real P_powerplant_pu "Power plant per unit";
  SI.ActivePower P_el_is = -epp.P;
  Boolean is_running(start=true, fixed=true) "For continuous plants always true, for discontinous depending on state";
  Real no_inertia=50;

public
  TransiEnt.Components.Electrical.Machines.VariableSpeedActivePowerGenerator Generator(terminal(change_sign=true), changeSign=true) annotation (Placement(transformation(extent={{16,-32},{44,-2}})));
  TransiEnt.Producer.Electrical.Wind.Base.WindturbineRotor Rotor(
    D=D_Rotor,
    P_el_n=P_el_n,
    beta_start=beta_start,
    turbineCharacteristics=turbineCharacteristics) annotation (Placement(transformation(extent={{-42,-28},{-22,-8}})));

  Modelica.Blocks.Sources.RealExpression v_wind1(y=max(v_wind_small, v_wind_internal))
                                                                   annotation (Placement(transformation(extent={{-72,-28},
            {-56,-8}})));
  TransiEnt.Producer.Electrical.Wind.Controller.PitchController_SI_deltaF pitchController(
    turbine=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.ExampleTurbineRanges(),
    k=k_p,
    Ti=Ti_p,
    yMax=yMax_p,
    yMin=yMin_p,
    controllerTypePitchCtrl=controllerType_p,
    v_wind=v_wind1.y,
    PitchControllerTimeConstant(T=50),
    Td=Td_p,
    beta_start=beta_start,
    P_el_n=P_el_n) annotation (Placement(transformation(extent={{-60,4},{-36,26}})));
  Modelica.Blocks.Sources.RealExpression omega_is(y=Rotor.omega)
    annotation (Placement(transformation(extent={{-40,40},{-12,58}})));

  Modelica.Blocks.Sources.RealExpression P_is(y=P_el_is)    annotation (Placement(transformation(extent={{-94,62},
            {-78,82}})));
  Modelica.Blocks.Sources.Constant P_set(k=P_el_n) annotation (Placement(transformation(extent={{-92,20},{-76,40}})));

  TransiEnt.Producer.Electrical.Wind.Controller.TorqueController_SI_deltaF torqueController(
    v_wind=v_wind1.y,
    k_turbine=Rotor.k_turbine,
    J=Inertia.J,
    lambdaOpt=Rotor.lambda_opt,
    rho=Rotor.rho,
    radius=Rotor.D/2,
    cp_opt=Rotor.cp_opt,
    tau_n=P_el_n/omega_n,
    v_cutIn=operationRanges.v_cutIn,
    v_fullLoad=operationRanges.v_fullLoad) annotation (Placement(transformation(rotation=0, extent={{8,22},{28,42}})));

  Modelica.Blocks.Sources.RealExpression freq(y=f_internal)
    annotation (Placement(transformation(extent={{-102,106},{-74,124}})));

  Modelica.Blocks.Sources.RealExpression f_n(y=50)
    annotation (Placement(transformation(extent={{-102,120},{-74,138}})));
  Modelica.Blocks.Sources.RealExpression P_pu(y=P_powerplant_pu)
    annotation (Placement(transformation(extent={{-50,80},{-22,98}})));
  Real T_pu;
  Modelica.Blocks.Sources.RealExpression Torque_pu(y=T_pu)
    annotation (Placement(transformation(extent={{-114,-88},{-86,-70}})));
  Modelica.Blocks.Sources.RealExpression omega_pu(y=Generator.omega/omega_n) annotation (Placement(transformation(extent={{-114,-104},{-86,-86}})));
  Modelica.Blocks.Sources.RealExpression wind_fullload(y=v_fullload)
    annotation (Placement(transformation(extent={{-38,14},{-10,32}})));
  Modelica.Blocks.Sources.RealExpression T_Nom(y=P_el_n/omega_n) annotation (Placement(transformation(extent={{-4,68},{24,86}})));
  TransiEnt.Producer.Electrical.Wind.Base.DeadbandFilter deadbandFilter annotation (Placement(transformation(rotation=0, extent={{-26,108},{-6,128}})));
  SI.KineticEnergy E_rot;
  TransiEnt.Components.Mechanical.ConstantInertia Inertia(
    omega(start=omega_start),
    nSubgrid=1,
    J=J) annotation (choicesAllMatching=true, Placement(transformation(extent={{-16,-33},{8,-4}})));
  Modelica.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{-60,112},{-40,132}})));
  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter    annotation (Placement(transformation(
        extent={{-10,-10.5},{10,10.5}},
        rotation=-90,
        origin={62.5,18})));

equation
  // _____________________________________________
  //
  //             Equations
  // _____________________________________________

  if integratePower then
  der(E_rot)=Inertia.P_rot;
  else
    E_rot=0;
  end if;
  is_running=not pitchController.halt.active;

  P_powerplant_pu=P_el_is/P_el_n;
  T_pu=Generator.tau_set*omega_n/P_el_n;

  if not use_inertia then
    f_internal=no_inertia; //no meassurement of df_dt
  else f_internal=epp.f;
  end if;

  eta = Rotor.cp * Generator.eta;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(Generator.epp, epp) annotation (Line(
      points={{44.14,-17.15},{82,-17.15},{82,78},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(v_wind1.y, Rotor.v_wind) annotation (Line(points={{-55.2,-18},{-41.4,-18},
          {-41.4,-18.2}}, color={0,0,127}));

  connect(P_set.y, pitchController.u_s) annotation (Line(points={{-75.2,30},{-72,30},{-72,8.76667},{-60,8.76667}},
                                    color={0,0,127}));
  connect(P_is.y, pitchController.u_m) annotation (Line(points={{-77.2,72},{-66,
          72},{-66,13.35},{-60,13.35}},
                                  color={0,0,127}));

  connect(omega_is.y, torqueController.omega_is) annotation (Line(points={{-10.6,49},{7.6,49},{7.6,40.6}},
                                          color={0,0,127}));
  connect(deadbandFilter.y,
                      torqueController.freq_is) annotation (Line(points={{-5.8,117.8},{46,117.8},{46,16},{19.8,16},{19.8,21.8}},
                                                color={0,0,127}));
  connect(pitchController.freq_deviation, torqueController.freq_is) annotation (
     Line(points={{-56.3077,5.46667},{-56.3077,-2},{8,-2},{8,10},{19.8,10},{19.8,21.8}},
        color={0,0,127}));
  connect(torqueController.y, Generator.tau_set) annotation (Line(points={{28,32},{16.98,32},{16.98,-26.75}},
                                     color={0,0,127}));
  connect(pitchController.beta_set, Rotor.beta_set) annotation (Line(points={{-35.8154,10.9667},{-32,10.9667},{-32,-8.4}},
                                      color={0,0,127}));
  connect(Rotor.flange, Inertia.mpp_a) annotation (Line(points={{-21.8,-18},{
          -16,-18},{-16,-18.5}}, color={0,0,0}));
  connect(Inertia.mpp_b, Generator.mpp) annotation (Line(points={{8,-18.5},{12,-18.5},{12,-17},{16,-17}},
                                             color={95,95,95}));
  connect(P_pu.y, deadbandFilter.P_pu) annotation (Line(points={{-20.6,89},{-23.4,89},{-23.4,107.8}},
                            color={0,0,127}));
  connect(freq.y, add.u2) annotation (Line(points={{-72.6,115},{-68.3,115},{-68.3,
          116},{-62,116}}, color={0,0,127}));
  connect(f_n.y, add.u1) annotation (Line(points={{-72.6,129},{-70,129},{-70,128},{-62,128}}, color={0,0,127}));
  connect(add.y, deadbandFilter.u) annotation (Line(points={{-39,122},{-32,122},{-32,134},{-16,134},{-16,127.6}},
                                            color={0,0,127}));
  connect(deadbandFilter.delta_f, deadbandFilter.u) annotation (Line(points={{-26.4,124.8},{-32,124.8},{-32,134},{-16,134},{-16,127.6}},
                                                           color={0,0,127}));
  connect(wind_fullload.y, pitchController.wind_fullload) annotation (Line(points={{-8.6,23},{-4,23},{-4,32},{-60,32},{-60,24.1667}}, color={0,0,127}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{62.5,28},{62,28},{62,78},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(Exciter.y, Generator.E_input) annotation (Line(points={{62.5,7.4},{62.5,8},{62,8},{62,2},{30,2},{30,-2.15},{29.58,-2.15}}, color={0,0,127}));
    annotation (
              Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,140}})),                                                                     Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,140}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Extends pitch controlled WTG with a synthetic Inertia control depending on frequency deviation (delta f).</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Define nominal power, moment of inertia and starting wind speed before use.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Validated according to reference stated below.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Miller, N. et al: &quot;GE Wind Plant Dynamic Performance for Grid and Wind Events&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on June 21 2016</span></p>
</html>"));
end Windturbine_SI_DF;
