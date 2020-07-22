within TransiEnt.Producer.Electrical.Controllers;
model PrimaryBalancingController "Primary balancing controller model based on Weissbach (2009)"

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

  import TransiEnt;
  extends Base.PartialPrimaryBalancingController;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter TransiEnt.Basics.Types.ControlPlantType plantType=TransiEnt.Basics.Types.ControlPlantType.Provided "Droop of Turbine (Relative frequency change, when demanded power changes)" annotation (Evaluate=true, Dialog(group="Droop"));
  parameter Real providedDroop=0.2/50/maxValuePrCtrl "Value used if plantType is set to 'Provided' (full activation at 200mHz for 50Hz nom. freq.)"
                                                   annotation (Dialog(enable=(
          plantType == TransiEnt.Basics.Types.ControlPlantType.Provided), group="Droop"));
  parameter Real k_part=1 "Participation factor"
                           annotation(Dialog(group="Droop"));
  parameter Real maxGradientPrCtrl = 0.02/30 "Two percent of design case power in 30s"
                                              annotation(Dialog(group="Dynamic"));
  parameter Real maxValuePrCtrl = 0.02 "Two percent of design case power"
                                       annotation(Dialog(group="Dynamic"));

  parameter SI.Time Td_GradientLimiter=0.001 "Time step of derivative calculation"
                                           annotation(Dialog(tab="Expert Settings"));

  parameter Boolean useThresh=false "Use threshould for suppression of numerical noise"
    annotation (Dialog(tab="Expert Settings"));
  parameter Real thres=1e-7 "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000."
    annotation (Dialog(tab="Expert Settings"));
  parameter Real Td=simCenter.Td "The higher Nd, the closer y follows u"
    annotation (Dialog(tab="Expert Settings", enable=(simCenter.isExpertmode)));
  parameter Boolean UseDeadband=false "Choose if deadband limiter is activated" annotation(Dialog(group="Deadband"));

  parameter SI.Frequency delta_f_db=0.01 "Frequency deadband of primary control" annotation(Dialog(enable=UseDeadband,group="Deadband"));

  final parameter SI.Power P_pr_max=k_part*maxValuePrCtrl*P_n "Maximum power provided by this primary controller";

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  final parameter SI.Power P_PBP_max=maxValuePrCtrl*k_part*P_n;
   parameter Boolean use_SlewRateLimiter=true "True if Gradient of Primary Balancing Power shall be limited";
  parameter Boolean integratePowerNeg=false "True if negative power shall be integrated";
  parameter Boolean integratePowerPos=false "True if positive power shall be integrated";
protected
  parameter Real droop=TransiEnt.Producer.Electrical.Controllers.DroopSelector(plantType, providedDroop);


  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

public
  Modelica.Blocks.Math.Gain delta_f_star(k=1/simCenter.f_n) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,0})));
  TransiEnt.Basics.Blocks.VariableSlewRateLimiter P_PBP_star(
    maxGrad_const=maxGradientPrCtrl,
    Td=Td_GradientLimiter,
    useThresh=useThresh,
    thres=thres,
    y_start=0) if use_SlewRateLimiter annotation (Placement(transformation(extent={{41,-10},{61,10}})));
  Modelica.Blocks.Math.Gain P_PBP_ideal_star(k=1/droop) annotation (Placement(transformation(extent={{-20,-9},{-2,10}})));
  Modelica.Blocks.Math.Gain P_PBP(k=k_part*P_n) annotation (Placement(transformation(extent={{69,-9},{88,9}})));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  SI.Energy E_total_PBP_bal_pos(start=0, fixed=true);
  SI.Energy E_total_PBP_bal_neg(start=0, fixed=true);

  Modelica.Blocks.Nonlinear.Limiter P_PBP_limit_star(
    uMax=maxValuePrCtrl,
    uMin=-maxValuePrCtrl,
    strict=true) annotation (Placement(transformation(extent={{6,-10},{26,10}})));
  TransiEnt.Basics.Blocks.DeadZoneLinear deadband(uMax=delta_f_db/simCenter.f_n, uMin=-delta_f_db/simCenter.f_n) if UseDeadband==true annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if integratePowerNeg then
  der(E_total_PBP_bal_neg) =min(0, P_PBP_set)
                                     "only add up negative power = additional power output";
  else
    E_total_PBP_bal_neg=0;
  end if;

  if integratePowerPos then
  der(E_total_PBP_bal_pos) =max(0, P_PBP_set)
                                     "only add up positive power = reduced power output";
  else
    E_total_PBP_bal_pos=0;
  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  if use_SlewRateLimiter then
 connect(P_PBP_limit_star.y, P_PBP_star.u) annotation (Line(points={{27,0},{39,0}}, color={0,0,127}));

  connect(P_PBP_star.y, P_PBP.u) annotation (Line(
      points={{62,0},{67.1,0}},
      color={0,0,127},
      smooth=Smooth.None));
  else
    connect(P_PBP_limit_star.y, P_PBP_set);
  end if;
   connect(P_PBP.y, P_PBP_set) annotation (Line(
      points={{88.95,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(delta_f, delta_f_star.u) annotation (Line(
      points={{-110,0},{-82,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_PBP_ideal_star.y, P_PBP_limit_star.u) annotation (Line(points={{-1.1,0.5},{0,0.5},{0,0},{4,0}},       color={0,0,127}));
  if UseDeadband==true then
    connect(deadband.y, P_PBP_ideal_star.u) annotation (Line(points={{-29,0},{-26,0},{-26,0.5},{-21.8,0.5}}, color={0,0,127}));
    connect(delta_f_star.y, deadband.u) annotation (Line(points={{-59,0},{-52,0}}, color={0,0,127}));
  else
    connect(delta_f_star.y,P_PBP_ideal_star.u);
  end if;
  annotation (defaultComponentName="PrimaryBalancingController",
  Diagram(graphics,
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                   Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-38,26},{38,-30}},
          lineColor={0,0,0},
          textString="Prim")}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Primary balancing controller modeled according to ENTSO-E requirements with</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- maximum value (typically 20&percnt; of nominal power plants nominal power)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- maximum power gradient (30 seconds time for 20&percnt; of nominal power)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- without frequency deadband</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>delta_f: input for frequency in Hz (connector of real input signal)</p>
<p>P_PBP_set: output for electric power in W (primary balancing setpoint)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TestPrimaryBalancingController&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">&quot;Verbesserung des Kraftwerks- und Netzregelverhaltens bezüglich handelsseitiger Fahrplanänderungen&quot;; Weißbach, Tobias; 2009, Universität Stuttgart</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end PrimaryBalancingController;
