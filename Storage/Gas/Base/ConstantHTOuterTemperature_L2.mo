within TransiEnt.Storage.Gas.Base;
model ConstantHTOuterTemperature_L2 "Heat transfer model for a constant heat transfer"



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





// modified model from the ClaRa library version 1.0.0                       //
// path: ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 //
// simplified it for L2                                                      //
// added input for temperature                                               //
// commented out ClaRa specific code                                         //
// revision: exchanged base class and deleted temperature input port         //

  extends HeatTransferOuterTemperature_L2;

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer alpha_nom=10 "Constant heat transfer coefficient" annotation (Dialog(group="Heat Transfer"));
  ClaRa.Basics.Units.Temperature Delta_T_mean;

equation
  Delta_T_mean = heat.T-T_outer;
  heat.Q_flow = alpha_nom*A_heat*Delta_T_mean;
  annotation(Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a heat transfer model with constant heat transfer coefficient. It is a modified version from ClaRa 1.0.0 model ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3. It was simplified for L2 and a temperature input was added.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>heat: heat port</p>
<p>T_outer: input for the outer temperature</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b> </p>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Apr 05 2016</p>
<p>Model modified by Carsten Bode (c.bode@tuhh.de) in May 2019 (exchanged base class and deleted temperature input port<span style=\"font-family: Courier New;\">)</span></p>
</html>"),
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end ConstantHTOuterTemperature_L2;
