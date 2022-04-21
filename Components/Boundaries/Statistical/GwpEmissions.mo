within TransiEnt.Components.Boundaries.Statistical;
model GwpEmissions "Source component for gwp emissions "



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
  //             Visible Parameters
  // _____________________________________________

  parameter Boolean useInputConnector = true "Gets parameter from input connector"
    annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(group="Boundary"));

  parameter TransiEnt.Basics.Units.MassFlowOfCDE m_flow_const=0 "Constant boundary"
  annotation (Dialog(group="Boundary", enable = not useInputConnector));

  parameter Boolean change_sign=false "Change sign on input value" annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(group="Boundary"));

  parameter Boolean isHeatEmission = true "False, emissions captured as electrical system emissions" annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(group="Boundary"));

  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat typeOfPrimaryEnergyCarrierHeat=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.Others "Type of primary energy carrier for co2 emissions global statistics"
  annotation (Dialog(group="Boundary", enable = isHeatEmission));

  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.Others "Type of primary energy carrier for co2 emissions global statistics"
  annotation (Dialog(group="Boundary", enable = not isHeatEmission));


  // _____________________________________________
  //
  //                  Outer models
  // _____________________________________________

  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

 Modelica.Blocks.Interfaces.RealInput m_flow_set(final quantity="MassFlowRate", final unit= "kg/s", displayUnit="kg/s") if useInputConnector "active power input"
                                                                 annotation (Placement(transformation(extent={{-140,60},{-100,100}},
          rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,120})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  Modelica.Blocks.Interfaces.RealInput m_flow_internal(final quantity="MassFlowRate", final unit= "kg/s", displayUnit="kg/s") "Needed to connect to conditional connector for active power";

public
  Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric            collectGwpEmissions annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if not useInputConnector then
    m_flow_internal = if change_sign then -m_flow_const else m_flow_const;
  end if;

  collectGwpEmissions.gwpCollector.m_flow_cde=if change_sign then m_flow_internal else -m_flow_internal;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  if isHeatEmission then
    connect(modelStatistics.gwpCollectorHeat[typeOfPrimaryEnergyCarrierHeat],collectGwpEmissions.gwpCollector);
  else
    connect(modelStatistics.gwpCollector[typeOfPrimaryEnergyCarrier],collectGwpEmissions.gwpCollector);
  end if;
  connect(m_flow_internal, m_flow_set);

  annotation (defaultComponentName="GwpEmissionSource",Diagram(graphics,
                                                               coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-104,130},{-82,110}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="m_flow"),
      Ellipse(
        lineColor={102,102,102},
        fillColor={204,204,204},
        fillPattern=FillPattern.Sphere,
        extent={{-62,-62},{58,58}})}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Time-variant or constant source term for model statistics of gwp emissions. Can be used, if gwp emissions should be captured in model statistics which are not modeled in a detailed component model.</span></p>
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
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Components.Boundaries.Statistical.Check.TestGwpEmissions&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 28.06.2017</span></p>
</html>"));
end GwpEmissions;
