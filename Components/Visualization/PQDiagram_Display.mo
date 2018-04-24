within TransiEnt.Components.Visualization;
model PQDiagram_Display
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  //Parameters
  parameter TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.Generic_PQ_Characteristics PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WW1() annotation (choicesAllMatching);

    Real a[:,:]=PQCharacteristics.PQboundaries annotation(HideResult=true);

    //values for heat generation
    Real Q[size(a,1)]=a[:,1]/max(abs(a[:,1]))*142-ones(size(a,1))*76;

    //values for power generation in full pressure operation
    Real P_full[size(a,1)]=a[:,2]/max(abs(a[:,2]))*128-ones(size(a,1))*66;

    //values for power generation in back pressure operation
    Real P_back[size(a,1)]=a[:,3]/max(abs(a[:,2]))*128-ones(size(a,1))*66;

    //points for full load operation
    Real points_P_full[size(a,1),2]=[Q,P_full];
    //points for back pressure operation
    Real points_P_back[size(a,1),2]=[Q,P_back];

    //coordinate values in diagram
    Real coordinate_P=eyeIn.P/max(abs(a[:,2]))*128-66;
    Real coordinate_Q=eyeIn.Q_flow/max(abs(a[:,1]))*142-76;

  TransiEnt.Basics.Interfaces.General.EyeIn eyeIn annotation (Placement(transformation(extent={{-138,-10},{-118,10}}), iconTransformation(extent={{-138,-10},{-118,10}})));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                   graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Text(
          extent={{-150,-101},{150,-141}},
          lineColor={0,134,134},
          textString="%name"),
        Rectangle(
          extent={{-50,60},{0,-60}},
          lineColor={255,255,255},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Line(points={{-50,-60},{-50,60},{50,60},{50,-60},{-50,-60},{-50,-30},{50,-30},{50,0},{-50,0},{-50,30},{50,30},{50,60},{0,60},{0,-61}},
            color={0,0,0}),                     Text(
          extent={{-94,-56},{-44,-104}},
          lineColor={0,128,0},
          textStyle={TextStyle.Bold},
          textString="S4"),
        Rectangle(
          extent={{-118,100},{100,-100}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-76,94},{-84,72},{-68,72},{-76,94}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-76,72},{-76,-76}}, color={192,192,192}),
        Line(points={{-86,-66},{86,-66}}, color={192,192,192}),
        Polygon(
          points={{94,-66},{72,-58},{72,-74},{94,-66}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points=DynamicSelect({{-76,62},{-60,62},{62,14}},points_P_full),
          color={255,128,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points=DynamicSelect({{-76,-28},{-24,-44},{62,-10},{62,14},{62,-10}},points_P_back),
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Text(
          extent={{-110,102},{-92,72}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="P 
[MW]"), Text(
          extent={{72,-26},{92,-60}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Q 
[MW]"), Ellipse(
          extent=DynamicSelect({{0,0},{0,0}},{{coordinate_Q-3,coordinate_P+3},{coordinate_Q+3,coordinate_P-3}}),
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent=DynamicSelect({{24,-72},{66,-102}},{{coordinate_Q-11,-74},{coordinate_Q+11,-94}}),
          lineColor={28,108,200},
          textString=DynamicSelect(" ", realString(eyeIn.Q_flow/1e6,1,1))),
        Line(points=DynamicSelect({{62,-66},{62,-72}},{{coordinate_Q,-66},{coordinate_Q,-72}}), color={192,192,192}),
        Line(points=DynamicSelect({{-76,62},{-82,62}},{{-76,coordinate_P},{-82,coordinate_P}}), color={215,215,215}),
        Text(
          extent=DynamicSelect({{-78,-6},{-100,6}},{{-88,coordinate_P+10},{-110,coordinate_P-10}}),
          lineColor={28,108,200},
          textString=DynamicSelect(" ", realString(eyeIn.P/1e6,1,1)))}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model is a display showing the PQ-diagram of an CHP plant and the current operation point in this diagram in animation mode.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Choise of CHP plant</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">In the parameters section the desired CHP plant can be chosen via the dropdown menu &QUOT;PQboundaries&QUOT; or own values for the PQ-diagram can be entered here.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Application of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The eye of the model needs to be connected to the eye of an CHP plant to get information about the current operation point.</span></p>
</html>"));
end PQDiagram_Display;
