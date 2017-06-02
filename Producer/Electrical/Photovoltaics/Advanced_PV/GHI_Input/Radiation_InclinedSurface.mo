within TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.GHI_Input;
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
  parameter String DiffuseModel="Skartveit and Olseth" "Choose the diffuse fraction correlation" annotation(choices(choice="Skartveit and Olseth",choice="Erbs",choice="Orgill and Hollands",choice="Reindl et al. 1",choice="Reindl et al. 2"));
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
  Real argument_alpha_s;
  Real alpha_s "sun azimuth";

  Real theta_z "sun zenith angle";
  Real gamma_s "angle sunheight";

  Real theta_gen "incidence angle of beam onto surface";

  Real theta_r "angle of refraction";
  Real tau_theta_gen "transmittance of the module at theta_gen";
  Real tau_0 "transmittance when theta_gen = 0";
  Real IAM "Incidence Angle Modification";

  Modelica.SIunits.Irradiance E0 "extraterrestrial radiation";
  Real kt "clearness Index";
  Real d "diffuse fraction of GHI";
  Real a1;
  Real kc;
  Real dc;
  Real a2;
  Real K;
  Real k0;

  Modelica.SIunits.Irradiance  GHI "global horizontal irradiation";
  Modelica.SIunits.Irradiance  Edir_horizontal "beam irradiation onto horizontal surface";
  Modelica.SIunits.Irradiance  Edif_horizontal "diffuse irradiation onto horizontal surface";
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
  Modelica.Blocks.Interfaces.RealInput GHI_in "Global Horizontal Irradiation in W/m^2" annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  DtR=Modelica.Constants.pi/180;

  //calculation of sun position
  J=time/86400;
  LocalTime=time-86400*integer(time/86400);
  if LocalTime-4*(timezone*15-lambda)*60>0 then
    LocalTime=MOZ+4*(timezone*15-lambda)*60;
  else
    MOZ=LocalTime-4*(timezone*15-lambda)*60+3600*24;
  end if;

  WOZ_s=MOZ+Zgl*60;

  //MOZ=WOZ_s-Zgl;
  J2=360*J/365;
  Zgl=0.0066+7.3525*cos((J2+85.9)*DtR)+9.9359*cos((2*J2+108.9)*DtR)+0.3387*cos((3*J2+105.2)*DtR);
  delta=0.3948-23.2559*cos((J2+9.1)*DtR)-0.3915*cos((2*J2+5.4)*DtR)-0.1764*cos((3*J2+26)*DtR);
  WOZ=WOZ_s/3600;
  omega=(12-WOZ)*15;
  gamma_s=asin(cos(omega*DtR)*cos(phi*DtR)*cos(delta*DtR)+sin(phi*DtR)*sin(delta*DtR))/DtR;
  argument_alpha_s=(sin(gamma_s*DtR)*sin(phi*DtR)-sin(delta*DtR))/(cos(gamma_s*DtR)*cos(phi*DtR));

  if noEvent(WOZ<=12) then
    alpha_s=180-acos(argument_alpha_s)/DtR;
  else
    alpha_s=180+acos(argument_alpha_s)/DtR;
  end if;

  theta_z=90-gamma_s;

  //calculation of theta_gen
  if Tracking=="No Tracking" then
    theta_gen=acos(-cos(gamma_s*DtR)*sin(Tilt*DtR)*cos((alpha_s-Azimuth)*DtR)+sin(gamma_s*DtR)*cos(Tilt*DtR))/DtR;
  else
    theta_gen=0;
  end if;

  //Incidence Angle Modification - refraction losses
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

  //extraterrestrial radiation
  if 1367*(1+0.033*cos(360*(J-3)/365*DtR))>0 then
    E0=1367*(1+0.033*cos(360*(J-3)/365*DtR));
  else
    E0=0;
  end if;

  //calculation of clearness index kt
  if E0*sin(gamma_s*DtR)<=GHI or gamma_s<=0.0 then
    kt=0;
   else
    kt=GHI/(E0*sin(gamma_s*DtR));
  end if;

  //Diffuse fraction calculation
  if DiffuseModel=="Skartveit and Olseth" then
    //difuse fraction d with model of Skartveit/Olseth:
    //  a1=1.09; //original value
    //  a2=0.27; //original value
    a1=1.15; //adapted value
    a2=0.33; //adapted value
    k0=0.24;
    kc=0.82-0.51*exp(-0.06*gamma_s);
    dc=0.12+0.46*exp(-0.06*gamma_s);

    if kt<=k0 then
      d=1;
      K=0.5*(1+sin(Modelica.Constants.pi*((kt-k0)/(kc-k0)-0.5)));
    elseif kt<=a1*kc and gamma_s<3 and GHI<19 then
      d=1;
      K=1;
    elseif kt<=a1*kc then
      d=1-(1-dc)*(a2*K^(1/2)+(1-a2)*K^2);
      K=0.5*(1+sin(Modelica.Constants.pi*((kt-k0)/(kc-k0)-0.5)));
    elseif kt>a1*kc and gamma_s<3 and GHI<19 then
      d=1;
      K=1;
    else
      d=1-a1*kc*(1-(1-(1-dc)*(a2*K^(1/2)+(1-a2)*K^2)))/kt;
      K=0.5*(1+sin(Modelica.Constants.pi*((a1*kc-k0)/(kc-k0)-0.5)));
    end if;

  elseif (DiffuseModel=="Erbs") then
    a1=0;
    kc=0;
    dc=0;
    a2=0;
    k0=0;
    K=0;

    if kt <= 0.22 then
      d = 1 - 0.09 * kt;
    elseif kt > 0.22 and kt <= 0.8 then
      d = 0.9511 - 0.1604 * kt + 4.388 * kt^2 - 16.638 * kt^3 + 12.336 * kt^4;
    else
      d = 0.165;
    end if;

  elseif (DiffuseModel=="Orgill and Hollands") then
    a1=0;
    kc=0;
    dc=0;
    a2=0;
    k0=0;
    K=0;

    if kt <= 0.35 then
      d = 1 - 0.24 * kt;
    elseif kt > 0.35 and kt <= 0.75 then
      d = 1.577 - 1.84 * kt;
    else
      d = 0.177;
    end if;

  elseif (DiffuseModel=="Reindl et al. 1") then
    a1=0;
    kc=0;
    dc=0;
    a2=0;
    k0=0;
    K=0;

    if kt <= 0.3 then
      d = 1.02 - 0.248 * kt;
    elseif kt > 0.3 and kt <= 0.78 then
      d = 1.45 - 1.67 * kt;
    else
      d = 0.177;
    end if;

  elseif (DiffuseModel=="Reindl et al. 2") then
    a1=0;
    kc=0;
    dc=0;
    a2=0;
    k0=0;
    K=0;

    if kt <= 0.3 then
      d = 1.02 - 0.254 * kt + 0.0123 * sin((90 - theta_z) * DtR);
    elseif kt > 0.3 and kt <= 0.78 then
      d = 1.4 - 1.749 * kt + 0.177 * sin((90 - theta_z) * DtR);
    else
      d = 0.486 * kt - 0.182 * sin((90 - theta_z) * DtR);
    end if;

  else
    a1=0;
    kc=0;
    dc=0;
    a2=0;
    k0=0;
    K=0;
    d=1;

  end if;

  GHI = GHI_in;
  Edif_horizontal=GHI*d;

  //direct radiation on horizontal plane
  if noEvent(GHI-Edif_horizontal<0) then
    Edir_horizontal=0;
  else
    Edir_horizontal=GHI-Edif_horizontal;
  end if;

  //diffuse radiation on tilted surface according to Klucher
  if GHI<=0.0001 then
    F=0;
    Edif_inclined=0;
  else
    F=1-(Edif_horizontal/GHI)^2;
    Edif_inclined=Edif_horizontal*((1+cos(Tilt*DtR))/2)*(1+F*sin(Tilt*DtR/2)^3)*(1+F*cos(theta_gen*DtR)^2*cos(gamma_s*DtR)^3)*((100-Soiling)/100);
  end if;

  //Edir_inclined
  if gamma_s<=0 or theta_gen>90 or theta_gen <-90 then
    Edir_inclined=0;
  else
    Edir_inclined=Edir_horizontal*cos(theta_gen*DtR)/sin(gamma_s*DtR)*IAM*(100-Soiling)/100;
  end if;

  //ground reflected irradiation
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
          smooth=Smooth.Bezier),
        Text(
          extent={{-150,-101},{150,-141}},
          lineColor={0,134,134},
          textString="%name")}),                                                           Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The purpose of this model is to calculate the irradiation onto a tilted surface for PV generation.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model is based on empiric equations. Optical losses are being consideres due to loss factors for soiling and refraction and reflexion (contained in the incidence angle modification); </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has been validated with System Advisor Model simulation results [1] for fixed PV arrays without shading influences. The results are best with Tilt angle of ~30&deg;.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has not been entirely validated for sun tracking. Disabling Incidence Angle Modifications seems to improve tracking results.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Input: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">GHI_in </span></b>for global horizontal irradiation</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Output: </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2;\">E_gen</span></b> for <span style=\"font-family: MS Shell Dlg 2;\">irradiation</span> usable for PV on the plane of array (= POA Irradiation)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See parameter and variable descriptions in the code.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.1. Sun Position</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The sun position angles are calculated follwing the correlations of Quaschning [2] using terms and variables from DIN 5034*. Therefore the location is needed which can be defined via the degree of longitude (<b>lambda</b>), degree of latitude (<b>phi</b>) and the <b>timezone</b>. The timezone can be definded via the difference to the UTC timezone such that for Central European Time +1 needs to be entered for UTC+1.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TransiEnt/Images/sunpositionQuaschning.JPG\"/>[2]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The Sun Position equations mainly estimate the sunheight <b>gamma_s</b>, the sun azimuth <b>alpha_s</b> and the generation angle <b>theta_gen</b> between the sunrays and the arrays normal, also present in the figure.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.2. Irradiation on a tilted surface</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The irradiation onto a tilted surface <b>E_gen</b> consists of three parts - the direct beam fraction (<b>Edir_inclined</b>), the diffuse fraction (<b>Edif_inclined</b>) and the fraction resulting from the reflection of the surrounding ground (<b>Eground_inclined</b>) [2]. </span></p>
