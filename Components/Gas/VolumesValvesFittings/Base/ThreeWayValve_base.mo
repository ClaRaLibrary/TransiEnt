within TransiEnt.Components.Gas.VolumesValvesFittings.Base;
partial model ThreeWayValve_base "Three way valve for vle media | base class |"

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

  // modified component of the ClaRa library, version 1.3.0                    //
  // Path: ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValve_base    //
  // changed ports and simCenter to TransiEnt versions                         //
  // two phase region is deactivated                                           //

    // _____________________________________________
    //
    //          Imports and Class Hierarchy
    // _____________________________________________
  import SI = Modelica.SIunits;

    // _____________________________________________
    //
    //              Visible Parameters
    // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.gasModel1 "Medium in the component" annotation(Dialog(group="Fundamental Definitions"));

  parameter Boolean showExpertSummary=simCenter.showExpertSummary "|Summary and Visualisation||True, if expert summary should be applied";
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";
  parameter Boolean splitRatio_input=false "|Fundamental Definitions|= true, if split ratio is defined by input";
  parameter Real splitRatio_fixed = 0.5 "|Fundamental Definitions|" annotation(Dialog(enable=not splitRatio_input));
  parameter Boolean useFluidModelsForSummary=false "True, if fluid models shall be used for the summary" annotation(Dialog(tab="Summary and Visualisation"));

    // _____________________________________________
    //
    //                 Outer Models
    // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________
public
  TransiEnt.Basics.Interfaces.General.MassFractionIn splitRatio_external(min=0,max=1,value=splitRatio) if splitRatio_input "Controls mass fraction m2/m1"
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,31}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,90})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut1(each Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut2(each Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{-10,-90},{10,-70}}), iconTransformation(extent={{-10,-110},{10,-90}})));
public
  ClaRa.Basics.Interfaces.EyeOut eye1 if showData annotation (Placement(transformation(extent={{90,-30},{110,-10}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-40})));
protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[2] annotation (Placement(transformation(extent={{45,-21},{47,-19}})));
public
  ClaRa.Basics.Interfaces.EyeOut eye2 if showData annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,-80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-110})));
    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    each vleFluidType=medium,
    h=noEvent(actualStream(gasPortIn.h_outflow)),
    xi=noEvent(actualStream(gasPortIn.xi_outflow)),
    p=gasPortIn.p,
    deactivateTwoPhaseRegion=true) if useFluidModelsForSummary annotation (Placement(transformation(extent={{-90,-12},{-70,8}}, rotation=0)));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut2(
    each vleFluidType=medium,
    h=noEvent(actualStream(gasPortOut2.h_outflow)),
    xi=noEvent(actualStream(gasPortOut2.xi_outflow)),
    p=gasPortOut2.p,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-70},{10,-50}}, rotation=0)));
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut1(
    each vleFluidType=medium,
    h=noEvent(actualStream(gasPortOut1.h_outflow)),
    xi=noEvent(actualStream(gasPortOut1.xi_outflow)),
    p=gasPortOut1.p,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{70,-10},{90,10}}, rotation=0)));

    // _____________________________________________
    //
    //             Variable Declarations
    // _____________________________________________

protected
  Real splitRatio;


equation
    // _____________________________________________
    //
    //           Characteristic Equations
    // _____________________________________________

 if (not splitRatio_input) then
    splitRatio = splitRatio_fixed;
  end if;
   eye_int[1].T=gasOut1.T - 273.15;
    eye_int[1].s=gasOut1.s/1e3;
    eye_int[1].p=gasOut1.p/1e5;
    eye_int[1].h=gasOut1.h/1e3;
    eye_int[2].T=gasOut2.T - 273.15;
    eye_int[2].s=gasOut2.s/1e3;
    eye_int[2].p=gasOut2.p/1e5;
    eye_int[2].h=gasOut2.h/1e3;
    eye_int[1].m_flow=-gasPortOut1.m_flow;
    eye_int[2].m_flow=-gasPortOut2.m_flow;

    // _____________________________________________
    //
    //               Connect Statements
    // _____________________________________________

  connect(eye_int[1],eye1)  annotation (Line(
      points={{46,-20.5},{74,-20.5},{74,-20},{100,-20}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(eye_int[2],eye2)  annotation (Line(
      points={{46,-19.5},{46,-60},{20,-60},{20,-80}},
      color={190,190,190},
      smooth=Smooth.None));

annotation(Icon(
      graphics={coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,80}},
        grid={2,2}),
        Polygon(
          points={{0,4},{50,-100},{-50,-100},{0,4}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
        points={{0,-16},{-38,-92},{38,-92},{0,-16}},
        lineColor={0,0,0},
        fillColor={215,215,215},
        fillPattern=FillPattern.Solid),
        Polygon(
          points={{10,0},{-100,50},{-100,-50},{10,0}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{55,0},{-55,50},{-55,-50},{55,0}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={45,0},
          rotation=180),
        Polygon(
        points={{7.10543e-15,-44},{-38,38},{38,38},{7.10543e-15,-44}},
        lineColor={0,0,0},
        fillColor={215,215,215},
        fillPattern=FillPattern.Solid,
        origin={-54,0},
        rotation=90),
        Polygon(
        points={{7.10543e-15,-44},{-38,38},{38,38},{7.10543e-15,-44}},
        lineColor={0,0,0},
        fillColor={215,215,215},
        fillPattern=FillPattern.Solid,
        origin={54,0},
        rotation=270),
        Rectangle(
          extent={{-4,70},{4,0}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,70},{40,62}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
      Diagram(graphics,
              coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a partial model for a three way valve for real gas flows. It is a modified version of the model ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValve_base from ClaRa version 1.3.0. The model is documented there and here only the changes are described. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The two-phase region is deactivated. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid if changes in density and the two-phase region of the fluid can be neglected.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.General.MassFractionIn splitRatio_external(min=0,max=1,value=splitRatio) if splitRatio_input &quot;Controls mass fraction m2/m1&quot;</p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) &quot;Inlet port&quot; </p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut1(each Medium=medium) &quot;Outlet port&quot; </p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut2(each Medium=medium) &quot;Outlet port&quot; </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016</p>
<p>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (updated to ClaRa 1.3.0)</p>
</html>"));
end ThreeWayValve_base;
