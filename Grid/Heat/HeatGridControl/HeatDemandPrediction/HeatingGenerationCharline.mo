within TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction;
model HeatingGenerationCharline "Characteristic line of the heating load in function of the ambient temperature"
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
  //             Visible Parameters
  // _____________________________________________

    parameter HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemand CharLine "Choose City's Characteristic Line" annotation (choicesAllMatching);
    parameter Real Damping_Weekend=1 "Damping ratio for heat load at weekends (between 0 and 1)";
  parameter TransiEnt.Basics.Types.TypeOfWeekday BeginWeekday=2 "Weekday on which simulation begins";
    parameter Real TransitionDuration=5;
    parameter Boolean offsetOn=true "if 'true', the heat demand is sumperimposed with a daily profile on cold days";
    parameter Boolean weekendOn=true "if 'true', the heat demand on the weekend is damped by the constant factor 'Damping_Weekend'";
    parameter Boolean SummerDayTypicalHeatLoadCharLine=true "if true, on warm days a typical heat load profile is added to the minimum load on summer days - if 'false' the load on warm days is constant (=minimum load)";

  // _____________________________________________
  //
  //             Variables
  // _____________________________________________

    Real m=CharLine.m;
    Real c=CharLine.c;
    Real a=CharLine.a;
    Real SummerDayProfile;
    Modelica.SIunits.Heat Q_dem;

    Real offset;

   // Real StartDayNumber;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput T_amb
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-120,0},{-100,20}})));
  Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //             Components
  // _____________________________________________

  Basics.Tables.GenericDataTable SummerDayTypicalHeatLoad(relativepath="\heat\TypicalHeatLoadDay_AbsoluteValues_MonoIncreasing.txt", extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    constantfactor=1/637.6e6*CharLine.a)                                                                                                                                                         annotation (Placement(transformation(extent={{-10,8},{10,28}})));

  Basics.Blocks.Sources.WeekendPulse_Trapezoid weekendPulse(BeginningWeekday=BeginWeekday, k_weekend=Damping_Weekend) annotation (Placement(transformation(extent={{-10,42},{10,62}})));
  Basics.Tables.GenericDataTable OffsetvalueDailyprofile(extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic, relativepath="\heat\TypicalHeatLoad_DHN_Normalized.txt") annotation (Placement(transformation(extent={{-10,-22},{10,-2}})));
  Modelica.Blocks.Sources.Trapezoid hour_of_day(
    falling=0,
    width=0,
    rising=3600*24*7,
    period=3600*24*7,
    startTime=-6*24*3600,
    offset=1,
    amplitude=6.9)                                                   annotation (Placement(transformation(extent={{-10,-62},{10,-42}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  if offsetOn==true then
    offset=OffsetvalueDailyprofile.y1;
  else
    offset=1;
  end if;

  if SummerDayTypicalHeatLoadCharLine==true then
    SummerDayProfile=SummerDayTypicalHeatLoad.y1;
  else
    SummerDayProfile=0;
  end if;

  if weekendOn==true then
    if (m*T_amb+c*weekendPulse.y)*offset > a*weekendPulse.y+SummerDayProfile then
      Q_flow=(m*T_amb +c*weekendPulse.y)*offset;
      else
      Q_flow=a*weekendPulse.y+SummerDayProfile;
    end if;
  else
    if (m*T_amb+c)*offset > a+SummerDayProfile then
      Q_flow=(m*T_amb +c)*offset;
    else
      Q_flow=a+SummerDayProfile;
    end if;
  end if;

  der(Q_dem)=Q_flow;
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-76,94},{-84,72},{-68,72},{-76,94}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-76,72},{-76,-76}}, color={192,192,192}),
        Text(
          extent={{-41,17},{41,-17}},
          lineColor={0,128,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={85,3},
          rotation=90,
          textString="Q_flow_tot"),
        Polygon(
          points={{94,-66},{72,-58},{72,-74},{94,-66}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-86,-66},{86,-66}}, color={192,192,192}),
        Line(
          points={{-66,66},{70,-48}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Text(
          extent={{-29,27},{29,-27}},
          lineColor={0,128,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-89,-1},
          rotation=90,
          textString="T_amb"),
        Text(
          extent={{-152,-109},{148,-149}},
          lineColor={0,134,134},
          textString="%name")}),
                            Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                   graphics), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">HeatingLoadCharline</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model calculates the heat demand depending on the ambient temperature. Different characterisitic lines can be choosen (e.g. from Hamburg or Berlin). These lines consinst of a characterstic behaviour for cold days and a characteristic load chart for warm days. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">A linear dependency between ambient temperature and heat production/demand is assumed. This dependency can be adjusted with the following features:</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">Offset: use for fine tuning of heat output by multiplying the linear-output by a known daily offset value.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Weekend: use to generate a change between week and weekend demand (for instance if lower demand during weekends is expected)</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Summer day: use to give an alternative (non-linear) profile in summer periods (i.e. periods where the heat output goes bellow the summer cap-line)</span></li>
</ul>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Offset values and Characteristic Lines are just examples of use. These values should be adapted according to the modeled system.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model calculates the heat load for warm days and cold days with two different formulas - the formula for &apos;cold days&apos; and for &apos;warm days&apos;. Both formulas can be superimposed with a damping ratio for the weekend (&apos;Damping_Weekend&apos;) to reduce the weekend load if the Boolean &apos;weekend_On&apos; is set to &apos;true&apos;.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">3. Limits of validity </span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">T_amb: Input of ambient temperature</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow: calculated heat demand output</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">5. Nomenclature</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Cold Days:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">In the formula for the calculation of the heat demand on cold days (WinterDay-formula) the heat demand is lineraly dependent on the ambient temperature. Herefore the slope and the axis intercept of the characteristic linear function can be varied. Furthermore, if the Boolean &apos;offsetOn&apos; is set to &apos;true, the heat demand is superimposed with a typical daily profile.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Warm Days:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For warm days the heat demand is independent of the ambient temperature. If the Boolean &apos;SummerDayTypicalHeatLoadCharLine&apos; is set to &apos;true, a typical heat load profile for summer days is added to the minimum load such that the load depends on the day time. If it is set to &apos;false&apos; the load is constant and equal to the minimum load.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The output for the heat demand will always be the higher value of the two ways of calculating the head demand (warm days/cold days).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">7. Remarks for Usage</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">8. Validation</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">9. References</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008c48;\">5. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Oliver Sch&uuml;lting and Ricardo Peniche,  2015</span></p>
</html>"));
end HeatingGenerationCharline;
