within TransiEnt.Consumer.Systems.FridgePoolControl.Pool;
model FridgePool

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

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

   parameter Integer poolSize = 2;
   parameter Real alpha=-10;
   parameter Real dbf=0.4;

   parameter Real uniqueParams[poolSize,9]
    annotation(HideResult=true);
   parameter Boolean startStatus[poolSize]
    annotation(HideResult=true);

  // total installed power of pool
  final parameter SI.Power P_el_n_pool = sum(uniqueFridge.fridgeFreezer.P_el_n);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

   UniqueFridge uniqueFridge[poolSize](
   each poolSize=poolSize,
   poolIndex=1:poolSize,
   each uniqueParams=uniqueParams,
   each startStatus=startStatus,
   each alpha=alpha,
   each dbf=dbf)
    annotation (Placement(transformation(extent={{-32,-30},{30,30}})));

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{79,-10},{99,10}})));

  // total power of pool
  Real P_el_star_pool = epp.P / P_el_n_pool;
  Real T_star = sum(uniqueFridge.fridgeFreezer.T_star)/poolSize;
  Real SOC = sum(uniqueFridge.fridgeFreezer.SOC)/poolSize;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  for i in  1:poolSize loop
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

    connect(epp, uniqueFridge[i].epp) annotation (Line(
      points={{89,0},{28,0},{26.9,0}},
      color={0,135,135},
      thickness=0.5));
  end for;

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-44,58},{44,-54}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-48,54},{40,-58}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-56,50},{36,-66}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{18,40},{24,16}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,0},{24,-56}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{36,8},{26,8},{-56,8}},    color={0,0,0})}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Check.TestPoolResponse&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end FridgePool;
