within TransiEnt.Consumer.DemandSideManagement.HeatpumpSystems.Base;
model HeatpumpSystemPool
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TransiEnt.Basics.Types.Poolsize N=20;

  final parameter Real[N,TransiEnt.Producer.Heat.Power2Heat.Components.nPar - 1] A=Modelica_LinearSystems2.Internal.Streams.readMatrixInternal(
      getFileName(N),
      "A",
      N,
      TransiEnt.Producer.Heat.Power2Heat.Components.nPar - 1)
                                                             "Input Matrix with Heat Pump Properties";

  replaceable TransiEnt.Consumer.DemandSideManagement.HeatpumpSystems.Base.BivalentHeatpumpSystemDSM[N] HeatPumpSystem(final A=A) constrainedby TransiEnt.Consumer.DemandSideManagement.HeatpumpSystems.Base.PartialHeatPumpSystemDSM(A=A) annotation (Placement(transformation(extent={{-22,-16},{24,16}})), choicesAllMatching=true);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.BooleanInput
                                      isLoadShedding annotation (Placement(transformation(extent={{-112,-10},{-92,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Boundaries.Electrical.ActivePower.Power Power annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.RealExpression P_el_bdry(y=P_el) annotation (Placement(transformation(extent={{44,12},{64,32}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Power P_el_n = sum(HeatPumpSystem.P_el_n);
  SI.Power P_el = sum(HeatPumpSystem.P_el);
  SI.Power P_el_star = P_el/P_el_n;
  SI.Power P_pot_pos = sum(HeatPumpSystem.P_pot_pos);
  SI.Power P_pot_neg = sum(HeatPumpSystem.P_pot_neg);
  Real SOC = sum(HeatPumpSystem.SOC_tot)/N;
  SI.Energy E_stor = sum(HeatPumpSystem.E_stor_total);
  Real COP_mean = sum(HeatPumpSystem.COP)/N;
  SI.Time t_pos_max = min(HeatPumpSystem.t_pos_max);
  SI.Time t_neg_max = min(HeatPumpSystem.t_neg_max);

  // _____________________________________________
  //
  //              Private Functions
  // _____________________________________________

protected
    function getFileName
    import TransiEnt.Basics.Types;
    input Types.Poolsize poolsize;
    output String filename;
    algorithm
    if poolsize == Types.N1 then
      filename := Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Types.PUBLIC_DATA) + "/electricity/HeatpumpSystemPool/HeatpumpSystem_N1.mat");
      //"PUBLIC_DATA"+"/electricity/HeatPumpSystemPool/heatpumpSystem_N1.mat";
    elseif poolsize == Types.N20 then
      filename := Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Types.PUBLIC_DATA)+"/electricity/HeatpumpSystemPool/HeatpumpSystem_N20.mat");
    elseif poolsize == Types.N100 then
     filename := Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Types.PUBLIC_DATA)+"/electricity/HeatpumpSystemPool/HeatpumpSystem_N100.mat");
    end if;
    end getFileName;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  for i in 1:N loop
      connect(isLoadShedding, HeatPumpSystem[i].isLoadShedding) annotation (Line(points={{-102,0},{-16.6812,0},{-16.6812,-0.16}}, color={255,0,255}));

  end for;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Power.epp, epp) annotation (Line(
      points={{80,0},{89.05,0},{89.05,0},{100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(P_el_bdry.y, Power.P_el_set) annotation (Line(points={{65,22},{76,22},{76,12}}, color={0,0,127}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-42,62},{38,-26}},
          lineColor={0,0,0}),
        Polygon(
          points={{-52,30},{-48,30},{-34,30},{-42,18},{-34,8},{-52,8},{-42,18},{-52,30}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,70},{16,54}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-18},{18,-34}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{26,32},{52,8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{30,12},{38,32},{48,12}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,44},{-24,-2},{24,-2}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,0},{-20,8},{-8,26},{-6,28},{2,34},{12,38},{20,38}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{-40,-41},{54,-76}},
          lineColor={0,0,0},
          textString="%N"),
        Text(
          extent={{-64,-41},{30,-76}},
          lineColor={0,0,0},
          textString="x")}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Models several heat pumps in a pool to allow load shedding by turning off heat pumps.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp - Electric Power Port</p>
<p>isLoadShedding - boolean signal</p>
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
<p>(no remarks)</p>
</html>"));
end HeatpumpSystemPool;
