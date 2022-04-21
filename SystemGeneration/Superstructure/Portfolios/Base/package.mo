within TransiEnt.SystemGeneration.Superstructure.Portfolios;
package Base


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



  extends TransiEnt.Basics.Icons.BasesPackage;

  replaceable partial type PowerPlantType = enumeration(:);

  replaceable partial model PowerPlantSystem


    // _____________________________________________
    //
    //          Imports and Class Hierarchy
    // _____________________________________________

    extends TransiEnt.Basics.Icons.Model;

    // _____________________________________________
    //
    //                 Outer Models
    // _____________________________________________

    outer TransiEnt.SimCenter simCenter;

    replaceable package Config = Base constrainedby Base               annotation (choicesAllMatching=true);

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________

    TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set annotation (Placement(transformation(rotation=0, extent={{-112,88},{-100,100}}), iconTransformation(extent={{-111,87},{-101,101}})));
    TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_OUT annotation (Placement(transformation(rotation=0, extent={{-5,95},{5,105}}), iconTransformation(extent={{-5,95},{5,105}})));
    TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=simCenter.gasModel1) annotation (Placement(transformation(rotation=0, extent={{90,-10},{110,10}})));
    Superstructure.Components.ControlBus controlBus annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={-102,0})));
    Modelica.Blocks.Interfaces.RealOutput P_max_noCCs annotation (Placement(transformation(extent={{-100,66},{-112,78}}), iconTransformation(extent={{-100,66},{-112,78}})));
    TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_Powerplant_is annotation (Placement(transformation(extent={{100,84},{112,96}}), iconTransformation(extent={{100,84},{112,96}})));
    TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_Powerplant_is annotation (Placement(transformation(extent={{100,64},{112,76}}),iconTransformation(extent={{100,64},{112,76}})));

    annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(coordinateSystem(extent={{-100,-80},{100,100}}), graphics={Ellipse(
                  extent={{-60,68},{78,-70}},
                  lineColor={3,132,132},
                  lineThickness=0.5,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Ellipse(
                  extent={{-66,68},{72,-70}},
                  lineColor={3,132,132},
                  lineThickness=0.5,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Ellipse(
                  extent={{-74,68},{64,-70}},
                  lineColor={3,132,132},
                  lineThickness=0.5,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Ellipse(
                  extent={{-82,68},{56,-70}},
                  lineColor={3,132,132},
                  lineThickness=0.5,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{-22,8},{18,-48}},
                  lineColor={95,95,95},
                  fillColor={0,134,134},
                  fillPattern=FillPattern.VerticalCylinder),Rectangle(
                  extent={{-58,38},{-50,-32}},
                  lineColor={95,95,95},
                  fillColor={0,134,134},
                  fillPattern=FillPattern.VerticalCylinder),Rectangle(
                  extent={{-60,-12},{-6,-50}},
                  lineColor={95,95,95},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{-56,-18},{-48,-24}},
                  lineColor={95,95,95},
                  fillPattern=FillPattern.Solid,
                  fillColor={215,215,215}),Rectangle(
                  extent={{-44,-18},{-36,-24}},
                  lineColor={95,95,95},
                  fillPattern=FillPattern.Solid,
                  fillColor={215,215,215}),Rectangle(
                  extent={{-32,-18},{-24,-24}},
                  lineColor={95,95,95},
                  fillPattern=FillPattern.Solid,
                  fillColor={215,215,215}),Rectangle(
                  extent={{-20,-18},{-12,-24}},
                  lineColor={95,95,95},
                  fillPattern=FillPattern.Solid,
                  fillColor={215,215,215}),Polygon(
                  points={{-14,10},{-2,10},{2,10},{20,22},{20,30},{18,38},{18,40},{20,48},{20,50},{16,50},{6,48},{6,46},{2,44},{0,42},{-10,36},{-12,34},{-14,34},{-16,30},{-20,26},{-22,26},{-10,24},{-12,14},{-14,10}},
                  lineColor={95,95,95},
                  smooth=Smooth.None,
                  fillColor={215,215,215},
                  fillPattern=FillPattern.Solid),Polygon(
                  points={{-58,40},{-54,40},{-52,40},{-46,40},{-44,42},{-34,48},{-32,48},{-20,56},{-16,58},{-12,60},{-10,62},{-6,64},{-4,66},{-16,68},{-20,66},{-28,62},{-34,60},{-36,56},{-40,54},{-42,52},{-46,50},{-48,48},{-50,46},{-52,44},{-54,44},{-58,44},{-58,40}},
                  lineColor={95,95,95},
                  smooth=Smooth.None,
                  fillColor={215,215,215},
                  fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for submodel of the powerplant system to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>controlBus</li>
<li>P_el_set</li>
<li>gasPortIn and gasPortIn1</li>
</ul>
<p>Outputs:</p>
<ul>
<li>epp</li>
<li>P_max_noCCs</li>
<li>P_Powerplant_is</li>
<li>gasPortOut for CO2 deposition</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure. An <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example.PowerPlantType\">enumeration</a> of all possible types has to be maintained alongside this model.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));

  end PowerPlantSystem;

  extends TransiEnt.Basics.Icons.Package;

  replaceable partial type ElectricalStorageType = enumeration(:);

  replaceable partial model ElectricalStorageSystem

    // _____________________________________________
    //
    //          Imports and Class Hierarchy
    // _____________________________________________

    extends TransiEnt.Basics.Icons.Model;

    replaceable package Config = Base constrainedby Base               annotation (choicesAllMatching=true);

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________

    TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_set annotation (Placement(transformation(rotation=0, extent={{-132,62},{-99,97}})));
    TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp annotation (Placement(transformation(rotation=0, extent={{95,-5},{105,5}})));

    // _____________________________________________
    //
    //             Variable Declarations
    // _____________________________________________
    Modelica.Blocks.Interfaces.RealOutput P_max_load_storage annotation (Placement(transformation(extent={{100,-36},{132,-4}})));
    Modelica.Blocks.Interfaces.RealOutput P_max_unload_storage annotation (Placement(transformation(extent={{100,-74},{132,-42}})));
    Modelica.Blocks.Interfaces.RealOutput P_storage_is annotation (Placement(transformation(extent={{100,-106},{132,-74}})));
    Modelica.Blocks.Interfaces.RealOutput E_storage_is annotation (Placement(transformation(extent={{100,54},{132,86}})));
    annotation (Icon(graphics={Ellipse(
                  lineColor={0,125,125},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  extent={{-82,-86},{90,86}}),Ellipse(
                  lineColor={0,125,125},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  extent={{-88,-86},{84,86}}),Rectangle(
                  extent={{-31,-2},{51,-30}},
                  lineColor={0,134,134},
                  fillColor={0,134,134},
                  fillPattern=FillPattern.VerticalCylinder),Line(points={{-31,-32},{-30,2},{50,0},{51,-32}}, color={0,0,0}),Ellipse(
                  lineColor={0,125,125},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  extent={{-94,-86},{78,86}}),Ellipse(
                  lineColor={0,125,125},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  extent={{-100,-86},{72,86}}),Rectangle(
                  extent={{-70,8},{36,-44}},
                  lineColor={95,95,95},
                  fillColor={215,215,215},
                  fillPattern=FillPattern.Solid),Polygon(
                  points={{36,-44},{36,8},{52,24},{52,-24},{36,-44}},
                  lineColor={95,95,95},
                  smooth=Smooth.None,
                  fillColor={177,177,177},
                  fillPattern=FillPattern.Solid),Polygon(
                  points={{36,8},{36,22},{52,38},{52,24},{36,8}},
                  lineColor={95,95,95},
                  smooth=Smooth.None,
                  fillColor={57,57,57},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{-70,8},{36,22}},
                  lineColor={95,95,95},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),Polygon(
                  points={{-70,22},{-40,38},{52,38},{36,22},{-70,22}},
                  lineColor={95,95,95},
                  smooth=Smooth.None,
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),Polygon(
                  points={{4,26},{16,32},{30,32},{20,26},{4,26}},
                  lineColor={255,0,0},
                  smooth=Smooth.None,
                  fillColor={255,143,7},
                  fillPattern=FillPattern.Solid),Polygon(
                  points={{-42,26},{-30,32},{-16,32},{-26,26},{-42,26}},
                  lineColor={255,0,0},
                  smooth=Smooth.None,
                  fillColor={255,143,7},
                  fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for a submodel of an electrical storage system to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>One gasPortOut[nRegions, n_gasPort]</p>
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
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end ElectricalStorageSystem;

  replaceable partial type PowerToGasType = enumeration(:);

  replaceable partial model PowerToGasSystem

    // _____________________________________________
    //
    //          Imports and Class Hierarchy
    // _____________________________________________

    extends TransiEnt.Basics.Icons.Model;

    replaceable package Config = Base constrainedby Base               annotation (choicesAllMatching=true);

    // _____________________________________________
    //
    //                 Outer Models
    // _____________________________________________

    outer TransiEnt.SimCenter simCenter;

    // _____________________________________________
    //
    //              Visible Parameters
    // _____________________________________________

    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Natural Gas model to be used" annotation (Dialog(tab="General", group="General"));
    parameter Integer usageOfWasteHeatOfPtG;
    parameter Boolean useHydrogenFromPtGInPowerPlants;

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________

    TransiEnt.SystemGeneration.Superstructure.Components.ControlBus controlBus annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={-108,0})));

    TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P(start=0) annotation (Placement(transformation(rotation=0, extent={{-99,-31},{-109,-21}})));
    TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_gas_out(start=0) annotation (Placement(transformation(rotation=0, extent={{-99,-61},{-109,-51}})));
    TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_IN annotation (Placement(transformation(rotation=0, extent={{-25,95},{-15,105}})));
    TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_OUT annotation (Placement(transformation(rotation=0, extent={{11,95},{21,105}})));
    TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=simCenter.fluid1) if usageOfWasteHeatOfPtG == 3 annotation (Placement(transformation(rotation=0, extent={{-45,-105},{-35,-95}})));
    TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=simCenter.fluid1) if usageOfWasteHeatOfPtG == 3 annotation (Placement(transformation(rotation=0, extent={{-65,-105},{-55,-95}})));
    TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut_1(each Medium=medium) annotation (Placement(transformation(rotation=0, extent={{95,-25},{105,-15}})));
    TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut_H2_toPowerPlant(Medium=medium) if useHydrogenFromPtGInPowerPlants annotation (Placement(transformation(rotation=0, extent={{95,15},{105,25}})));
    TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut Pel_wasteHeatBoiler if usageOfWasteHeatOfPtG == 2 annotation (Placement(transformation(rotation=0, extent={{-99,-45},{-109,-35}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a if usageOfWasteHeatOfPtG == 2 annotation (Placement(transformation(rotation=0, extent={{55,-105},{65,-95}})));

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

  equation

    annotation (
      Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
      Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
          Ellipse(
            extent={{-68,58},{66,-70}},
            lineColor={3,132,132},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-82,59},{52,-69}},
            lineColor={3,132,132},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-18,14},{-28,-2},{-20,-2},{-34,-22},{-26,-22},{-38,-42},{-6,-8},{-14,-8},{-2,6},{-10,6},{-4,14},{-18,14}},
            lineColor={238,46,47},
            lineThickness=0,
            fillColor={255,255,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-36,-38},{-2,-72}},
            lineColor={0,0,255},
            textString="H2O"),
          Text(
            extent={{-10,42},{30,14}},
            lineColor={162,210,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="H2"),
          Text(
            extent={{-70,42},{-18,16}},
            lineColor={85,170,255},
            textString="O2")}),
      Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for submodel of the power to gas system to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>controlBus</li>
<li>P_el_set</li>
<li>gasPortIn and gasPortIn1</li>
</ul>
<p>Outputs:</p>
<ul>
<li>epp</li>
<li>P_max_noCCs</li>
<li>P_Powerplant_is</li>
<li>gasPortOut for CO2 deposition</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure. An <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example.PowerPlantType\">enumeration</a> of all possible types has to be maintained alongside this model.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end PowerToGasSystem;

  replaceable partial type GasStorageType = enumeration(:);

  replaceable partial model GasStorageSystem




    // _____________________________________________
    //
    //          Imports and Class Hierarchy
    // _____________________________________________

    extends TransiEnt.Basics.Icons.Model;

    // _____________________________________________
    //
    //                 Outer Models
    // _____________________________________________

    outer TransiEnt.SimCenter simCenter;

    replaceable package Config = Base constrainedby Base               annotation (choicesAllMatching=true);

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________

    TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=simCenter.gasModel1) annotation (Placement(transformation(rotation=0, extent={{95,-13},{105,-3}})));
    TransiEnt.SystemGeneration.Superstructure.Components.ControlBus controlBus annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={-100,0}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={-100,0})));
    Modelica.Blocks.Interfaces.RealOutput m_storage annotation (Placement(transformation(extent={{100,60},{120,80}})));
    Modelica.Blocks.Interfaces.RealOutput m_flow_storage annotation (Placement(transformation(extent={{100,40},{120,60}})));

    // _____________________________________________
    //
    //             Variable Declarations
    // _____________________________________________
    SI.Mass m_gas;
    annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Ellipse(
                  lineColor={0,125,125},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  extent={{-100,-100},{100,100}}),Ellipse(
                  extent={{-69,-26},{13,-68}},
                  lineColor={0,0,0},
                  fillColor={255,255,170},
                  fillPattern=FillPattern.VerticalCylinder),Rectangle(
                  extent={{-69,38},{13,-48}},
                  lineColor={0,0,0},
                  fillColor={255,255,170},
                  fillPattern=FillPattern.VerticalCylinder),Ellipse(
                  extent={{-69,64},{13,14}},
                  lineColor={0,0,0},
                  fillColor={255,255,170},
                  fillPattern=FillPattern.Solid),Ellipse(
                  extent={{-45,49},{-11,31}},
                  lineColor={0,0,0},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid),Ellipse(
                  extent={{-45,53},{-11,35}},
                  lineColor={0,0,0},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-58,8},{2,-52}},
                  lineColor={0,0,0},
                  textString="L2"),Line(
                  points={{-26,46},{34,46},{34,-40},{98,-40}},
                  color={0,0,0},
                  thickness=1),Line(
                  points={{46,48},{62,32},{62,48},{46,32},{46,48}},
                  color={0,0,0},
                  thickness=1),Line(
                  points={{98,40},{34,40}},
                  color={0,0,0},
                  thickness=1),Line(
                  points={{46,-32},{62,-48},{62,-32},{46,-48},{46,-32}},
                  color={0,0,0},
                  thickness=1)}),
      Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for submodel of the gas storage system to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>controlBus</li>
