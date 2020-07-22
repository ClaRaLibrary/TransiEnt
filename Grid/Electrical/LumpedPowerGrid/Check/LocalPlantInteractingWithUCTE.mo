within TransiEnt.Grid.Electrical.LumpedPowerGrid.Check;
model LocalPlantInteractingWithUCTE "Example how the continental europe grid interacts with a local grid"
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
  extends TransiEnt.Basics.Icons.Example;
  inner TransiEnt.SimCenter  simCenter(         thres=1e-9,
    Td=450,
    useThresh=true,
    redeclare Base.ExampleGenerationPark                           generationPark(
      P_min_star_GT=0.3,
      P_grad_max_star_GT=0.1/60,
      P_grad_max_star_CCP=0.02/60,
      P_grad_max_star_BC=0.02/60,
      P_grad_max_star_BCG=0.013/60,
      P_el_n_WindOff=7e6),
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    annotation (Placement(transformation(extent={{-69,80},{-49,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-99,80},{-79,100}})));
  Consumer.Electrical.LinearElectricConsumer Demand(kpf=0.5) annotation (Placement(transformation(
        extent={{-19,-15},{19,15}},
        rotation=0,
        origin={63,-43})));
  TransiEnt.Components.Sensors.ElectricActivePower P_12(change_of_sign=true) annotation (Placement(transformation(extent={{16,19},{-6,41}})));
  TransiEnt.Producer.Electrical.Conventional.Components.NonlinearThreeStatePlant Gen(
    typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Cogeneration,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal,
    P_el_n=simCenter.P_n_ref_1,
    primaryBalancingController(k_part=0.5, providedDroop=0.2/50/(3/150 - 0.2*0.01)),
    isPrimaryControlActive=true,
    fixedStartValue_w=false,
    isSecondaryControlActive=true,
    P_init_set=-Gen_set.k) annotation (Placement(transformation(extent={{66,8},{38,36}})));

  TransiEnt.Grid.Electrical.LumpedPowerGrid.LumpedGrid UCTE(
    delta_pr=0.2/50/(3/150 - 0.2*0.01),
    P_pr_max_star=0.02,
    T_r=150,
    lambda_sec=simCenter.P_n_ref_2/(simCenter.P_n_ref_1 + simCenter.P_n_ref_2)*3e9/0.2,
    redeclare Noise.ZeroError genericGridError,
    P_el_n=simCenter.P_n_ref_2 - 3e9,
    k_pr=simCenter.P_n_ref_2/UCTE.P_el_n*0.5,
    P_L=simCenter.P_n_low - 5e9,
    beta=0.5) annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Constant Gen_set(k=-2e9) annotation (Placement(transformation(extent={{96,36},{76,56}})));
  Modelica.Blocks.Sources.Constant Load(k=2e9) annotation (Placement(transformation(extent={{30,-26},{50,-6}})));
  Components.AGC aGC(
    K_r=simCenter.P_n_ref_1/(simCenter.P_n_ref_1 + simCenter.P_n_ref_2)*3e9/0.2,
    beta=0.5,
    T_r=150,
    changeSignOfTieLinePower=true) annotation (Placement(transformation(extent={{14,46},{40,70}})));
equation
  connect(Gen.epp, P_12.epp_IN) annotation (Line(
      points={{39.4,31.8},{24,31.8},{24,30},{15.12,30}},
      color={0,135,135},
      thickness=0.5));
  connect(UCTE.epp, P_12.epp_OUT) annotation (Line(
      points={{-20,30},{-5.34,30}},
      color={0,135,135},
      thickness=0.5));
  connect(P_12.epp_IN, Demand.epp) annotation (Line(
      points={{15.12,30},{18,30},{18,32},{24,32},{24,-43},{44.38,-43}},
      color={0,135,135},
      thickness=0.5));
  connect(P_12.epp_IN, aGC.epp) annotation (Line(
      points={{15.12,30},{27,30},{27,46}},
      color={0,135,135},
      thickness=0.5));
  connect(aGC.P_sec_set, Gen.P_SB_set) annotation (Line(points={{40.78,58},{64.46,58},{64.46,34.46}}, color={0,0,127}));
  connect(P_12.P, aGC.P_tie_is) annotation (Line(points={{9.18,38.58},{9.18,80},{27,80},{27,70}}, color={0,0,127}));
  connect(Load.y, Demand.P_el_set) annotation (Line(points={{51,-16},{58,-16},{63,-16},{63,-25.6}},                color={0,0,127}));
  connect(Gen_set.y, Gen.P_el_set) annotation (Line(points={{75,46},{54.1,46},{54.1,35.86}}, color={0,0,127}));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,100}})),
    experiment(
      StopTime=7200,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(events=false),
    Icon(graphics,
         coordinateSystem(extent={{-100,-80},{100,100}})),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(no remarks)</p>
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
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end LocalPlantInteractingWithUCTE;
