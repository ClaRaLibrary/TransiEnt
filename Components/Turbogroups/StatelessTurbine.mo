within TransiEnt.Components.Turbogroups;
model StatelessTurbine "Generic model of a turbine without distinct states (no state events)"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  extends Base.PartialTurbine;

//  extends Base.PartialTurbine(mpp(tau(start=-P_turb_init/(2*Modelica.Constants.pi*simCenter.f_n), fixed=true)));

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Power P_nom=2e9 "Nominal power";

  parameter Real P_min_star=0.2 "Dimensionless minimum power (=20% of nominal power)";

  parameter Real P_max_star=1 "Dimensionless maximum power (=Nominal power)";

  parameter Real P_grad_max_star=0.12/60 "Dimensionless maximum power gradient per second (12% of P_nom per minute)";

  parameter Real Td=1e-3 "The higher Nd, the closer y follows u"
                                            annotation(Dialog(group="Numerical"));
  parameter Boolean useThresh=false "Use threshould for suppression of numerical noise"
                                                         annotation(Dialog(group="Numerical"));
  parameter Real thres=1e-7 "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000."  annotation(Dialog(group="Numerical"));

  parameter Real P_turb_init=0 "Initial or guess value of turbine power (in p.u.)";

  parameter SI.Time T_plant=10 "Turbine first order dynamic";

  parameter SI.Time t_startup=0 "Startup time (no output during startup)";

  parameter SI.Time t_shutdown=60 "Time it takes to disconnect from grid (P=P_set during shutdown)";

  outer SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.BooleanOutput isGeneratorRunning annotation (
      Placement(transformation(rotation=0, extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealInput P_spinning_set "Setpoint for spinning reserve power"
                                                      annotation (Placement(transformation(
        rotation=270,
        extent={{-12,-12},{12,12}},
        origin={36,98})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Math.Gain normalize(k=1/P_nom)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,54})));

  Modelica.Blocks.Math.Gain normalizePbal(k=1/P_nom)  annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={36,52})));

  Modelica.Blocks.Math.MultiSum P_total(nu=2, k={1,1}) annotation (Placement(transformation(
        extent={{-6.5,-6},{6.5,6}},
        rotation=0,
        origin={53.5,-38})));
  Modelica.Blocks.Math.Gain deNormalize(k=P_nom)
    annotation (Placement(transformation(extent={{66,-44},{78,-32}})));
  Boundaries.Mechanical.Power MechanicalBoundary annotation (Placement(transformation(extent={{70,-84},{88,-66}})));
  Modelica.Blocks.Nonlinear.Limiter P_max_star_limiter_total(uMax=0, uMin=-
        P_max_star) "Upper limit is nominal power"
    annotation (Placement(transformation(extent={{-4,-70},{16,-50}})));

  // _____________________________________________
  //
  //           Diagnostic Variables
  // _____________________________________________

  Real P_set_star = normalize.y;
  Real P_is_star = deNormalize.u;

  Modelica.Blocks.Continuous.FirstOrder plantDynamic(                           T=T_plant,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=-P_turb_init/P_nom)                                                 annotation (Placement(transformation(extent={{24,-70},{44,-50}})));
  Modelica.Blocks.Sources.BooleanExpression isOperating(y=true)                            annotation (Placement(transformation(extent={{64,10},{84,30}})));
  Modelica.Blocks.Continuous.FirstOrder plantPrimaryCtrlDynamic(
    initType=Modelica.Blocks.Types.Init.SteadyState,
    y_start=0,
    T=7)                                                                        annotation (Placement(transformation(extent={{22,-20},{42,0}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(MechanicalBoundary.mpp, mpp) annotation (Line(
      points={{88,-75},{88,-2},{100,-2}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(P_target, normalize.u) annotation (Line(
      points={{0,98},{0,66},{2.22045e-015,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deNormalize.y, MechanicalBoundary.P_mech_set) annotation (
      Line(
      points={{78.6,-38},{79,-38},{79,-64.38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_spinning_set, normalizePbal.u) annotation (Line(
      points={{36,98},{36,60.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_max_star_limiter_total.y, plantDynamic.u) annotation (Line(points={{17,-60},{17,-60},{22,-60}}, color={0,0,127}));
  connect(plantDynamic.y, P_total.u[1]) annotation (Line(points={{45,-60},{52,-60},{52,-48},{46,-48},{46,-44},{28,-44},{28,-35.9},{47,-35.9}},
                                                                                                                                           color={0,0,127}));
  connect(P_total.y, deNormalize.u) annotation (Line(points={{61.105,-38},{64.8,-38}}, color={0,0,127}));
  connect(plantPrimaryCtrlDynamic.y, P_total.u[2]) annotation (Line(points={{43,-10},{50,-10},{50,-26},{40,-26},{40,-40.1},{47,-40.1}}, color={0,0,127}));
  connect(plantPrimaryCtrlDynamic.u, normalizePbal.y) annotation (Line(points={{20,-10},{12,-10},{12,-8},{8,-8},{8,28},{38,28},{38,44.3},{36,44.3}}, color={0,0,127}));
  connect(isOperating.y, isGeneratorRunning) annotation (Line(points={{85,20},{110,20},{110,20}}, color={255,0,255}));
  connect(normalize.y, P_max_star_limiter_total.u) annotation (Line(points={{-2.22045e-015,43},{-2.22045e-015,-6},{-22,-6},{-22,-60},{-6,-60}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(graphics={
    Polygon(visible=true,
          lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-80,92},{-88,70},{-72,70},{-80,92}}),
      Line(visible=true,
            points={{-80,80},{-80,-88}},
          color={192,192,192}),
    Line(visible=true,
          points={{-90,-78},{82,-78}},
        color={192,192,192}),
    Polygon(visible=true,
          lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90,-78},{68,-70},{68,-86},{90,-78}}),
        Line(
          points={{-50,-18},{-42,-24}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-70,-44},{-62,-50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-30,10},{-22,4}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-14,34},{-6,28}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(extent={{-50,-52},{-42,-60}}, lineColor={28,108,200})}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Turbine model modeled by </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- minimum / maximum power ouput</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- maximum power gradient</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- on / off status dependent on schedule value without time delay. Turbine shuts down if scheduled value is below minimum power</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- sends on/off status to momentum of inertia statistics </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Note, that no statistics are involved!</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The input P_spinning_set is supposed to be gradient limited by limtations of the primary balancing offer mechanism which has normally a higher gradient limit than the rest of the plant.</span></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">The input P_target is the sum of secondary balancing setpoint and scheduled set point</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end StatelessTurbine;
