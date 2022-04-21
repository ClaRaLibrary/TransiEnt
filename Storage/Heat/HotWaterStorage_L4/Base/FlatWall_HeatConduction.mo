within TransiEnt.Storage.Heat.HotWaterStorage_L4.Base;
model FlatWall_HeatConduction "Flat wall heat conduction ( one material for insulation)"


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




  extends Partial_HeatTransfer(
    final lambda = A_heat*k/width);

//  import SI = Modelica.SIunits;

  parameter Modelica.Units.SI.Area A_heat=1 "Area of Heat Transfer";
  parameter Modelica.Units.SI.Length width=0.1 "Thickness insulation";
  parameter Modelica.Units.SI.ThermalConductivity k=0.04 "Specific heat conductivity of insulation";

algorithm
    assert(A_heat > 0,
      "Area of heat transfer hast to be positive. Adjust!");
    assert(width > 0,
      "Thickness of insulation hast to be positive. Adjust!");
    assert(k> 0,
      "Specific heat conductivity of insulation hast to be positive. Adjust!");

annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Providing the thermal conductance for the model ThermalConductor from the Modelica Standard Library (MSL). Inside this model it is named lambda. The thermal conductance has to be constant during simulation. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Providing parameter thermal conduction for one dimensional heat conductivity with constant thermal conduction.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Just thermal conduction with constant heat conductivity considered. This model is just for the the flat wall geometrie and considers just one insulation layer.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b> </p>
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
</html>"),
 Icon(graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={191,0,0}),
        Line(
          points={{-64,100},{-64,-20},{-40,-60},{4,-84},{54,-100},{64,-100}},
          color={191,0,0},
          smooth=Smooth.Bezier,
          origin={0,0},
          rotation=90),
        Text(
          extent={{-100,20},{100,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid,
          textString="ht")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end FlatWall_HeatConduction;
