within TransiEnt.Producer.Electrical.Wind;
model Windturbine_SI_dfdt "Pitch controlled WTG with df/dt Synthetic Inertia"
  import TransiEnt;

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
  extends TransiEnt.Producer.Electrical.Wind.Base.PartialWindTurbine(P_el_n=P_el_n);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Velocity v_wind_small = 0.1 "Wind velocity considered as negligible" annotation (Dialog(tab="Wind Turbine Data"));
  parameter Real J = 12e6 "Moment of inertia of entire plant" annotation (Dialog(tab="Wind Turbine Data"));
  final parameter SI.Length D_Rotor=Rotor.D "Rotor diameter of wind turbine" annotation (Dialog(tab="Wind Turbine Data"));
  parameter TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.BetzCoefficientApproximation turbineCharacteristics=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.VariableWTG_WU() "Characteristic behaviour of betz factor" annotation (choicesAllMatching=true, Dialog(tab="Wind Turbine Data"));
  parameter TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.WindSpeedOperationRanges operationRanges=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.ExampleTurbineRanges() "Wind speed operation ranges" annotation (choicesAllMatching=true, Dialog(tab="Wind Turbine Data"));
  parameter Modelica.Blocks.Types.SimpleController controllerType_p=.Modelica.Blocks.Types.SimpleController.PI "Type of controller"
                                                                                                    annotation (Dialog(tab="Controller", group="Pitch"),choicesAllMatching=true);
  parameter Real k_p=2e-5 "Gain of controller" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter SI.Time Ti_p=12 "Integral time constant of controller" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter SI.Time Td_p=3 "Derivative time constant of controller" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter Real yMax_p=30 "Upper limit of PI controlled beta setpoint" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter Real yMin_p=0 "Lower limit of output" annotation (Dialog(tab="Controller", group="Pitch"));
  parameter Real beta_start=0 "Setpoint for pitch angle" annotation (Dialog(tab="Wind Turbine Data"));
  parameter Real v_wind_start "Wind speed start value" annotation (Dialog(tab="Wind Turbine Data"));

  parameter Boolean use_inertia= false "activate synthetic inertia";
  parameter Boolean integratePower=false "True if power shall be integrated";

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  final parameter SI.AngularVelocity omega_start=if v_wind_start > 12 then omega_n else if (v_wind_start > 4 and v_wind_start < 12) then (Rotor.lambda_opt/Rotor.D*2*v_wind_start) else 1e-3;
//  final parameter Real v_fullload = (8*P_el_n
//                                            /(Rotor.rho*Modelica.Constants.pi*Rotor.D^2*Rotor.cp_opt))^(1/3);
  final parameter SI.AngularVelocity omega_n=Rotor.lambda_opt*operationRanges.v_fullLoad*2/Rotor.D;