</ul>
<p>Outputs:</p>
<ul>
<li>gasPortIn</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure. An <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example.GasStorageType\">enumeration</a> of all possible types has to be maintained alongside this model.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end GasStorageSystem;
  //    replaceable partial type LocalDemandType = enumeration(:);

  replaceable partial model LocalDemand

    // _____________________________________________
    //
    //          Imports and Class Hierarchy
    // _____________________________________________

    extends TransiEnt.Basics.Icons.Household;

    replaceable package Config = Base constrainedby Base               annotation (choicesAllMatching=true);

    // _____________________________________________
    //
    //                 Outer Models
    // _____________________________________________

    outer TransiEnt.SimCenter simCenter;

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________
    TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{90,30},{110,50}})));
    TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
    Modelica.Blocks.Interfaces.RealInput Q_flow annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
    Modelica.Blocks.Interfaces.RealOutput Load annotation (Placement(transformation(extent={{100,-106},{128,-78}})));

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

    Modelica.Blocks.Sources.RealExpression realExpression(y=epp.P) annotation (Placement(transformation(extent={{52,-150},{72,-130}})));

  equation
    connect(realExpression.y, Load) annotation (Line(points={{73,-140},{78,-140},{78,-92},{114,-92}}, color={0,0,127}));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
      Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for submodel of the local demand to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>Q_flow</li>
