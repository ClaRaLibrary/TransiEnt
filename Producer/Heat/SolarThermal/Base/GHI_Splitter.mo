within TransiEnt.Producer.Heat.SolarThermal.Base;
model GHI_Splitter

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
  //        Constants and Hidden Parameters
  // _____________________________________________
  parameter String DiffuseModel="Skartveit and Olseth" "Choose the diffuse fraction correlation" annotation(choices(choice="Skartveit and Olseth",choice="Erbs",choice="Orgill and Hollands",choice="Reindl et al. 1",choice="Reindl et al. 2"));
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  Real kt "clearness Index";
  Real d "diffuse fraction of GHI";
  Real a1;
  Real kc;
  Real dc;
  Real a2;
  Real K;
  Real k0;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer IrradianceOnATiltedSurface irradiance;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Ambient.IrradianceIn GHI_input annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  TransiEnt.Basics.Interfaces.Ambient.IrradianceOut irradiance_direct_horizontal "Measured direct irradiance" annotation (Placement(transformation(extent={{100,30},{120,50}})));
  TransiEnt.Basics.Interfaces.Ambient.IrradianceOut irradiance_diffuse_horizontal "Measured diffuse irradiance" annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  // _____________________________________________
  //
  //              Private Functions
  // _____________________________________________
  //   function plotResult
  //   constant String resultFileName = "InsertModelNameHere.mat";
  //   algorithm
  //     TransiEnt.Basics.Functions.plotResult(resultFileName);
  //     createPlot(...); // obtain content by calling function plotSetup() in the commands window
  //     //add ,filename=resultFileName at the end of first createPlot command
  //   end plotResult;
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  irradiance_direct_horizontal = max(0, GHI_input*(1 - d));
  irradiance_diffuse_horizontal=max(0,GHI_input*d);

  kt=GHI_input/max(1,irradiance.skymodel.irradiance_extraterrestrial*cos(max(0.001,irradiance.skymodel.angle_tilted)));

  if DiffuseModel=="Skartveit and Olseth" then
    //difuse fraction d with model of Skartveit/Olseth:
    //  a1=1.09; //original value
    //  a2=0.27; //original value
    a1=1.15; //adapted value
    a2=0.33; //adapted value
    k0=0.24;
    kc=0.82 - 0.51*exp(-0.06*(90 - Modelica.Units.Conversions.to_deg(irradiance.skymodel.angle_tilted)));
    dc=0.12 + 0.46*exp(-0.06*(90 - Modelica.Units.Conversions.to_deg(irradiance.skymodel.angle_tilted)));

    if kt<=k0 then
      d=1;
      K=0.5*(1+sin(Modelica.Constants.pi*((kt-k0)/(kc-k0)-0.5)));
    elseif kt<=a1*kc and GHI_input<19 then
      d=1;
      K=1;
    elseif kt<=a1*kc then
      d=1-(1-dc)*(a2*K^(1/2)+(1-a2)*K^2);
      K=0.5*(1+sin(Modelica.Constants.pi*((kt-k0)/(kc-k0)-0.5)));
    elseif kt>a1*kc and GHI_input<19 then
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
      d = 1.02 - 0.254 * kt + 0.0123 * sin(irradiance.skymodel.angle_tilted);
    elseif kt > 0.3 and kt <= 0.78 then
      d = 1.4 - 1.749 * kt + 0.177 * sin(irradiance.skymodel.angle_tilted);
    else
      d = 0.486 * kt - 0.182 * sin(irradiance.skymodel.angle_tilted);
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

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________


  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-100,0},{-6,0}},
          color={255,220,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-6,0},{90,40}},
          color={255,220,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-6,0},{92,-40}},
          color={255,220,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open})}),                      Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model calculates the diffuse fraction of measured GHI d, to estimate the diffuse and direct fraction of GHI onto a horizontal surface. The user can choose between serveral empiric models to calculate the diffuse fraction (Skartveit and Olseth [1], Erbs, Orgill and Hollands or Reindl et al. [2]). The calculation of direct and</p>
<p>diffuse irradation from GHI is highly inaccurate.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>irradiance_diffuse_horizontal: output for irradiance in W/m2</p>
<p>GHI_input: input for irradiance in W/m2</p>
<p>irradiance_direct_horizontal: output for irradiance in W/m2</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Skartveit, Arvid; Olseth, Jan Asle, &quot;A model for the diffuse fraction of hourly global radiation&quot;. In: Solar Energy 38 (4), S. 271&ndash;274. DOI: 10.1016/0038-092X(87)90049-1, 1987.</p>
<p>[2] PVPerformance Modeling Collaborative, &quot;Piecewise Decomposition Models&quot;, URL: https://pvpmc.sandia.gov/modeling-steps/1-weather-design-inputs/irradiance-and-insolation-2/direct-normal-irradiance/piecewise_decomp-models, 2018.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Schülting (oliver.schuelting@tuhh.de), May 2018</p>
</html>"));
end GHI_Splitter;
