within TransiEnt.Components.Sensors.RealGas;
model GCVSensor "Sensor calculating the gross calorific value of real gas mixtures at 25 C"


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

  extends TransiEnt.Components.Sensors.RealGas.Base.RealGas_SensorBase;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter SI.MassFraction xi_start[medium.nc-1]= medium.xi_default "Initial composition" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer flowDefinition=1 "Defines which flow direction is considered" annotation(Dialog(group="Fundamental Definitions"),choices(choice = 1 "both", choice = 2 "both, noEvent", choice = 3 "in -> out", choice = 4 "out -> in"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Basics.Interfaces.General.SpecificEnthalpyOut GCV(displayUnit="kWh/kg") "Gross calorific value for given composition" annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Basics.Interfaces.General.SpecificEnthalpyOut GCV_InToOut(displayUnit="kWh/kg") "Gross calorific value for given composition (in to out)" annotation (Placement(transformation(extent={{100,30},{120,50}}), iconTransformation(extent={{100,30},{120,50}})));
  Basics.Interfaces.General.SpecificEnthalpyOut GCV_OutToIn(displayUnit="kWh/kg") "Gross calorific value for given composition (out to in)" annotation (Placement(transformation(extent={{100,-50},{120,-30}}), iconTransformation(extent={{100,-50},{120,-30}})));
  Basics.Interfaces.General.EnthalpyFlowRateOut H_flow_GCV(displayUnit="W") "Enthalphy flow rate based on GCV" annotation (Placement(transformation(extent={{-100,-10},{-120,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  Basics.Media.RealGasGCV_xi realGasGCV_InToOut(realGasType=medium, xi_in=inStream(gasPortIn.xi_outflow))  annotation (Placement(transformation(extent={{-12,30},{8,50}})));
  Basics.Media.RealGasGCV_xi realGasGCV_OutToIn(realGasType=medium, xi_in=gasPortIn.xi_outflow)  annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.MassFraction[medium.nc-1] xi(start=xi_start) "Mass fraction vector";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  xi = if flowDefinition==1 then actualStream(gasPortIn.xi_outflow) elseif flowDefinition==2 then noEvent(actualStream(gasPortIn.xi_outflow)) elseif flowDefinition==3 then inStream(gasPortIn.xi_outflow) else inStream(gasPortOut.xi_outflow);
  GCV_InToOut = realGasGCV_InToOut.GCV;
  GCV_OutToIn = realGasGCV_OutToIn.GCV;
  GCV = if flowDefinition==1 then (if gasPortIn.m_flow > 0 then GCV_InToOut else GCV_OutToIn)
        elseif flowDefinition==2 then (if noEvent(gasPortIn.m_flow > 0) then GCV_InToOut else GCV_OutToIn)
        elseif flowDefinition==3 then realGasGCV_InToOut.GCV
        else realGasGCV_OutToIn.GCV;
  H_flow_GCV=gasPortIn.m_flow*GCV;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                   graphics={
       Polygon(
         points={{-20,40},{-20,40},{-62,40},{-86,0},{-62,-40},{-20,-40},{20,-40},{62,-40},{86,0},{62,40},{20,40},{-20,40}},
         lineColor={27,36,42},
         smooth=Smooth.Bezier,
         lineThickness=0.5),
       Line(
         points={{0,-40},{0,-100}},
         color={27,36,42},
         thickness=0.5,
         smooth=Smooth.None),
       Text(
         extent={{-100,24},{100,-16}},
         fillColor={0,255,0},
         fillPattern=FillPattern.Solid,
         textString="%name"),
       Line(
         points={{-96,-100},{98,-100}},
         color={255,255,0},
         thickness=0.5),
        Text(
          extent={{-100,60},{100,90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if GCV > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" GCV ", realString(GCV/3.6e6, 1,1)+" kWh/kg")),
       Line(
         points={{0,30},{-3.06156e-015,10}},
         color={27,36,42},
          origin={110,0},
          rotation=90)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Gross calorific value sensor and enthalpy flow rate sensor for VLEFluidTypes.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Can only be used for VLEFluidTypes.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>GasPortIn, GasPortOut and RealOutpus for GCV.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>GCV in [J/kg]</p>
<p>EnthalpyFlowRateOut in [W]</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>GCV = sum(xi_i*GCV_i)</p>
<p>EnthalpyFlowRateOut=gasPortIn.m_flow*NCV</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>Gross calorific values of the pure components are defined in the record TransiEnt.Basics.Records.GasProperties.GrossCalorificValues.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Tested in check model &quot;TransiEnt.Components.Sensors.RealGas.Check.TestRealGasSensors&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Lisa Andresen (andresen@tuhh.de) in Jun 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Jul 2019: added enthalpy flow rate</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Carsten Bode (c.bode@tuhh.de), Nov 2020: added GCV in different flow directions</span></p>
</html>"));
end GCVSensor;
