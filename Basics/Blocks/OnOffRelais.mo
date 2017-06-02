within TransiEnt.Basics.Blocks;
model OnOffRelais "Three state dynamic model - operating at init"

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
  //                   Import
  // _____________________________________________

   import TransiEnt.Basics.Types;
   extends TransiEnt.Basics.Icons.BooleanBlock;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

   parameter SI.Time t_min_on = 3600 "Min on time after startup";
   parameter SI.Time t_min_off = 600 "Min off time after shutdown";
   parameter Types.OnOffRelaisStatus init_state "State of relais at initialization"
                                                                                   annotation (__Dymola_editText=false);

  Modelica.Blocks.Interfaces.BooleanInput u "Input signal (e.g. output of OnOff Controller)" annotation (Placement(transformation(extent={{-120,-16},{-88,16}}, rotation=0)));
  Modelica.Blocks.Interfaces.BooleanOutput y "Limited signal to plant" annotation (Placement(transformation(extent={{94,-16},{126,16}}, rotation=0)));
    inner Modelica.StateGraph.StateGraphRoot
                         stateGraphRoot
      annotation (Placement(transformation(extent={{-100,82},{-86,96}})));
  Modelica.StateGraph.Transition t_min_off_passed(
    enableTimer=true,
    condition=true,
    waitTime=t_min_off) annotation (Placement(transformation(extent={{-62,30},{-42,50}}, rotation=0)));
  Modelica.StateGraph.Step off_ready(nIn=2) annotation (Placement(transformation(extent={{-30,30},{-10,50}}, rotation=0)));
  Modelica.StateGraph.StepWithSignal on_blocked(nIn=2) annotation (Placement(transformation(extent={{20,30},{40,50}}, rotation=0)));
  Modelica.StateGraph.Step        off_blocked(nIn=2) annotation (Placement(transformation(extent={{-86,30},{-66,50}}, rotation=0)));
  Modelica.StateGraph.Transition switch_to_on(
    waitTime=t_min_on,
    condition=u,
    enableTimer=false)
                 annotation (Placement(transformation(extent={{-8,30},{12,50}}, rotation=0)));
  Modelica.StateGraph.Transition t_min_on_passed(
    condition=true,
    enableTimer=true,
    waitTime=t_min_on) annotation (Placement(transformation(extent={{44,30},{64,50}}, rotation=0)));
  Modelica.StateGraph.StepWithSignal on_ready(nIn=2) annotation (Placement(transformation(extent={{76,30},{96,50}}, rotation=0)));
  Modelica.StateGraph.Transition switch_to_off(
    waitTime=t_min_on,
    condition=not u,
    enableTimer=false)
                     annotation (Placement(transformation(extent={{12,66},{-8,86}}, rotation=0)));
  Modelica.Blocks.Logical.Or on annotation (Placement(transformation(extent={{66,-10},{86,10}}, rotation=0)));
  Modelica.StateGraph.InitialStep init(nIn=0, nOut=4) annotation (Placement(transformation(extent={{-80,-40},{-60,-20}}, rotation=0)));
  Modelica.StateGraph.Transition initOffReady(
    waitTime=t_min_off,
    condition=init_state == Types.off_ready,
    enableTimer=false);
  Modelica.StateGraph.Transition initOnReady(
    waitTime=t_min_off,
    condition=init_state == Types.on_ready,
    enableTimer=false);
  Modelica.StateGraph.Transition initOffBlocked(
    waitTime=t_min_off,
    enableTimer=true,
    condition=init_state == Types.off_blocked);
  Modelica.StateGraph.Transition initOnBlocked(
    waitTime=t_min_off,
    enableTimer=true,
    condition=init_state == Types.on_blocked);
equation
  connect(on_blocked.outPort[1], t_min_on_passed.inPort) annotation (Line(points={{40.5,40},{40.5,40},{50,40}}, color={0,0,0}));
  connect(t_min_on_passed.outPort, on_ready.inPort[1]) annotation (Line(points={{55.5,40},{60,40},{75,40},{75,40.5}},
                                                                                                    color={0,0,0}));
  connect(off_blocked.outPort[1], t_min_off_passed.inPort) annotation (Line(points={{-65.5,40},{-60,40},{-56,40}}, color={0,0,0}));
  connect(t_min_off_passed.outPort, off_ready.inPort[1]) annotation (Line(points={{-50.5,40},{-44,40},{-31,40},{-31,40.5}},
                                                                                                    color={0,0,0}));
  connect(off_ready.outPort[1], switch_to_on.inPort) annotation (Line(points={{-9.5,40},{-5.75,40},{-2,40}}, color={0,0,0}));
  connect(switch_to_on.outPort, on_blocked.inPort[1]) annotation (Line(points={{3.5,40},{19,40},{19,40.5}},
                                                                                                    color={0,0,0}));
  connect(on_ready.outPort[1], switch_to_off.inPort) annotation (Line(points={{96.5,40},{100,40},{100,42},{100,76},{6,76}}, color={0,0,0}));
  connect(switch_to_off.outPort, off_blocked.inPort[1]) annotation (Line(points={{0.5,76},{-98,76},{-98,40.5},{-87,40.5}},
                                                                                                    color={0,0,0}));
  connect(on.y, y);
  connect(on_ready.active, on.u1);
  connect(on_blocked.active, on.u2);
  connect(init.outPort[2], initOffReady.inPort);
  connect(init.outPort[4], initOnReady.inPort);
  connect(initOnReady.outPort, on_ready.inPort[2]);
  connect(initOffReady.outPort, off_ready.inPort[2]);
  connect(init.outPort[1], initOffBlocked.inPort);
  connect(init.outPort[3], initOnBlocked.inPort);
  connect(initOffBlocked.outPort, off_blocked.inPort[2]);
  connect(initOnBlocked.outPort, on_blocked.inPort[2]);
  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple time relais. If the input changes from false to true, the time t_min_on has to past before the output changes to false again. In the same way t_min_off has to pass before starting up againg after a shutdown.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised (code conventinos) by Pascal Dubucq (dubucq@tuhh.de) on 21.04.2017</span></p>
</html>"));
end OnOffRelais;
