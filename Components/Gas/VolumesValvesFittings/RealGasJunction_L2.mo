within TransiEnt.Components.Gas.VolumesValvesFittings;
model RealGasJunction_L2 "Volume junction for real gases"

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

  // Modified component of the ClaRa library, version: 1.3.0
  // Path: ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2
  // changed ports and simCenter to TransiEnt versions
  // changed fluid models from ideal gas to real gas and their names (in summary as well)
  // changed start temperature to start enthalpy
  // changed start value for composition to default value
  // deleted "model Gas..."
  // changed eyeGas to eye
  // added temperature start value
  // added Boolean to turn on constant composition (improves model speed in that case)
  // added heat port
  // added mass quasi-stationary mass balance and mass balances for dependent mass fractions

  outer TransiEnt.SimCenter simCenter;
  extends TransiEnt.Basics.Icons.RealGasJunction_L2;

protected
  inner model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.RealGasBulk gasBulk;
    TransiEnt.Basics.Records.FlangeRealGas gasPort1;
    TransiEnt.Basics.Records.FlangeRealGas gasPort2;
    TransiEnt.Basics.Records.FlangeRealGas gasPort3;
  end Summary;

// ***************************** defintion of medium used in cell *************************************************

public
  replaceable parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

  inner parameter Integer initOption=0 "Type of initialisation" annotation (                              choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"), Dialog(group="Initial Values"));

  replaceable model PressureLoss1 =
    ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction constrainedby ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp "Pressure loss model at gasPort1" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss2 =
    ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction constrainedby ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp "Pressure loss model at gasPort2" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  replaceable model PressureLoss3 =
    ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction constrainedby ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp "Pressure loss model at gasPort3" annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);



  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPort1(Medium=medium, m_flow) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPort2(Medium=medium, m_flow) annotation (Placement(transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPort3(Medium=medium, m_flow) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  parameter ClaRa.Basics.Units.Volume volume=0.1 "Volume of the junction" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean constantComposition=simCenter.useConstCompInGasComp "Use simplified equation for constant composition (xi_nom will be used)" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.MassFraction xi_nom[medium.nc - 1] = medium.xi_default "Constant composition" annotation (Dialog(group="Fundamental Definitions",enable=constantComposition));
  parameter Integer variableCompositionEntries[:](min=0,max=medium.nc)={0} "Entries of medium vector which are supposed to be completely variable" annotation(Dialog(group="Fundamental Definitions",enable=not constantComposition));
  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"),choices(choice=1 "Dynamic", choice=4 "Quasi stationary"));
  final parameter Integer dependentCompositionEntries[:]=if variableCompositionEntries[1] == 0 then 1:medium.nc else TransiEnt.Basics.Functions.findSetDifference(
                                                                                                                                                  1:medium.nc, variableCompositionEntries) "Entries of medium vector which are supposed to be dependent on the variable entries";
  parameter Boolean showHeatPort=false annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation" annotation(Dialog(group="Initial Values"));

  PressureLoss1 pressureLoss1;
  PressureLoss2 pressureLoss2;
  PressureLoss3 pressureLoss3;
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gas1(
    vleFluidType=medium,
    p=p,
    h=noEvent(actualStream(gasPort1.h_outflow)),
    xi=noEvent(actualStream(gasPort1.xi_outflow)),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gas2(
    vleFluidType=medium,
    p=gasPort2.p,
    h=noEvent(actualStream(gasPort2.h_outflow)),
    xi=noEvent(actualStream(gasPort2.xi_outflow)),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-86},{10,-66}})));

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gas3(
    vleFluidType=medium,
    p=gasPort3.p,
    h=noEvent(actualStream(gasPort3.h_outflow)),
    xi=noEvent(actualStream(gasPort3.xi_outflow)),
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{66,-10},{86,10}})));

  inner TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT gasBulk(
    vleFluidType=medium,
    p=p,
    T=heat.T,
    xi=xi,
    stateSelectPreferForInputs=true,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
public
  parameter Boolean showData=true "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false";

  /****************** Initial values *******************/

//   parameter Boolean fixedInitialPressure = true
//     "if true, initial pressure is fixed" annotation(Dialog(group="Initial Values"));

  parameter ClaRa.Basics.Units.Pressure p_start=simCenter.p_amb_const+simCenter.p_eff_2 "Initial value for gas pressure"
    annotation(Dialog(group="Initial Values"));
//   parameter Boolean fixedInitialPressure = true
//     "if true, initial pressure is fixed" annotation(Dialog(group="Initial Values"));

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(medium,p_start,T_start,xi_start) "Initial value for gas specific enthalpy"
    annotation(Dialog(group="Initial Values"));

  parameter ClaRa.Basics.Units.MassFraction[medium.nc - 1]
                                                         xi_start=medium.xi_default "Initial value for mass fractions"
                                     annotation(Dialog(group="Initial Values"));

  parameter ClaRa.Basics.Units.Temperature T_start=simCenter.T_ground "Initial value for gas temperature (used in calculation of h_start)"
    annotation(Dialog(group="Initial Values"));

public
  ClaRa.Basics.Units.MassFraction xi[medium.nc - 1](start=xi_start,stateSelect={if Modelica.Math.Vectors.find(j, dependentCompositionEntries) == 0 then StateSelect.always else StateSelect.never for j in 1:medium.nc - 1});
  Modelica.SIunits.MassFraction xi_end=1-sum(xi) "Last entry of mass fraction";
  Modelica.SIunits.SpecificEnthalpy h(start=h_start) "Specific enthalpy";
  ClaRa.Basics.Units.Pressure p(start=p_start, stateSelect=if massBalance==4 then StateSelect.never else StateSelect.prefer);

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

public
  ClaRa.Basics.Interfaces.EyeOut
                           eye1 if
                                  showData
    annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-50})));
