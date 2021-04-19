within TransiEnt.Components.Boundaries.Gas;
model BoundaryIdealGas_pTxi "Gas boundary for ideal gases with p, T, xi as inputs"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.GasSource;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter TILMedia.GasTypes.BaseGas gasModel "Medium in the component" annotation (choices(choice=simCenter.gasModel2 "gasModel 2 (simCenter_TransiEnt)",
                                                  choice=simCenter.exhaustGasModel "exhaustGasModel (simCenter_TransiEnt)"),
                                                     Dialog(group="Fundamental Definitions"));
  parameter Boolean calculateMass=false "True if mass in boundary shall be calculated" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean calculateH_GCV=false "True if energy related to GCV shall be calculated" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean calculateH_NCV=false "True if energy related to NCV shall be calculated" annotation(Dialog(group="Fundamental Definitions"));

  parameter Boolean variable_p=false "True, if mass flow defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_T=false "True, if temperature defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_xi=false "True, if composition defined by variable input"    annotation(Dialog(group="Define Variable Boundaries"));

  parameter Boolean verbose = false "Show initial gas compostion in log" annotation(Dialog(group="Define Variable Boundaries"));

  parameter SI.AbsolutePressure p_const=simCenter.p_amb_const+simCenter.p_eff_2 "Constant absolute pressure" annotation (Dialog(group="Constant Boundaries", enable=not variable_p));
  parameter SI.Temperature T_const=simCenter.T_ground "Constant temperature of source" annotation (Dialog(group="Constant Boundaries", enable=not variable_T));
  parameter SI.MassFraction xi_const[gasModel.nc - 1]=gasModel.xi_default "Constant composition" annotation (Dialog(group="Constant Boundaries", enable=not variable_xi));
  parameter SI.Pressure Delta_p= 0 "Flange pressure drop at nominal mass flow (zero refers to ideal boundary)"
                                                                                                    annotation(Dialog(group="Nominal Values"));
  parameter SI.MassFlowRate m_flow_nom=0 "Nominal flange mass flow (zero refers to ideal boundary)" annotation (Dialog(group="Nominal Values"));

  // _____________________________________________
  //
  //          Variables
  // _____________________________________________

  Modelica.SIunits.Mass m(start=0, stateSelect=StateSelect.never)
                                                                 annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.AbsolutePressure p_in;
  SI.Temperature T_in;
  SI.MassFraction xi_in[gasModel.nc - 1];

  // _____________________________________________
  //
  //           Interfaces
  // _____________________________________________

public
  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortIn gasPort(Medium=gasModel) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  TransiEnt.Basics.Interfaces.General.PressureIn p(value=p_in) if (variable_p) "Variable absolute pressure"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn T(value=T_in) if (variable_T) "Variable temperature"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  TransiEnt.Basics.Interfaces.General.MassFractionIn xi[gasModel.nc - 1](value=xi_in) if
       (variable_xi) "Variable mass composition"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  // _____________________________________________
  //
  //          Complex components
  // _____________________________________________
  Modelica.Blocks.Sources.RealExpression xi_actual[gasModel.nc - 1](y=noEvent(actualStream(gasPort.xi_outflow))) if calculateH_GCV     annotation (Placement(transformation(extent={{-60,76},{-40,96}})));
  Modelica.Blocks.Math.Product product if calculateH_GCV     annotation (Placement(transformation(extent={{18,58},{38,78}})));
  Modelica.Blocks.Continuous.Integrator integrator if calculateH_GCV     annotation (Placement(transformation(extent={{54,58},{74,78}})));
  Modelica.Blocks.Interfaces.RealOutput H_GCV annotation (Placement(transformation(extent={{80,50},{100,70}}), iconTransformation(extent={{80,50},{100,70}})));
  Modelica.Blocks.Sources.Constant zero(k=0, y(unit="J")) if not calculateH_GCV     annotation (Placement(transformation(extent={{18,30},{38,50}})));
  Modelica.Blocks.Sources.RealExpression MassFlow(y=gasPort.m_flow) if calculateH_GCV           annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.RealExpression xi_actual2[gasModel.nc - 1](y=noEvent(actualStream(gasPort.xi_outflow))) if calculateH_NCV     annotation (Placement(transformation(extent={{-60,-44},{-40,-24}})));
  Modelica.Blocks.Math.Product product1 if calculateH_NCV    annotation (Placement(transformation(extent={{18,-64},{38,-44}})));
  Modelica.Blocks.Continuous.Integrator integrator1 if calculateH_NCV    annotation (Placement(transformation(extent={{48,-64},{68,-44}})));
  Modelica.Blocks.Interfaces.RealOutput H_NCV annotation (Placement(transformation(extent={{80,-70},{100,-50}}), iconTransformation(extent={{80,-70},{100,-50}})));
  Modelica.Blocks.Sources.Constant zero1(k=0, y(unit="J")) if not calculateH_NCV    annotation (Placement(transformation(extent={{18,-90},{38,-70}})));
  Modelica.Blocks.Sources.RealExpression Massflow2(y=gasPort.m_flow) if calculateH_NCV          annotation (Placement(transformation(extent={{-60,-84},{-40,-64}})));
