within TransiEnt.Components.Turbogroups.OperatingStates.Check;
model TestPumpstorageStates "Model for testing pump storage states"
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  PumpstorageStates ps_consInit(P_star_init=0.5) annotation (Placement(transformation(extent={{-10,36},{18,70}})));
  Modelica.Blocks.Sources.TimeTable TestSchedule(table=[0,0.5; 350,0.5; 350,0.5; 720,0.5; 720,0.5; 3e3,0.5; 3000,0.5; 3001,0.5; 3002,0.5; 4e3,0.5; 4e3,0.2; 4500,0.2; 4500,0.2; 6000,0.2; 6000,0.7; 10e3,0.7; 10e3,0; 1.2e4,0; 1.2e4,-0.8; 2e4,-0.8; 2e4,-0.2; 2.5e4,-0.2])
                                                                                                    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  PumpstorageStates ps_prodInit(P_star_init=-0.5) annotation (Placement(transformation(extent={{-2,-36},{26,-2}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-30,-38},{-10,-18}})));
equation
  connect(TestSchedule.y, ps_consInit.P_set_star) annotation (Line(points={{-49,0},{-6,0},{-6,48.1429}},color={0,0,127}));
  connect(gain.y, ps_prodInit.P_set_star) annotation (Line(points={{-9,-28},{2,-28},{2,-23.8571}},color={0,0,127}));
  connect(TestSchedule.y, gain.u) annotation (Line(points={{-49,0},{-46,0},{-46,-2},{-40,-2},{-40,-28},{-32,-28}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{34,90},{100,4}},
          lineColor={0,0,0},
          textString="Look at:
ps_consInit.P_set_star
ps_consInit.P_set_star_lim

ps_prodInit.P_set_star
ps_prodInit.P_set_star_lim

(P<0: Produce electricity; 
P>0 consume electricity)
")}),                                     experiment(StopTime=24000),
    __Dymola_experimentSetupOutput(equidistant=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for pump storage states</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
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
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestPumpstorageStates;
