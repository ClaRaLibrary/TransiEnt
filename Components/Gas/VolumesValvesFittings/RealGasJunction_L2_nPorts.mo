within TransiEnt.Components.Gas.VolumesValvesFittings;
model RealGasJunction_L2_nPorts "Volume junction for real gases with n ports"

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


  extends TransiEnt.Basics.Icons.RealGasJunction_L2;
  outer TransiEnt.SimCenter simCenter;

public
  inner parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(group="Initial Values"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"));

// ***************************** defintion of medium used in cell *************************************************

  replaceable parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);

  TransiEnt.Components.Gas.VolumesValvesFittings.Base.Linear_inclZero pressureLoss[n_ports](m_flow_nom=m_flow_nom, dp_nom=Delta_p_nom);

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPort[n_ports](each Medium=medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}}),   iconTransformation(extent={{-10,-10},{10,10}})));

  parameter Integer n_ports=3 annotation(Dialog(group="Fundamental Definitions"));

  parameter ClaRa.Basics.Units.Volume volume=0.1 "Volume of the junction" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean constantComposition=simCenter.useConstCompInGasComp "Use simplified equation for constant composition (xi_nom will be used)" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.MassFraction xi_nom[medium.nc - 1] = medium.xi_default "Constant composition" annotation (Dialog(group="Fundamental Definitions",enable=constantComposition));
  parameter Integer variableCompositionEntries[:](min=0,max=medium.nc)={0} "Entries of medium vector which are supposed to be completely variable" annotation(Dialog(group="Fundamental Definitions",enable=not constantComposition));
  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"),choices(choice=1 "Dynamic", choice=4 "Quasi stationary"));
  final parameter Integer dependentCompositionEntries[:]=if variableCompositionEntries[1] == 0 then 1:medium.nc else TransiEnt.Basics.Functions.findSetDifference(1:medium.nc, variableCompositionEntries) "Entries of medium vector which are supposed to be dependent on the variable entries";
  parameter Boolean showHeatPort=false annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation" annotation(Dialog(group="Initial Values"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nom[n_ports]=ones(n_ports)*10 "Nominal mass flow rate" annotation(Dialog(group="Fundamental Definitions"));
  parameter Modelica.SIunits.PressureDifference Delta_p_nom[n_ports](displayUnit="Pa")=zeros(n_ports) "Nominal pressure loss at m_flow_nom" annotation(Dialog(group="Fundamental Definitions"));

