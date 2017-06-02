within TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.DNIDHI_Input;
model Radiation_InclinedSurface
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
  extends TransiEnt.Basics.Icons.RadiationModel;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter Real lambda "degree of longitude of location" annotation(Dialog(group="Location parameters"));
  parameter Real phi "degree of latitude of location" annotation(Dialog(group="Location parameters"));
  parameter Real timezone=1 "timezone of location (UTC+) - for CET: timezone=1" annotation(Dialog(group="Location parameters"));
  parameter String Tracking="No Tracking" "Choose if sun position is tracked by Tracking device" annotation(choices(choice="No Tracking",choice="Biaxial Tracking"));
  parameter Real Tilt "inclination of surface" annotation(Dialog(group="parameters for fixed mounting"));
  parameter Real Azimuth "gyration of surface; Orientation: +90=West, -90=East, 0=South" annotation(Dialog(group="parameters for fixed mounting"));
  parameter String IncidenceAngleModification="yes" "Chose if decrease of irradiance due to reflexion depending of the angle of incidence is calculated"
                                                                                                    annotation(choices(choice="Yes",choice="No"));
  parameter Real Soiling=4 "percentage of irradiation losses due to soiling";
  parameter Real Albedo=0.25 "value for albedo - e.g. 0.25 is a common value for green grass";
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real DtR "conversion factor from degree to radian";

  Real J "daycount";
  Real LocalTime "local time";
  Real MOZ "middle local time - Mittlere Ortszeit";
  Real J2 "parameter for equation of time";
  Real Zgl "equation of time - Zeitgleichung";
  Real WOZ_s "true local time - Wahre Ortszeit in s";
  Real WOZ "true local time - Wahre Ortszeit";
  Real delta "sun declination";
  Real omega "hour angle";
  Real gamma_s2 "angle sunheight - avoids acos(>1) - from Sandia calculations";
  Real argument_alpha_s;
  Real alpha_s "sun azimuth";

  Real theta_d "Declination Angle";
  Real E_qt "Equation of Time";
  Real Long_sm "Longitude of Standard Meridian of Timezone";
  Real Long_local "Longitude";
  Real T_local "Local Time";
  Real T_solar "Solar Time";
  Real theta_hr "Hour Angle";
  Real theta_z "sun zenith angle";
  Real gamma_s "angle sunheight";

  Real theta_gen "incidence angle of beam onto surface";

  Real theta_r "angle of refraction";
  Real tau_theta_gen "transmittance of the module at theta_gen";
  Real tau_0 "transmittance when theta_gen = 0";
  Real IAM "Incidence Angle Modification";

  Modelica.SIunits.Irradiance  Edir_horizontal "beam irradiation onto horizontal surface";
  Modelica.SIunits.Irradiance  Edif_horizontal "diffuse irradiation onto horizontal surface";
  Modelica.SIunits.Irradiance  GHI "global horizontal irradiation";
  Real F "clearness index for Klucher calculation";
  Modelica.SIunits.Irradiance  Edif_inclined "beam irradiation onto tilted surface";
  Modelica.SIunits.Irradiance  Edir_inclined "diffuse irradiation onto tilted surface";
  Modelica.SIunits.Irradiance  Eground_inclined "ground reflected irradiation onto tilted surface";

  Modelica.SIunits.Energy sum_dir_inclined(stateSelect=StateSelect.never) "sum of energy resulting from beam irradiation onto tilted surface";
  Modelica.SIunits.Energy sum_dif_inclined(stateSelect=StateSelect.never) "sum of energy resulting from diffuse irradiation onto tilted surface";
  Modelica.SIunits.Energy sum_total_inclined(stateSelect=StateSelect.never) "sum of energy resulting from total irradiation onto tilted surface";
  Modelica.SIunits.Energy sum_GHI(stateSelect=StateSelect.never) "sum of energy resulting from GHI irradiation onto horizontal surface";
  Modelica.SIunits.Energy sum_ground(stateSelect=StateSelect.never) "sum of energy resulting from ground reflected irradiation onto tilted surface";
  Modelica.SIunits.Energy sum_dif_horizontal(stateSelect=StateSelect.never) "sum of energy resulting from diffuse irradiation onto horizontal surface";
  Modelica.SIunits.Energy sum_dir_horizontal(stateSelect=StateSelect.never) "sum of energy resulting from direct irradiation onto horizontal surface";

  Modelica.Blocks.Interfaces.RealOutput E_gen "radiation onto tilted surface" annotation (Placement(transformation(extent={{100,-19},{138,19}})));