</ul>
<p>Outputs:</p>
<ul>
<li>gasPortOut</li>
<li>epp</li>
<li>Load</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end LocalDemand;
  //    replaceable partial type LocalDemandType = enumeration(:);

  replaceable partial model LocalRenewableProduction

    // _____________________________________________
    //
    //          Imports and Class Hierarchy
    // _____________________________________________

    extends TransiEnt.Basics.Icons.Windmodel;

    replaceable package Config = Base constrainedby Base               annotation (choicesAllMatching=true);

    // _____________________________________________
    //
    //                 Outer Models
    // _____________________________________________

    outer TransiEnt.SimCenter simCenter;

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________
    TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
    TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
    Modelica.Blocks.Interfaces.RealOutput P_RE_potential annotation (Placement(transformation(extent={{100,82},{120,102}})));
    Modelica.Blocks.Interfaces.RealInput P_curtailment annotation (Placement(transformation(extent={{-140,76},{-100,116}})));

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

  equation

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Submodel of the local renewable production to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p><br>(no remarks)</p><p><br><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>P_curtailment</li>
</ul>
<p>Outputs:</p>
<ul>
<li>gasPortOut</li>
<li>epp</li>
<li>P_RE_potential</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end LocalRenewableProduction;
  //    replaceable partial type LocalDemandType = enumeration(:);

  replaceable partial model CO2System

    // _____________________________________________
    //
    //          Imports and Class Hierarchy
    // _____________________________________________

    extends TransiEnt.Basics.Icons.Model;

    replaceable package Config = Base constrainedby Base               annotation (choicesAllMatching=true);

    // _____________________________________________
    //
    //                 Outer Models
    // _____________________________________________

    outer TransiEnt.SimCenter simCenter;

    // _____________________________________________
    //
    //              Visible Parameters
    // _____________________________________________

    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the gas storage" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);
    parameter Boolean CO2NeededForPowerToGas;
    parameter Real CO2StorageNeeded;
    parameter Integer nPowerPlants;

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________

    TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp if CO2NeededForPowerToGas annotation (Placement(transformation(rotation=0, extent={{50,92},{70,112}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a if CO2NeededForPowerToGas annotation (Placement(transformation(rotation=0, extent={{-70,90},{-50,110}})));
    TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn[nPowerPlants](each Medium=medium) annotation (Placement(transformation(rotation=0, extent={{92,50},{112,70}})));
    TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) if CO2NeededForPowerToGas annotation (Placement(transformation(rotation=0, extent={{90,-50},{110,-30}})));

    // _____________________________________________
    //
    //             Variable Declarations
    // _____________________________________________

    // _____________________________________________
    //
    //           Instances of other Classes
    // _____________________________________________

    TransiEnt.SystemGeneration.Superstructure.Components.ControlBus controlBus annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={-100,0})));
    TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el(start=0) if CO2NeededForPowerToGas annotation (Placement(transformation(rotation=0, extent={{-99,-25},{-109,-15}})));

    Modelica.Blocks.Interfaces.RealOutput m_flow_fromPowerplants annotation (Placement(transformation(extent={{100,-78},{120,-58}})));
    Modelica.Blocks.Interfaces.RealOutput m_flow_toPtG annotation (Placement(transformation(extent={{100,-98},{120,-78}})));
  equation

    annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Ellipse(
                  extent={{-81,-24},{1,-66}},
                  lineColor={0,0,0},
                  fillColor={255,255,170},
                  fillPattern=FillPattern.VerticalCylinder),Rectangle(
                  extent={{-81,40},{1,-46}},
                  lineColor={0,0,0},
                  fillColor={255,255,170},
                  fillPattern=FillPattern.VerticalCylinder),Ellipse(
                  extent={{-81,66},{1,16}},
                  lineColor={0,0,0},
                  fillColor={255,255,170},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-70,16},{-10,-44}},
                  lineColor={0,0,0},
                  textString="CO2"),Polygon(
                  points={{16,80},{16,28},{76,0},{76,62},{16,80}},
                  lineColor={28,108,200},
                  lineThickness=1,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Ellipse(
                  extent={{-12,6},{12,-6}},
                  lineColor={28,108,200},
                  lineThickness=1,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  origin={26,36},
                  rotation=270),Ellipse(
                  extent={{-12,6},{12,-6}},
                  lineColor={28,108,200},
                  lineThickness=1,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  origin={42,30},
                  rotation=270),Ellipse(
                  extent={{-12,6},{12,-6}},
                  lineColor={28,108,200},
                  lineThickness=1,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  origin={58,22},
                  rotation=270),Ellipse(
                  extent={{-12,6},{12,-6}},
                  lineColor={28,108,200},
                  lineThickness=1,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  origin={28,62},
                  rotation=270),Ellipse(
                  extent={{-12,6},{12,-6}},
                  lineColor={28,108,200},
                  lineThickness=1,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  origin={44,56},
                  rotation=270),Ellipse(
                  extent={{-12,6},{12,-6}},
                  lineColor={28,108,200},
                  lineThickness=1,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  origin={60,48},
                  rotation=270)}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Submodel of CO2 storage and direct air capture to be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Inputs:</p>
