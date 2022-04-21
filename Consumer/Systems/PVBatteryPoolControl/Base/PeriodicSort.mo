within TransiEnt.Consumer.Systems.PVBatteryPoolControl.Base;
model PeriodicSort "Sorts the values in input vector by value periodically (e.g. sort PBP offer by value every week before auction)"


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

  extends TransiEnt.Basics.Icons.DiscreteBlock;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer PoolParameter param;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real algoWeekUnsortedPotentialPBP_temp[:](start=fill(param.P_el_max_bat,param.nSystems));
  Real algoWeekSortedPotentialPBP[:](start=fill(param.P_el_max_bat,param.nSystems));
  Real algoWeekSortedPotentialPBP_temp[:](start=fill(param.P_el_max_bat,param.nSystems));
  Real algoWeekUnsortedPotentialPBP[:](start=fill(param.P_el_max_bat,param.nSystems));
  Real algoSumPotentialPBP(start=0);
  Real sumPotentialPBP(start=0);
  Modelica.Blocks.Interfaces.IntegerInput week(start=0)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={40,-118})));
  Modelica.Blocks.Interfaces.IntegerInput samplerate(start=0)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={76,-118})));
  Modelica.Blocks.Interfaces.RealOutput weekSortedPotentialPBP[param.nSystems](start=fill(param.P_el_max_bat,param.nSystems))
  annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-110})));
  Modelica.Blocks.Interfaces.RealOutput weekUnsortedPotentialPBP[param.nSystems](start=fill(param.P_el_max_bat,param.nSystems))
  annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealOutput sortedVector[param.nSystems](start=zeros(param.nSystems))
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput unsortedVector[param.nSystems](start=zeros(param.nSystems))
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.IntegerOutput indexVector[param.nSystems](start=ones(param.nSystems))
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
algorithm
  when initial() or change(week) then
    for n in 1:param.nSystems loop
      algoWeekUnsortedPotentialPBP[n]:=pre(algoWeekUnsortedPotentialPBP_temp[n]);
      algoWeekUnsortedPotentialPBP_temp[n]:=param.P_el_max_bat;
      algoWeekSortedPotentialPBP[n]:=pre(algoWeekSortedPotentialPBP_temp[n]);
      algoWeekSortedPotentialPBP_temp[n]:=param.P_el_max_bat;
    end for;
    algoSumPotentialPBP:=sum(algoWeekSortedPotentialPBP);
  elsewhen change(samplerate) then
    for n in 1:param.nSystems loop
      if unsortedVector[n]<pre(algoWeekUnsortedPotentialPBP_temp[n]) then
        algoWeekUnsortedPotentialPBP_temp[n]:=unsortedVector[n];
      end if;
      if sortedVector[n]<pre(algoWeekSortedPotentialPBP_temp[n]) then
        algoWeekSortedPotentialPBP_temp[n]:=sortedVector[n];
      end if;
    end for;
  end when;
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
    for n in 1:param.nSystems loop
      weekSortedPotentialPBP[n]=algoWeekSortedPotentialPBP[n];
      weekUnsortedPotentialPBP[n]=algoWeekUnsortedPotentialPBP[n];
    end for;
    sumPotentialPBP=algoSumPotentialPBP;
    (sortedVector, indexVector)=Modelica.Math.Vectors.sort(unsortedVector,
    ascending=false);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{-92,51},{-52,-49}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Rectangle(
            extent={{48,50},{88,-50}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Polygon(
            points={{-96.41,1.9079},{-96.41,-2.09208},{-92.41,-0.09208},{-96.41,1.9079}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Line(points={{-74,2},{-62.1395,12.907},{-51.1395,12.907}}, color={0,0,
                127}),
          Line(points={{-75,4},{-61,40},{-51,40}}, color={0,0,127}),
          Line(points={{-115,0},{-78.0373,-0.01802}},   color={0,0,127}),
          Ellipse(
            extent={{-83.0437,4.5925},{-73.0437,-4.9075}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Line(points={{-75,-5},{-62,-40},{-51,-40}}, color={0,0,127}),
          Line(points={{-74,-2},{-62.0698,-12.907},{-51.0698,-12.907}}, color={
                0,0,127}),
          Polygon(
            points={{-50.8808,-11},{-50.8808,-15},{-46.8808,-13},{-50.8808,-11}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Line(points={{-48,13},{-37,13},{33,-30},{43,-30}}, color={0,0,127}),
          Line(points={{-47,40},{-37,40},{33,0},{42,0}}, color={0,0,127}),
          Line(points={{-47,-40},{-36,-40},{33,30},{42,30}}, color={0,0,127}),
          Polygon(
            points={{-51,42},{-51,38},{-47,40},{-51,42}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Polygon(
            points={{-50.8728,-38.0295},{-50.8728,-42.0295},{-46.8728,-40.0295},{-50.8728,-38.0295}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Polygon(
            points={{-50.9983,14.8801},{-50.9983,10.8801},{-46.9983,12.8801},{-50.9983,14.8801}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Ellipse(
            extent={{81.3052,4.1274},{91.3052,-5.37257}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Polygon(
            points={{41.1618,32.3085},{41.1618,28.3085},{45.1618,30.3085},{41.1618,32.3085}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Polygon(
            points={{41.2575,1.8044},{41.2575,-2.19557},{45.2575,-0.19557},{41.2575,1.8044}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Polygon(
            points={{41.8805,-28.1745},{41.8805,-32.1745},{45.8805,-30.1745},{41.8805,-28.1745}},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Line(points={{46,0},{68,0}}, color={0,0,127}),
          Line(points={{45,30},{58,30},{71,3}}, color={0,0,127}),
          Line(points={{47,-30},{58,-30},{72,-4}}, color={0,0,127})}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>week: Integer Input</p>
<p>samplerate: Integer Input</p>
<p>weekSortedPotentialPBP[param.nSystems]: RealOutput</p>
<p>weekUnsortedPotentialPBP[param.nSystems]: RealOutput</p>
<p>sortedVector[param.nSystems]:RealOutput</p>
<p>unsortedVector[param.nSystems]: RealInput</p>
<p>indexVector[param.nSystems]: Integer Output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end PeriodicSort;
