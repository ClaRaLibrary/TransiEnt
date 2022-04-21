within TransiEnt.Grid.Electrical.GridConnector.Components;
model TransmissionLine "Universal Transmission Line to connect components on the 380kV level, specifically Superstructure components"


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





  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Boolean hasTransformers=false "Activate voltage transformation at each end of the power line" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Voltage U_S=220*1e3 "voltage level of transmission line" annotation (Dialog(group="Fundamental Definitions"), enable=hasTransformers);

  parameter Boolean activateSwitch=false annotation (Dialog(group="Fundamental Definitions"));
  parameter Integer ChooseVoltageLevel=3 "Choose Voltage Level" annotation (Dialog(group="Fundamental Definitions"), choices(
      __Dymola_radioButtons=true,
      choice=1 "Low Voltage",
      choice=2 "Medium Voltage",
      choice=3 "High Voltage",
      choice=4 "Custom Data"));
  parameter Real p=1 "Number of parallel lines" annotation (Dialog(group="Fundamental Definitions"));
  parameter Boolean calculateOverload=true "choose if boolean variable 'overload' is calculated'" annotation (Dialog(group="Fundamental Definitions"));

  parameter TransiEnt.Basics.Units.SpecificResistance r_custom=0.06e-3 "Resistance load per unit length" annotation (Dialog(group="cable properties", enable=if ChooseVoltageLevel == 4 then true else false));
  parameter TransiEnt.Basics.Units.SpecificReactance x_custom=0.301e-3 "Reactance load per unit length" annotation (Dialog(group="cable properties", enable=if ChooseVoltageLevel == 4 then true else false));
  parameter TransiEnt.Basics.Units.SpecificCapacitance c_custom=0.0125e-9 "Capacitance load per unit length" annotation (Dialog(group="cable properties", enable=if ChooseVoltageLevel == 4 then true else false));
  parameter SI.Current i_r_custom=1290 "Rated current" annotation (Dialog(group="cable properties", enable=if ChooseVoltageLevel == 4 then true else false));
  parameter TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1 "Type of low voltage cable" annotation (
    Evaluate=true,
    HideResult=true,
    Dialog(group="cable properties", enable=if ChooseVoltageLevel == 1 then true else false));
  parameter TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1 "Type of Medium voltage cable" annotation (
    Evaluate=true,
    HideResult=true,
    Dialog(group="cable properties", enable=if ChooseVoltageLevel == 2 then true else false));
  parameter TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L1 "Type of high voltage cable" annotation (
    Evaluate=true,
    HideResult=true,
    Dialog(group="cable properties", enable=if ChooseVoltageLevel == 3 then true else false));
  parameter SI.Length l=1 "Cable LengthCable Length" annotation (Evaluate=true, Dialog(group="cable properties"));
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
public
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Modelica.Blocks.Interfaces.BooleanInput switched_input if activateSwitch annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));

  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_p annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_n annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine(
    activateSwitch=activateSwitch,
    ChooseVoltageLevel=3,
    p=p,
    r_custom=r_custom,
    x_custom=x_custom,
    c_custom=c_custom,
    i_r_custom=i_r_custom,
    LVCableType=LVCableType,
    MVCableType=MVCableType,
    HVCableType=HVCableType,
    l=l,
    calculateOverload=calculateOverload) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformerComplex simpleTransformerComplex_n(
    UseInput=false,
    U_P=simCenter.v_n,
    U_S=U_S) if hasTransformers annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
  TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformerComplex simpleTransformerComplex_p(U_P=simCenter.v_n, U_S=U_S) if hasTransformers annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  if hasTransformers then
    connect(epp_p, simpleTransformerComplex_p.epp_p) annotation (Line(
        points={{-100,0},{-80,0},{-80,-20},{-60,-20}},
        color={28,108,200},
        thickness=0.5));
    connect(simpleTransformerComplex_p.epp_n, transmissionLine.epp_p) annotation (Line(
        points={{-40,-20},{-20,-20},{-20,0},{-10,0}},
        color={28,108,200},
        thickness=0.5));
    connect(transmissionLine.epp_n, simpleTransformerComplex_n.epp_n) annotation (Line(
        points={{10,0},{20,0},{20,-20},{40,-20}},
        color={28,108,200},
        thickness=0.5));
    connect(simpleTransformerComplex_n.epp_p, epp_n) annotation (Line(
        points={{60,-20},{80,-20},{80,0},{100,0}},
        color={28,108,200},
        thickness=0.5));
  else
    connect(epp_p, transmissionLine.epp_p) annotation (Line(
        points={{-100,0},{-10,0}},
        color={28,108,200},
        thickness=0.5));
    connect(transmissionLine.epp_n, epp_n) annotation (Line(
        points={{10,0},{100,0}},
        color={28,108,200},
        thickness=0.5));
  end if;

  connect(switched_input, transmissionLine.switched_input) annotation (Line(points={{0,100},{0,10}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-80,6},{80,-6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Line(
          points={{-100,0},{100,0}},
          color={0,0,0},
          smooth=Smooth.None)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of an transmission&nbsp;line&nbsp;to connect components with a differing voltage level of the transmission line.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>see <a href=\"TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced\">PiModelComplex_advanced</a> and <a href=\"TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformerComplex\">SimpleTransformerComplex</a></p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Two ComplexPowerPort for each terminal of the transmission line</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
end TransmissionLine;