<ul>
<li>heat port for DAC</li>
<li>gasPortIn</li>
</ul>
<p>Outputs:</p>
<ul>
<li>gasPortOut</li>
<li>epp</li>
<li>P_el for DAC</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end CO2System;
  //    replaceable partial type LocalDemandType = enumeration(:);

  replaceable partial model HeatingGrid

    // _____________________________________________
    //
    //          Imports and Class Hierarchy
    // _____________________________________________

    extends TransiEnt.Basics.Icons.Model;

    // _____________________________________________
    //
    //                 Outer Models
    // _____________________________________________

    outer TransiEnt.SimCenter simCenter;
    parameter Boolean useExternalHeatSource=false;

    // _____________________________________________
    //
    //                  Interfaces
    // _____________________________________________

    TransiEnt.Basics.Interfaces.Thermal.FluidPortIn WaterPortIn_ExternalHeatSource(Medium=medium_water) if useExternalHeatSource annotation (Placement(transformation(extent={{-50,-112},{-30,-92}})));
    TransiEnt.Basics.Interfaces.Thermal.FluidPortOut WaterPortOut_ExternalHeatSource(Medium=medium_water) if useExternalHeatSource annotation (Placement(transformation(extent={{30,-112},{50,-92}})));
    TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp "Choice of power port" annotation (Placement(transformation(extent={{90,-60},{110,-40}}), iconTransformation(extent={{80,-68},{110,-40}})));
    TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{90,-100},{110,-80}})));
    Modelica.Blocks.Interfaces.RealOutput P_ElectricalHeater_max annotation (Placement(transformation(extent={{100,76},{128,104}})));
    Modelica.Blocks.Interfaces.RealOutput P_el_CHP annotation (Placement(transformation(extent={{100,46},{128,74}})));
    Modelica.Blocks.Interfaces.RealInput P_set_ElectricalHeater annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
    Modelica.Blocks.Interfaces.RealInput Q_demand annotation (Placement(transformation(extent={{-140,22},{-100,62}})));
    Modelica.Blocks.Interfaces.RealOutput m_flow_gas annotation (Placement(transformation(extent={{100,16},{128,44}})));

    annotation (Icon(graphics={Line(
                  points={{34,12},{34,40},{34,70},{-18,70},{-44,70},{-44,-66},{-18,-66},{34,-66},{34,-38}},
                  color={175,0,0},
                  thickness=0.5),Rectangle(
                  extent={{-82,18},{-48,14}},
                  lineColor={175,0,0},
                  fillColor={175,0,0},
                  fillPattern=FillPattern.Solid),Polygon(
                  points={{-54,22},{-54,10},{-44,16},{-54,22}},
                  lineColor={175,0,0},
                  smooth=Smooth.None,
                  fillColor={175,0,0},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{-82,2},{-48,-2}},
                  lineColor={175,0,0},
                  fillColor={175,0,0},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{-82,-14},{-48,-18}},
                  lineColor={175,0,0},
                  fillColor={175,0,0},
                  fillPattern=FillPattern.Solid),Polygon(
                  points={{-54,6},{-54,-6},{-44,0},{-54,6}},
                  lineColor={175,0,0},
                  smooth=Smooth.None,
                  fillColor={175,0,0},
                  fillPattern=FillPattern.Solid),Polygon(
                  points={{-54,-10},{-54,-22},{-44,-16},{-54,-10}},
                  lineColor={175,0,0},
                  smooth=Smooth.None,
                  fillColor={175,0,0},
                  fillPattern=FillPattern.Solid),Line(
                  points={{46,-10},{46,20},{74,20},{74,-10}},
                  color={0,0,0},
                  thickness=0.5),Line(
                  points={{44,18},{60,34},{76,18}},
                  color={0,0,0},
                  thickness=0.5),Line(
                  points={{34,-38},{34,8},{46,8}},
                  color={175,0,0},
                  thickness=0.5),Line(
                  points={{34,12},{34,12},{46,12}},
                  color={175,0,0},
                  thickness=0.5)}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for submodel of a local heating grid to be used inside a superstructure. Model is in developement and not usable.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>To be used inside a superstructure.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model adjusted by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
  end HeatingGrid;

annotation (Icon(graphics={
        Ellipse(
          extent={{-30,-18},{30,42}},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Base;
