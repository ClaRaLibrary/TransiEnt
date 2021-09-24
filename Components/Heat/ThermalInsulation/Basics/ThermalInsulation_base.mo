within TransiEnt.Components.Heat.ThermalInsulation.Basics;
partial model ThermalInsulation_base "Partial Model for thermal Insulation"

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


 import SI = ClaRa.Basics.Units;



model Summary
  extends ClaRa.Basics.Icons.RecordIcon;
  input ClaRa.Basics.Units.HeatFlowRate Q_flow_loss;
end Summary;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________


  parameter Integer N_cv = 10 "Number of axial control volumes  " annotation(Dialog(group="Fundamental Definitions"));

  parameter Integer N_iso = 3 "Number of lateral insulation discretisation for each layer" annotation (Dialog(group="Geometry"));

  parameter SI.Length length = 1 "Length of Insulation" annotation(Dialog(group="Geometry"));

  parameter SI.Length circumference = 1 "Circumference of Insulation" annotation(Dialog(group="Geometry"));


  //___________________________________________
  //
  //                 Outer Models
  // _____________________________________________


     outer ClaRa.SimCenter simCenter;



  //_____________________________________
  //
  //                  Interfaces
  // _____________________________________________


     ClaRa.Basics.Interfaces.HeatPort_a[N_cv] heat annotation (Placement(transformation(extent={{90,-10},{110,10}}),iconTransformation(extent={{90,-10},{110,10}})));




equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},
            {100,80}}),                                         graphics={Text(
          extent={{-100,100},{100,76}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.None,
          textString="%name")}),            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-80},{100,80}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base Class for models for the isolation of packed bed high temperature thermal energy storage</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>heat conduction in storage length direction considered</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<ul>
<li>Constant thickness (using d(1,1))</li>
<li>Constant Temperature at start</li>
<li>Instationary heat conduction in radial direction</li>
</ul>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>heat</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b> </p>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the Research Project &quot;Future Energy Solution&quot; (FES), 2020</p>
</html>"));
end ThermalInsulation_base;