protected
  inner TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT gasBulk(
    vleFluidType=medium,
    p=p,
    T=heat.T,
    xi=xi,
    stateSelectPreferForInputs=true,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

  /****************** Initial values *******************/
public
  parameter ClaRa.Basics.Units.Pressure p_start=simCenter.p_amb_const+simCenter.p_eff_2 "Initial value for gas pressure"
    annotation(Dialog(group="Initial Values"));

  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(medium,p_start,T_start,xi_start) "Initial value for gas specific enthalpy"
    annotation(Dialog(group="Initial Values"));

  parameter ClaRa.Basics.Units.MassFraction[medium.nc - 1]
                                                         xi_start=medium.xi_default "Initial value for mass fractions"
                                     annotation(Dialog(group="Initial Values"));

  parameter ClaRa.Basics.Units.Temperature T_start=simCenter.T_ground "Initial value for gas temperature (used in calculation of h_start)"
    annotation(Dialog(group="Initial Values"));

public
 ClaRa.Basics.Units.MassFraction xi[medium.nc - 1](stateSelect={if Modelica.Math.Vectors.find(j, dependentCompositionEntries) == 0 then StateSelect.always else StateSelect.never for j in 1:medium.nc - 1});
  Modelica.SIunits.MassFraction xi_end=1-sum(xi) "Last entry of mass fraction";
  Modelica.SIunits.SpecificEnthalpy h(start=h_start) "Specific enthalpy";
  ClaRa.Basics.Units.Pressure p(start=p_start, stateSelect=if massBalance==4 then StateSelect.never else StateSelect.always);

  ClaRa.Basics.Units.Mass mass "Gas mass in control volume";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat annotation (Placement(transformation(extent=if showHeatPort then {{-10,20},{10,40}} else {{0,30},{0,30}})));
protected
  Real drhodt;
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

  h = gasBulk.h;
  der(h) = 1/mass*(sum(gasPort[i].m_flow*(noEvent(actualStream(gasPort[i].h_outflow))-h) for i in 1:n_ports) + volume*der(p) + heat.Q_flow) "Energy balance";

  if massBalance==4 then //quasi stationary

    drhodt = 0;
    if constantComposition then
      xi=xi_nom;
    else
      xi = sum(noEvent(max(0, gasPort[i].m_flow))*inStream(gasPort[i].xi_outflow) for i in 1:n_ports)/sum(noEvent(max(0, gasPort[i].m_flow)) for i in 1:n_ports);
    end if;

  else

    if not constantComposition then
      if variableCompositionEntries[1] == 0 then //all components are considered fully variable
        der(xi) = 1/mass*sum(gasPort[i].m_flow*(noEvent(actualStream(gasPort[i].xi_outflow))-xi) for i in 1:n_ports) "Component mass balance";
      else
        if variableCompositionEntries[end] == medium.nc then //the last component is considered fully variable and the last dependent entry is left out instead
          for j in variableCompositionEntries[1:end - 1] loop
            der(xi[j]) = 1/mass*sum(gasPort[i].m_flow*(noEvent(actualStream(gasPort[i].xi_outflow[j]))-xi[j]) for i in 1:n_ports) "Component mass balance";
          end for;
          der(xi_end) = 1/mass*sum(gasPort[i].m_flow*(1-sum(noEvent(actualStream(gasPort[i].xi_outflow)))-xi_end) for i in 1:n_ports) "Component mass balance";
          for j in dependentCompositionEntries[1:end - 1] loop
            xi[j] = (1 - (sum(xi[k] for k in variableCompositionEntries[1:end - 1]) + xi_end))/(1 - (sum(xi_nom[k] for k in variableCompositionEntries[1:end - 1]) + 1 - sum(xi_nom)))*xi_nom[j];
          end for;
        else //the last component is calculated from the sum of the remaining
          for j in variableCompositionEntries loop
            der(xi[j]) = 1/mass*sum(gasPort[i].m_flow*(noEvent(actualStream(gasPort[i].xi_outflow[j]))-xi[j]) for i in 1:n_ports) "Component mass balance";
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

  mass = volume*gasBulk.d "Mass in cell";

  drhodt*volume = sum(gasPort.m_flow) "Mass balance";

  pressureLoss.m_flow=gasPort.m_flow;

  for i in 1:n_ports loop
    gasPort[i].p - pressureLoss[i].dp = p;
    gasPort[i].xi_outflow = xi;
    gasPort[i].h_outflow = h;
  end for;

  annotation (defaultComponentName="junction",Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true)),
                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}},
                   preserveAspectRatio=false), graphics={
        Text(
          extent={{-20,-56},{20,-98}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="L2")}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a generalized junction for real gases with n ports. It is a modified version of the model TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2. The model is documented there and here only the changes are described: The three ports were replaced by one vector, summary, eye and fluid models at port were deleted. Linear pressure losses can be turned on by setting Delta_p_nom to a value unequal to zero for the desired port. You can choose a quasi-stationary or dynamic mass balance implementations. Additionally, the parameter variableCompositionEntries can be used in case that not all components are freely variable, e.g. when hydrogen is fed into natural gas.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPort[n_ports]: vector of inlets/outlets for gas</p>
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
<p>Created by Carsten Bode (c.bode@tuhh.de), Mar 2019</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), May 2020 (added quasi-stationary equations and simplified equations for only dependent mass fractions)</p>
</html>"));
end RealGasJunction_L2_nPorts;