<p><code>E_gen=Edir_inclined+Edif_inclined+Eground_inclined</code> </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">As the only input is GHI = GHI_in, GHI has to be divided into a diffuse and a direct fraction.</span></p>
<pre>Edif_horizontal=GHI*d
Edir_horizontal=GHI-Edif_horizontal</pre>
<p><b>d</b> is the diffuse fraction estimated by the empiric models of Skartveit and Olseth [3], Erbs, Orgill and Hollands or Reindl et al. [4].</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The calculation of the diffuse part Edif_inclined is calculated via a model from Klucher [5]:</span></p>
<pre>F=1-(Edif_horizontal/GHI)^2</pre>
<p><code>Edif_inclined=Edif_horizontal*((1+<span style=\"color: #ff0000;\">cos</span>(Tilt*DtR))/2)*(1+F*<span style=\"color: #ff0000;\">sin</span>(Tilt*DtR/2)^3)*(1+F*<span style=\"color: #ff0000;\">cos</span>(theta_gen*DtR)^2*<span style=\"color: #ff0000;\">cos</span>(gamma_s*DtR)^3)*((100-Soiling)/100)</code></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The calculation of the direct irradiation onto an inclined surface can be done via the angle theta_gen (see 6.1. Sun Position):</span></p>
<p><code>Edir_inclined=Edir_horizontal*<span style=\"color: #ff0000;\">cos</span>(theta_gen*DtR)/<span style=\"color: #ff0000;\">sin</span>(gamma_s*DtR)*IAM*(100-Soiling)/100</code></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">IAM is the Incidence Angle Modifier and Soiling is the soiling losses (see 6.3. Losses).</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The ground reflected part can be calculated with the following equation [6].</span></p>
<p><code>Eground_inclined=GHI*Albedo*(1-<span style=\"color: #ff0000;\">cos</span>(Tilt*DtR))/2*(100-Soiling)/100</code></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">While GHI = Edif_horizontal + Edir_horizontal and albedo is the typical <b>Albedo</b> of the surrounding surfaces. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6.3. Losses</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Incidence Angle Modification (IAM): </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The IAM takes into account losses for direct beams resulting from reflections due to incidence angles unequal 0. The physical model according to [7] is used. The value IAM will be in the range between 0 and 1.</span></p>
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
[3] Skartveit, Arvid; Olseth, Jan Asle (1987): A model for the diffuse fraction of hourly global radiation. In: Solar Energy 38 (4), S. 271&ndash;274. DOI: 10.1016/0038-092X(87)90049-1.
[4] https://pvpmc.sandia.gov/modeling-steps/1-weather-design-inputs/irradiance-and-insolation-2/direct-normal-irradiance/piecewise_decomp-models/
[5] http://www.physics.arizona.edu/~cronin/Solar/References/Irradiance&percnt;20Models&percnt;20and&percnt;20Data/LMF07.pdf and originated from Klucher, T.M., 1979. Evaluation of models to predict insolation on tilted surfaces. Solar Energy 23 (2), 111&ndash;114
[6] https://pvpmc.sandia.gov/modeling-steps/1-weather-design-inputs/plane-of-array-poa-irradiance/calculating-poa-irradiance/poa-ground-reflected/
[7] https://pvpmc.sandia.gov/modeling-steps/1-weather-design-inputs/shading-soiling-and-reflection-losses/incident-angle-reflection-losses/physical-model-of-iam/</pre>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<pre>Advanced_PV by Oliver Sch&uuml;lting and Ricardo Peniche, Technische Universit&auml;t Hamburg, Institut f&uuml;r Energietechnik, 2015
Advanced_PV_rev_tb by Tobias Becke, Technische Universit&auml;t Hamburg, Institut f&uuml;r Energietechnik, 2016</pre>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Radiation_InclinedSurface;
