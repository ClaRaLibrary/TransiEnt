within TransiEnt.Producer.Heat.Heat2Heat;
model Indirect_HEX_const_dT_L1 "Constant dT Heat Exchanger Model"


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

 import Modelica.Units.SI;
 import TIL = TILMedia.VLEFluidFunctions;
 outer TransiEnt.SimCenter simCenter;
 extends TransiEnt.Producer.Heat.Base.PartialHEX;
 // _____________________________________________
 //
 //                   Parameters
 // _____________________________________________

 parameter SI.Temperature T_start = 90 + 273.15 "Temperature at start of simulation";
 parameter Real dT_set = simCenter.dT "Setpoint temperature difference between supply and return pipe";
 parameter SI.MassFlowRate m_flow_min = 0.01 "Minimum mass flow rate to counteract possible zero massflow sitations";
 final parameter SI.SpecificHeatCapacityAtConstantPressure cp = TIL.specificIsobaricHeatCapacity_pTxi(simCenter.fluid1,simCenter.p_nom[2],T_start,{1,0,0});

 // _____________________________________________
 //
 //                   Variables
 // _____________________________________________

 SI.HeatFlowRate Q_withdrawal "Heat taken out of the district heating";

 SI.Temperature T_out "Outlet temperature of the ideal HEX";

 // _____________________________________________
 //
 //                   Interfaces
 // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput Q_demand
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-72,80})));
  Modelica.Blocks.Interfaces.RealOutput T_out_calc annotation (Placement(
        transformation(extent={{100,-60},{120,-40}}),iconTransformation(extent={{90,-20},{130,20}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow annotation (Placement(
        transformation(extent={{100,30},{140,70}}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,-104})));
  Modelica.Blocks.Interfaces.RealInput T_in annotation (Placement(
        transformation(extent={{-120,64},{-80,104}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={68,80})));

equation
  // Calculation of the necessary mass flow to achive the given constant temperature difference between supply and return.

    Q_withdrawal = Q_demand;
    m_flow = max(Q_withdrawal/(cp*dT_set),m_flow_min);
    T_out =  T_in - Q_withdrawal/(cp*m_flow);
    T_out_calc = T_out;

    annotation (Line(points={{120,50},{11,50},{11,50},{120,50}}, color={0,0,127}),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Simple heat exchanger model specifically modeled to be used in district heating networks.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Calculates the necessary mass flow for a constant dT between supply and return:</span></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-6awzfCmN.png\" alt=\"Q  = m * cp * dT_const \"/></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<p>Due to the simple nature of the model, it is important to have a realistic supply temperature to avoid the return temperature to fall below possible values. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Philipp Huismann (huismann@gwi-essen.de), Oct 2018</span></p>
</html>"));
end Indirect_HEX_const_dT_L1;
