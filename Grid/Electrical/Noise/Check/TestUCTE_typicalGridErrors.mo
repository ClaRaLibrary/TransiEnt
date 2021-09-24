within TransiEnt.Grid.Electrical.Noise.Check;
model TestUCTE_typicalGridErrors "Example of the component PowerPlant_PoutGrad_L1"


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




  extends Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter(
    P_n_ref_1=0,
    P_n_ref_2=300e9,
    P_peak_1=0,
    P_peak_2=300e9,
    Td=10)                                                                      annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  LumpedPowerGrid.LumpedGrid uCTEModel(P_L=simCenter.P_n_ref_2, redeclare TypicalLumpedGridError genericGridError(P_L=simCenter.P_n_ref_2)) annotation (Placement(transformation(extent={{-66,0},{0,62}})));
  Components.Boundaries.Electrical.ActivePower.Power constantFrequency_L1_1(useInputConnectorP=false) annotation (Placement(transformation(extent={{42,21},{62,41}})));
  Basics.Tables.GenericDataTable f_1year_60s(
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
    relativepath="electricity/GridFrequencyMeasurement_60s_01012012_31122012.txt",
    use_absolute_path=false) annotation (Placement(transformation(extent={{-18,-50},{2,-30}})));
  Modelica.Blocks.Interaction.Show.RealValue realValue(use_numberPort=false, number=(f_1year_60s.y1 - uCTEModel.epp.f)/f_1year_60s.y1*100) annotation (Placement(transformation(extent={{26,-44},{74,4}})));
equation

  connect(constantFrequency_L1_1.epp, uCTEModel.epp) annotation (Line(
      points={{42,31},{19.95,31},{19.95,31},{0,31}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=604800, Interval=60),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}})),
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
</html>"),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestUCTE_typicalGridErrors;
