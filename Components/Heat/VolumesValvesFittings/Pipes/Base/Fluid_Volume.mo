within TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base;
model Fluid_Volume "A very simple control volume for liquid"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  //
  //Options to choose from:
  // steady state or dynamic mass balance
  //
  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends ClaRa.Basics.Icons.Volume;

  import Modelica.Constants.eps;
  import ClaRa;
  import      Modelica.Units.SI;

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  inner parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium=simCenter.fluid1 "Medium in the component"
                                     annotation(Dialog(group="Fundamental Definitions"), choicesAllMatching);
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation"
                                                                    annotation(Dialog(tab="Initialisation"));

  parameter SI.Pressure p_nom=1e5 "Nominal pressure"                    annotation(Dialog(group="Nominal Values"));
  parameter SI.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy" annotation(Dialog(group="Nominal Values"));

  parameter Boolean Use_steady_state_mass_balance= true "Steady state mass balance"
    annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.SpecificEnthalpy h_start= 1e5 "Start value of sytsem specific enthalpy"
                                                    annotation(Dialog(tab="Initialisation"));
  parameter SI.Pressure p_start= 1e5 "Start value of sytsem pressure"
                                          annotation(Dialog(tab="Initialisation"));
  final parameter SI.Volume V_start(min=0.00001) = V_const "Start Volume";

  parameter Integer nPorts = 2 "Number of fluid ports";

protected
  parameter SI.Density d_nom= TILMedia.VLEFluidFunctions.density_phxi(medium, p_nom, h_nom) "Nominal density";
  parameter SI.Density d_start= TILMedia.VLEFluidFunctions.density_phxi(medium, p_start, h_start) "Start density";

  // _____________________________________________
  //
  //                   Internal variables
  // _____________________________________________

 SI.SpecificEnthalpy h_ports[nPorts] "Specific enthalpy vector inflowing";

public
  SI.Volume V(start= V_start) "Volume";
  SI.Mass m(min = 0.000001,start=V_start*d_start) "Total system mass";
  SI.SpecificEnthalpy h(start=h_start, stateSelect=StateSelect.prefer);
  SI.Pressure             p(start=p_start, stateSelect=StateSelect.prefer) "System pressure";
  SI.Temperature  T "System temperature";
  SI.Temperature T_ports[nPorts] "Inlet Temperature";
  SI.Density d = bulk.d;
  Real drhodt;//(unit="kg/(m3s)");
  SI.HeatFlowRate Q_flow "Heat Flow Rate";
  SI.EnthalpyFlowRate H_flow[nPorts] "Enthalpy flow rate passing from inlet to volume";

  parameter SI.Volume V_const = 2 "Volume";
  final parameter SI.Mass m_const(min = 0.000001) = V_start*d_start "Total system mass";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
public
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn[nPorts] waterPort_in(each Medium=medium) "Fluid port" annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (Placement(transformation(extent={{-10,86},{10,106}})));

  // _____________________________________________
  //
  //                  Models
  // _____________________________________________
//Media
public
  TILMedia.VLEFluid_ph[nPorts] fluidPorts(
    each vleFluidType=medium,
    each computeTransportProperties=false,
    each computeVLEAdditionalProperties=false,
    each computeVLETransportProperties=false,
    each deactivateTwoPhaseRegion=true,
    final h=h_ports,
    final p=waterPort_in.p) annotation (Placement(transformation(extent={{-10,-82},{10,-62}}, rotation=0)));

protected
  inner TILMedia.VLEFluid_ph  bulk(vleFluidType =    medium, p=p, h=h,
    computeVLEAdditionalProperties=false,
    computeVLETransportProperties=false,
    deactivateTwoPhaseRegion=true,
    computeTransportProperties=false)
    annotation (Placement(transformation(extent={{-10,-8},{10,12}},
                     rotation=0)));

  // _____________________________________________
  //
  //              Equations
  // _____________________________________________

equation
  assert(nPorts>0, "It is not allowed to have less than 1 fluid port");
