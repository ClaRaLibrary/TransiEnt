within TransiEnt.Components.Gas.VolumesValvesFittings;
model PipeFlow_L4_Simple_varXi "A 1D tube-shaped control volume considering one-phase heat transfer in a straight pipe with static momentum balance, simple energy balance, and variable composition."

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
// Modified component of the ClaRa library, version: 1.3.0                   //
// Path: ClaRa.Components.VolumeValvesFittings.Pipes.PipeFlow_L4_Simple      //
// Modifications: minimum number of finite volumes adjusted to 1             //
// added modelStatistics and cost collector


  extends TransiEnt.Components.Gas.VolumesValvesFittings.Base.VolumeRealGas_L4_varXi(
    redeclare model Geometry =
        ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.PipeGeometry_N_cv (
        z_in=z_in,
        z_out=z_out,
        N_tubes=N_tubes,
        N_cv=N_cv,
        diameter=diameter_i,
        length=length,
        Delta_x=Delta_x,
        N_passes=N_passes));
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  extends TransiEnt.Basics.Icons.PipeFlow_L4_Simple;
  ClaRa.Basics.Interfaces.Connected2SimCenter connected2SimCenter(
    powerIn=noEvent(if sum(heat.Q_flow) > 0 then sum(heat.Q_flow) else 0),
    powerOut=if not heatFlowIsLoss then -sum(heat.Q_flow) else 0,
    powerAux=0) if  contributeToCycleSummary;

//## P A R A M E T E R S #######################################################################################

//____Geometric data_____________________________________________________________________________________
public
  parameter ClaRa.Basics.Units.Length
                            length= 1 "Length of the pipe (one pass)"
                                                                     annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                            diameter_i= 0.1 "Inner diameter of the pipe"
                                                                        annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                            z_in = 0.1 "Height of inlet above ground"
                                                                     annotation(Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length
                            z_out= 0.1 "Height of outlet above ground"
                                                                      annotation(Dialog(group="Geometry"));

  parameter Integer N_tubes= 1 "Number Of parallel pipes"
                                                         annotation(Dialog(group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the tubes" annotation(Dialog(group="Geometry"));

//____Discretisation_____________________________________________________________________________________
   parameter Integer N_cv=3 "Number of finite volumes" annotation(Dialog(group="Discretisation"));
public
  parameter ClaRa.Basics.Units.Length
                            Delta_x[N_cv]=ClaRa.Basics.Functions.GenerateGrid({0}, length*N_passes, N_cv) "Discretisation scheme"
                             annotation(Dialog(group="Discretisation"));

//________Summary_________________
  parameter Boolean contributeToCycleSummary = simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation"
                                                                                            annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss = true "True if negative heat flow is a loss (not a process product)" annotation(Dialog(tab="Summary and Visualisation"));

protected
  ClaRa.Basics.Interfaces.EyeIn eye_int[1]
    annotation (Placement(transformation(extent={{85,-41},{87,-39}})));
public
  ClaRa.Basics.Interfaces.EyeOut eye if showData
 annotation (Placement(transformation(extent={{130,-50},{150,-30}}),
        iconTransformation(extent={{136,-44},{156,-24}})));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  replaceable model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs
                                                                                                                                                                                 "Cost model" annotation(Dialog(group="Statistics"),choicesAllMatching);

  Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    der_E_n=0,
    E_n=0,
    redeclare model CostRecordGeneral = CostSpecsGeneral(size1=diameter_i, size2=length*N_tubes),
    produces_P_el=false,
    consumes_P_el=false,
    produces_Q_flow=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    consumes_H_flow=false,
    produces_other_flow=false,
    consumes_other_flow=false,
    produces_m_flow_CDE=false,
    consumes_m_flow_CDE=false)                                                                                                                                        annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));

//### E Q U A T I O N P A R T #######################################################################################
//-------------------------------------------
equation

  assert(abs(z_out-z_in) <= length, "Length of pipe less than vertical height", AssertionLevel.error);
  //Summary:
  eye_int[1].m_flow=-gasPortOut.m_flow;
  eye_int[1].T=gasOut.T - 273.15;
  eye_int[1].s=gasOut.s/1e3;
  eye_int[1].p=gasPortOut.p/1e5;
  eye_int[1].h=noEvent(actualStream(gasPortOut.h_outflow))/1e3;
         //fillColor={0,131,169};//DynamicSelect(if time > 0 then (if not FlowModel==FlowModelStructure.inlet_innerPipe_outlet and not FlowModel==FlowModelStructure.inlet_innerPipe_dp_outlet then {0,131,169} else {255,255,255}) else {255,255,255}),
  connect(eye_int[1],eye)  annotation (Line(
      points={{86,-40},{140,-40}},
      color={255,204,51},
      smooth=Smooth.None,
      thickness=0.5));
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);
annotation (defaultComponentName="pipe",Icon(graphics={
        Polygon(
          points={{-132,42},{-122,42},{-114,34},{-114,-36},{-122,-42},{-132,-42},
              {-132,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor= {0,131,169},
          fillPattern=FillPattern.Solid,
          visible=frictionAtInlet),
        Polygon(
          points={{132,42},{122,42},{114,34},{114,-36},{122,-42},{132,-42},
              {132,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor= {0,131,169},
          fillPattern=FillPattern.Solid,
          visible=frictionAtOutlet)},        coordinateSystem(preserveAspectRatio=false,
                                                           extent={{-140,-50},{
            140,50}})),
        Diagram(graphics,
                coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-50},{140,50}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">1D Flow of real gas mixtures.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Extends from TransiEnt.Components.Gas.VolumesValvesFittings.Base.VolumeRealGas_L4_varXi</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">It is a modified version of the model ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple from ClaRa version 1.3.0. The model is documented there and here only the changes are described. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L4, consideres HeatTransfer, PressureLoss, Discretisation of the pipe Length and time delay from inlet to outlet. Is able to use real gas mixtures (VLEFluids). Static momentum and simple energy balance. Compared to the ClaRa version, the minimum value for N_cv was deleted, the summary was left here and a cost collector was added.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">-</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>gasportIn: inlet for real gas</p>
<p>gasportOut: outet for real gas</p>
<p>heat: heat port</p>
<p>eye: outlet</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">-</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #006400;\">//Components&nbsp;Mass&nbsp;Balance</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;<span style=\"color: #ff0000;\">der</span>(xi[i,:])&nbsp;=&nbsp;1/mass[i]*(Xi_flow[i,:]&nbsp;-&nbsp;Xi_flow[i+1,:]);</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">when using compositions, the number of finite volume elemts (N_cv) should be chosen in a way that one element ist about 1-2 km long. Otherwise the simulation is very slow. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">copied and changed from ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Tom Lindemann (tom.lindemann@tuhh.de) in Jun 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Carsten Bode (c.bode@tuhh.de) in Oct 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Lisa Andresen (andresen@tuhh.de) in May 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Revised by Carsten Bode (c.bode@tuhh.de), Apr 2018 (updated to ClaRa 1.3.0)</span></p>
</html>"));
end PipeFlow_L4_Simple_varXi;
