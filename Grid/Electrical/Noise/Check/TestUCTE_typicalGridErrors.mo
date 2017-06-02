within TransiEnt.Grid.Electrical.Noise.Check;
model TestUCTE_typicalGridErrors "Example of the component PowerPlant_PoutGrad_L1"

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

  extends Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter(
    P_n_ref_1=0,
    P_n_ref_2=300e9,
    P_peak_1=0,
    P_peak_2=300e9)                                                             annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  LumpedPowerGrid.LumpedGrid uCTEModel(P_L=simCenter.P_n_ref_2, redeclare TypicalLumpedGridError genericGridError(P_L=simCenter.P_n_ref_2)) annotation (Placement(transformation(extent={{-66,0},{0,62}})));
  Components.Boundaries.Electrical.Power constantFrequency_L1_1(useInputConnectorP=false) annotation (Placement(transformation(extent={{42,21},{62,41}})));
  Basics.Tables.GenericDataTable f_1year_60s(
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
    relativepath="electricity/GridFrequencyMeasurement_60s_01012012_31122012.txt",
    use_absolute_path=false) annotation (Placement(transformation(extent={{-18,-50},{2,-30}})));
  Modelica.Blocks.Interaction.Show.RealValue realValue(use_numberPort=false, number=(f_1year_60s.y1 - uCTEModel.epp.f)/f_1year_60s.y1*100) annotation (Placement(transformation(extent={{26,-44},{74,4}})));
equation

  connect(constantFrequency_L1_1.epp, uCTEModel.epp) annotation (Line(
      points={{41.9,30.9},{19.95,30.9},{19.95,31},{0,31}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=604800, Interval=60),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
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
end TestUCTE_typicalGridErrors;