// System definition ~~~~~~~~
   //m= if useHomotopy then V*homotopy(bulk.d,d_nom) else V*bulk.d
   // "Mass in volume";
    // m= V*d_nom "Mass in volume";               // Nur bei Annahme der konstanten Dichte

    if Use_steady_state_mass_balance then
     m= m_const;
     V = m/d;
    sum(waterPort_in.m_flow) = 0 "Mass Balance";
                                          // Nur bei Annahme der konstanten Dichte
   drhodt = 0;
    else
    V= V_const;
      m= if useHomotopy then V*homotopy(bulk.d,d_nom) else V*bulk.d;
   drhodt*V=sum(waterPort_in.m_flow)
                               "Mass balance";
   drhodt=der(p)*bulk.drhodp_hxi
                             + der(h)*bulk.drhodh_pxi;
    end if;                                                //calculating drhodt from state variable

   for i in 1:nPorts loop
   H_flow[i] =waterPort_in[i].m_flow*h_ports[i];
   end for;

 der(h) = (sum(H_flow) + Q_flow)/m "Energy balance";

 for i in 1:nPorts loop
   h_ports[i]=if useHomotopy then homotopy(actualStream(waterPort_in[i].h_outflow), inStream(waterPort_in[i].h_outflow)) else actualStream(waterPort_in[i].h_outflow);
  end for;

  //  fluidIn.h und inlet.h_outflow haben verschieden Werte-
  //  dieses ist dem Modell L2 aus der ClaRa nachempfunden und fhrt dazu, dass
  //  auch mehrere Volumen hintereinander funktionieren

  for i in 1:nPorts loop
    waterPort_in[i].h_outflow = h;
  end for;

// Pressure in System and at ports
  for i in 1:nPorts loop
    waterPort_in[i].p = p;
  end for;

//Temperatures in systems and at ports
   T = bulk.T "Temperature in Volume";

  for i in 1:nPorts loop
   T_ports[i] = fluidPorts[i].T "Temperature at Inlet";
   end for;

   heatPort.T = bulk.T;

// Heat Flow from HeatPort
   Q_flow = heatPort.Q_flow "Heat Flow Rate";

// _____________________________________________
//
//              Documentation
// _____________________________________________

    annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
          Text(
          extent={{-100,-100},{102,-134}},
          lineColor={27,36,42},
          textString="%name")}),
                              Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}}),
                                      graphics),
                        Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple control volume for vle fluids. The volume has a heat port and variable number of fluid ports. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L2: Model ist based on law of conservation of mass or volume. Fluid in the volume is assumed to be idaelly stirred, so the fluid in the volume has one temperature and one pressure. Kinetic energy and potential energy are neglected. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Model is only valid for single phase fluids and nor pressure losses are included. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>heatPort: model gives temperature and may get heat flow</p><p>ports[nPorts]: a variable number of fluid ports </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>nPorts: number of fluid connections to the volume </p><p>V_const: Volume of Fluid </p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The governing equations are law of conservation of mass or volume and the conservation of energy. The balance of mass is described in tne formula below. You can choose to use a steady state mass balance. In this case the sum of entering and leaving mass flow is to be zero.</p>
<p><br>The conservation of energy is shown in the following formula. The kinetic and potential energy are neglected. The amount of energy in the volume can be changed due to heat transfer or mass transfer (konvektive energy). There is no possibilty to add direct electrical or mechanical energy.</p>
<p>Image at src=&QUOT;Sketchbook/tr/Thermal/Images/equations/energy_balance.png&QUOT; missing </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The simulation should be performed with steady mass balance. The inflowing an outflowing mass has always the same amount. On the other hand the simulation could also be performed with assuming constant fluid volume. The mass increases or decreases due to temperature </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Ramm (tobias.ramm@tuhh.de) on Fri Mar 20 2015</p>
<p>Revised and edited by Lisa Andresen (andresen@tuhh.de), Jun 2015</p>
</html>"));
end Fluid_Volume;