protected
 TransiEnt.Basics.Interfaces.General.FrequencyIn f_internal "Needed to connect to conditional connector";
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  TransiEnt.Components.Electrical.Machines.VariableSpeedActivePowerGenerator Generator(terminal(change_sign=true), changeSign=true) annotation (Placement(transformation(extent={{16,-32},{44,-2}})));
  TransiEnt.Producer.Electrical.Wind.Base.WindturbineRotor Rotor(
    P_el_n=P_el_n,
    beta_start=beta_start,
    turbineCharacteristics=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.VariableWTG_WU(),
    v_fullLoad=operationRanges.v_fullLoad) annotation (Placement(transformation(extent={{-42,-28},{-22,-8}})));
  Modelica.Blocks.Sources.RealExpression v_wind1(y=max(v_wind_small, v_wind_internal))
                                                                   annotation (Placement(transformation(extent={{-72,-28},
            {-56,-8}})));
  TransiEnt.Producer.Electrical.Wind.Controller.PitchController_SI_dt_df pitchController(
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
    lambdaOpt=Rotor.lambda_opt,
    rho=Rotor.rho,
    radius=Rotor.D/2,
    cp_opt=Rotor.cp_opt,
    J=Inertia.J,
    P_el_n=P_el_n) annotation (Placement(transformation(extent={{-62,4},{-38,26}})));

  Modelica.Blocks.Sources.RealExpression omega_is(y=Rotor.omega)
    annotation (Placement(transformation(extent={{-32,16},{-4,34}})));

  Modelica.Blocks.Sources.RealExpression P_is(y=-P_el_is)   annotation (Placement(transformation(extent={{-92,42},
            {-76,62}})));
  Modelica.Blocks.Sources.Constant P_set(k=P_el_n) annotation (Placement(transformation(extent={{-92,20},{-76,40}})));

  TransiEnt.Producer.Electrical.Wind.Controller.TorqueController_SI_df_dt torqueController(
    v_wind=v_wind1.y,
    k_turbine=Rotor.k_turbine,
    J=Inertia.J,
    lambdaOpt=Rotor.lambda_opt,
    rho=Rotor.rho,
    radius=Rotor.D/2,
    cp_opt=Rotor.cp_opt,
    torqueControllerDisabled(uLow=0.98*pitchController.turbine.v_fullLoad, uHigh=1.02*pitchController.turbine.v_fullLoad),
    tau_n=P_el_n/omega_n,
    v_cutIn=operationRanges.v_cutIn,
    v_fullLoad=operationRanges.v_fullLoad) annotation (Placement(transformation(rotation=0, extent={{6,22},{26,42}})));

  Modelica.Blocks.Sources.RealExpression freq(y=f_internal)
    annotation (Placement(transformation(extent={{-102,82},{-74,100}})));

  Modelica.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{-62,86},{-42,106}})));
  Modelica.Blocks.Sources.RealExpression f_n(y=50)
    annotation (Placement(transformation(extent={{-100,94},{-72,112}})));

  Modelica.Blocks.Sources.RealExpression Torque_pu(y=T_pu)
    annotation (Placement(transformation(extent={{-94,-84},{-66,-66}})));
  Modelica.Blocks.Sources.RealExpression omega_pu(y=Generator.omega/omega_n) annotation (Placement(transformation(extent={{-94,-100},{-66,-82}})));
  Modelica.Blocks.Sources.RealExpression der_f(y=der_f_grid)
    annotation (Placement(transformation(extent={{-40,106},{-12,124}})));
  Modelica.Blocks.Sources.RealExpression P_el_pu(y=P_powerplant_pu)
    annotation (Placement(transformation(extent={{14,-9},{-14,9}},
        rotation=180,
        origin={-40,71})));
  Modelica.Blocks.Sources.RealExpression wind_fullload(y=operationRanges.v_fullLoad)
    annotation (Placement(transformation(extent={{-60,44},{-32,62}})));
  TransiEnt.Producer.Electrical.Wind.Base.DeadbandFilter deadbandFilter annotation (Placement(transformation(rotation=0, extent={{-18,86},{2,106}})));
  TransiEnt.Components.Mechanical.ConstantInertia Inertia(
    omega(start=omega_start),
    nSubgrid=1,
    J=J) annotation (choicesAllMatching=true, Placement(transformation(extent={{-16,-33},{8,-4}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  Real der_f_grid;
  Real T_pu;
  SI.KineticEnergy E_rot;
  SI.ActivePower P_el_is = -epp.P;
  Real P_powerplant_pu "Power plant per unit";
  Real no_inertia=50;
  Boolean is_running(start=true, fixed=true) "For continuous plants always true, for discontinous depending on state";

  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter    annotation (Placement(transformation(
        extent={{-10,-10.5},{10,10.5}},
        rotation=-90,
        origin={62.5,18})));

equation
  // _____________________________________________
  //
  //             Equations
  // _____________________________________________

  is_running=not pitchController.halt.active;

  if integratePower then
  der(E_rot)=Inertia.P_rot;
  else
    E_rot=0;
  end if;

    der_f_grid=der(epp.f);
  P_powerplant_pu=-P_el_is/P_el_n;
  T_pu=Generator.tau_set/torqueController.tau_n;

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

  connect(P_set.y, pitchController.u_s) annotation (Line(points={{-75.2,30},
          {-72,30},{-72,7.2},{-62,7.2}},
                                    color={0,0,127}));
  connect(P_is.y, pitchController.u_m) annotation (Line(points={{-75.2,52},
          {-66,52},{-66,12.2},{-62,12.2}},
                                  color={0,0,127}));

  connect(f_n.y, add.u1) annotation (Line(points={{-70.6,103},{-64,103},{-64,102}}, color={0,0,127}));
  connect(freq.y, add.u2)
    annotation (Line(points={{-72.6,91},{-64,91},{-64,90}}, color={0,0,127}));
  connect(omega_is.y, torqueController.omega_is) annotation (Line(points={{-2.6,25},{6.6,25},{6.6,24.8}},
                                          color={0,0,127}));
  connect(torqueController.y, Generator.tau_set) annotation (Line(points={{26.4,32},{16.98,32},{16.98,-26.75}},
                                     color={0,0,127}));
  connect(pitchController.beta_set, Rotor.beta_set) annotation (Line(points={{-37.8154,9.6},{-32,9.6},{-32,-8.4}},
                                               color={0,0,127}));
  connect(P_el_pu.y, torqueController.P_el_pu) annotation (Line(points={{-24.6,71},{18,71},{18,46},{18,42.2},{20,42.2}},
                                                  color={0,0,127}));
  connect(pitchController.der_f_grid, torqueController.der_f_grid)
    annotation (Line(points={{-58.3077,3.6},{-58.3077,0},{-38,0},{-38,44},{6,44},{6,60},{12,60},{12,42.2}},
                                           color={0,0,127}));
  connect(pitchController.omega_is, omega_is.y) annotation (Line(points={{-46.8615,7.2},{-2.6,7.2},{-2.6,25}},
                                               color={0,0,127}));
  connect(wind_fullload.y, pitchController.wind_fullLoad) annotation (Line(
        points={{-30.6,53},{-30,53},{-30,32},{-62.1846,32},{-62.1846,22}},
        color={0,0,127}));
  connect(P_el_pu.y, deadbandFilter.P_pu)
    annotation (Line(points={{-24.6,71},{-15.4,71},{-15.4,85.8}},
                                                            color={0,0,127}));
  connect(add.y, deadbandFilter.delta_f)
    annotation (Line(points={{-41,96},{-30,96},{-30,102.8},{-18.4,102.8}},
                                                 color={0,0,127}));
  connect(der_f.y, deadbandFilter.u) annotation (Line(points={{-10.6,115},{-10.6,111.5},{-8,111.5},{-8,105.6}},
                                         color={0,0,127}));
  connect(deadbandFilter.y, torqueController.der_f_grid)
    annotation (Line(points={{2.2,95.8},{12,95.8},{12,42.2}},
                                                        color={0,0,127}));
  connect(Rotor.flange, Inertia.mpp_a) annotation (Line(points={{-21.8,-18},{-16,
          -18},{-16,-18.5}}, color={0,0,0}));
  connect(Inertia.mpp_b, Generator.mpp) annotation (Line(points={{8,-18.5},{12,-18.5},{12,-17},{16,-17}},
                                      color={95,95,95}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{62.5,28},{72,28},{72,60},{82,60},{82,78},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(Exciter.y, Generator.E_input) annotation (Line(points={{62.5,7.4},{46.25,7.4},{46.25,-2.15},{29.58,-2.15}}, color={0,0,127}));
    annotation (
              Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,120}})),                                                                     Icon(graphics,
                                                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,120}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Extends pitch controlled WTG with a synthetic Inertia control depending on the rate of change of frequency (df/dt).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quasistationary model for real power simulation only.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: choice of power port</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">v_wind: input for velocity of wind in m/s</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Define nominal power, moment of inertia and starting wind speed before use.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Validated according to reference stated below.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] Wu, Lei: &quot;Towards an Assessment of Power System Frequency Support From Wind Pland - Modeling Aggregate Inertial Response&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on June 21 2016</span></p>
</html>"));
end Windturbine_SI_dfdt;