protected
  ClaRa.Basics.Interfaces.EyeIn
                          eye_int[2]
    annotation (Placement(transformation(extent={{55,-51},{57,-49}})));
public
  ClaRa.Basics.Interfaces.EyeOut
                           eye2 if
                                  showData
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-110}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-110})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat annotation (Placement(transformation(extent=if showHeatPort then {{-10,20},{10,40}} else {{0,30},{0,30}})));
initial equation

    if initOption == 1 then //steady state
      der(h)=0;
      der(p)=0;
      der(xi)=zeros(medium.nc-1);
    elseif initOption == 201 then //steady pressure
      der(p)=0;
    elseif initOption == 202 then //steady enthalpy
      der(h)=0;
    elseif initOption == 208 then // steady pressure and enthalpy
      der(h)=0;
      der(p)=0;
    elseif initOption == 210 then //steady density
      drhodt=0;
    elseif initOption == 0 then //no init
    // do nothing
    else
     assert(initOption == 0,"Invalid init option");
    end if;

  if not constantComposition and not massBalance == 4 then
    if variableCompositionEntries[1] <> 0 then
      for j in variableCompositionEntries loop
        if j <> medium.nc then
          xi[j] = xi_start[j];
        else
          xi_end = 1-sum(xi_start);
        end if;
      end for;
    else
      xi = xi_start;
    end if;
  end if;

