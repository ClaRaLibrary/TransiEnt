within TransiEnt.Consumer.Gas.Check;
model GasDemandVarH2_varGCV_controlMFlow

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



  extends TransiEnt.Basics.Icons.Checkmodel;
  inner TransiEnt.SimCenter simCenter(
    p_amb=101343,
    T_amb=283.15,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    p_eff_1=2000,
    p_eff_2=1500000,
    p_eff_3=8000000,
    T_ground=273.15)                  annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP gasDemandHFlow(change_of_sign=false, constantfactor=2.710602*12.14348723*3.6e6/7) annotation (Placement(transformation(extent={{96,-4},{76,16}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow district(k=1e6,
    length=3000,
    p_start=ones(district.pipe.N_cv)*16e5,
    h_start=ones(district.pipe.N_cv)*(-2.16e4),
    m_flow_start=ones(district.pipe.N_cv + 1)*10.5)            annotation (Placement(transformation(extent={{38,-4},{58,16}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source(
    medium=simCenter.gasModel1,
    p_const=simCenter.p_amb_const + simCenter.p_eff_2,
    variable_xi=true)
                     annotation (Placement(transformation(extent={{-58,-4},{-38,16}})));
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow(phi_H2max=0.1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-4,6})));
  TransiEnt.Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation composition_linearVariation(stepsize=0.1, period=900) annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));
equation
  connect(source.gasPort, maxH2MassFlow.gasPortIn) annotation (Line(
      points={{-38,6},{-38,6},{-14,6}},
      color={255,255,0},
      thickness=1.5));
  connect(district.fluidPortIn, maxH2MassFlow.gasPortOut) annotation (Line(
      points={{38,6},{6,6}},
      color={255,255,0},
      thickness=1.5));
  connect(district.H_flow, gasDemandHFlow.y1) annotation (Line(points={{59,6},{75,6}},        color={0,0,127}));
  connect(composition_linearVariation.xi, source.xi) annotation (Line(points={{-74,0},{-60,0}}, color={0,0,127}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=1800,
      Interval=5,
      Tolerance=1e-07),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test model for the model GasConsumerPipe_HFlow. It shows how the gas demand of the consumers controls the mass flow output of the source. A jump in the composition results in a jump in the mass flows as well. </p>
<p>Also, the maximum possible feed-in mass flow rate of hydrogen is calculated using a sensor.</p>
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
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</p>
</html>"));
end GasDemandVarH2_varGCV_controlMFlow;
