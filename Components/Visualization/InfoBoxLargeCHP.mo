within TransiEnt.Components.Visualization;
model InfoBoxLargeCHP

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
        Diagram(graphics,
                coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-220},{0,0}},
        initialScale=0.5)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>InfoBox for dynamic display of:</p>
<ul>
<li>P ...    P_el_is of CHP</li>
<li>Q ...   Q_el_is of CHP</li>
<li>m ...    m_flow of hot water through CHP</li>
<li>T_s ... T_supply of CHP</li>
<li>T_r ... T_return of CHP</li>
</ul>
</html>"));

end InfoBoxLargeCHP;