protected
  TILMedia.Gas_pT gas_pT(
    p=p_in,
    xi=xi_in,
    gasType=gasModel,
    T=T_in)           annotation (Placement(transformation(extent={{20,-12},{40,8}})));

/*model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    TransiEnt.Basics.Records.FlangeIdealGas gasPort;
  end Summary;*/
/*public 
  inner Summary summary(gasPort(mediumModel=gasModel,
          xi = Gas_pT.xi,
          x = Gas_pT.x,
          m_flow = gas.m_flow,
          T = Gas_pT.T,
          p = gas.p,
          h = Gas_pT.h,
          rho = Gas_pT.d))   annotation (Placement(transformation(extent={{-100,-114},{-80,-94}})));*/

  Basics.Media.IdealGasGCV_xi_Block idealGasGCV_xi(idealGasType=gasModel) if calculateH_GCV annotation (Placement(transformation(extent={{-30,76},{-10,96}})));
  Basics.Media.IdealGasNCV_xi_Block idealGasNCV_xi(idealGasType=gasModel) if calculateH_NCV annotation (Placement(transformation(extent={{-28,-44},{-8,-24}})));
initial equation

  if verbose and variable_xi then
    TransiEnt.Basics.Functions.GasProperties.verboseXi(gasModel.gasNames, xi_in);
  end if;

equation
  // _____________________________________________
  //
  //          Characteristic equations
  // _____________________________________________

  if (not variable_p) then
    p_in=p_const;
  end if;
  if (not variable_T) then
    T_in=T_const;
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
  gasPort.h_outflow=gas_pT.h;
  if Delta_p>0 then
    gasPort.p=p_in + Delta_p/m_flow_nom*gasPort.m_flow;
  else
    gasPort.p=p_in;
  end if;
  gasPort.xi_outflow=xi_in;

  connect(idealGasGCV_xi.xi_in,xi_actual. y) annotation (Line(points={{-30,86},{-39,86}}, color={0,0,127}));
  connect(product.u1,idealGasGCV_xi. GCV) annotation (Line(points={{16,74},{2,74},{2,86},{-9,86}}, color={0,0,127}));
  connect(product.y,integrator. u) annotation (Line(points={{39,68},{52,68}}, color={0,0,127}));
  connect(zero.y, H_GCV) annotation (Line(points={{39,40},{80,40},{80,60},{90,60}}, color={0,0,127}));
  connect(product.u2,MassFlow. y) annotation (Line(points={{16,62},{2,62},{2,50},{-39,50}}, color={0,0,127}));
  connect(idealGasNCV_xi.xi_in,xi_actual2. y) annotation (Line(points={{-28,-34},{-34,-34},{-34,-34},{-39,-34}},
                                                                                            color={0,0,127}));
  connect(idealGasNCV_xi.NCV,product1. u1) annotation (Line(points={{-7,-34},{4,-34},{4,-48},{16,-48}}, color={0,0,127}));
  connect(product1.y,integrator1. u) annotation (Line(points={{39,-54},{46,-54}}, color={0,0,127}));
  connect(integrator1.y, H_NCV) annotation (Line(points={{69,-54},{84,-54},{84,-60},{90,-60}},
                                                                             color={0,0,127}));
  connect(zero1.y, H_NCV) annotation (Line(points={{39,-80},{80,-80},{80,-60},{90,-60}}, color={0,0,127}));
    connect(product1.u2,Massflow2. y) annotation (Line(points={{16,-60},{4,-60},{4,-74},{-39,-74}}, color={0,0,127}));
  connect(integrator.y, H_GCV) annotation (Line(points={{75,68},{86,68},{86,60},{90,60}},
                                                                          color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Boundary for real gases with pressure, temperature and mass fraction input. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Gas</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">IdealGasEnthPortIn</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: pressure in Pa</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: mass fraction in kg/kg</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: temperature in K</span></p>
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
end BoundaryIdealGas_pTxi;
