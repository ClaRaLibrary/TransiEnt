within TransiEnt.Components.Boundaries.Gas;
model BoundaryRealGas_phxi "A real gas boundary defining enthalpy, mass composition and mass flow"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.GasSink;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used"  annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter Boolean calculateMass=false "true if mass in boundary shall be calculated" annotation(Dialog(group="Fundamental Definitions"));

  parameter Boolean variable_p=false "True, if pressure defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_h=false "True, if enthalpy defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_xi=false "True, if composition defined by variable input"    annotation(Dialog(group="Define Variable Boundaries"));

  parameter Boolean verbose = false "show initial gas compostion in log" annotation(Dialog(group="Define Variable Boundaries"));

  parameter SI.AbsolutePressure p_const=simCenter.p_amb_const+simCenter.p_eff_2 "Constant absolute pressure" annotation (Dialog(group="Constant Boundaries", enable=not variable_p));
  parameter SI.SpecificEnthalpy h_const=-1.8e3 "Constant specific enthalpy of source" annotation (Dialog(group="Constant Boundaries", enable=not variable_h));
  parameter SI.MassFraction xi_const[medium.nc - 1]=medium.xi_default "Constant mass composition" annotation (Dialog(group="Constant Boundaries", enable=not variable_xi));
  parameter SI.Pressure Delta_p= 0 "Flange pressure drop at nominal mass flow (zero refers to ideal boundary)"
                                                                                                    annotation(Dialog(group="Nominal Values"));
  parameter SI.MassFlowRate m_flow_nom=0 "Nominal flange mass flow (zero refers to ideal boundary)" annotation (Dialog(group="Nominal Values"));

  // _____________________________________________
  //
  //          Variables
  // _____________________________________________

  SI.Mass m(start=0, stateSelect=StateSelect.never)
                                                   annotation (Dialog(group="Initialization", showStartAttribute=true));

protected
  SI.AbsolutePressure p_in;
  SI.SpecificEnthalpy h_in;
  SI.MassFraction xi_in[medium.nc - 1];
  /*model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    TransiEnt.Basics.Records.FlangeRealGas port;
  end Summary;*/

  // _____________________________________________
  //
  //           Interfaces
  // _____________________________________________

public
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPort(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  TransiEnt.Basics.Interfaces.General.PressureIn p(value=p_in) if (variable_p) "Variable absolute pressure"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  TransiEnt.Basics.Interfaces.General.SpecificEnthalpyIn h(value=h_in) if (variable_h) "Variable specific enthalpy"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  TransiEnt.Basics.Interfaces.General.MassFractionIn xi[medium.nc-1](value=xi_in) if
       (variable_xi) "Variable mass composition"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  // _____________________________________________
  //
  //           Instances of other classes
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

/*protected 
  TILMedia.VLEFluid_ph gas_ph(
    vleFluidType=medium,
    p=gasPort.p,
    h=actualStream(gasPort.h_outflow),
    xi=xi_in,
    deactivateTwoPhaseRegion=true) annotation (Placement(transformation(extent={{20,-12},{40,8}})));
public 
  inner Summary summary(port(
      mediumModel=medium,
      xi=gas_ph.xi,
      x=gas_ph.x,
      m_flow=gasPort.m_flow,
      T=gas_ph.T,
      p=gasPort.p,
      h=gas_ph.h,
      rho=gas_ph.d)) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));*/

initial equation

  if verbose and variable_xi then
    TransiEnt.Basics.Functions.GasProperties.verboseXi(medium.vleFluidNames, xi_in);
  end if;

equation
  // _____________________________________________
  //
  //          Characteristic equations
  // _____________________________________________

  if (not variable_p) then
    p_in=p_const;
  end if;
  if (not variable_h) then
    h_in=h_const;
  end if;
  if (not variable_xi) then
    xi_in=xi_const;
  end if;

  //change of mass in boundary
  if calculateMass then
    der(m) = gasPort.m_flow;
  else
    m=0;
  end if;

  //give values to gasPort
  gasPort.h_outflow=h_in;
  if Delta_p>0 then
    gasPort.p=p_in + Delta_p/m_flow_nom*gasPort.m_flow;
  else
    gasPort.p=p_in;
  end if;
  gasPort.xi_outflow=xi_in;

 annotation (defaultComponentName="boundary_phxi",Icon(graphics={
        Text(
          extent={{-78,32},{82,-28}},
          lineColor={27,36,42},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="h, xi")}),
                             Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                     graphics),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Boundary for real gases with pressure, specific enthalpy and mass fraction input. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Gas</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">IdealGasEnthPortIn</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: pressure in Pa</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: mass fraction in kg/kg</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: specific enthalpy in kJ/kg</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Created by Lisa Andresen (andresen@tuhh.de), Aug 2015</span></p>
</html>"));
end BoundaryRealGas_phxi;