equation
  pressureLoss1.m_flow = gasPort1.m_flow;
  pressureLoss2.m_flow = gasPort2.m_flow;
  pressureLoss3.m_flow = -gasPort3.m_flow;

  gasPort1.xi_outflow = xi;
  gasPort2.xi_outflow = xi;
  gasPort3.xi_outflow = xi;

  gasPort1.h_outflow = gasBulk.h;
  gasPort2.h_outflow = gasBulk.h;
  gasPort3.h_outflow = gasBulk.h;
  h = gasBulk.h;

  gasPort1.p =p + pressureLoss1.dp;
               // Volume is located at portA

  der(h) =1/mass*(gasPort1.m_flow*(gas1.h - h) + gasPort2.m_flow*(gas2.h - h) + gasPort3.m_flow*(gas3.h - h) + volume*der(p) + heat.Q_flow)
                       "Energy balance";

  if massBalance==4 then //quasi stationary

    drhodt = 0;
    if constantComposition then
      xi = xi_nom;
    else
      xi = (noEvent(max(0, gasPort1.m_flow))*inStream(gasPort1.xi_outflow) + noEvent(max(0, gasPort2.m_flow))*inStream(gasPort2.xi_outflow) + noEvent(max(0, gasPort3.m_flow))*inStream(gasPort3.xi_outflow))/
            (noEvent(max(0, gasPort1.m_flow)) + noEvent(max(0, gasPort2.m_flow)) + noEvent(max(0, gasPort3.m_flow)));
    end if;

  else

    if not constantComposition then
      if variableCompositionEntries[1] == 0 then //all components are considered fully variable
        der(xi) = 1/mass*(gasPort1.m_flow*(gas1.xi - xi) + gasPort2.m_flow*(gas2.xi - xi) + gasPort3.m_flow*(gas3.xi - xi)) "Component mass balance";
      else
        if variableCompositionEntries[end] == medium.nc then //the last component is considered fully variable and the last dependent entry is left out instead
          for j in variableCompositionEntries[1:end - 1] loop
            der(xi[j]) = 1/mass*(gasPort1.m_flow*(gas1.xi[j] - xi[j]) + gasPort2.m_flow*(gas2.xi[j] - xi[j]) + gasPort3.m_flow*(gas3.xi[j] - xi[j])) "Component mass balance";
          end for;
          der(xi_end) = 1/mass*(gasPort1.m_flow*(1-sum(gas1.xi) - xi_end) + gasPort2.m_flow*(1-sum(gas2.xi) - xi_end) + gasPort3.m_flow*(1-sum(gas3.xi) - xi_end)) "Component mass balance";
          for j in dependentCompositionEntries[1:end - 1] loop
            xi[j] = (1 - (sum(xi[k] for k in variableCompositionEntries[1:end - 1]) + xi_end))/(1 - (sum(xi_nom[k] for k in variableCompositionEntries[1:end - 1]) + 1 - sum(xi_nom)))*xi_nom[j];
          end for;
        else //the last component is calculated from the sum of the remaining
          for j in variableCompositionEntries loop
            der(xi[j]) = 1/mass*(gasPort1.m_flow*(gas1.xi[j] - xi[j]) + gasPort2.m_flow*(gas2.xi[j] - xi[j]) + gasPort3.m_flow*(gas3.xi[j] - xi[j])) "Component mass balance";
          end for;
          for j in dependentCompositionEntries[1:end - 1] loop
                xi[j] = (1 - sum(xi[k] for k in variableCompositionEntries))/(1 - sum(xi_nom[k] for k in variableCompositionEntries))*xi_nom[j];
          end for;
        end if;
      end if;
    else
      xi=xi_nom;
    end if;

    drhodt = gasBulk.drhodh_pxi*der(h) + gasBulk.drhodp_hxi*der(p) + sum({gasBulk.drhodxi_ph[i]*der(gasBulk.xi[i]) for i in 1:medium.nc - 1}) "Total differential";

  end if;

  mass =volume*gasBulk.d
                       "Mass in cell";


  drhodt*volume =gasPort1.m_flow + gasPort2.m_flow + gasPort3.m_flow
                                                             "Mass balance";

  gasPort2.p =p + pressureLoss2.dp  "Momentum balance";
  gasPort3.p =p - pressureLoss3.dp  "Momentum balance";

  eye_int[1].T= gas2.T-273.15;
    eye_int[1].s=gas2.s/1e3;
    eye_int[1].p=gas2.p/1e5;
    eye_int[1].h=gas2.h/1e3;
    eye_int[2].T= gas3.T-273.15;
    eye_int[2].s=gas3.s/1e3;
    eye_int[2].p=gas3.p/1e5;
    eye_int[2].h=gas3.h/1e3;
    eye_int[1].m_flow=-gasPort2.m_flow;
    eye_int[2].m_flow=-gasPort3.m_flow;

    connect(eye_int[1],eye1)  annotation (Line(
      points={{56,-50.5},{84,-50.5},{84,-50},{110,-50}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(eye_int[2],eye2)  annotation (Line(
      points={{56,-49.5},{56,-90},{30,-90},{30,-110}},
      color={190,190,190},
      smooth=Smooth.None));

  annotation (defaultComponentName="junction",Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true)),
                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}},
                   preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-92,32},{-74,-32}},
          pattern=LinePattern.None,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          visible=pressureLoss1.hasPressureLoss), Rectangle(
          extent={{74,32},{92,-32}},
          pattern=LinePattern.None,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          visible=pressureLoss2.hasPressureLoss),
        Rectangle(
          extent={{-32,-76},{32,-92}},
          pattern=LinePattern.None,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          visible=pressureLoss3.hasPressureLoss),
        Text(
          extent={{-20,-40},{20,-82}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="L2")}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a junction for real gases. It is a modified version of the model ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2 from ClaRa version 1.3.0. The model is documented there and here only the changes are described. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The two-phase region is deactivated. Pressure losses at the ports have been added. A simplified equation for constant composition can be used to improve simulation speed. Also, a heat port is added with which heat transfer can be integrated. You can choose a quasi-stationary or dynamic mass balance implementations. Additionally, the parameter variableCompositionEntries can be used in case that not all components are freely variable, e.g. when hydrogen is fed into natural gas.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for real gases without phase change.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPort1: inlet for gas</p>
<p>gasPort2: inlet for gas</p>
<p>gasPort3: outlet for gas</p>
<p>eye1: outlet</p>
<p>eye2: outlet</p>
<p>heat: heat port</p>
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
<p>Edited by Carsten Bode (c.bode@tuhh.de), Apr 2016</p>
<p>Revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (updated to new ClaRa version 1.3.0)</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), Feb 2019 (added temperature start value)</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), Mar 2019 (added pressure losses)</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), May 2019 (added simplified equation for constant composition)</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), Sep 2019 (added heat port)</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), May 2020 (added quasi-stationary equations and simplified equations for only dependent mass fractions)</p>
</html>"));
end RealGasJunction_L2;
