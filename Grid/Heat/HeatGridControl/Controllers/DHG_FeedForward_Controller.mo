within TransiEnt.Grid.Heat.HeatGridControl.Controllers;
model DHG_FeedForward_Controller "Assigns output targets to the heat generating plants based on the total expected heat demand"

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
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.LargeController;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

   parameter TransiEnt.Grid.Heat.HeatGridControl.Base.DHGMassFlowCharacteristicLines.GenericMassFlowCharacteristicLines MassFlowCL=Base.DHGMassFlowCharacteristicLines.SampleMassFlowCharacteristicLines() annotation (choicesAllMatching);
  // _____________________________________________
  //
  //             Variables
  // _____________________________________________

    Modelica.SIunits.MassFlowRate m_flow_set;
   Modelica.SIunits.HeatFlowRate Q_flow_set;

  // _____________________________________________
  //
  //             Components
  // _____________________________________________

    TILMedia.VLEFluid_pT h_supply(
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater vleFluidType,
    p=1200000,
    T=supplyandReturnTemperature.T_supply_K)
              annotation (Placement(transformation(extent={{-70,32},{-50,52}})));
  TILMedia.VLEFluid_pT h_return(
    redeclare TILMedia.VLEFluidTypes.TILMedia_InterpolatedWater vleFluidType,
    p=600000,
    T=supplyandReturnTemperature.T_return_K)
              annotation (Placement(transformation(extent={{-48,32},{-28,52}})));

  // _____________________________________________
  //
  //             Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput T_ambient annotation (Placement(transformation(extent={{-166,-6},{-154,6}}),  iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput Q_dot_DH_Targ annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,110})));

  SupplyAndReturnTemperatureDHG
                             supplyandReturnTemperature
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  MassFlowCharacteristicLines                                    massFlowRestrictions(MassFlowCL=MassFlowCL)
                                                                         annotation (Placement(transformation(extent={{46,-58},{66,-38}})));

  Modelica.Blocks.Sources.RealExpression m_flow_set_source(y=m_flow_set) "in kg/s"
                                                                         annotation (Placement(transformation(extent={{-26,-57},{4,-39}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_i[size(massFlowRestrictions.combiTable1Ds.columns, 1)](final quantity="MassFlowRate", final unit="kg/s") annotation (Placement(transformation(extent={{140,-58},{160,-38}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_i[size(massFlowRestrictions.combiTable1Ds.columns, 1)](final quantity="HeatFlowRate", final unit="W") annotation (Placement(transformation(extent={{140,48},{160,68}})));
  Basics.Blocks.Sources.RealVectorExpression Q_flow_calc(nout=size(massFlowRestrictions.combiTable1Ds.columns, 1), y_set=vector(m_flow.y .* delta_h.y)) annotation (Placement(transformation(extent={{24,48},{44,68}})));

  Modelica.Blocks.Sources.RealExpression delta_h(y=h_supply.h - h_return.h) annotation (Placement(transformation(extent={{-18,34},{12,56}})));
  Basics.Blocks.Sources.RealVectorExpression m_flow(nout=size(massFlowRestrictions.combiTable1Ds.columns, 1), y_set=massFlowRestrictions.m_flow_i) annotation (Placement(transformation(extent={{-8,56},{12,76}})));
equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

   Q_flow_set=Q_dot_DH_Targ;
   m_flow_set=Q_flow_set/(h_supply.h-h_return.h);
//
//   MassFlowEast_sc=-1*MassFlowEast;
//   MassFlowWest_sc=-1*MassFlowWest;
//   MassFlowCenter_sc=-1*MassFlowCenter;
//   MassFlowWUWSPS_sc=-1*MassFlowWUWSPS;
//   MassFlowWW1_sc=-1*schedulingTwoBlocks.y/(h_supply.h-h_return.h);
//   MassFlowWW2_sc=-1*schedulingTwoBlocks.y1/(h_supply.h-h_return.h);
//
//   TargetHeatFlowEast_sc=-1*TargetHeatFlowEast;
//   TargetHeatFlowWest_sc=-1*TargetHeatflowWest;
//   TargetHeatFlowCenter_sc=-1*TargetHeatflowCenter;
//   TargetHeatFlowWUWSPS_sc=-1*TargetHeatFlowWUWSPS;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(m_flow_set_source.y, massFlowRestrictions.m_flow_total) annotation (Line(points={{5.5,-48},{44,-48}},    color={0,0,127}));
  connect(Q_flow_calc.y, Q_flow_i) annotation (Line(points={{45,58},{150,58}}, color={0,0,127}));
  connect(massFlowRestrictions.m_flow_i, m_flow_i) annotation (Line(points={{67,-48},{86,-48},{150,-48}},      color={0,0,127}));

  //General annotations
  connect(T_ambient, supplyandReturnTemperature.T_amb) annotation (Line(points={{-160,0},{-142,0},{-142,0}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{140,100}})),
    experiment(StopTime=3.1536e+007),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-160,-100},{140,100}}, preserveAspectRatio=false),
                    graphics={
        Text(
          extent={{-56,120},{60,44}},
          lineColor={0,127,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Q_flow_tot"),
        Text(
          extent={{34,-27},{-34,27}},
          lineColor={0,128,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={85,54},
          rotation=90,
          textString="Q_flow [i]"),
        Text(
          extent={{-40,36},{40,-36}},
          lineColor={0,128,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-84,4},
          rotation=90,
          textString="T_amb"),
        Text(
          extent={{-37.5,21.5},{37.5,-21.5}},
          lineColor={0,128,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="m_flow [i]",
          origin={85.5,-38.5},
          rotation=90)}),
    Documentation(info="<html>
<h4><span style=\"color:#008000\">District Heating Network Control</span></h4>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This component takes the predicted heat load in a given district heating network and determines the output target for the heating condensers or heat exchangers heat demand of the city (in this case three units). </p>
<p>In other words, this components takes care of the formation of output targets for the district heating units.</p>
<p><br><br><h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4></p>
<p>The model considers </p>
<ul>
<li>The supply temperature according to the contract of the company (SupplyTemperature)</li>
<li>The return temperature according to the ... law (ReturnTemperature)</li>
<li>The mass flow restrictions of each branch (massFlowRestrictions_EWC)</li>
</ul>
<p><br>It is assumed that these values are known by the network operator. The values should be added to the tables.</p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>Inputs: </p>
<ul>
<li>Ambient Temperature in &deg;C</li>
<li>Expected load in the district heating network in W</li>
</ul>
<p>Outputs:</p>
<ul>
<li>Target heatflow output at east branch</li>
<li>Target heatflow output at west branch</li>
<li>Target heatflow output at center </li>
</ul>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color:#008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color:#008000\">9. Validation</span></h4>
<p>(no remarks)</p>
</html>"));
end DHG_FeedForward_Controller;