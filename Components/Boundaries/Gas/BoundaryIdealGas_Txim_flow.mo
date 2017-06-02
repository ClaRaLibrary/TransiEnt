within TransiEnt.Components.Boundaries.Gas;
model BoundaryIdealGas_Txim_flow "Gas boundary for ideal gases with T, m_flow and xi as inputs"

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

  extends TransiEnt.Basics.Icons.GasSource;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter TILMedia.GasTypes.BaseGas gasModel "Medium in the component"  annotation (choices(choice=simCenter.gasModel2 "gasModel 2 (simCenter_TransiEnt)",
                                                  choice=simCenter.flueGasModel "flueGasModel (simCenter_TransiEnt)"),
                                                     Dialog(group="Fundamental Definitions"));

  parameter Boolean variable_m_flow=false "True, if mass flow defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_T=false "True, if temperature defined by variable input" annotation(Dialog(group="Define Variable Boundaries"));
  parameter Boolean variable_xi=false "True, if composition defined by variable input"    annotation(Dialog(group="Define Variable Boundaries"));

  parameter Boolean verbose = false "show initial gas compostion in log" annotation(Dialog(group="Define Variable Boundaries"));

  parameter SI.MassFlowRate m_flow_const=0 "Constant mass flow rate (negative sign for source)" annotation (Dialog(group="Constant Boundaries", enable=not variable_m_flow));
  parameter SI.Temperature T_const=simCenter.T_ground "Constant temperature of source" annotation (Dialog(group="Constant Boundaries", enable=not variable_T));
  parameter SI.MassFraction xi_const[gasModel.nc - 1]=gasModel.xi_default "Constant composition" annotation (Dialog(group="Constant Boundaries", enable=not variable_xi));
  parameter SI.Pressure p_nom=1e5 "Nominal flange pressure" annotation (Dialog(group="Nominal Values"));
  parameter SI.MassFlowRate m_flow_nom=0 "Nominal flange mass flow (zero refers to ideal boundary)" annotation (Dialog(group="Nominal Values"));

  // _____________________________________________
  //
  //          Variables
  // _____________________________________________

  SI.Mass m(start=0, stateSelect=StateSelect.never);

protected
  SI.MassFlowRate m_flow_in;
  SI.Temperature T_in;
  SI.MassFraction xi_in[gasModel.nc - 1];

  // _____________________________________________
  //
  //           Interfaces
  // _____________________________________________

public
  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortOut gasPort(Medium=gasModel) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput m_flow(value=m_flow_in) if (variable_m_flow) "Variable mass flow rate" annotation (Placement(transformation(extent={{-120,40},{-80,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput T(value=T_in) if (variable_T) "Variable temperature" annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput xi[gasModel.nc - 1](value=xi_in) if (variable_xi) "Variable composition" annotation (Placement(transformation(extent={{-120,-80},{-80,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  // _____________________________________________
  //
  //          Complex components
  // _____________________________________________

protected
  TILMedia.Gas_pT gas_pT(
    p=gasPort.p,
    T=T_in,
    xi=xi_in,
    gasType=gasModel) annotation (Placement(transformation(extent={{20,-12},{40,8}})));

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

initial equation

  if verbose and variable_xi then
    TransiEnt.Basics.Functions.GasProperties.verboseXi(gasModel.gasNames, xi_in);
  end if;

equation

  // _____________________________________________
  //
  //          Characteristic equations
  // _____________________________________________

  if (not variable_m_flow) then
    m_flow_in=m_flow_const;
  end if;
  if (not variable_T) then
    T_in=T_const;
  end if;
  if (not variable_xi) then
    xi_in=xi_const;
  end if;

  //change of mass in boundary
  der(m) = gasPort.m_flow;

  //give values to gasPort
  gasPort.h_outflow=gas_pT.h;
  if m_flow_nom>0 then
    gasPort.m_flow=m_flow_in - (m_flow_nom/p_nom) * (p_nom - gasPort.p);
  else
    gasPort.m_flow=m_flow_in;
  end if;
  gasPort.xi_outflow=xi_in;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
            Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Boundary for ideal gases with mass flow, temperature and mass fraction input. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Gas</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Created by Lisa Andresen (andresen@tuhh.de), Aug 2015</span></p>
</html>"));
end BoundaryIdealGas_Txim_flow;