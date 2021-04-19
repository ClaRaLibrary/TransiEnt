within TransiEnt.Components.Visualization;
model DHG_PressureDiagram "Pressure diagram of district heating grids (pressure as a function of grid length) "
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  input ClaRa.Basics.Units.Pressure p_supply[n]=zeros(n) "Pressure values at supply pipes' inputs and outputs in Pa" annotation(Dialog(group="Input", enable=not showInterface));
  input ClaRa.Basics.Units.Pressure p_return[m]=zeros(m) "Pressure values at return pipes' inputs and outputs in Pa" annotation(Dialog(group="Input", enable=not showInterface));
  input Real relative_positions_supply[n] "Supply pipes' relative input and output position in p.u." annotation(Dialog(group="Input", enable=not showInterface));
  input Real relative_positions_return[m] "Supply pipes' relative input and output position in p.u." annotation(Dialog(group="Input", enable=not showInterface));

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________
  parameter Integer n=2 "Numer of inlet/outlet pairs in supply";
  parameter Integer m=4 "Number of inlet/outlet pairs in return";
  parameter Real minY=0 "Choose or guess the minimal value of the y-axis" annotation(Dialog(group="Layout"));
  parameter Real maxY(min=minY+Modelica.Constants.eps)=1 "Choose or guess the maximal value of the y-axis"
                                                      annotation(Dialog(group="Layout"));
  parameter String Unit="[-]" "Unit for plot variable" annotation(Dialog(group="Layout"));

public
  constant ClaRa.Basics.Types.Color colorh={167,25,48} "Line color"         annotation (HideResult=false, Dialog(group="Layout"));
  constant ClaRa.Basics.Types.Color colorc={0,131,169} "Line color"         annotation (HideResult=false, Dialog(group="Layout"));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
protected
  Real y_supply[ size(relative_positions_supply, 1)];
  Real y_return[ size(relative_positions_return, 1)];

public
  final Real[size(relative_positions_supply, 1), 2] point_supply=transpose({relative_positions_supply*100,y_supply})  annotation(HideResult=false);
  final Real[size(relative_positions_return, 1), 2] point_return=transpose({relative_positions_return*100,y_return})  annotation(HideResult=false);

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  for i in 1:size(y_supply, 1) loop
     y_supply[i] = if p_supply[i] < minY then (1-(maxY -minY)/(maxY - minY))*100 else
           if  p_supply[i] > maxY then    (1-(maxY -maxY)/(maxY - minY))*100 else
               (1-(maxY -p_supply[i])/(maxY - minY))*100;

  end for;
  for i in 1:size(y_return, 1) loop
    y_return[i] = if p_return[i] < minY then     (1-(maxY -minY)/(maxY - minY))*100 else
          if  p_return[i] > maxY then    (1-(maxY -maxY)/(maxY - minY))*100 else
              (1-(maxY -p_return[i])/(maxY - minY))*100;

  end for;

annotation (    Icon(coordinateSystem(preserveAspectRatio=true, extent={{0,0},{
            100,100}}),   graphics={
        Rectangle(
          extent={{0,0},{100,100}},
          lineColor={27,36,42},
          fillColor={164,167,170},
          fillPattern=FillPattern.Solid),
        Text(
            extent={{2,94},{-18,100}},
            lineColor={27,36,42},
            textString="%maxY"),
        Text(
          extent={{-16,6},{2,0}},
          lineColor={27,36,42},
          textString="%minY"),
          Text(
            extent={{66,-4},{36,-12}},
            lineColor={27,36,42},
          textString="Length"),
        Text(
          extent={{-20,114},{120,104}},
          lineColor={27,36,42},
          textString="%Unit"),
          Line(
            points=DynamicSelect({{0,90},{100,50}}, point_supply),
            color=colorh,
            thickness=DynamicSelect(0.25,0.5)),
          Line(
            points=DynamicSelect({{0,20},{82,45},{82,30},{100,40}}, point_return),
            color=colorc,
            thickness=DynamicSelect(0.25, 0.5)),
        Line(
          points={{50,0},{50,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{0,0},{0,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{10,0},{10,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{20,0},{20,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{30,0},{30,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{40,0},{40,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{100,0},{100,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{90,0},{90,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{80,0},{80,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{70,0},{70,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Line(
          points={{60,0},{60,-2}},
          color={27,36,42},
          smooth=Smooth.None),
        Text(
          extent={{96,-3},{104,-5}},
          lineColor={27,36,42},
          textString="1"),
        Text(
          extent={{44,-3},{56,-5}},
          lineColor={27,36,42},
          textString="0.5"),
        Text(
          extent={{-4,-3},{4,-6}},
          lineColor={27,36,42},
          textString="0"),
          Text(
            extent={{16.5,5.5},{-16.5,-5.5}},
            lineColor={27,36,42},
          origin={-8.5,51.5},
          rotation=90,
          textString="Pressure NN"),
        Text(
          extent={{0,100},{12,94}},
          pattern=LinePattern.Dash,
          lineColor=colorh,
          textString=DynamicSelect("p_supply_start",String(p_supply[1],format = "1."+String(1)+"f"))),
        Text(
          extent={{0,6},{12,0}},
          lineColor=colorc,
          pattern=LinePattern.Dash,
          textString=DynamicSelect("p_return_start", String(p_return[1],format = "1."+String(1)+"f"))),
        Text(
          extent={{88,100},{100,94}},
           lineColor=colorh,
          pattern=LinePattern.Dash,
          textString=DynamicSelect("p_supply_end",String(p_supply[n],format = "1."+String(1)+"f"))),
        Text(
          extent={{88,6},{100,0}},
          lineColor=colorc,
          pattern=LinePattern.Dash,
          textString=DynamicSelect("p_return_end",String(p_return[m],format = "1."+String(1)+"f"))),
        Text(
          extent={{0,-10},{100,-30}},
          lineColor={0,134,134},
          textString="%name")}), Diagram(graphics,
                                         coordinateSystem(extent={{0,0},{
            100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Pressure diagram of district heating grids (pressure as a function of grid length) </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p>Peniche, 2017</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Jakobus Gaeth, 2015</span></p>
</html>"));
end DHG_PressureDiagram;
