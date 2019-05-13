within TransiEnt.Components.Boundaries.Electrical.ComplexPower;
model SlackBoundary "Slack Bus in TransiEnt"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

// _____________________________________________
//
//          Imports and Class Hierarchy
// _____________________________________________
//
      import TransiEnt;
      extends TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp);
      extends TransiEnt.Basics.Icons.ElectricSource;

      outer TransiEnt.SimCenter simCenter;

// _____________________________________________
//
//                   Parameters
// _____________________________________________

  parameter Modelica.SIunits.Voltage v_gen=simCenter.v_n "Voltage of Plant, controlled by generator" annotation (Dialog(enable = not useInputConnectorv));
  parameter Modelica.SIunits.Frequency f_n=simCenter.f_n "Nominal frequency" annotation (Dialog(enable = not useInputConnectorf));
  parameter Modelica.SIunits.Angle delta_slackgen=0;
  parameter Boolean useInputConnectorv = false "Gets parameter v from input connector"
  annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  parameter Boolean useInputConnectorf = false "Gets parameter f_n from input connector"
  annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________

 TransiEnt.Basics.Interfaces.Electrical.VoltageIn v_gen_set if              useInputConnectorv "fixed votlage input"
                                                                 annotation (Placement(transformation(extent={{-140,60},{-100,100}},
          rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,120})));
 TransiEnt.Basics.Interfaces.Electrical.FrequencyIn f_gen_set if useInputConnectorf "fixed frequency input" annotation (Placement(transformation(extent={{-140,22},
            {-100,62}},
          rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,120})));
  // _____________________________________________

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  Modelica.SIunits.ActivePower P_gen(start=180e3) "Active Power of Plant, Load Flow";
  Modelica.SIunits.ReactivePower Q_gen(start=0) "Reactive Power of Plant, Load Flow";
protected
  TransiEnt.Basics.Interfaces.Electrical.VoltageIn v_internal "Needed to connect to conditional connector for fixed voltage";
  TransiEnt.Basics.Interfaces.Electrical.FrequencyIn f_internal "Needed to connect to conditional connector for fixed frequency";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________


  if not useInputConnectorv then
    v_internal = v_gen;
  end if;

  epp.v =v_internal;

  if not useInputConnectorf then
    f_internal = f_n;
  end if;

  epp.f =f_internal;


  epp.P = -P_gen;
  epp.Q=-Q_gen;
  epp.delta=delta_slackgen;
  Connections.root(epp.f);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(v_internal, v_gen_set);
  connect(f_internal, f_gen_set);


  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Line(points={{-18,6},{2,26},{2,-26}}, color={28,108,200}),
        Text(
        visible=useInputConnectorf,
          extent={{-96,128},{-74,108}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="f"),
        Text(
        visible=useInputConnectorv,
          extent={{24,130},{46,110}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="V")}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model for slack bus when using ComplexPowerPort for LoadFlowCalculations</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">&gt;L1E (defined in the CodingConventions), Voltage (magnitude and angle) are fixed</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">stationary component that balances active and reactive power perfectly</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">ComplexPowerPort epp</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p>P_gen&nbsp;&quot;Active&nbsp;Power&nbsp;of&nbsp;Plant,&nbsp;Load&nbsp;Flow&quot;</p>
<p>Q_gen&nbsp;&quot;Reactive&nbsp;Power&nbsp;of&nbsp;Plant,&nbsp;Load&nbsp;Flow&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Use for stationary load flow calculations</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">validated by Jan-Peter Heckel (jan.heckel@tuhh.de)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in January 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Input connector added in April 2019</span></p>
</html>"));
end SlackBoundary;
