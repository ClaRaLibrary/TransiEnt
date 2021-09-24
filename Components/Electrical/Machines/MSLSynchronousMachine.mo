within TransiEnt.Components.Electrical.Machines;
model MSLSynchronousMachine "ApparentPowerPort: Transient MSL synchronous machine model to TransiEnt interfaces"


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

  import TransiEnt;

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Components.Electrical.Machines.Base.PartialQuasiStationaryGenerator;

  // _____________________________________________
  //
  //               Parameters & Constants
  // _____________________________________________

  constant Integer m=3 "Number of phases";
  parameter Modelica.Units.SI.Voltage VNominal=100 "Nominal RMS voltage per phase";
  parameter Modelica.Units.SI.Frequency fNominal=50 "Nominal frequency";
  parameter Modelica.Units.SI.AngularVelocity wActual(displayUnit="1/min") = 1499*2*Modelica.Constants.pi/60 "Actual speed";
  parameter Modelica.Units.SI.Angle gamma0(displayUnit="deg") = 0 "Initial rotor displacement angle";
  parameter Modelica.Electrical.Machines.Utilities.SynchronousMachineData smeeData(
    SNominal=30e3,
    VsNominal=100,
    fsNominal=50,
    IeOpenCircuit=10,
    x0=0.1,
    xd=1.6,
    xq=1.6,
    xdTransient=0.1375,
    xdSubtransient=0.121428571,
    xqSubtransient=0.148387097,
    Ta=0.014171268,
    Td0Transient=0.261177343,
    Td0Subtransient=0.006963029,
    Tq0Subtransient=0.123345081,
    alpha20s(displayUnit="1/K") = Modelica.Electrical.Machines.Thermal.Constants.alpha20Zero,
    alpha20r(displayUnit="1/K") = Modelica.Electrical.Machines.Thermal.Constants.alpha20Zero,
    alpha20e(displayUnit="1/K") = Modelica.Electrical.Machines.Thermal.Constants.alpha20Zero,
    TsSpecification=293.15,
    TsRef=293.15,
    TrSpecification=293.15,
    TrRef=293.15,
    TeSpecification=293.15,
    TeRef=293.15) "Change other synchronous machine parameters"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-20,-100},{0,-80}})));
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricCurrentIn i_e "Excitation current"  annotation (Placement(transformation(extent={{-126,-60},{-86,-20}},
          rotation=0), iconTransformation(
        extent={{-15,-15},{15,15}},
        rotation=0,
        origin={-81,-65})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Electrical.Machines.BasicMachines.SynchronousMachines.SM_ElectricalExcited smee(
    phiMechanical(start=-(Modelica.Constants.pi + gamma0)/smee.p, fixed=true),
    fsNominal=smeeData.fsNominal,
    Rs=smeeData.Rs,
    TsRef=smeeData.TsRef,
    Lssigma=smeeData.Lssigma,
    Lmd=smeeData.Lmd,
    Lmq=smeeData.Lmq,
    Lrsigmad=smeeData.Lrsigmad,
    Lrsigmaq=smeeData.Lrsigmaq,
    Rrd=smeeData.Rrd,
    Rrq=smeeData.Rrq,
    TrRef=smeeData.TrRef,
    VsNominal=smeeData.VsNominal,
    IeOpenCircuit=smeeData.IeOpenCircuit,
    Re=smeeData.Re,
    TeRef=smeeData.TeRef,
    sigmae=smeeData.sigmae,
    p=2,
    Jr=0.29,
    Js=0.29,
    useDamperCage=true,
    statorCoreParameters(VRef=100),
    strayLoadParameters(IRef=100),
    brushParameters(ILinear=0.01),
    TsOperational=293.15,
    alpha20s=smeeData.alpha20s,
    ir(each fixed=true),
    TrOperational=293.15,
    alpha20r=smeeData.alpha20r,
    alpha20e=smeeData.alpha20e,
    TeOperational=293.15) annotation (Placement(transformation(extent={{-20,-50},{0,-30}}, rotation=0)));

  Modelica.Electrical.Analog.Basic.Ground groundExcitation
    annotation (Placement(transformation(
        origin={-66,-68},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Electrical.Machines.Sensors.ElectricalPowerSensor electricalPowerSensor
    annotation (Placement(transformation(
        origin={0,60},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Electrical.Polyphase.Sources.SineVoltage sineVoltage(
    final m=m,
    final V=fill(VNominal*sqrt(2), m),
    final f=fill(fNominal, m)) annotation (Placement(transformation(extent={{-20,80},{-40,100}}, rotation=0)));
  Modelica.Electrical.Polyphase.Basic.Star star(final m=m) annotation (Placement(transformation(extent={{-50,80},{-70,100}}, rotation=0)));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(
        origin={-90,90},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Electrical.Analog.Sources.SignalCurrent
                                                 rampCurrent
                       annotation (Placement(transformation(
        origin={-50,-40},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Electrical.Machines.Utilities.TerminalBox terminalBox(
      terminalConnection="Y")        annotation (Placement(transformation(
          extent={{-20,-30},{0,-10}}, rotation=0)));
  Modelica.Mechanics.Rotational.Components.Fixed fixed
    annotation (Placement(transformation(extent={{-10,-68},{10,-48}})));

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower terminal annotation (Placement(transformation(extent={{78,-10},{58,10}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(star.pin_n, ground.p)
    annotation (Line(points={{-70,90},{-80,90}}, color={0,0,255}));
  connect(star.plug_p, sineVoltage.plug_n)   annotation (Line(points={{-50,
          90},{-40,90}}, color={0,0,255}));
  connect(sineVoltage.plug_p, electricalPowerSensor.plug_p)   annotation (Line(
        points={{-20,90},{1.83697e-015,90},{1.83697e-015,70}},   color={0,0,
          255}));
  connect(rampCurrent.p, groundExcitation.p)
                                     annotation (Line(points={{-50,-50},{-66,-50},{-66,-58}},
                     color={0,0,255}));
  connect(rampCurrent.p, smee.pin_en)    annotation (Line(points={{-50,-50},
          {-40,-50},{-40,-46},{-20,-46}}, color={0,0,255}));
  connect(rampCurrent.n, smee.pin_ep)    annotation (Line(points={{-50,-30},
          {-40,-30},{-40,-34},{-20,-34}}, color={0,0,255}));
  connect(electricalPowerSensor.plug_nv, smee.plug_sn)   annotation (Line(
        points={{-10,60},{-16,60},{-16,-30}}, color={0,0,255}));
  connect(terminalBox.plug_sn, smee.plug_sn)   annotation (Line(
      points={{-16,-26},{-16,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(terminalBox.plug_sp, smee.plug_sp)   annotation (Line(
      points={{-4,-26},{-4,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(smee.support, fixed.flange) annotation (Line(
      points={{0,-50},{0,-58}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(terminalBox.plugSupply, electricalPowerSensor.plug_ni) annotation (
      Line(
      points={{-10,-24},{-10,50},{-1.77636e-015,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(mpp, smee.flange) annotation (Line(
      points={{-100,0},{46,0},{46,-40},{0,-40}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(terminal.epp, epp) annotation (Line(
      points={{78.1,-0.1},{89.05,-0.1},{89.05,0},{100,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(terminal.P_el_set, electricalPowerSensor.P) annotation (Line(
      points={{74,12},{74,65},{11,65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(terminal.Q_el_set, electricalPowerSensor.Q) annotation (Line(
      points={{62,12},{62,55},{11,55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(i_e, rampCurrent.i) annotation (Line(points={{-106,-40},{-78,-40},{-57,-40}},           color={0,0,127}));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=30, Interval=0.005),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">MSL Synchronous Machine model adapted to TransiEnt L2E interfaces.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L2E (defined in the CodingConventions)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Mechanical power port mpp</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: electric current in [A]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica RealInput: electric potential in [V]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Apparent power port epp</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Do not use!</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in the check model &quot;TransiEnt.Components.Electrical.Machines.Check.CheckMSLSynchronousMachine&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"),
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end MSLSynchronousMachine;
