within TransiEnt.Producer.Heat.SolarThermal.Base;
model HeatFlow_SolarThermal "Heat flow boundary with h_in and Q_flow_collector as input to be used in SolarCollector"



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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
   extends TransiEnt.Basics.Icons.HeatSink;

  import Const = Modelica.Constants;
  outer TransiEnt.SimCenter simCenter;

  input SI.HeatFlowRate Q_flow_collector "Heat flow provided by solar collector";
  input Modelica.Units.SI.SpecificEnthalpy h_in "Enthalpy of the medium flowing into the collector";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  //Pressure loss
  parameter Integer n_serial(max=12)=1 "Number of collectors in series (max. 12)" annotation (Dialog(group="Pressure drop"));
  parameter Real a(unit="1/(s.m)")=0 "Linear pressure drop coefficient" annotation (Dialog(group="Pressure drop"));
  parameter Real b(unit="1/(kg.m)")=0 "Quadratic pressure drop coefficient" annotation (Dialog(group="Pressure drop"));
  parameter SI.Height z1=0 "Height inlet" annotation (Dialog(group="Pressure drop"));
  parameter SI.Height z2=0 "Height outlet"  annotation (Dialog(group="Pressure drop"));

  parameter SI.Density d=985.269 "Density of medium";

  parameter Boolean useHomotopy=simCenter.useHomotopy "true =  homotopy method is used during initialisation" annotation (Dialog(tab="General", group="General"));
  parameter Boolean noFriction=true "true = assume no pressure loss due to friction" annotation(Dialog(group="Pressure drop"));

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 annotation (Dialog(tab="General", group="General"));
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
public
  Basics.Interfaces.Thermal.FluidPortOut  waterPortOut(Medium=medium)  annotation (Placement(transformation(extent={{76,-8},{96,12}})));
  Basics.Interfaces.Thermal.FluidPortIn   waterPortIn(Medium=medium)  annotation (Placement(transformation(extent={{-94,-8},{-74,12}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_out  annotation (Placement(transformation(
         extent={{-10,-10},{10,10}},
         rotation=0,
         origin={108,-40}),
                          iconTransformation(
         extent={{-10,-10},{10,10}},
         rotation=0,
         origin={102,54})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  Q_flow_out = waterPortOut.m_flow*(actualStream(waterPortOut.h_outflow)-actualStream(waterPortIn.h_outflow));

  waterPortIn.m_flow + waterPortOut.m_flow = 0;

  waterPortIn.h_outflow = inStream(waterPortIn.h_outflow);
  waterPortOut.h_outflow=Q_flow_collector/waterPortIn.m_flow+inStream(waterPortIn.h_outflow);

  waterPortIn.xi_outflow = inStream(waterPortOut.xi_outflow);
  waterPortOut.xi_outflow = inStream(waterPortIn.xi_outflow);

  waterPortOut.p = if noFriction then waterPortIn.p + Const.g_n*d*(z1 - z2) else waterPortIn.p + Const.g_n*d*(z1 - z2) - (a*waterPortIn.m_flow + b*waterPortIn.m_flow^2)*10^3*n_serial;

  h_in=if useHomotopy then homotopy(actualStream(waterPortIn.h_outflow), inStream(waterPortIn.h_outflow)) else actualStream(waterPortIn.h_outflow);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Boundary model that transmits the generated solar thermal energy to the heat carrier fluid.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>None.</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(none)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Model created by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), Sept 2020 (removed formulas from SolarCollector_L1_constProp and moved them into this submodel to allow for fluidports to be removed)</p>
</html>"));
end HeatFlow_SolarThermal;
