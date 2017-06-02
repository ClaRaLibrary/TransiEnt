within TransiEnt.Components.Gas.VolumesValvesFittings;
model RealGasJunction_L2 "Adiabatic Volume Junction for real gases"

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

  // Modified component of the ClaRa library, version: 1.2.1                   //
  // Path: ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2  //
  // changed ports and simCenter to TransiEnt versions                         //
  // changed fluid models from ideal gas to real gas and their names           //
  // changed start temperature to start enthalpy                               //
  // changed start value for composition to default value                      //

  extends ClaRa.Basics.Icons.Tpipe2;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L2");
  outer TransiEnt.SimCenter simCenter;

protected
  inner model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.RealGasBulk gasBulk;
    TransiEnt.Basics.Records.FlangeRealGas gasPort1;
    TransiEnt.Basics.Records.FlangeRealGas gasPort2;
    TransiEnt.Basics.Records.FlangeRealGas gasPort3;
  end Summary;

public
  inner parameter ClaRa.Basics.Choices.Init initType=ClaRa.Basics.Choices.Init.noInit "Type of initialisation"
                             annotation(Dialog(tab="Initialisation", choicesAllMatching));

// ***************************** defintion of medium used in cell *************************************************

  replaceable parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPort1(Medium=medium, m_flow) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPort2(Medium=medium, m_flow) annotation (Placement(transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPort3(Medium=medium, m_flow) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  parameter ClaRa.Basics.Units.Volume volume=0.1 "Volume of the junction" annotation(Dialog(group="Fundamental Definitions"));

protected
  TILMedia.VLEFluid_ph gas1(
    vleFluidType=medium,
    p=p,
    h=noEvent(actualStream(gasPort1.h_outflow)),
    xi=noEvent(actualStream(gasPort1.xi_outflow)),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));

  TILMedia.VLEFluid_ph gas2(
    vleFluidType=medium,
    p=gasPort2.p,
    h=noEvent(actualStream(gasPort2.h_outflow)),
    xi=noEvent(actualStream(gasPort2.xi_outflow)),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-86},{10,-66}})));

  TILMedia.VLEFluid_ph gas3(
    vleFluidType=medium,
    p=gasPort3.p,
    h=noEvent(actualStream(gasPort3.h_outflow)),
    xi=noEvent(actualStream(gasPort3.xi_outflow)),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{66,-10},{86,10}})));

  inner TILMedia.VLEFluid_ph gasBulk(
    vleFluidType=medium,
    p=p,
    h=h,
    xi=xi,
    stateSelectPreferForInputs=true,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

  /****************** Initial values *******************/

public
  parameter ClaRa.Basics.Units.Pressure p_start=simCenter.p_amb_const+simCenter.p_eff_2 "Initial value for pressure"
                                     annotation(Dialog(group="Initial Values"));
//   parameter Boolean fixedInitialPressure = true
//     "if true, initial pressure is fixed" annotation(Dialog(group="Initial Values"));
  parameter ClaRa.Basics.Units.MassFraction[medium.nc-1] xi_start=medium.xi_default "Initial value for composition"
                                    annotation(Dialog(group="Initial Values"));

  parameter Modelica.SIunits.SpecificEnthalpy h_start=(-1850) "Initial value for gas enthalpy"   annotation(Dialog(group="Initial Values"));

  ClaRa.Basics.Units.MassFraction xi[medium.nc - 1](start=xi_start);
  Modelica.SIunits.SpecificEnthalpy h(start=h_start) "Specific enthalpy";
  ClaRa.Basics.Units.Pressure p(start=p_start);

  ClaRa.Basics.Units.Mass mass "Gas mass in control volume";
protected
  Real drhodt;
public
  inner Summary summary(
    gasPort1(
      mediumModel=medium,
      xi=gas1.xi,
      x=gas1.x,
      m_flow=gasPort1.m_flow,
      T=gas1.T,
      p=gasPort1.p,
      h=gas1.h,
      rho=gas1.d),
    gasPort2(
      mediumModel=medium,
      xi=gas2.xi,
      x=gas2.x,
      m_flow=gasPort2.m_flow,
      T=gas2.T,
      p=gasPort2.p,
      h=gas2.h,
      rho=gas2.d),
    gasPort3(
      mediumModel=medium,
      xi=gas3.xi,
      x=gas3.x,
      m_flow=gasPort3.m_flow,
      T=gas3.T,
      p=gasPort3.p,
      h=gas3.h,
      rho=gas3.d),
    gasBulk(
      mediumModel=medium,
      mass=mass,
      T=gasBulk.T,
      p=p,
      h=h,
      xi=xi,
      x=gasBulk.x,
      rho=gasBulk.d)) annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));

initial equation

  if initType == ClaRa.Basics.Choices.Init.steadyState then
    der(h)=0;
    der(p)=0;
  elseif initType == ClaRa.Basics.Choices.Init.steadyPressure then
    der(p)=0;
  elseif initType == ClaRa.Basics.Choices.Init.steadyEnthalpy then
    der(h)=0;
  elseif initType == ClaRa.Basics.Choices.Init.steadyDensity then
    drhodt=0;
  end if;

equation

  gasPort1.xi_outflow = xi;
  gasPort2.xi_outflow = xi;
  gasPort3.xi_outflow = xi;

  gasPort1.h_outflow = gasBulk.h;
  gasPort2.h_outflow = gasBulk.h;
  gasPort3.h_outflow = gasBulk.h;

  gasPort1.p = p;
               // Volume is located at portA

  der(h) =1/mass*(gasPort1.m_flow*(gas1.h - h) + gasPort2.m_flow*(gas2.h - h) + gasPort3.m_flow*(gas3.h - h) + volume*der(p))
                       "Energy balance";

  der(xi) =1/mass*(gasPort1.m_flow*(gas1.xi - xi) + gasPort2.m_flow*(gas2.xi - xi) + gasPort3.m_flow*(gas3.xi - xi))     "Component mass balance";

  mass =volume*gasBulk.d
                       "Mass in cell";

  drhodt =gasBulk.drhodh_pxi*der(h) + gasBulk.drhodp_hxi*der(p) + sum({gasBulk.drhodxi_ph[i]*der(gasBulk.xi[i]) for i in 1:medium.nc - 1})
                                                                                                                                "Total differential";

  drhodt*volume =gasPort1.m_flow + gasPort2.m_flow + gasPort3.m_flow
                                                             "Mass balance";

  gasPort1.p - gasPort2.p = 0 "Momentum balance";
  gasPort1.p - gasPort3.p = 0 "Momentum balance";

  annotation (defaultComponentName="junction",Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true)),
                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}},
                   preserveAspectRatio=false)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a junction for real gases. It is a modified version of the model ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2 from ClaRa version 1.2.1. The model is documented there and here only the changes are described. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The two-phase region is deactivated. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for real gases without phase change.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
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
<p>Created by Christopher Helbig (christopher.helbig@tuhh.de), Nov 2014</p>
<p>Modified by Lisa Andresen (andresen@tuhh.de), Feb 2015</p>
<p><br>Edited by Carsten Bode (c.bode@tuhh.de), Apr 2016</p>
</html>"));
end RealGasJunction_L2;
