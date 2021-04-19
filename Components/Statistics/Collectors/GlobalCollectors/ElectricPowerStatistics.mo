within TransiEnt.Components.Statistics.Collectors.GlobalCollectors;
model ElectricPowerStatistics "Total electric power statistics (different types of resources and balancing types)"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import TransiEnt.Basics.Types;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter Boolean integrateElPower=simCenter.integrateElPower "true if electric powers shall be integrated";

  final parameter Boolean is_setter=false "just for change of icon.." annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  parameter Integer nTypes=Types.nTypeOfResource  annotation(HideResult=true);

  parameter Integer nSubgrids=2 "For calculation of statistics in subgrids (=1 local grid, e.g. hamburg, =2 surrounding grid, e.g. UCTE grid"
                                                                                              annotation(HideResult=true);
  outer SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput powerCollector[nTypes] annotation (HideResult=true,
      Placement(transformation(extent={{-10,-108},{10,-88}}),
        iconTransformation(extent={{-16,-16},{16,16}},
        rotation=90,
        origin={0,-87})));
  Modelica.Blocks.Interfaces.RealInput primBalPowerCollector[nTypes] annotation(HideResult=true);
  Modelica.Blocks.Interfaces.RealInput primBalPowerOfferCollector[2] annotation(HideResult=true);
  Modelica.Blocks.Interfaces.RealInput secBalPowerCollector[nTypes] annotation(HideResult=true);
  Modelica.Blocks.Interfaces.RealInput secBalPowerOfferCollector[2] annotation(HideResult=true);

  Modelica.Blocks.Interfaces.RealInput tielinePowerCollector "Power on tieline to subsystem"  annotation(HideResult=true);
  Modelica.Blocks.Interfaces.RealInput tielineSetPowerCollector "Scheduled imports to subsystem" annotation(HideResult=true);

  Modelica.Blocks.Interfaces.RealInput kineticEnergyCollector[nSubgrids] annotation(HideResult=true);
  Modelica.Blocks.Interfaces.RealInput surroundingGridLoad annotation (HideResult=true,
      Placement(transformation(extent={{22,-110},{42,-90}}),
        iconTransformation(extent={{-16,-16},{16,16}},
        rotation=90,
        origin={0,-87})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Energy E[nTypes]( each start=0, each fixed=true, each stateSelect=StateSelect.never) annotation(HideResult=true);

  // Visible results: Fractions
  Real x_RE_demand = E_renewable_gen / max(simCenter.E_small, E_consumer) "share of RE energy in consumption";
  Real x_RE_generation = E_renewable_gen / max(simCenter.E_small, E_gen_total) "share of RE energy in generation";

  // Visible results: Energies
  SI.Energy E_consumer(start=0)=-E[Types.TypeOfResource.Consumer] "total consumed energy";
  SI.Energy E_gen_total(start=0)=sum(E)+E_consumer "total generated energy";
  SI.Energy E_conventional(start=0)=E[Types.TypeOfResource.Conventional] "total produced energy by conventional plants";
  SI.Energy E_cogen(start=0)=E[Types.TypeOfResource.Cogeneration] "total produced energy by cogeneration plants";
  SI.Energy E_renewable_gen(start=0)=E[Types.TypeOfResource.Renewable] "total produced energy by renewable energy plants";
  SI.Energy E_residual_pos(start=0, fixed=true) "positive residual energy";
  SI.Energy E_residual_neg(start=0, fixed=true) "negative residual energy";
  SI.Energy E_loss(start=0)=E_gen_total-E_consumer "total energy loss";
  SI.Energy E_prim_bal_pos(start=0)=sum(posPBE) "total primary balancing energy positive";
  SI.Energy E_prim_bal_neg(start=0)=-sum(negPBE) "total primary balancing energy negative";

  // Visible result: Power
  SI.ActivePower P_gen_total(start=0) = sum(powerCollector)-powerCollector[Types.TypeOfResource.Consumer]-powerCollector[Types.TypeOfResource.Generic];
  SI.ActivePower P_demand=-powerCollector[Types.TypeOfResource.Consumer];
  SI.ActivePower P_renewable_gen=powerCollector[Types.TypeOfResource.Renewable];
  SI.ActivePower P_residual=P_demand-P_renewable_gen;
  SI.ActivePower P_residual_pos;
  SI.ActivePower P_residual_neg;
  SI.ActivePower P_residual_with_CHP=P_residual-powerCollector[Types.TypeOfResource.Cogeneration];
  SI.ActivePower P_conventional_with_CHP=powerCollector[Types.TypeOfResource.Conventional]+powerCollector[Types.TypeOfResource.Cogeneration];
  SI.ActivePower P_CHP=powerCollector[Types.TypeOfResource.Cogeneration];
  SI.ActivePower P_conventional=powerCollector[Types.TypeOfResource.Conventional];
  SI.ActivePower P_storage=-powerCollector[Types.TypeOfResource.Storage];
  SI.ActivePower P_prim_bal_total(start=0) = sum(primBalPowerCollector);
  SI.ActivePower P_sec_bal_total(start=0) = sum(secBalPowerCollector);
  SI.ActivePower P_prim_bal_pos_offer_total = -primBalPowerOfferCollector[1];
  SI.ActivePower P_prim_bal_neg_offer_total = -primBalPowerOfferCollector[2];
  SI.ActivePower P_sec_bal_pos_offer_total = -secBalPowerOfferCollector[1];
  SI.ActivePower P_sec_bal_neg_offer_total = -secBalPowerOfferCollector[2];


  // primary balancing
  SI.ActivePower posPBP[nTypes] annotation(HideResult=true);
  SI.ActivePower negPBP[nTypes] annotation(HideResult=true);
  SI.Energy posPBE[nTypes](each start=0, each fixed=true) annotation(HideResult=true);
  SI.Energy negPBE[nTypes](each start=0, each fixed=true) annotation(HideResult=true);

  // secondary balancing
  SI.ActivePower posSBP[nTypes]  annotation(HideResult=true);
  SI.ActivePower negSBP[nTypes] annotation(HideResult=true);
  SI.Energy posSBE[nTypes](each start=0, each fixed=true) annotation(HideResult=true);
  SI.Energy negSBE[nTypes](each start=0, each fixed=true) annotation(HideResult=true);

  // inertia time constant
  SI.Energy E_kin_1=-kineticEnergyCollector[simCenter.iDetailedGrid];
  SI.Energy E_kin_2=-kineticEnergyCollector[simCenter.iSurroundingGrid];
  SI.Time T_tc_total=(E_kin_1+E_kin_2)/max(P_demand+surroundingGridLoad,simCenter.P_el_small);
  SI.Time T_tc_1=(E_kin_1)/max(P_demand,simCenter.P_el_small);
  SI.Time T_tc_2=(E_kin_2)/max(surroundingGridLoad,simCenter.P_el_small);


  SI.ActivePower P_tieline = tielinePowerCollector "Total tieline power (including scheduled imports)";
  SI.ActivePower P_import = tielineSetPowerCollector "Scheduled imports to subsystem";
  SI.ActivePower P_ACE=P_tieline-P_import "Area control error (tieline power minus scheduled imports)";

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if integrateElPower then
    der(E)=powerCollector;
  else
    E=zeros(nTypes);
  end if;

  // negative and positive residual powers and energies
  if noEvent(P_residual <0) then
    P_residual_neg=P_residual;
    P_residual_pos=0;
  else
    P_residual_neg=0;
    P_residual_pos=P_residual;
  end if;
  if integrateElPower then
    der(E_residual_neg)=P_residual_neg;
    der(E_residual_pos)=P_residual_pos;
  else
    E_residual_neg=0;
    E_residual_pos=0;
  end if;

  // balancing power

  if integrateElPower then
    der(posPBE) = posPBP;
    der(negPBE) = -negPBP;
    der(posSBE) = posPBP;
    der(negSBE) = -negSBP;
  else
    posPBE = zeros(nTypes);
    negPBE = zeros(nTypes);
    posSBE = zeros(nTypes);
    negSBE = zeros(nTypes);
  end if;

  for i in 1:nTypes loop
    posPBP[i] = max(0, primBalPowerCollector[i]);
    posSBP[i] = max(0, secBalPowerCollector[i]);
    negPBP[i] = min(0, primBalPowerCollector[i]);
    negSBP[i] = min(0, secBalPowerCollector[i]);

  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),      Polygon(
          visible=is_setter,
          points={{-12,81},{-12,3},{-48,3},{0,-65},{44,3},{10,3},{10,81},{6,81},
              {-12,81}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-7,19},{-7,-5},{-23,-5},{3,-33},{27,-5},{11,-5},{11,19},{1,19},
              {-7,19}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={3,-37},
          rotation=180),
        Ellipse(
          extent={{-34,80},{32,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{-4,69},{-14,59}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{14,69},{4,59}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{-16,51},{-26,41}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{12,29},{2,39}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{26,51},{16,41}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{-4,33},{-14,23}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),               Ellipse(
          visible=not is_setter,
          extent={{4,53},{-6,43}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-136,150},{146,106}},
          lineColor={0,0,0},
          textString="%name"),            Polygon(
          points={{-7,19},{-7,-5},{-23,-5},{3,-33},{27,-5},{11,-5},{11,19},{1,19},
              {-7,19}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={63,-37},
          rotation=180),                  Polygon(
          points={{-7,19},{-7,-5},{-23,-5},{3,-33},{27,-5},{11,-5},{11,19},{1,19},
              {-7,19}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-59,-37},
          rotation=180)}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end ElectricPowerStatistics;
