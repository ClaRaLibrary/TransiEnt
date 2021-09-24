within TransiEnt.Producer.Heat.SolarThermal.Base;
model SolarTime "Calculates the solar time"


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

  extends TransiEnt.Basics.Icons.Model;
  import Const = Modelica.Constants;
  import      Modelica.Units.SI;

  // _____________________________________________
  //
  //        Constants and  Parameters
  // _____________________________________________

  parameter Real[4] offset(unit={"d","h","m","s"})={0,0,0,0}; //d,h,m,s; Offset=0 means t=0 equals 1.1. 00:00:00
  parameter SI.Angle longitude_local=Modelica.Units.Conversions.from_deg(10);
  parameter SI.Angle longitude_standard=Modelica.Units.Conversions.from_deg(15) "East positive, west negative, 10 for Hamburg, 15 needed for offset calculation of central european time, 30 for central european summer time";
  parameter Real utc=longitude_standard*12/Const.pi "Difference between UTC and zone time; i.e. +1 in Amsterdam/Berlin/Bern/Rome; default works for standard time, beware of summer time !";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  Modelica.Units.NonSI.Time_day dayoftheyear "Day as floating point number. 0.0 at 1.1. 00:00:00, 1.0 at 2.1. 00:00:00 a.s.o.";
  Modelica.Units.NonSI.Time_day totaldays=365 "total days of the year, standard=365, leap year=366";
  SI.Time solarTime "Local solar time in seconds";
  SI.Time offset_sec; // Offset in seconds
protected
  SI.Angle J; // position of the earth on the orbit around the sun; needed for calculation
  SI.Time equationOfTime;
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  offset_sec=((offset[1]*24+offset[2])*60+offset[3])*60+offset[4];
  J=Modelica.Units.Conversions.from_deg((dayoftheyear)*360/totaldays);
                                                           // +0.5 leads to an average of "1" for day 1, "2" for day 2 etc.

  equationOfTime=60*(0.0066 + 7.3525*cos(J + Modelica.Units.Conversions.from_deg(85.9)) + 9.9359*cos(2*J + Modelica.Units.Conversions.from_deg(108.99)) + 0.3387*cos(3*J + Modelica.Units.Conversions.from_deg(105.2)));

  dayoftheyear=noEvent(integer((time+offset_sec)/(24*60*60)+1));
  solarTime=time-utc+offset_sec+4*60*longitude_local+equationOfTime;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Calculates the solar time at a given longitude in respect of zone time, difference to UTC and an optional offset.</p>
<p>Note: Here day is provided as a floating point value which means that other models might have to use integer() if they need an integer value.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p><br>Parameters:</p>
<p><br>offset: Sets the offset of simulation time [0, ...] to time to simulate. Type ist Real[4]: seconds, minutes, hours, day. {10,5,1,0} starts at 3910s </p>
<p><br>longitude_local: longitude of position, west positive </p>
<p><br>longitude_standard: standard longitude of time zone, west positive, e.g. -15&deg; for UTC+1 regular time.</p>
<p><br>utc: difference to utc in hours, e.g. +1 for Amsterdam/Berlin/Bern/Rome</p>
<p>public variables:</p>
<p>solarTime: gives calculated solar time in seconds</p>
<p>day_floatingpoint: gives day as floating point value, day=0 means 0:0:0, day=0.5 means 12:0:0 (h,m,s) </p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>offset_sec=((offset[1]*24+offset[2]*60)+offset[3]*60)+offset[4]</p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-LFRCa0cj.png\" alt=\"day_floatingpoint=(time+offset_sec)/(24*60*60)\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-NMaYc4qJ.png\" alt=\"
be=(day_floatingpoint+0.5)*360/365\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-0o7nqU2o.png\" alt=\"solarTime=time-utc+offset_sec+4*60*(-longitude_local)+equationOfTime\"/></p>
<p><img src=\"modelica://TransiEnt/Images/equations/equation-XBRg3dnS.png\" alt=\"equationOfTime=60*(0.0066+7.3525*cos(J+SI.Conversions.from_deg(85.9))+9.9359*cos(2*J+SI.Conversions.from_deg(108.99))+0.3387*cos(3*J+SI.Conversions.from_deg(105.2)))\"/></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>DIN 5034 as cited by Quschning: Regenerative Energiesysteme (2014)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Toerber (tobias.toerber@tuhh.de), Jul 2015</p>
<p>Edited by Sascha Guddusch (sascha.guddusch@tuhh.de), May 2016</p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Mar 2017</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de), Apr. 2017</p>
</html>"), experiment(
      StopTime=604800,
      Interval=100,
      Tolerance=0.001),
    __Dymola_experimentSetupOutput,
    Icon(graphics={
        Line(points={{0,94},{0,-4},{24,20},{56,52}},color={28,108,200},
          thickness=0.5),
        Ellipse(extent={{-16,-22},{32,-70}},fillPattern=FillPattern.Solid, fillColor={255,255,0}, lineColor={255,255,0},
          lineThickness=1),
        Line(points={{-46,-16},{-20,-26}},color={255,255,0},
          thickness=1),
        Line(points={{56,-12},{36,-24}},color={255,255,0},
          thickness=1),
        Line(points={{-38,-78},{-20,-64}}, color={255,255,0},
          thickness=1),
        Line(points={{52,-78},{34,-64}}, color={255,255,0},
          thickness=1),
        Line(points={{6,-76},{6,-94}}, color={255,255,0},
          thickness=1),
        Line(points={{-58,-46},{-26,-48}}, color={255,255,0},
          thickness=1),
        Line(points={{42,-44},{50,-44},{76,-44}}, color={255,255,0},
          thickness=1),
        Line(points={{10,4},{10,-14}}, color={255,255,0},
          thickness=1)}));
end SolarTime;
