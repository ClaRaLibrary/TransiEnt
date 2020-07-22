within TransiEnt.Storage.Heat.HotWaterStorage_L4.Base;
model FlowSplit "Splits single input flow according to a vector with size n to n weighted output streams"
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

// _____________________________________________________________________________
//
//          Imports and Class Hierarchy
// _____________________________________________________________________________
  import SI = Modelica.SIunits;
  inner TransiEnt.SimCenter simCenter;

//______________________________________________________________________________
//                         Parameter
//______________________________________________________________________________
   parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1;
   parameter Integer nOutPorts = 3 "Number of solar input segments";
   input Real layerTemperatures[nOutPorts] = {0.2, 0.6, 0.2} "Vector containing the temperature layers";
   parameter Real distributionExponent(min=0, max=4) = 2 "Exponent manages the fluid distribution to the layers";
   // the higher the exponent the more fluid flows in the bettest fitting temperature layer

//______________________________________________________________________________
//                         Variables
//______________________________________________________________________________
      final Real splitVector[nOutPorts]= Utilities.get_SolarInputFraction_Exp(
 nOutPorts,
 layerTemperatures,
 Fluid.T,
 distributionExponent) "Vector containing the temperature layers";

   SI.MassFlowRate m_flow_out;

//______________________________________________________________________________
//                   Componenents / submodels
//______________________________________________________________________________
  //Medium
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph Fluid(
    vleFluidType=medium,
    deactivateTwoPhaseRegion=true,
    computeVLEAdditionalProperties=false,
    computeVLETransportProperties=false,
    h=inStream(port_in.h_outflow),
    p=port_in.p,
    computeTransportProperties=false) annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

// _____________________________________________________________________________
//
//         Interfaces
// _____________________________________________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn port_in(Medium=medium) annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut[nOutPorts] ports_out(each Medium=medium) annotation (Placement(transformation(extent={{-8,92},{8,108}}), iconTransformation(extent={{-12,28},{8,108}})));

// _____________________________________________________________________________
//
//          Equations
// _____________________________________________________________________________

equation
  for i in 1:nOutPorts loop
    ports_out[i].h_outflow = inStream(port_in.h_outflow);
    ports_out[i].m_flow = m_flow_out*splitVector[i];
  end for;

port_in.h_outflow=sum(inStream(ports_out.h_outflow).*splitVector);
port_in.p = ports_out[1].p;
0 = port_in.m_flow + m_flow_out;

annotation (        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Text(
          extent={{-150,-30},{150,-70}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-148,80},{152,50}},
          lineColor={0,0,0},
          textString="m=%m"),
        Line(
          points={{0,90},{0,40}},
          color={181,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-60,40},{60,30}},
          lineColor={181,0,0},
          fillColor={181,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,30},{0,-30},{0,-90}},
          color={181,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,-30},{-20,30}},
          color={181,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,-30},{20,30}},
          color={181,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,-30},{60,30}},
          color={181,0,0},
          smooth=Smooth.None)}),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Splitting a single flow in a higher number of flows according to the flows temperature and a higher number of input temperatures. The number of input temperatures and the number of splitted parts of flow are the same. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects consideres.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>ports_in: a single entering fluid flow </p><p>ports_out[nOutPorts]: a higher number of outflowing fluid flows </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>nOutPorts: number of outflowing fluid flows</p><p>layerTemperatures[nOutPorts]: according to this temperatures the flow is distributed </p><p>distributionExponent: desribes the way the fluid is distributed on the flows. The lower the distributionExponent the more equal is amount of the flows. </p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Ramm (tobias.ramm@tuhh.de) on Fri Mar 20 2015</p>
<p>Revised and edited by Lisa Andresen (andresen@tuhh.de), Jun 2015</p>
</html>"));
end FlowSplit;
