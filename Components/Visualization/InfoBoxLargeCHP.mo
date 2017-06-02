within TransiEnt.Components.Visualization;
model InfoBoxLargeCHP
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

  Basics.Interfaces.General.EyeIn eye annotation (Placement(transformation(extent={{-200,-102},{-180,-82}}), iconTransformation(extent={{-200,-102},{-180,-82}})));
  annotation (
        Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-220},{0,0}},
        initialScale=0.05),
        graphics={
        Text(
          extent={{-170,-2},{-36,-50}},
          lineColor={0,140,72},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString=DynamicSelect(" P ", realString(eye.P/1e6,1,1) +" MWe")),
        Text(
          extent={{-170,-42},{-36,-90}},
          lineColor={238,46,47},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect(" Q ", realString(eye.Q_flow/1e6,1,1) +" MWth"),
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-168,-82},{-34,-130}},
          lineColor={238,46,47},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect(" m ", realString(eye.m_flow,1,1) +" kg/s"),
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-170,-120},{-36,-168}},
          lineColor={238,46,47},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect(" T_s ", realString(eye.T_supply,1,1) +" C"),
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-168,-168},{-34,-216}},
          lineColor={238,46,47},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString=DynamicSelect(" T_r ", realString(eye.T_return,1,1) +" C"),
          textStyle={TextStyle.Bold})}),
        Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-220},{0,0}},
        initialScale=0.5)));

end InfoBoxLargeCHP;
