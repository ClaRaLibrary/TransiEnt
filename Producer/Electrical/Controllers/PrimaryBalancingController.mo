within TransiEnt.Producer.Electrical.Controllers;
model PrimaryBalancingController "Primary balancing controller model based on Weissbach (2009)"

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
  extends Base.PartialPrimaryBalancingController;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter TransiEnt.Basics.Types.ControlPlantType plantType=TransiEnt.Basics.Types.ControlPlantType.Provided "Droop of Turbine (Relative frequency change, when demanded power changes)" annotation (Evaluate=true, Dialog(group="Droop"));
  parameter Real providedDroop=0.2/50/maxValuePrCtrl "Value used if plantType is set to 'Provided' (full activation at 200mHz for 50Hz nom. freq.)"
                                                   annotation (Dialog(enable=(
          plantType == Characteristics.PlantType.Custom), group="Droop"));
  parameter Real k_part=1 "Participation factor"
                           annotation(Dialog(group="Droop"));
  parameter Real maxGradientPrCtrl = 0.02/30 "Two percent of design case power in 30s"
                                              annotation(Dialog(group="Dynamic"));
  parameter Real maxValuePrCtrl = 0.02 "Two percent of design case power"
                                       annotation(Dialog(group="Dynamic"));

  parameter Modelica.SIunits.Power P_nom=simCenter.P_n_low;
  parameter SI.Time Td_GradientLimiter=0.001 "Time step of derivative calculation"
                                           annotation(Dialog(tab="Expert Settings"));

  parameter Boolean useThresh=false "Use threshould for suppression of numerical noise"
    annotation (Dialog(tab="Expert Settings"));
  parameter Real thres=1e-7 "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000."
    annotation (Dialog(tab="Expert Settings"));
  parameter Real Td=simCenter.Td "The higher Nd, the closer y follows u"
    annotation (Dialog(tab="Expert Settings", enable=(simCenter.isExpertmode)));

  final parameter SI.Power P_pr_max=k_part * maxValuePrCtrl * P_nom "Maximum power provided by this primary controller";

  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  final parameter SI.Power P_PBP_max = maxValuePrCtrl * k_part * P_nom;

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
        origin={-64,0})));
  TransiEnt.Basics.Blocks.VariableSlewRateLimiter P_PBP_star(
    maxGrad_const=maxGradientPrCtrl,
    Td=Td_GradientLimiter,
    useThresh=useThresh,
    thres=thres,
    y_start=0) annotation (Placement(transformation(extent={{35,-10},{55,10}})));
  Modelica.Blocks.Math.Gain P_PBP_ideal_star(k=1/droop) annotation (Placement(transformation(extent={{-38,-9},{-20,10}})));
  Modelica.Blocks.Math.Gain P_PBP(k=k_part*P_nom) annotation (Placement(transformation(extent={{69,-9},{88,9}})));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  SI.Energy E_total_PBP_bal_pos(start=0, fixed=true);
  SI.Energy E_total_PBP_bal_neg(start=0, fixed=true);

  Modelica.Blocks.Nonlinear.Limiter P_PBP_limit_star(
    uMax=maxValuePrCtrl,
    uMin=-maxValuePrCtrl,
    strict=true) annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  der(E_total_PBP_bal_neg) =min(0, P_PBP_set)
                                     "only add up negative power = additional power output";
  der(E_total_PBP_bal_pos) =max(0, P_PBP_set)
                                     "only add up positive power = reduced power output";

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(delta_f_star.y, P_PBP_ideal_star.u) annotation (Line(
      points={{-53,0},{-44,0},{-44,0.5},{-39.8,0.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_PBP.y, P_PBP_set) annotation (Line(
      points={{88.95,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_PBP_star.y, P_PBP.u) annotation (Line(
      points={{56,0},{67.1,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(delta_f, delta_f_star.u) annotation (Line(
      points={{-110,0},{-76,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_PBP_limit_star.y, P_PBP_star.u) annotation (Line(points={{21,0},{33,0}}, color={0,0,127}));
  connect(P_PBP_ideal_star.y, P_PBP_limit_star.u) annotation (Line(points={{-19.1,0.5},{-14,0.5},{-14,0},{-2,0}}, color={0,0,127}));
  annotation (defaultComponentName="PrimaryBalancingController",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
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
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end PrimaryBalancingController;
