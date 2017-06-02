within TransiEnt.Grid.Heat.HeatGridControl;
model MassFlowCharacteristicLines "Model for the specification of the heating water massflow at each feed-in point as a funcion of the total amount of heating water massflow"

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

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter TransiEnt.Grid.Heat.HeatGridControl.Base.DHGMassFlowCharacteristicLines.GenericMassFlowCharacteristicLines MassFlowCL=Base.DHGMassFlowCharacteristicLines.SampleMassFlowCharacteristicLines() annotation (choicesAllMatching);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // comment: place all instances of type "Type" without prefixes "parameter"
  // or "constant" here

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealOutput m_flow_i[size(combiTable1Ds.columns, 1)](final quantity="MassFlowRate", final unit="kg/s") annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_total(final quantity= "MassFlowRate", final unit="kg/s") annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table=MassFlowCL.CL_MassFlow_DHG) annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

  // _____________________________________________
  //
  //           Functions
  // _____________________________________________

equation
    // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(combiTable1Ds.y, m_flow_i) annotation (Line(points={{13,0},{110,0}}, color={0,0,127}));
  connect(m_flow_total, combiTable1Ds.u) annotation (Line(points={{-120,0},{-66,0},{-10,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{86,44},{26,36},{-24,-4},{-70,-46}},
          color={255,128,0},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-70,-58},{-6,-12},{36,14},{88,28}},
          color={0,0,127},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{-68,-68},{16,-60},{60,-40},{86,-4}},
          color={135,135,135},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Polygon(
          points={{-70,90},{-78,68},{-62,68},{-70,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-70,68},{-70,-80}}, color={192,192,192}),
        Line(points={{-80,-70},{92,-70}}, color={192,192,192}),
        Polygon(
          points={{100,-70},{78,-62},{78,-78},{100,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Provides a practical interface to input the mass flow supplied by a given heating plant as a funciton of the total expected massflow.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely tabular component without physical modeling)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely tabular component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Real Input:</p>
<ul>
<li>u[1] Total mass flow supplied to the district heating grid in kg/s</li>
</ul>
<p>Real Output:</p>
<ul>
<li>y[1]: Mass flow supplied by plant 1 in t/h</li>
<li>y[2]: Mass flow supplied by plant 2 in t/h</li>
<li>...</li>
<li>y[n] Mass flow supplied by plant n in t/h</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p>This component was created using the combiTable 1Ds of the MSL. For further information regarding its usage refer to that component.</p>
<p>Create a text file with the following structure:</p>
<p><br>#1</p>
<p>double default(n-rows, m-columns) #Comment: u[1] y[1] y[2]</p>
<p>xx xx xx</p>
<p>xx xx xx</p>
<p>xx xx xx</p>
<p><br><br>In the parameter &QUOT;columns&QUOT; write for instance {2, 3} (meaning that the 2nd and third columns will be used and assigned to the outputs y[1] and y[2]).</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>KWK Optimierung Band 1 , Abbildung 7</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end MassFlowCharacteristicLines;