public
  Modelica.Blocks.Interfaces.RealInput DNI_in "Global Horizontal Irradiation in W/m^2" annotation (Placement(transformation(extent={{-140,-56},{-100,-16}})));
  Modelica.Blocks.Interfaces.RealInput DHI_in "Global Horizontal Irradiation in W/m^2" annotation (Placement(transformation(extent={{-140,18},{-100,58}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Degree to Radian
  DtR=Modelica.Constants.pi/180;

  //calculation of sun position
  J=time/86400;
  LocalTime=time-86400*integer(time/86400);
  if LocalTime-4*(timezone*15-lambda)*60>0 then
    MOZ=LocalTime-4*(timezone*15-lambda)*60;
  else
    MOZ=LocalTime-4*(timezone*15-lambda)*60+3600*24;
  end if;
  J2=360*J/365;
  Zgl=0.0066+7.3525*cos((J2+85.9)*DtR)+9.9359*cos((2*J2+108.9)*DtR)+0.3387*cos((3*J2+105.2)*DtR);
  WOZ_s=MOZ+Zgl*60;
  WOZ=WOZ_s/3600;
  delta=0.3948-23.2559*cos((J2+9.1)*DtR)-0.3915*cos((2*J2+5.4)*DtR)-0.1764*cos((3*J2+26)*DtR);
  omega=(12-WOZ)*15;
  gamma_s2=asin(cos(omega*DtR)*cos(phi*DtR)*cos(delta*DtR)+sin(phi*DtR)*sin(delta*DtR))/DtR; // from the calculation of theta_z, gamma_s reaches values so that acos(argument_alpha_s) can't be calculated. gamma_s2 does not reach such values
  argument_alpha_s=(sin(gamma_s2*DtR)*sin(phi*DtR)-sin(delta*DtR))/(cos(gamma_s2*DtR)*cos(phi*DtR));
  if noEvent(WOZ<=12) then
    alpha_s=180-acos(argument_alpha_s)/DtR;
  else
    alpha_s=180+acos(argument_alpha_s)/DtR;
  end if;

  //Calculation of theta_z and gamma_s from https://pvpmc.sandia.gov/modeling-steps/1-weather-design-inputs/sun-position/simple-models/
  theta_d=23.45*Modelica.Constants.pi/180*sin(2*Modelica.Constants.pi*(284+J)/365)/DtR; // in degrees
  if J<107 then
    E_qt = -14.2*sin(Modelica.Constants.pi*(J+7)/111);
  elseif J>=107 and J<167 then
    E_qt = 4.0*sin(Modelica.Constants.pi*(J-106)/59);
  elseif J>=167 and J<246 then
    E_qt = -6.5*sin(Modelica.Constants.pi*(J-166)/80);
  else
    E_qt = 16.4*sin(Modelica.Constants.pi*(J-247)/113);
  end if;
  Long_sm=timezone*15;
  Long_local = lambda;
  T_local = LocalTime / 86400 * 24;
  T_solar = T_local + E_qt / 60 + (Long_sm - Long_local) / 15; //in hours
  theta_hr =  Modelica.Constants.pi * ((12 - T_solar) / 12);

  theta_z = acos(sin(phi*DtR)*sin(theta_d*DtR)+cos(phi*DtR)*cos(theta_d*DtR)*cos(theta_hr))/DtR;
  gamma_s = 90 - theta_z;

  //calculation of theta_gen
  if Tracking=="No Tracking" then
    //theta_gen=acos(-cos(gamma_s2*DtR)*sin(Tilt*DtR)*cos((alpha_s-Azimuth)*DtR)+sin(gamma_s2*DtR)*cos(Tilt*DtR))/DtR; //the use of gamma_s2 in the calculation of theta_gen worsenes the results
    theta_gen=acos(-cos(gamma_s*DtR)*sin(Tilt*DtR)*cos((alpha_s-Azimuth)*DtR)+sin(gamma_s*DtR)*cos(Tilt*DtR))/DtR;
  elseif Tracking=="Biaxial Tracking" then
    theta_gen=0;
  end if;

  if IncidenceAngleModification=="yes" then
    theta_r=asin(1/1.526*sin(theta_gen*DtR))/DtR;
    if (theta_r+theta_gen)<=0.0 then
      tau_theta_gen=0;
    else
      tau_theta_gen=exp(-4*0.002/cos(theta_r*DtR))*(1-0.5*(sin((theta_r-theta_gen)*DtR)^2/sin((theta_r+theta_gen)*DtR)^2+tan((theta_r-theta_gen)*DtR)^2/tan((theta_r+theta_gen)*DtR)^2));
    end if;
    tau_0=exp(-4*0.002)*(1-((1-1.526)/(1+1.526))^2);
    IAM=tau_theta_gen/tau_0;
  else
    IAM=1;
  end if;

  if DNI_in * (cos((90-gamma_s)*DtR)) > 0 then
    Edir_horizontal = DNI_in * (cos((90-gamma_s)*DtR));
  else
    Edir_horizontal = 0;
  end if;
  if DHI_in > 0 then
    Edif_horizontal = DHI_in;
  else
    Edif_horizontal = 0;
  end if;
  GHI = Edif_horizontal + Edir_horizontal;

  //Edir_inclined
  if gamma_s==0 or theta_gen>90 or theta_gen <-90 then
    Edir_inclined=0;
  else
    Edir_inclined=Edir_horizontal*cos(theta_gen*DtR)/sin(gamma_s*DtR)*IAM*(100-Soiling)/100;
  end if;

  //diffuse irradiation on tilted surface according to Klucher
  if GHI<=0.0001 then
    F=0;
    Edif_inclined=0;
  else
    F=1-(Edif_horizontal/GHI)^2;
    Edif_inclined=Edif_horizontal*((1+cos(Tilt*DtR))/2)*(1+F*sin(Tilt*DtR/2)^3)*(1+F*cos(theta_gen*DtR)^2*cos(gamma_s*DtR)^3)*((100-Soiling)/100);
  end if;

  Eground_inclined=GHI*Albedo*(1-cos(Tilt*DtR))/2*(100-Soiling)/100;

  E_gen=Edir_inclined+Edif_inclined+Eground_inclined;

  der(sum_dir_inclined)=Edir_inclined;
  der(sum_dif_inclined)=Edif_inclined;
  der(sum_ground)=Eground_inclined;
  der(sum_GHI)=GHI;
  der(sum_total_inclined)=E_gen;
  der(sum_dif_horizontal)=Edif_horizontal;
  der(sum_dir_horizontal)=Edir_horizontal;

 annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(points={{42,-42}}, color={28,108,200}),
        Line(
          points={{32,-20}},
          color={28,108,200},
          smooth=Smooth.Bezier)}),                                                         Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The purpose of this model is to calculate the irradiation onto a tilted surface for PV generation.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model is based on empiric equations. Optical losses are being consideres due to loss factors for soiling and refraction and reflexion (contained in the incidence angle modification); </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has been validated with System Advisor Model simulation results [1] for fixed PV arrays without shading influences. The results are best with Tilt angle of ~30&deg;.</span></p>
<p>The model has not been entirely validated for sun tracking. Disabling Incidence Angle Modifications seems to improve tracking results.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Input: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">DNI_in</span></b> for direct normal irradiation </p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">DHI_in</span></b> for diffuse horizontal irradiation</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Output: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">E_gen</span></b> for irradiation usable for PV on the plane of array (= POA Irradiation)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See parameter and variable descriptions in the code.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.1. Sun Position</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The sun position angles are calculated follwing the correlations of Quaschning [2] using terms and variables from DIN 5034*. Therefore the location is needed which can be defined via the degree of longitude (<b>lambda</b>), degree of latitude (<b>phi</b>) and the <b>timezone</b>. The timezone can be definded via the difference to the UTC timezone such that for Central European Time +1 needs to be entered for UTC+1.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TransiEnt/Images/sunpositionQuaschning.JPG\"/>[2]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The Sun Position equations mainly estimate the sunheight <b>gamma_s</b>, the sun azimuth <b>alpha_s</b> and the generation angle <b>theta_gen</b> between the sunrays and the arrays normal, also present in the figure.</span></p>
<p>*The calculation of the sun position has been extended by the calculation of gamma_s2 from Sandia [3] to prevent asin() arguments &GT;1 and &LT; -1 in the calculation of alpha_s. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.2. Irradiation on a tilted surface</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The irradiation onto a tilted surface <b>E_gen</b> consists of three parts - the direct beam fraction (<b>Edir_inclined</b>), the diffuse fraction (<b>Edif_inclined</b>) and the fraction resulting from the reflection of the surrounding ground (<b>Eground_inclined</b>) [2]. </span></p>
<pre>E_gen=Edir_inclined+Edif_inclined+Eground_inclined</pre>
<p><span style=\"font-family: MS Shell Dlg 2;\">The calculation of thedirect irradiation onto an inclined surface can be done via the angle theta_gen (see 6.1. Sun Position):</span></p>
<p><code>Edir_inclined=Edir_horizontal*<span style=\"color: #ff0000;\">cos</span>(theta_gen*DtR)/<span style=\"color: #ff0000;\">sin</span>(gamma_s*DtR)*IAM*(100-Soiling)/100</code></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">While <b>Edir_horizontal</b> is calculated by </span><code>Edir_horizontal&nbsp;=&nbsp;DNI_in&nbsp;*&nbsp;(<span style=\"color: #ff0000;\">cos</span>((90-gamma_s)*DtR)), </code><span style=\"font-family: MS Shell Dlg 2;\">IAM is the Incidence Angle Modifier and Soiling is the soiling losses (see 6.3. Losses).</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The calculation of the diffuse part Edif_inclined is calculated via a model from Klucher [4]:</span></p>
<pre>F=1-(Edif_horizontal/GHI)^2</pre>
<p><code>Edif_inclined=Edif_horizontal*((1+<span style=\"color: #ff0000;\">cos</span>(Tilt*DtR))/2)*(1+F*<span style=\"color: #ff0000;\">sin</span>(Tilt*DtR/2)^3)*(1+F*<span style=\"color: #ff0000;\">cos</span>(theta_gen*DtR)^2*<span style=\"color: #ff0000;\">cos</span>(gamma_s*DtR)^3)*((100-Soiling)/100)</code></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">While <b>Edif_horizontal</b> = DHI_in and <b>Tilt</b> is the tilt angle of the plane. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The ground reflected part can be calculated with the following equation [5].</span></p>
<p><code>Eground_inclined=GHI*Albedo*(1-<span style=\"color: #ff0000;\">cos</span>(Tilt*DtR))/2*(100-Soiling)/100</code></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">While GHI = Edif_horizontal + Edir_horizontal and albedo is the typical <b>Albedo</b> of the surrounding surfaces. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.3. Losses</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Incidence Angle Modification (IAM):</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The IAM takes into account losses for direct beams resulting from reflections due to incidence angles unequal 0. The physical model according to [6] is used. The value IAM will be in the range between 0 and 1.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Soiling:</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The Soiling reduces all parts of the irradiation by a fixed percentage value. The parameter Soiling can be a value between 0 and 100.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The Radiation_InclinedSurface model is to be used in PVModule model.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has been validated with System Advisor Model simulation results [1] for fixed PV arrays without shading influences.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">IWEC or TMY data was used in Hamburg, Munich and Miami. See Advanced_PV_rev_tb.Validation_Irradiation.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<pre>[1] https://sam.nrel.gov/
[2] Quaschning, V.: Regenerative Energiesysteme: Technologie - Berechnung - Simulation, Carl Hanser Verlag GmbH &AMP; Co. KG, 2013
[3] https://pvpmc.sandia.gov/modeling-steps/1-weather-design-inputs/sun-position/simple-models/
[4] http://www.physics.arizona.edu/~cronin/Solar/References/Irradiance&percnt;20Models&percnt;20and&percnt;20Data/LMF07.pdf and originated from Klucher, T.M., 1979. Evaluation of models to predict insolation on tilted surfaces. Solar Energy 23 (2), 111&ndash;114
[5] https://pvpmc.sandia.gov/modeling-steps/1-weather-design-inputs/plane-of-array-poa-irradiance/calculating-poa-irradiance/poa-ground-reflected/
[6] https://pvpmc.sandia.gov/modeling-steps/1-weather-design-inputs/shading-soiling-and-reflection-losses/incident-angle-reflection-losses/physical-model-of-iam/</pre>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<pre>Advanced_PV by Oliver Sch&uuml;lting and Ricardo Peniche, Technische Universit&auml;t Hamburg, Institut f&uuml;r Energietechnik, 2015
Advanced_PV_rev_tb by Tobias Becke, Technische Universit&auml;t Hamburg, Institut f&uuml;r Energietechnik, 2016</pre>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Radiation_InclinedSurface;
