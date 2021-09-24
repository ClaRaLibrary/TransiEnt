within TransiEnt.Components.Sensors.IdealGas;
model GasMassflowSensor "Ideal gas mass flow sensor"


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

  extends TransiEnt.Components.Sensors.IdealGas.Base.GasSensorBase;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Integer xiNumber=1 "xi vector entry for auxiliary mass flow";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow "mass flow in port" annotation (Placement(transformation(extent={{100,-10},{120,10}},
                                                                    rotation=
            0), iconTransformation(extent={{100,-10},{120,10}})));

  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_aux "mass flow in port" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,0}),  iconTransformation(extent={{-100,-10},{-120,10}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  m_flow = inlet.m_flow;

  assert(xiNumber<=medium.nc, "xiNumber is outside of range");

  if xiNumber==medium.nc then
    m_flow_aux= m_flow * (1-sum(actualStream(inlet.xi_outflow)));
  else
    m_flow_aux= m_flow * actualStream(inlet.xi_outflow[xiNumber]);
  end if;

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Text(
          extent={{-98,76},{102,106}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if m_flow > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" m_flow ", realString(m_flow, 1,3)+" kg/s")),
        Text(
          extent={{-100,42},{100,72}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({230, 230, 230},  if m_flow_aux > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" m_flow_aux"+"["+ realString(xiNumber) +"] ", realString(m_flow_aux, 1,3)+" kg/s")),
        Polygon(
          points={{-20,40},{-20,40},{-62,40},{-86,0},{-62,-40},{-20,-40},{20,-40},{62,-40},{86,0},{62,40},{20,40},{-20,40}},
          lineColor={27,36,42},
          smooth=Smooth.Bezier,
          lineThickness=0.5),
        Line(
          points={{80,0},{100,0}},
          color={27,36,42},
          smooth=Smooth.None),
        Text(
          extent={{-98,22},{102,-18}},
          lineColor={27,36,42},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(
          points={{0,-40},{0,-100}},
          color={27,36,42},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-98,-100},{96,-100}},
          color={255,213,170},
          thickness=0.5)}),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Ideal gas mixture mass flow sensor.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>IdealGasEnthPortIn: ideal gas enthalpy inlet</p>
<p>IdealGasEnthPortOut: ideal gas enthalpy outlet</p>
<p>RealOut: m_flow</p>
<p>RealOut: m_flow_aux</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Sep 2016</p>
</html>"));
end GasMassflowSensor;
